class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.8"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.8/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "1f28b52788f65ac7ee5a2a8882feb325f01efee19142e760ab00c760ffc8523f"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.8/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "b06031f92d4cb652dda8903f6c46d4a5cc316ce8b8bdb3bbfcfeb00d2c6249d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.8/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fcedb8afca08e0b682e8b22f529d210eafb4237c081c3fe3a3b75bbba3f2fc18"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.8/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d2e0074de32b641014ee2f950b024973c35ff8d63520b37672ad31692ec7fa00"
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
