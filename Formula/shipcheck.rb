class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.1"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.1/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "f78672d6041203a636bdf0d7bffb43fa009b6ca5c531f43e8903525e60aab0a1"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.1/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "3eb6a8480b1d2bde6f8d342bc9da85d2c6c8319b8e96fcdfe991a87275434dc0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.1/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b170f3b4b4aeba34b162b9c3ac332130c0002a2f47062805e0f02c43343ff292"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.1/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "514601c1d2e2c8feef5ac015209a74c771196cf28fd647e1db385b80c09776f1"
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
