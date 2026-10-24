class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.3"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.3/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "7899329c334111bcd97e83df8c395dd619b030cc55a9b892471dd01852777655"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.3/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "423c3ce8231fe4f8676f06a2dbc5792375e7e618c6fff3955e653f660b45a298"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.3/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f5123b8dfdb909e3c745297e9207f13cce098d2b46dfb1ea57b0ea63e564dee5"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.3/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29cb9015ca07d1568562dccb964272516a278077461c4ec3850d51b64e6ff440"
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
    assert_match "usage: shipcheck", shell_output("#{bin}/shipcheck --help")
  end
end
