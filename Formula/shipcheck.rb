class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.4"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.4/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "7d74075c5cff0dcd811b145d66c2df765ee31d7712f8d1e1a1eda9057bb48dae"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.4/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "bfa3b72647f8943b9107abfa091fe37f9d2ba63e3c3a53f42ac884f7994942b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.4/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bb2608f6d9410fc69e7179a173ab781f64a7b71e5c3ff1fd8b1c96b98d0b4914"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.4/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "77f9fd614bc6692ea9e85d61901eabfd99ffb87e87233d9d5cbf54d782c3d663"
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
