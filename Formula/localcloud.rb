class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.6"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.6/localcloud-darwin-arm64.tar.gz"
      sha256 "2b9c6514767a21c36226d16e13ba8c651e9723aef49a7cf4c7ff65fb6376ab3a"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.6/localcloud-darwin-amd64.tar.gz"
      sha256 "2ca42d3f38b6c283ea088db1fc4e67afec28ee8066f631aa34f83dc41d9485eb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.6/localcloud-linux-arm64.tar.gz"
      sha256 "5c5890417e8afd864456542ed206dca63dcf6b96cd420001b2865a4c06102491"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.6/localcloud-linux-amd64.tar.gz"
      sha256 "ff3908c6cc2c00c356df4dd87533c930dfc5d385e923cc805b4cad4e4f9e85b3"
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
