FROM ubuntu:20.04
COPY . /ton
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends build-essential git make cmake \
     clang libgflags-dev zlib1g-dev libssl-dev \
     libreadline-dev libmicrohttpd-dev pkg-config \
     libgsl-dev python3 python3-dev python3-pip \
     wget \
     systemctl
RUN pip3 install psutil crc16 requests
RUN apt-get install -y opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev
ENV CCACHE_DISABLE 1
RUN mkdir /build
WORKDIR /build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DMINEROPENCL=true /ton
RUN make -j 8 pow-miner pow-miner-opencl tonlib-cli tonlib-opencl-cli lite-client
RUN wget https://newton-blockchain.github.io/global.config.json
RUN wget https://raw.githubusercontent.com/igroman787/mytonctrl/master/scripts/install.sh
RUN bash install.sh -m lite
