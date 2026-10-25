class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.13"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.13/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "0a2a1a13cf900494688de8e342039b7f436de72b79871abed494826bd7b74e67"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.13/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "ecfb541a3f25b558d3de9570761d9ad4d8ccdbf0474692dfce06fbf363bb8730"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.13/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f5f9e7d911171e356985c11b65e4660029f2e39c78a883445d63ab06fd7fe66"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.13/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "86c79c3dbd56800a768be8c57c98d5412879847bd545543a0ee4bd5e89ba1c59"
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
