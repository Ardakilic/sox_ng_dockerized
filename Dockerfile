FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc make libtool ladspa-sdk libao-dev libasound2-dev \
libgsm1-dev libid3tag0-dev libltdl-dev libmad0-dev libmagic-dev \
libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev \
libopusfile-dev libpng-dev libpulse-dev libsamplerate0-dev \
libsndfile1-dev libspeex-dev libspeexdsp-dev libtwolame-dev \
libvorbis-dev libwavpack-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY sox_ng ./sox_ng
WORKDIR /build/sox_ng

RUN ./configure && make

RUN make install

ENTRYPOINT ["sox_ng"]