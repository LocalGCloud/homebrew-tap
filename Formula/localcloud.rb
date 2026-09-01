class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.2"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-arm64.tar.gz"
      sha256 "93aa0b32acfc6ee7157e98f07f28f32d62eaaff0e4686eb7388c4bf1503ab972"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-darwin-amd64.tar.gz"
      sha256 "af8a4e1c44d4518ed1c5c5989bb127a3d339fb4f14d4295ee301ed2727a93e94"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-arm64.tar.gz"
      sha256 "14df5d15b1a5dfd1efdb3f4eb011845d8efa0ea9a3b338088d0bdd2dd7e6dadb"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.2/localcloud-linux-amd64.tar.gz"
      sha256 "2de5026c76a08fa5987a6cc83ba37d2b99c4423683e95c942f21e9fde1c1b478"
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
    assert_match(
      /^localcloud #{Regexp.escape(version.to_s)} \(commit [0-9a-f]{12}, released \d{4}-\d{2}-\d{2}\)\n$/,
      canonical_version,
    )
    assert_equal canonical_version, shell_output("#{bin}/lc --version")
    assert_match "LocalCloud coding-agent guide", shell_output("#{bin}/localcloud guide")
  end
end
