class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.10"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.10/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "b85f75a8e9b0eaec1fabf9648604184d2e61f071cded11edf7c4e5e4ee7873a8"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.10/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "1775ca36755084ad3eff7a4df1bb6fede4fde3043b5d0ce627db7c282f7d3509"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.10/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5aca107d45a39d1dbc7b25db7fd1249c474ebe08f1754609c22b72292e8747c6"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.10/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2e59fb73bad5012aa465a9f5949b4f1f69ef196ead86ab071d070c566097027"
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
