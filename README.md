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
  docker pull ghcr.io/YOUR_GITHUB_USERNAME/sox_ng:<version>
  ```

- **Docker Hub:**
  ```bash
  docker pull yourdockerhubuser/sox_ng:<version>
  ```

> Replace `<version>` with a release tag like `sox_ng-0.1.0`.

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
├── Dockerfile                # Builds from source in sox_ng/
├── sox_ng/                   # Source from the latest Codeberg release (extracted)
├── .last_seen_release        # Internal file to track latest processed release
└── .github/
    └── workflows/
        └── release-watcher.yml   # The automation workflow
```

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