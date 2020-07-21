FROM debian:buster

RUN apt update
RUN apt install gcc-arm-linux-gnueabihf ninja-build cmake ldc git -y

WORKDIR /build
RUN mkdir /lib/arm

RUN export CC=arm-linux-gnueabihf-gcc && \
    ldc-build-runtime --ninja --dFlags="-w;-mtriple=arm-linux-gnueabihf" && \
    mv ldc-build-runtime.tmp /lib/arm

RUN git clone https://github.com/openssl/openssl --depth 1 && \
    cd openssl && \
    export INSTALL_DIR=/lib/arm && \
    ./Configure linux-generic32 shared --prefix=$INSTALL_DIR --openssldir=$INSTALL_DIR/openssl --cross-compile-prefix=arm-linux-gnueabihf- && \
    make && \
    make install && \
    cd .. && \
    rm openssl -rf

RUN git clone https://github.com/madler/zlib.git --depth 1 && \
    cd zlib && \
    export CC=arm-linux-gnueabihf-gcc INSTALL_DIR=/lib/arm && \
    ./configure --prefix=$INSTALL_DIR && \
    make && \
    make install && \
    cd .. && \
    rm zlib -rf

COPY ldc2-rpi /usr/bin/ldc2-rpi

WORKDIR /src
ENTRYPOINT ["/usr/bin/ldc2-rpi"]
