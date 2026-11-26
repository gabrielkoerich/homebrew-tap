class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.26"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.26/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "2ec8787e4714d4a91ef9787aa68856d37aefa19a571339f378ee054e2800a679"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.26/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "8cd2302ce2991538d44824984081b101be19f0d486d92b9d0db0ad2b21ddd89a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.26/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc90726f66ae64234785eabf7fdf9e5018c2202f026f64df36c59031c71d5ef9"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.26/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53436b0cc8d9b5addeab6dabfc7a52ae97c853b65110b2e82c495e5aea0b7103"
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
