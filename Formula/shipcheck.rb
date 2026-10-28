class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.25"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.25/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "442c6c8d043467d87b2e6a742370b861d7539deaa6f95dc1d79962a3805e7189"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.25/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "65a1a5e31b2120b573344703c9047f3a9b00de5054dfdeee47415adcd22aaea7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.25/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ecb1794595373d6f2b46ad70a6f2ea9a4803055a0b87dda957d731bfee5242ec"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.25/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "58db47e0f137685ce18f312e9c94d8bfaf755bdd9dfc6a8decfda2fd0f0dc42a"
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
