class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.13"
  license :cannot_represent

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :ventura

    url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.13/localcloud-darwin-arm64.tar.gz"
    sha256 "be559f61c2f6d02be20ae9cd8a1538ef7524bed350c2bbffb663714ffe16bc51"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.13/localcloud-linux-arm64.tar.gz"
      sha256 "2a6595533277f7f24025358265f15f4b0a15b5cab4116ce28b76d73f7fb7ed54"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.13/localcloud-linux-amd64.tar.gz"
      sha256 "a117a4e312c56a86943da3bbcf9ae070fa039f42b041130ae002ad4bba8e762e"
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
