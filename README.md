# sox_ng Docker Builder

🛠️ **Automated Docker image builder for [`sox_ng`](https://codeberg.org/sox_ng/sox_ng) releases from Codeberg**  
📦 **Publishes images to [GitHub Container Registry (GHCR)](https://ghcr.io) and [Docker Hub](https://hub.docker.com)**

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

## 🚀 Docker Images

You can pull the prebuilt `sox_ng` images from:

- **GitHub Container Registry (GHCR):**
  ```bash
  docker pull ghcr.io/Ardakilic/sox_ng:<version>
  ```

- **Docker Hub:**
  ```bash
  docker pull Ardakilic/sox_ng:<version>
  ```

> Replace `<version>` with a release tag like `sox_ng-0.1.0`.

---

## 🔨 Building the Image Manually

You can build the Docker image manually using the included Dockerfile:

1. **Clone this repository:**
   ```bash
   git clone https://github.com/Ardakilic/sox_ng_dockerized.git
   cd sox_ng_dockerized
   ```

2. **Download and extract the sox_ng release:**
   ```bash
   # For a specific version (replace X.Y.Z with version number)
   cd sox_ng
   git fetch
   git checkout sox_ng-X.Y.Z
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

- The GitHub Action runs every 30 minutes (`cron: */30 * * * *`).
- It uses the Codeberg API to fetch the latest release info.
- If a **new release is found**, the workflow:
  - Downloads and extracts the tarball,
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

You can also manually trigger the workflow from the **Actions** tab on GitHub to force a rebuild.

---

## 🤝 Contributing

PRs welcome if you'd like to:
- Add multi-arch support,
- Add version tagging like `:latest` or `:stable`,
- Improve the caching or reduce image size.

---

## 📜 License

MIT — Do whatever you want, but attribution is appreciated.

---

## 🗣 Credits

- [`sox_ng`](https://codeberg.org/sox_ng/sox_ng) by the `sox_ng` maintainers.
- Docker and GitHub Actions setup by [Arda Kılıçdağı](https://github.com/Ardakilic).