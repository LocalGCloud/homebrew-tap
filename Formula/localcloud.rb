class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.12"
  license :cannot_represent

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :ventura

    url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.12/localcloud-darwin-arm64.tar.gz"
    sha256 "ba1fb45558dfedfe5ce41b7217b17658ffe80edc53b1ad8269effadf5193cb11"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.12/localcloud-linux-arm64.tar.gz"
      sha256 "60bd1a34f19c1ed3ca691e793c2444e05539df481aec0f91eaf2625ee2233061"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.12/localcloud-linux-amd64.tar.gz"
      sha256 "e7d35ee66d472f33fe959203316f27850a8c57177dd9bf20af63efbc90fa59ff"
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
