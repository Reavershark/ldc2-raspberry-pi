FROM debian:buster

RUN apt update
RUN apt install gcc-arm-linux-gnueabihf ninja-build cmake ldc wget perl dub -y

WORKDIR /build

# LDC runtime
RUN export CC=arm-linux-gnueabihf-gcc && \
    ldc-build-runtime --ninja --dFlags="-w;-mtriple=arm-linux-gnueabihf" && \
    mv ldc-build-runtime.tmp/lib/* /usr/arm-linux-gnueabihf/lib && \
    rm ldc-build-runtime.tmp -rf

# OpenSSL
RUN export OPENSSL_VERSION=1_1_1g INSTALL_DIR=/usr/arm-linux-gnueabihf && \
    wget https://github.com/openssl/openssl/archive/OpenSSL_$OPENSSL_VERSION.tar.gz && \
    tar xzf OpenSSL_$OPENSSL_VERSION.tar.gz && \
    rm OpenSSL_$OPENSSL_VERSION.tar.gz && \
    cd openssl-OpenSSL_$OPENSSL_VERSION && \
    ./Configure linux-generic32 shared --prefix=$INSTALL_DIR --openssldir=$INSTALL_DIR/openssl --cross-compile-prefix=arm-linux-gnueabihf- && \
    make && \
    make install && \
    cd .. && \
    rm openssl-OpenSSL_$OPENSSL_VERSION -rf

# Zlib
RUN export ZLIB_VERSION=1.2.11 CC=arm-linux-gnueabihf-gcc INSTALL_DIR=/usr/arm-linux-gnueabihf && \
    wget https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz && \
    tar xzf zlib-$ZLIB_VERSION.tar.gz && \
    rm zlib-$ZLIB_VERSION.tar.gz && \
    cd zlib-$ZLIB_VERSION && \
    ./configure --prefix=$INSTALL_DIR && \
    make && \
    make install && \
    cd .. && \
    rm zlib-$ZLIB_VERSION -rf

COPY ldc2-rpi /usr/local/bin/ldc2
COPY dub-rpi /usr/local/bin/dub

WORKDIR /src
CMD ["/usr/local/bin/ldc2"]
