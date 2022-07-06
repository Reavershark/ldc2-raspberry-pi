#!/usr/bin/env bash
docker build -t reavershark/ldc2-rpi:armv7hf --build-arg TARGET_TRIPLE=arm-linux-gnueabihf .
docker build -t reavershark/ldc2-rpi:armv7hf-bullseye --build-arg TARGET_TRIPLE=arm-linux-gnueabihf .
docker build -t reavershark/ldc2-rpi:aarch64 --build-arg TARGET_TRIPLE=aarch64-linux-gnu .
docker build -t reavershark/ldc2-rpi:aarch64-bullseye --build-arg TARGET_TRIPLE=aarch64-linux-gnu .