class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.6"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.6/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "4fb668de966774ae953f3e45c71f78014b6ca2ce56882550dc152a3b90f14121"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.6/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "87e3a02e2ab6f0aebfc34158f8c626c260d9f7cebc1213cae64371769d37e7bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.6/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "434b5a491c82b88feed427cd9fc5fa944daaf043a127be7d1212f91d2166e38c"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.6/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f0501ef0d65976d4e1d3aa9f45de6be06eb52cdccf7512382f35d79fb749bc9"
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
