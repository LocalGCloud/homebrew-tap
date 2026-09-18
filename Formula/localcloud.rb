class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.5"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.5/localcloud-darwin-arm64.tar.gz"
      sha256 "07ea54f96fb1e0422c9c24abd5316155da3da3d6eebddd6e311ebd2b8802aa85"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.5/localcloud-darwin-amd64.tar.gz"
      sha256 "e72da9638b93eb9ab5daaa0b7f25d8c0d5d119f270cfd00b31a0e874130a9adb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.5/localcloud-linux-arm64.tar.gz"
      sha256 "3c26f2259e1a8a52e21cc666af8f112c252377b55c7d403855e9d34fcb5142ad"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.5/localcloud-linux-amd64.tar.gz"
      sha256 "21250bc26b43a07001f44aaf119d73953fc3f825964d493badbe080fa16c65e3"
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
