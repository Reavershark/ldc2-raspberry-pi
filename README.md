# ldc2 cross compiler for the Raspberry Pi
Docker container for cross compiling D code to the Raspberry pi

Also contains cross-compiled versions of openssl and zlib, which are dependencies of [vibe-d](https://vibed.org/).

## Usage
Build the image:
```
docker build -t ldc2-rpi .
```

Run with:
```
docker run --rm -v "$(pwd)":/src ldc2-rpi ldc2-rpi app.d
```

Example:
```
echo "import std.stdio; void main() {writeln("Hello D");} > app.d
docker run --rm -v "$(pwd)":/src ldc2-rpi ldc2-rpi app.d
rsync ./app pi@raspberry:
ssh pi@raspberry
./app
> Hello D
```

With dub:
```
mkdir example && cd example
dub init -n
docker run --rm -v "$(pwd)":/src ldc2-rpi dub build --compiler=ldc2-rpi
rsync ./example pi@raspberry:
ssh pi@raspberry
./example
> Edit source/app.d to start your project.
```

## Note
Heavily inspired by https://github.com/pander86/raspberry_vibed
