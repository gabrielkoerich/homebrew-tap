class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.0"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.0/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "f5ab0bf9db45c36edc3597679b9a4214cd487bc18f9a9f63d9596bc35afe3783"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.0/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "75309eaf4ecb539b4571441abfa836d3d44afcf043d4ff0a184d03a9ebfc03b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.0/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7b304535a6474ce686028cb8e841e5de8069467e4d0ff65e7d4367feb31a3cdf"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.0/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a01983def6c538d118a776b0bcaacfcb120c1556303fed1d86aa3c8476d31ba4"
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
