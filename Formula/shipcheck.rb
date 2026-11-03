class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.17"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.17/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "7c8284649e3af448938ff53b9ae33926a871fbcdd791f9af145edcf7d384bd91"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.17/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "d05df73a634b6b48549141e503b89ca3ffacfbd618f14fb1113ec5cb9a2f0c7b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.17/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24c7ba7d424676f0f67f8961e158fdb0bc7c896b751f34f18df65eec3ef2f8ce"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.17/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "605fd945e602b9570d3bb140866030621d0070ffd3b11499d6b33c7f3a221df8"
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
