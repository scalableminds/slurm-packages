# Slurm Debian Packages

## Generate New Packages and Dockerimage

Releases are created from tags.
To create a new release for a new Slurm version run:

```bash
git tag "<slurm_version>"
git push --tags
```

The corresponding packages and image are created using [GitHub Actions](./.github/workflows/build-slurm-packages.yml).
