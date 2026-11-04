class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.14"
  license :cannot_represent

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :ventura

    url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.14/localcloud-darwin-arm64.tar.gz"
    sha256 "835f99e66c881268861c33c178cb08ed9c81fff0e617d855b937f91a01994dea"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.14/localcloud-linux-arm64.tar.gz"
      sha256 "3d425e99a7f6f5c08f054bcb5b5d0f68df2cfeacf80670d42342a66348e6de7a"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.14/localcloud-linux-amd64.tar.gz"
      sha256 "2948e489b66b9c47183d1f3fb5292d9bea063d6fbd08a4e7ef22cdc240e1b244"
    end
  end

  def install
    libexec.install "localcloud", "localcloud-runtime"
    bin.write_exec_script libexec/"localcloud"
    bin.install_symlink bin/"localcloud" => "lc"
  end

  def caveats
    <<~EOS
      Docker Desktop, Colima, or Docker Engine must already be running.
      Linux binaries require glibc 2.35 or newer (Ubuntu 22.04 equivalent).

      lc is an alias for localcloud; both commands behave identically.

      Quick start:
        lc doctor                 # check Docker setup
        lc start                  # start the LocalCloud runtime
        eval "$(lc env)"          # export Google Cloud SDK environment
        lc console                # open web console (http://localhost:5380)

      AI coding agents:
        lc mcp                    # stdio MCP bridge for Claude, Cursor, Codex
        lc guide                  # coding-agent prompt and usage guide
    EOS
  end

  test do
    canonical_version = shell_output("#{bin}/localcloud --version")
    assert_match(
      /^localcloud #{Regexp.escape(version.to_s)} \(commit [0-9a-f]{12}, released \d{4}-\d{2}-\d{2}\)\n$/,
      canonical_version,
    )
    assert_equal canonical_version, shell_output("#{bin}/lc --version")
    assert_match "LocalCloud coding-agent guide", shell_output("#{bin}/localcloud guide")
  end
end
