class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.18"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.18/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "5236ada43b3cc2e39566ca00f57395bcb212f8b7edb9a4104c871fa71f4b39b6"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.18/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "0ae74056a3d1e8b7cf8bd5995df914c0bf1ebca8764aa85d6fabfb5d8574cea3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.18/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d6a3fb620b291053d7724f3f0ad5cf96a980131b7039ed6676576175c0c44854"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.18/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "072484c0fa3e62eb00776b70fa172df754b4bf1360deb98b96aab4f54b7f4a90"
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
