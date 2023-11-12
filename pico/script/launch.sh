#!/bin/sh
export picodir=/mnt/SDCARD/App/pico
export sysdir=/mnt/SDCARD/.tmp_update
export miyoodir=/mnt/SDCARD/miyoo
cd $picodir
export PATH=$PATH:$PWD/bin
export HOME=$picodir

get_curvol() {
    awk '/LineOut/ {if (!printed) {gsub(",", "", $8); print $8; printed=1}}' /proc/mi_modules/mi_ao/mi_ao0
}

is_process_running() {
  process_name="$1"
  if [ -z "$(pgrep -f "$process_name")" ]; then
    return 1
  else
    return 0
  fi
}

kill_audio_servers() {
    is_process_running "audioserver" && pkill -9 -f "audioserver"
    is_process_running "audioserver.mod" && killall -q "audioserver.mod"
}

runifnecessary() {
    cnt=0
    a=`ps | grep $1 | grep -v grep`
    a=$(pgrep $1)
    while [ "$a" == "" ] && [ $cnt -lt 8 ]; do
        $2 $3 &
        sleep 0.5
        cnt=$(expr $cnt + 1)
        a=$(pgrep $1)
    done
}

set_snd_level() {
    local target_vol="$1"
    local current_vol
    local start_time
    local elapsed_time

    start_time=$(date +%s)
    while [ ! -e /proc/mi_modules/mi_ao/mi_ao0 ]; do
        sleep 0.2
        elapsed_time=$(( $(date +%s) - start_time ))
        if [ "$elapsed_time" -ge 30 ]; then
            echo "Timed out waiting for /proc/mi_modules/mi_ao/mi_ao0"
            return 1
        fi
    done

    start_time=$(date +%s)
    while true; do
        echo "set_ao_volume 0 ${target_vol}dB" > /proc/mi_modules/mi_ao/mi_ao0
        echo "set_ao_volume 1 ${target_vol}dB" > /proc/mi_modules/mi_ao/mi_ao0
        current_vol=$(get_curvol)

        if [ "$current_vol" = "$target_vol" ]; then
            echo "Volume set to ${current_vol}dB"
            return 0
        fi

        elapsed_time=$(( $(date +%s) - start_time ))
        if [ "$elapsed_time" -ge 360 ]; then
            echo "Timed out trying to set volume"
            return 1
        fi

        sleep 0.2
    done
}

# when wifi is restarted, udhcpc and wpa_supplicant may be started with libpadsp.so preloaded, this is bad as they can hold mi_ao open even after audioserver has been killed.
libpadspblocker() { 
    wpa_pid=$(ps -e | grep "[w]pa_supplicant" | awk 'NR==1{print $1}')
    udhcpc_pid=$(ps -e | grep "[u]dhcpc" | awk 'NR==1{print $1}')
    if [ -n "$wpa_pid" ] && [ -n "$udhcpc_pid" ]; then
        if grep -q "libpadsp.so" /proc/$wpa_pid/maps || grep -q "libpadsp.so" /proc/$udhcpc_pid/maps; then
            echo "Network Checker: $wpa_pid(WPA) and $udhcpc_pid(UDHCPC) found preloaded with libpadsp.so"
            unset LD_PRELOAD
            killall -9 wpa_supplicant
            killall -9 udhcpc 
            $miyoodir/app/wpa_supplicant -B -D nl80211 -iwlan0 -c /appconfigs/wpa_supplicant.conf & 
            udhcpc -i wlan0 -s /etc/init.d/udhcpc.script &
            echo "Network Checker: Removing libpadsp.so preload on wpa_supp/udhcpc"
        fi
    fi
}

start_pico() {
    export LD_LIBRARY_PATH="$picodir/lib:/lib:/config/lib:/mnt/SDCARD/miyoo/lib:/mnt/SDCARD/.tmp_update/lib:/mnt/SDCARD/.tmp_update/lib/parasyte:/sbin:/usr/sbin:/bin:/usr/bin"
    export SDL_VIDEODRIVER=mmiyoo
    export SDL_AUDIODRIVER=mmiyoo
    export EGL_VIDEODRIVER=mmiyoo
    
    kill_audio_servers
    libpadspblocker
    set_snd_level "${curvol}" &
    pico8_dyn -splore
}

main() {
    echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    curvol=$(get_curvol) # grab current volume
    mount --bind /mnt/SDCARD/Roms/PICO /mnt/SDCARD/App/pico/.lexaloffle/pico-8/carts
    start_pico
    umount /mnt/SDCARD/App/pico/.lexaloffle/pico-8/carts
    echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

main
