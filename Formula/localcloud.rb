class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.1"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.1/localcloud-darwin-arm64.tar.gz"
      sha256 "b9b33cafdc40890cdf87dfe07289010f5fe1a68430faab3b758c76d736640b6f"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.1/localcloud-darwin-amd64.tar.gz"
      sha256 "56bae15cd07465f7b060388263502359d42b0fe5c5290189267bcffac5017f04"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.1/localcloud-linux-arm64.tar.gz"
      sha256 "3a21fc8d46c69c4b8484460ef8ffeca3a05b9afbfb7909aec4e193f03f2119de"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.1/localcloud-linux-amd64.tar.gz"
      sha256 "4ab5c5271c25852d91bc8c1b4299a554a16316b354967e54a6ddac71b385ae8f"
    end
  end

  def install
    bin.install "localcloud"
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
