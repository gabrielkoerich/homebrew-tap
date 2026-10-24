class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.7"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.7/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "bc1fbf0aa464b08fe16e65e311e9bf7658a6508cffda29614d677f1d7bd23b19"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.7/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "765fd85b28205d0d45e3fd4fd6da3e7927ec95527c794f9244e187eb152e5346"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.7/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c72c8ca95dd0a78c3f0b035c12d021586f8b0a362981cc457af1e9d4183476fb"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.7/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c3a37ed15e4a2c51c8ddb8c2a0e8eac012cae154058eb274b3e506300c7d6a54"
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
