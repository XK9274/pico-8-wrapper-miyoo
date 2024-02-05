FROM debian:buster-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    make \
    pkg-config \
    autoconf \
    automake \
    m4 \
    wget \
    tar \
    git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY script/cmd.sh /root/cmd.sh

RUN chmod +x /root/cmd.sh

ENTRYPOINT ["/root/cmd.sh"]

CMD ["/bin/bash"]

VOLUME /root/workspace
WORKDIR /root/workspace