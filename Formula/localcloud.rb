class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.4"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.4/localcloud-darwin-arm64.tar.gz"
      sha256 "af85906091daa9186fae2cdddb1f696b88b65548ac1da05b6278472cc12ecd3d"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.4/localcloud-darwin-amd64.tar.gz"
      sha256 "db1dc655d32fb1898e594901cf29620a9374de4395b3c9cf44c5670f87c852a3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.4/localcloud-linux-arm64.tar.gz"
      sha256 "9bea6195f6dd6907418b034990b08278c4b777b6d630310fdd50051b4591e94c"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.4/localcloud-linux-amd64.tar.gz"
      sha256 "0cb670ce017ff3a38b4a037dbfc581899d15c85daf53d8a6d6efc0584efbd21b"
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

      Then open http://localhost:5365.
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
