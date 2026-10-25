class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.11"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.11/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "ba0094b7ac5d315ee7d78b25ce754125d0c8b4e16a657dfe2c47a4ccee51f637"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.11/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "36c54064321b2dd1de625e0c09579a4bc0ecd425cf674787f371ad77cbd4155e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.11/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aab64d22bf221174387c634ce8d5e5d711131fa1591ba3702d687f46aab2b4a8"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.11/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "74edf692e5d51b9b1461a9aa738d5cf5300d32cb1805cd8146a36b084d4309e7"
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
