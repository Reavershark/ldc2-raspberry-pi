# ldc2 cross compiler for the Raspberry Pi
Docker image for cross compiling D code to Raspberry Pi OS with ldc2 or dub.

Also contains cross compiled versions of OpenSSL and zlib, which are dependencies of [vibe-d](https://vibed.org/).

Builds are available from [Docker hub](https://hub.docker.com/r/reavershark/ldc2-rpi).

## Obtaining
Pull the image from [Docker hub](https://hub.docker.com/r/reavershark/ldc2-rpi):
```
docker pull reavershark/ldc2-rpi:armv7hf # Raspbery Pi OS 32-bit
docker pull reavershark/ldc2-rpi:aarch64 # Raspbery Pi OS 64-bit
```

The full list of tags is as follows:
  - armv7hf (latest, currently bullseye)
  - armv7hf-bullseye
  - aarch64 (latest, currently bullseye)
  - aarch64-bullseye

Or you can build the image yourself from this repo with a custom triple (takes a lot of time):
```
docker build -t ldc2-rpi --build-arg TARGET_TRIPLE=aarch64-linux-gnu .
```

## Usage
Running `ldc2`:
```
docker run --rm -v "$(pwd)":/src reavershark/ldc2-rpi:armv7hf ldc2 app.d
```

Running `dub build`:
```
docker run --rm -v "$(pwd)":/src -v "$HOME/.dub":/root/.dub reavershark/ldc2-rpi:armv7hf dub build
```

## Examples
Compiling and running the example code from [run.dlang.io](https://run.dlang.io/):
```
echo 'import std.stdio; void main() {writeln("Hello D");}' > app.d
docker run --rm -v "$(pwd)":/src reavershark/ldc2-rpi:armv7hf ldc2 app.d

scp app pi@raspberry:
ssh pi@raspberry
$ ./app
> Hello D
```

Compiling and running a minimal vibe.d http server with dub:
```
mkdir example && cd example
dub init -t vibe.d -n
docker run --rm \
  -v "$(pwd)":/src \
  -v "$HOME/.dub":/root/.dub \
  reavershark/ldc2-rpi:armv7hf \
  dub build

scp example pi@raspberry:
ssh pi@raspberry
$ ./example
> [main(----) INF] Listening for requests on http://[::1]:8080/
> [main(----) INF] Listening for requests on http://127.0.0.1:8080/
> [main(----) INF] Please open http://127.0.0.1:8080/ in your browser.
```

## Notes
### Dub dependencies
Passing `-v "$HOME/.dub":/root/.dub` to `docker run` avoids redownloading and rebuilding dependencies.

### Permissions
After running `dub` or `ldc2`, permissions on all files created in `/src` and `/root/.dub` are set to the user who owns the `/src` directory (usually the user executing `docker run`).

### Dynamic libraries
Cross-compiled libraries reside in `/cross-libs/`.
You can easily add your own dependencies as volumes.

Example for adding the wiringPi library to a project: (outdated)
```
ssh pi@raspberry -t sudo apt install wiringpi -y
mkdir lib
scp pi@raspberry:/usr/lib/libwiringPi.so.2.50 lib/

docker run --rm \
  -v "$(pwd)":/src \
  -v "$HOME/.dub":/root/.dub \
  -v "$(pwd)"/lib/libwiringPi.so.2.50:/cross-libs/libwiringPi.so.2.50 \
  -v "$(pwd)"/lib/libwiringPi.so.2.50:/cross-libs/libwiringPi.so \
  ldc2-rpi:armv7hf dub build
```

### Contributing
Issues, suggestions and pull requests are always welcome!

### Sources
- Heavily inspired by https://github.com/pander86/raspberry_vibed.
- A D wiki page covers the `ldc-build-runtime` tool: [Building LDC runtime libraries](https://wiki.dlang.org/Building_LDC_runtime_libraries).
