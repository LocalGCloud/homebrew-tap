class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.2"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-arm64.tar.gz"
      sha256 "b5b18b6e2f81fcab8e643388c23bd48184cc6e2b35f5015a82f71b4724ce9182"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-amd64.tar.gz"
      sha256 "75af953102a649912589beb8278bb19e611f51960a20e9dad06545bb4e0116ca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-arm64.tar.gz"
      sha256 "59280de7b7332fa16041fdb20901a7e85adbf276e02c5de28d197389a304b158"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-amd64.tar.gz"
      sha256 "9b86cfbe46cfb19d60f30d8c611da9cfd942529f41408429cb1c9d93e4408081"
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
