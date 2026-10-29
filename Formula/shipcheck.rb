class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.1"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.1/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "94bb211ecb71fb283cc5c342713f97187693386dac27d2d1a092e012003a1b67"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.1/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "ab3a400da6d9ad4d49bac6df5e355933e1a54550eb46bf693b72bf521b234114"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.1/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd871d803a29a6a72a2eaed4b6a15f3ce041c997233960725360cee08d7b9cde"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.1/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "08f7569c58a9dd8d8ddcb95e5e005fec2aeb4d106f8feb884725f0e27b2cc878"
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
