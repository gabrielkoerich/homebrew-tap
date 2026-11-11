class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.21"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.21/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "02c8f907293344886b945f54f1f23eee6e24b00327d9567c52daa1b032e88e73"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.21/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "8643248626423a542a643f584ff6f2ab1085492878f7fb2e9c8746e2c7243faf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.21/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f43ec225ceb079e4cc6e6783020db6b939271d2007a8fe7f4078c8749c0635f2"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.21/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8fa34e86e6dc60b822ceccf8dd431f3dc331de68c6794778d00889f97082d53d"
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
