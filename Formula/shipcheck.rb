class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.5"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.5/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "d3cc0f1a6ee3ed8ca12dd61be5a9bc95f0a101a5bfe265b2cbfee7ef96b48698"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.5/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "5e4e65173df29df44aafa2b678f014e8cdf831073c04e0591525c33d6d383772"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.5/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1da9361f3bd784e5f4e63ddfe0940da38192378e72fbf47707dfd4e973437632"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.5/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0ce2398d24c5c1738a75b3ea2ab82628ae329058e061b8d3f48b8b3c5d2a901"
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
