class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.0/localcloud-darwin-arm64.tar.gz"
      sha256 "d546706d9ccf3ab87ad12963026a7be3d2fb31041e708fbc5c11e337487fa3c4"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.0/localcloud-darwin-amd64.tar.gz"
      sha256 "01a4f20db7d9f05c1beba58f46d7bc5418c7bd36feef73f02f5895dc038ba0fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.0/localcloud-linux-arm64.tar.gz"
      sha256 "ae1dea6a4e659b5d49e4f917b2bc735ff317e669fd3f52ecbcd41be37632dee3"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.0/localcloud-linux-amd64.tar.gz"
      sha256 "7d7ee554addbff9f8b14a82669f4082fb15bcdbed0589df8e1e2f3526e7ec401"
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
