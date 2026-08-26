class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.2"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-arm64.tar.gz"
      sha256 "793ac718d03c21e8b92fe60fa80f8ffad7dd22697644d54a607def3ab8b47dd8"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-amd64.tar.gz"
      sha256 "ff26e51de98f38bb7b7f38989b11712c83c2b896b17f4d84b67e34a91faf73ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-arm64.tar.gz"
      sha256 "d90d3bc5cb1d66fe7823fc1711ba417c7524b1d71847a07e0e6c4f3a0351d3b0"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-amd64.tar.gz"
      sha256 "7a8169bb9448e6a33435445e6b894b4c03588984571b18e28cbbbeda830c04f9"
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

      Then open http://localhost:24080.
    EOS
  end

  test do
    canonical_version = shell_output("#{bin}/localcloud --version")
    assert_equal "localcloud #{version}\n", canonical_version
    assert_equal canonical_version, shell_output("#{bin}/lc --version")
    assert_match "LocalCloud coding-agent guide", shell_output("#{bin}/localcloud guide")
  end
end
