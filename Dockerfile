# Stage 1: Build environment
FROM debian:trixie-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    autoconf \
    autoconf-archive \
    automake \
    gcc \
    libtool \
    make \
    pkg-config \
    # Audio codec and format libraries (dev versions)
    ladspa-sdk \
    libao-dev \
    libasound2-dev \
    libfftw3-dev \
    libflac-dev \
    libgsm1-dev \
    libid3tag0-dev \
    libltdl-dev \
    libmad0-dev \
    libmagic-dev \
    libmp3lame-dev \
    libogg-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libopus-dev \
    libopusfile-dev \
    libpng-dev \
    libpulse-dev \
    libsamplerate0-dev \
    libsndfile1-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libtwolame-dev \
    libvorbis-dev \
    libwavpack-dev \
    # Clean up APT cache to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /source

# Copy the local sox_ng source code
COPY sox_ng .

# Build sox_ng
RUN autoreconf -i \
    && ./configure --with-ffmpeg \
    && make \
    && make install DESTDIR=/install

# Stage 2: Final image
FROM debian:trixie-slim

LABEL org.opencontainers.image.authors="Arda Kilicdagi <arda@kilicdagi.com>" \
      org.opencontainers.image.url="https://github.com/ardakilic/sox_ng_dockerized" \
      org.opencontainers.image.documentation="https://github.com/ardakilic/sox_ng_dockerized" \
      org.opencontainers.image.source="https://codeberg.org/sox_ng/sox_ng" \
      org.opencontainers.image.title="sox_ng" \
      org.opencontainers.image.description="SoX_ng, the hard fork of SoX, the Swiss Army knife of audio processing"

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    # Runtime versions of codec libraries
    libao4 \
    libasound2 \
    libfftw3-bin \
    libflac12 \
    libgsm1 \
    libid3tag0 \
    libltdl7 \
    libmad0 \
    libmagic1 \
    libmp3lame0 \
    libogg0 \
    libopencore-amrnb0 \
    libopencore-amrwb0 \
    libopus0 \
    libopusfile0 \
    libpng16-16 \
    libpulse0 \
    libsamplerate0 \
    libsndfile1 \
    libspeex1 \
    libspeexdsp1 \
    libtwolame0 \
    libvorbis0a \
    libvorbisenc2 \
    libvorbisfile3 \
    libwavpack1 \
    # FFmpeg for additional format support
    ffmpeg \
    # Clean up APT cache to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binaries and libraries from the builder stage
COPY --from=builder /install/usr/local /usr/local

# Update shared library cache
RUN ldconfig

# Set the working directory
WORKDIR /audio

# Set the entry point to sox_ng
ENTRYPOINT ["sox_ng"]
CMD ["--help"]