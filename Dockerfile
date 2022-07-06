FROM debian:bullseye

ARG TARGET_TRIPLE=arm-linux-gnueabihf

RUN apt-get update
RUN apt-get install gcc-${TARGET_TRIPLE} ninja-build cmake ldc wget perl dub -y

WORKDIR /build

# LDC runtime
RUN export CC=${TARGET_TRIPLE}-gcc && \
    ldc-build-runtime --ninja --dFlags="-w;-mtriple=${TARGET_TRIPLE}" && \
    mv ldc-build-runtime.tmp/lib/* /usr/${TARGET_TRIPLE}/lib/ && \
    rm ldc-build-runtime.tmp -rf

# OpenSSL
RUN export OPENSSL_VERSION=1_1_1g INSTALL_DIR=/usr/${TARGET_TRIPLE} && \
    wget https://github.com/openssl/openssl/archive/OpenSSL_$OPENSSL_VERSION.tar.gz && \
    tar xzf OpenSSL_$OPENSSL_VERSION.tar.gz && \
    rm OpenSSL_$OPENSSL_VERSION.tar.gz && \
    cd openssl-OpenSSL_$OPENSSL_VERSION && \
    ./Configure linux-generic32 shared --prefix=$INSTALL_DIR --openssldir=$INSTALL_DIR/openssl --cross-compile-prefix=${TARGET_TRIPLE}- && \
    make && \
    make install && \
    cd .. && \
    rm openssl-OpenSSL_$OPENSSL_VERSION -rf

# Zlib
RUN export ZLIB_VERSION=1.2.12 CC=${TARGET_TRIPLE}-gcc INSTALL_DIR=/usr/${TARGET_TRIPLE} && \
    wget https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz && \
    tar xzf zlib-$ZLIB_VERSION.tar.gz && \
    rm zlib-$ZLIB_VERSION.tar.gz && \
    cd zlib-$ZLIB_VERSION && \
    ./configure --prefix=$INSTALL_DIR && \
    make && \
    make install && \
    cd .. && \
    rm zlib-$ZLIB_VERSION -rf

# Copy files from repo
COPY ldc2-rpi /usr/local/bin/ldc2
RUN sed -i "s/DOCKER_TARGET_TRIPLE=/DOCKER_TARGET_TRIPLE=${TARGET_TRIPLE}/g" /usr/local/bin/ldc2

COPY dub-rpi /usr/local/bin/dub

COPY ldc2.conf /etc/ldc2.conf

RUN ln -s /usr/${TARGET_TRIPLE}/lib /cross-libs

WORKDIR /src
CMD ["/usr/local/bin/ldc2"]
