class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.20"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.20/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "da7511951f9688d651946c9c4980d04d8743fe9cdaa337d79f58c938cab331c8"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.20/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "aafce5595979c895c23fbfcb0444d37ebc192c4a709d713fd99fe4a9d227dae0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.20/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5cfe897e7c9dcce7f8be18a6802b9da612e9266c27ac0b3f353793105910bab3"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.20/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99380a2bf026899a2b8d243b4330ab036638f2fbad081ebf729cd7884b2e28e0"
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
