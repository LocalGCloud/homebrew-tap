class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.2"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-arm64.tar.gz"
      sha256 "263ebba7ae8262de7f368b99db4ce24d579cca6b40d102ba5cf3b9c04151ad23"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-amd64.tar.gz"
      sha256 "de8631bb9d5afaf5656d4e9034ae50955894bc589cb3a707373ab10e940d7694"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-arm64.tar.gz"
      sha256 "37bb1a02f7a2a9c3096aea9b4377943e2650fdb78f0a8aac9344d07eb61340b3"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-amd64.tar.gz"
      sha256 "e1e8d76b8ed2cc3d90089f90b87d7836dfae5b67ed1fecb8d11be4433428b1bb"
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
