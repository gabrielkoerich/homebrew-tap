class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.11"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.11/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "96a114416cc4f8b7076074a4af178baab444b2dc2c7f15a44448e51db4e9e648"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.11/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "9d7587c902e19175e29ce34fdd72c93370451820c9e4984d2b41e8f013e9a532"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.11/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d020e6e7e6cd3ef7f6ab50aee5bab821d10ee8d30f0d2d874be0ca0b9d6d070"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.11/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1a40107415295da81abcf4edb4322cbcd30ae762beb80190f3849ef87d577555"
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
