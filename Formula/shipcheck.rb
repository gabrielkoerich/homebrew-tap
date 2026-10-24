class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.5"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.5/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "37fabaf8bc882a067211674801373a645f0ef60b8afd9679747e9c0bbd642cea"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.5/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "f9182d1d57aac240e59a8ab3493726f65c06ed09601875fde734836c7140bd06"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.5/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a69a2b793ca342146338feb4c5d53faba220a64c1d01f86ed97334306480e65e"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.5/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd8d942d42a058d3d30ef6b20c7286fa1887300d44ea0be7bdbf6378ba46898d"
    end
  end

  head do
    url "https://github.com/gabrielkoerich/shipcheck.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
      # The hardened runtime stops another program loading code into shipcheck to read its keychain items
      system "codesign", "--force", "--sign", "-", "--options", "runtime", bin/"shipcheck" if OS.mac?
    else
      bin.install "shipcheck"
    end
  end

  def caveats
    <<~EOS
      Host mode runs your checks natively in an OS sandbox. act mode runs
      each job in a Docker container, so it needs a running Docker engine:
      Docker Desktop, OrbStack or colima (brew install colima).

      In a repository: shipcheck init, then see https://shipcheck.run/docs/quickstart/
    EOS
  end

  test do
    assert_match "Usage: shipcheck", shell_output("#{bin}/shipcheck --help")
  end
end
