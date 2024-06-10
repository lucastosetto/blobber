# Blobber CLI

<p align="center">
  <img src="assets/logo.png" alt="Blobber Logo" width="100"/>
</p>

Blobber is a lightweight CLI tool designed for managing MinIO storage buckets with ease. As a simplified version of a blob storage system, Blobber is hosted on a Kubernetes (K8s) cluster and can be used as a blob storage solution for on-premises setups. Whether you're creating buckets, uploading, or downloading assets, Blobber simplifies your workflow with a set of intuitive commands. Perfect for developers and DevOps engineers..

## Purpose

Blobber aims to provide a seamless experience for managing MinIO buckets in a Kubernetes environment. It's designed to help you:
- Quickly create and manage storage buckets.
- Efficiently upload and download files.
- Integrate easily into your existing workflows.
- Leverage Kubernetes for on-premises blob storage solutions.

## Features

- **Easy bucket management:** Create and manage MinIO buckets effortlessly.
- **Simple file operations:** Upload and download files with straightforward commands.
- **Extensible and scalable:** Designed to grow with your needs, supporting additional features like backups and a web UI in the future.
- **Kubernetes Integration:** Leverages Kubernetes for deploying and managing MinIO, providing a robust on-premises blob storage solution.

## System Prerequisites

Blobber is currently only available for macOS users.

## Installation

Clone the repository and run the install command to set up all dependencies.

```bash
git clone https://github.com/yourusername/blobber.git
cd blobber
make install
```

## Usage

### General Usage

```bash
blobber {create-bucket|upload|download|--version} [options]
```

### Create a Bucket

```bash
blobber create-bucket --name=my-bucket
```

### Upload a File

```bash
blobber upload --source=path/to/source --dest=my-bucket/path/to/dest
```

### Download a File

```bash
blobber download --source=my-bucket/path/to/file --dest=path/to/file
```


### Check Blobber CLI Version

```bash
blobber --version
```

## Next Steps

### Support for Linux

Currently available for macOS, future versions will include Linux support to ensure cross-platform compatibility.

### Automatic Backups

Future updates will introduce automatic backup functionalities to safeguard your data without manual intervention.

### Web UI

A web-based user interface is in development to provide a more visual and user-friendly way to manage your MinIO buckets and assets.

## Contributing

Contributions are welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get involved.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.

## Acknowledgments

Inspired by the need for a streamlined MinIO management tool.
Thanks to the open-source community for providing invaluable tools and resources.