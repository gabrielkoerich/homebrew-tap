class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.10"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.10/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "178639cc384361ed87daaadf30dbdb7dd9f3d4c6b2c1c5cd1a967f671c2d53e5"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.10/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "f3012cdf201050b41e09ca59d9f67877c5abc2f477204bf5d7ad2dfbc066cf45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.10/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e852cd68372388df29c5f9e6b6b89699b55b8aefdad8dbf6a92b47d6c560a5e0"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.10/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "adeb874762a828cc0c7d26de657ff105446de3fb76b32241d5562b6a7d0942d9"
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
