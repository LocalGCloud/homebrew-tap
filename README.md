# LocalCloud Homebrew Tap

Official Homebrew tap for [LocalCloud](https://local.cloud).

```sh
brew install LocalGCloud/tap/localcloud
```

Docker Desktop, Colima, or Docker Engine must already be running. After installation, run `localcloud doctor` and `localcloud start`, then open <http://localhost:24080>.

Upgrade with `brew upgrade localcloud` and uninstall the CLI with `brew uninstall localcloud`. Uninstalling the formula does not remove LocalCloud containers or persistent data.

LocalCloud is proprietary software. See [LICENSE](LICENSE).

## Maintainers: how `Formula/localcloud.rb` gets updated

`Formula/localcloud.rb` is generated, not hand-edited. It is published by
[`.github/workflows/publish-formula.yml`](.github/workflows/publish-formula.yml),
which:

1. downloads the `localcloud.rb` formula rendered by the
   [`LocalGCloud/localcloud-cli`](https://github.com/LocalGCloud/localcloud-cli)
   release workflow for the given version;
2. verifies it against that release's cosign-signed `SHA256SUMS` (checksums
   must match exactly, and the signature's certificate identity must trace
   back to `cli-release.yml` running on the matching tag);
3. runs a real `brew install` + `brew test` on all four supported platforms
   (macOS ARM64/Intel, Linux ARM64/AMD64); and
4. commits `Formula/localcloud.rb` to `main` only after every check and every
   platform install passes.

Trigger a publish once a CLI release exists for the target version:

```sh
gh workflow run publish-formula.yml --repo LocalGCloud/homebrew-tap -f "version=X.Y.Z"
```

This is normally run as the last step of the CLI release process — see
[`RELEASING.md`](https://github.com/LocalGCloud/localcloud-cli/blob/main/RELEASING.md)
in `localcloud-cli` for the full release runbook.
