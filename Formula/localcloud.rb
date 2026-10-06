class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.8"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.8/localcloud-darwin-arm64.tar.gz"
      sha256 "9e9bfb77ff7c17605f7d62768d7acdfb368a028806dbfea9444c9f4ae07ba8bd"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.8/localcloud-darwin-amd64.tar.gz"
      sha256 "5401b1fe00bf3218ad749a47e58b8414134f9ef281954d370f22d7ceabea7aab"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.8/localcloud-linux-arm64.tar.gz"
      sha256 "b93024c61ec35cd8f5376b1034af05d176bb1b7451c22077b8c3740cc18263e2"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.8/localcloud-linux-amd64.tar.gz"
      sha256 "4ce2e0db82551191e7180b0f39375379768a57ba4f9b861046ada6f64e1097a3"
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

      Diagnose Docker and start LocalCloud:
        lc doctor
        lc start

      Then open http://localhost:5380.
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
