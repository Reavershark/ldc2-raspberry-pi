# ldc2-raspberry-pi
Docker container for cross compiling D code to the Raspberry pi

Also contains cross-compiled versions of openssl and zlib, which are dependencies of [vibe-d](https://vibed.org/).

## Usage
Build the image:
```
docker build -t ldc2-rpi .
```

Example:
```
echo "import std.stdio; void main() {writeln("Hello D");} > app.d
docker run --rm -v "$(pwd)":/src ldc2-rpi app.d
rsync ./app pi@raspberry:
ssh pi@raspberry
./app
> Hello D
```

## Note
Heavily inspired by https://github.com/pander86/raspberry_vibed
