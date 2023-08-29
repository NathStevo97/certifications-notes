# 3.21 - Verify Platform Binaries Pre-Deployment

- Kubernetes platform binaries are available via the Kubernetes Github repo's release
- As part of security best practices, it's important to ensure said binaries are safe for use
  - This can be done by comparing the binary checksum with the checksum
listed on the website.
  - The reason for this check needing to occur is due to the possibility of the download being intercepted by attackers.
  - Even the smallest of changes can cause a complete change to the hash
- Binaries downloaded by curl command i.e. curl <url> -L -o <filename>
- Checksum can be viewed by using the shasum utility (Mac): `shasum -a 512 <filename>` or `sha512sum <filename>` (Linux)
  - Checksum can then be compared against the release page checksum
- **Reference Links:**
  - https://kubernetes.io/docs/setup/release/notes
  - https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG