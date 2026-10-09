class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.11"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.11/localcloud-darwin-arm64.tar.gz"
      sha256 "8d7fd55b620f2d699985bdf5f529f27ca9d21a1f233990ad012ba9ebf4d85756"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.11/localcloud-darwin-amd64.tar.gz"
      sha256 "6c7d57c9dba11bd187f7fcc25db9dd2b304efcd250289bad216fd517d7be911a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.11/localcloud-linux-arm64.tar.gz"
      sha256 "fafbb7f4b47e618119623bc49bfa547a38d3aece19a13816caa1f8c0ed10e684"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.11/localcloud-linux-amd64.tar.gz"
      sha256 "59fe59aee7e8cc97767a1b4520ceb0386b449cf4eb36bb76ba56a2bae9c373b5"
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
