# sox_ng Docker Builder

🛠️ **Automated Docker image builder for [`sox_ng`](https://codeberg.org/sox_ng/sox_ng) releases from Codeberg**  
📦 **Publishes images to [GitHub Container Registry (GHCR)](https://github.com/Ardakilic/sox_ng_dockerized/pkgs/container/sox_ng) and [Docker Hub](https://hub.docker.com/r/ardakilic/sox_ng)**

---

## 📦 What is `sox_ng`?

[`sox_ng`](https://codeberg.org/sox_ng/sox_ng) is a hard fork of the SoX (Sound eXchange) utility, aiming to consolidate bug fixes and modernize the audio processing toolset. It installs alongside `sox` as `sox_ng` and supports a wide range of audio formats.

---

## 🔁 What does this repo do?

This GitHub repository:

- Periodically **polls Codeberg for new releases** of `sox_ng`,
- Downloads the latest release tarball,
- Builds it using a **Debian slim base image**, optimized for caching,
- Pushes the resulting Docker image to:
  - **GitHub Container Registry (GHCR)**
  - **Docker Hub**

---

## 🐳 Docker Images

You can pull the prebuilt `sox_ng` images from:

- **GitHub Container Registry (GHCR):**
  ```bash
  docker pull ghcr.io/ardakilic/sox_ng:latest
  ```

or via

- **Docker Hub:**
  ```bash
  docker pull ardakilic/sox_ng:latest
  ```

## 🚀 Example Usages
```bash
# Simplest usage
docker run --rm -v "$(pwd)":/audio ardakilic/sox_ng:latest input.wav output.mp3
```

```bash
# Or a more complicated example:
# Downsample a HiFi FLAC file to 16 bit 48kHz, multi-threaded
docker run --rm -v "$(pwd)":/audio ardakilic/sox_ng:latest HiFi.flac -b 16 LoFi.flac rate -v -L 48000 dither --multi-threaded
```

```bash
# Or if you want to use GHCR instead:
docker run --rm -v "$(pwd)":/audio ghcr.io/ardakilic/sox_ng:latest input.wav output.mp3
```

```bash
# Get file information
docker run --rm -v "$(pwd)":/audio ardakilic/sox_ng:latest --i HiFi.flac
```

## FFmpeg Examples

FFmpeg is also included in the image in addition to the native codec packages, to provide enhanced support for a wide range of audio and video formats, complementing sox_ng's capabilities. You can use it by overriding the entrypoint:

```bash
# Simple audio conversion
docker run --rm --entrypoint ffmpeg -v "$(pwd)":/audio ardakilic/sox_ng:latest -i input.wav output.mp3
```

```bash
# More complex: Convert video to audio with specific settings
docker run --rm --entrypoint ffmpeg -v "$(pwd)":/audio ardakilic/sox_ng:latest -i input.mp4 -vn -acodec libmp3lame -ab 192k output.mp3
```

```bash
# Using GHCR
docker run --rm --entrypoint ffmpeg -v "$(pwd)":/audio ghcr.io/ardakilic/sox_ng:latest -i input.wav output.mp3
```

```bash
# Get media info (using ffprobe, part of FFmpeg)
docker run --rm --entrypoint ffprobe -v "$(pwd)":/audio ardakilic/sox_ng:latest input.wav
```

```bash
# Persistent container with docker exec
# First, run the container in detached mode
docker run -d --name sox_container -v "$(pwd)":/audio ardakilic/sox_ng:latest sleep infinity

# Then, exec into it to run ffmpeg
docker exec sox_container ffmpeg -i input.wav output.mp3

# Stop the container when done
docker stop sox_container
docker rm sox_container
```

```bash
# Using ffprobe with docker exec
docker exec sox_container ffprobe input.wav
```
---

## 🔨 Building the Image Manually

You can build the Docker image manually using the included Dockerfile:

1. **Clone this repository:**
   ```bash
   git clone --recursive-submodules https://github.com/Ardakilic/sox_ng_dockerized.git
   cd sox_ng_dockerized
   ```

2. **(Optional) Change the sox_ng release if you don't want the latest release:**
   ```bash
   cd sox_ng
   git fetch
   git checkout sox_ng-X.Y.Z
   cd ..
   ```

3. **Build the Docker image:**
   ```bash
   docker build -t sox_ng:local .
   ```

4. **Run sox_ng from your new container:**
   ```bash
   # Test that it works
   docker run --rm sox_ng:local --version
   
   # Process audio files (mount current directory to /audio in container)
   docker run --rm -v "$(pwd)":/audio sox_ng:local input.wav output.mp3
   ```

---

## 🧠 How it works

- The GitHub Action runs every 12 hours (`cron: 0 */12 * * *`).
- It uses the Codeberg API to fetch the latest release info.
- If a **new release is found**, the workflow:
  - Checks out the newly found tag from the submodule source repository,
  - Builds the Docker image with only local files (no runtime downloading in Dockerfile),
  - Tags the image with the release version,
  - Pushes to both GHCR and Docker Hub.

---

## 📁 Project Structure

```
.
├── Dockerfile                # Multi-stage build that compiles and packages sox_ng
├── sox_ng/                   # Source from the latest Codeberg release (extracted)
├── .last_seen_release        # Internal file to track latest processed release
└── .github/
    └── workflows/
        └── release-watcher.yml   # The automation workflow
```

---

## 🐳 Dockerfile Details

The Dockerfile uses a multi-stage build process:
- **Stage 1 (Builder)**: Installs all necessary build dependencies and compiles sox_ng
- **Stage 2 (Final)**: Contains only runtime dependencies for minimal image size

Key features:
- Based on debian:bookworm-slim for stability and small size
- Includes FFmpeg support for additional audio format compatibility
- Properly separates build dependencies from runtime dependencies
- Uses ENTRYPOINT to make the container behave like the sox_ng command

---

## 🔐 Secrets Required

Make sure to set the following GitHub Action secrets:

| Name                 | Purpose                          |
|----------------------|----------------------------------|
| `DOCKERHUB_USERNAME` | Docker Hub username              |
| `DOCKERHUB_TOKEN`    | Docker Hub access token/password |

---

## 🧪 Manual Trigger

If you forked the repository, you can also manually trigger the workflow from the **Actions** tab on GitHub to force a rebuild.

---

## 🤝 Contributing

PRs welcome if you'd like to:
- Add multi-arch support for another architecture (already supported x64, arm64, arm/v7),
- Improve the caching or reduce image size.

---

## 📜 License

MIT — Do whatever you want, but attribution is appreciated.

---

## 🗣 Credits

- [`sox_ng`](https://codeberg.org/sox_ng/sox_ng) by the `sox_ng` maintainers.
- Docker and GitHub Actions setup by [Arda Kılıçdağı](https://github.com/Ardakilic).
