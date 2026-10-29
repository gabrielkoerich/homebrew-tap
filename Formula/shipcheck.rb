class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.3"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.3/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "ee48371744eed3a89dd1ea73c85e9b87729d487acc6bfd40706db2b7a8deec8e"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.3/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "7100856bdfedf5b33284d052a082ad41ab2032eb4986a9a100742b26ef4ab7cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.3/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b077b6e351d9b245da1cf422269279b7a88cddf30e4bbbafab0c792998fe3cc9"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.3/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cbfd9709b11214e63b1ebbe7c1ff4338656ead75ef7e90aaa5c05d87ac0d8650"
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
