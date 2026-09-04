class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.3"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.3/localcloud-darwin-arm64.tar.gz"
      sha256 "55c5f51a995b8d8e080c459ada4f2de0b353fedbcee958a53b87042dc4c74ba3"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.3/localcloud-darwin-amd64.tar.gz"
      sha256 "136e790f997d03d5d7acd895cf3bfe89bce645027307fd218c217d57b6fd2561"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.3/localcloud-linux-arm64.tar.gz"
      sha256 "6ea413a42ea7b4560fa14db06cf07f101f03b8a27b757f518d50e80875a66b13"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.3/localcloud-linux-amd64.tar.gz"
      sha256 "e4c9a3b44e5648e8cc37620947b2460c9ae29511ecb8b1b900388f20433128f3"
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
