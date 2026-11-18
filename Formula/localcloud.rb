class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.15"
  license :cannot_represent

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :ventura

    url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.15/localcloud-darwin-arm64.tar.gz"
    sha256 "695aa8ba4cd9118bfe6048bd06e3b20788429ebf0bdb796b8f8142ac7289b6df"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.15/localcloud-linux-arm64.tar.gz"
      sha256 "7b7609a99ae6773ccfd17ebf06f27c49a425cf011537e434a128f32a77bfbf52"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.15/localcloud-linux-amd64.tar.gz"
      sha256 "47c95db9da92bf5cbf73182570eb43dc2292bd9170f04da874f29444bd72ec3d"
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
