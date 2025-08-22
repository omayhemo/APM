---
name: distribution-build
description: Build AP Mapping distribution package
---

Build the AP Mapping distribution package by running the build script.

This command will:
1. Clean any previous builds
2. Create the distribution structure
3. Copy all necessary files
4. Generate the install.sh script
5. Create the compressed tar.gz file
6. Regenerate the README.md file from INSTALL-README.md
7. Place the README.md next to the compressed file in the dist/ directory

Run the build script:
```bash
bash /mnt/c/Code/agentic-persona-mapping/build-distribution.sh
```

After completion, the distribution will be available at:
- Compressed package: `dist/coherence-v4.3.2-installer.tar.gz`
- Installation guide: `dist/README.md`