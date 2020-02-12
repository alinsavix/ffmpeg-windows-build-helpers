#!/bin/bash
# Do an ffmpeg test build with the arguments used for the old ffmpeg build.
# This will get removed once we have the full build process working smoothly
set -e
cd /Users/jg/git/ffmpeg-windows-build-helpers/sandbox/win64/ffmpeg_git_shared

export PKG_CONFIG_PATH=/Users/jg/git/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/x86_64-w64-mingw32/lib/pkgconfig
export PATH=/Users/jg/git/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/bin:$PATH

BUILDPREP=(
    '--pkg-config=pkg-config'
    '--pkg-config-flags=--static'
    '--extra-version=ffmpeg-windows-build-helpers'   # What should this be?
    '--enable-version3'  # What is this?
    '--disable-debug'
    '--disable-w32threads'
    '--prefix=/Users/jg/git/ffmpeg-windows-build-helpers/sandbox/win64/ffmpeg_git_shared'
)

TARGET=(
    '--arch=x86_64'
    '--target-os=mingw32'
    '--cross-prefix=/Users/jg/git/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/bin/x86_64-w64-mingw32-'
    '--enable-shared'
    '--disable-static'
)

# uses extra-cflags
OPTIM=(
    '-mtune=generic'
    '-O3'
)

ENABLE_FEATURES=(libcaca gray libtesseract fontconfig gmp gnutls libass libbluray libbs2b libflite libfreetype libfribidi libgme libgsm libilbc libmodplug libmp3lame libopencore-amrnb libopencore-amrwb libopus libsnappy libsoxr libspeex libtheora libtwolame libvo-amrwbenc libvorbis libwebp libzimg libzvbi libmysofa libopenjpeg  libopenh264 liblensfun  libvmaf libsrt demuxer=dash libxml2 libdav1d libsvthevc libaom libvpx nvenc nvdec)

# (do we need extra-libs here, as they were originally? Or can they wait until the end?)
ENABLE_FEATURES+=(amf libmfx gpl avisynth frei0r filter=frei0r librubberband libvidstab libx264 libx265 libxvid libxavs avresample)

EXTRA_LIBS=(
    harfbuzz
    m
    pthread
)

EXTRA_DEFINES=(
    LIBTWOLAME_STATIC
    MODPLUG_STATIC
    CACA_STATIC
)


FINAL_OPTS=()
FINAL_OPTS+=("${BUILDPREP[@]}")
FINAL_OPTS+=("${TARGET[@]}")

for i in "${OPTIM[@]}"
do
    FINAL_OPTS+=("--extra-cflags=${i}")
done

for i in "${ENABLE_FEATURES[@]}"
do
    FINAL_OPTS+=("--enable-${i}")
done

for i in "${EXTRA_LIBS[@]}"
do
    FINAL_OPTS+=("--extra-libs=-l${i}")
done

for i in "${EXTRA_DEFINES[@]}"
do
    FINAL_OPTS+=("--extra-cflags=-D${i}")
done

./configure "${FINAL_OPTS[@]}"
