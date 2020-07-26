# ldc2 cross compiler for the Raspberry Pi
Docker container for cross compiling D code to the Raspberry Pi.

Also contains cross-compiled versions of openssl and zlib, which are dependencies of [vibe-d](https://vibed.org/).

Builds are available from [Docker hub](https://hub.docker.com/r/reavershark/ldc2-rpi).

## Usage
Pull the image from [Docker hub](https://hub.docker.com/r/reavershark/ldc2-rpi):
```
docker pull reavershark/ldc2-rpi
```

Alternatively build the image yourself (Optional) with:
```
docker build -t ldc2-rpi .
```

Run with:
```
docker run --rm -v "$(pwd)":/src reavershark/ldc2-rpi ldc2 app.d
```

Example:
```
echo 'import std.stdio; void main() {writeln("Hello D");}' > app.d
docker run --rm -v "$(pwd)":/src reavershark/ldc2-rpi ldc2 app.d
rsync ./app pi@raspberry:
ssh pi@raspberry
./app
> Hello D
```

With dub:
```
mkdir example && cd example
dub init -t vibe.d -n
docker run --rm -v "$(pwd)":/src reavershark/ldc2-rpi dub build --override-config vibe-d:tls/openssl-1.1
rsync ./example pi@raspberry:
ssh pi@raspberry
./example
> [main(----) INF] Listening for requests on http://[::1]:8080/
> [main(----) INF] Listening for requests on http://127.0.0.1:8080/
> [main(----) INF] Please open http://127.0.0.1:8080/ in your browser.
```

## Todo
 - ~~Set newly created files ownership to current user instead of root, use `sudo chown` for now.~~
   Permissions are set to the owner of the `/src` volume.
 - ~~Prevent dub from downloading all packages on every build.~~
   Use `-v "$HOME/.dub":/root/.dub` as `docker run` parameter to preserve packages and build files, avoiding downloads and rebuilds of dependencies.
   Permissions are also set to the owner of `/src`.


## Note
Heavily inspired by https://github.com/pander86/raspberry_vibed
