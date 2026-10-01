class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.7"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.7/localcloud-darwin-arm64.tar.gz"
      sha256 "ec62863db03c562733ebf86d226d894ac3b54c88b45135a56ebd0e1ca895eeec"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.7/localcloud-darwin-amd64.tar.gz"
      sha256 "6b85e4dcd4ce5c8be7593431f347957937f921a687de4f87ca5ca87442b79a6a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.7/localcloud-linux-arm64.tar.gz"
      sha256 "888c0ab557871cdeaf6a7fcbb0776974d92c551d1b5ab495d97d0b6605a12405"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.7/localcloud-linux-amd64.tar.gz"
      sha256 "19d4f1b3e6778f269539aa081117e7c98b4fe0dbf9157660eeea67847adbde18"
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
