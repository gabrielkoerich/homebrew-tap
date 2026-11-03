class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.14"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.14/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "ed0580c50f18a60c0f89e7a81917f695ebc1ccd444fb98b325d8363a107a3873"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.14/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "9541e657acff8fea7fba2f8a88ee53bf6515069716e41beda5447696a6144001"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.14/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ce147bd51aca5e6feed5d6652492bd14a1453546882499215eb855a5f6c42bb1"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.14/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38d9a20ac18e06a734b2ce179556c85d4dbbccf27d9465cb57340c7ad4728767"
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
