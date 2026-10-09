class Localcloud < Formula
  desc "Host CLI for the LocalCloud Google Cloud emulator"
  homepage "https://local.cloud"
  version "0.1.9"
  license :cannot_represent

  on_macos do
    depends_on macos: :ventura

    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.9/localcloud-darwin-arm64.tar.gz"
      sha256 "bc15e741c178cb70599a9af367d5f9ad3ffb8889f4dba6fec0f915b746a8f32f"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.9/localcloud-darwin-amd64.tar.gz"
      sha256 "59c7b7e6a68d295df4d02b1eb3c2f42747f48c470e056b4e6347ba37bb5816ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.9/localcloud-linux-arm64.tar.gz"
      sha256 "62d497e2f835f3d20152a195a30c8633570bf35cc3c1b3aca355028737f5ba30"
    else
      url "https://github.com/LocalGCloud/localcloud-cli/releases/download/v0.1.9/localcloud-linux-amd64.tar.gz"
      sha256 "92132008a231c64b507544aa095d4e3c2b402177ae87c99a0b530569f9f84219"
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
