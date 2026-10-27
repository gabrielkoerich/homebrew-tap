class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.14"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.14/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "c6e9488af2b17d08bdfbb078ea347e9d46153d3d16bd9056be11f32c1c7ca9e5"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.14/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "a893534c8af2c1d9b86aa5e78795031a1df4ce51d3a2806420b73dcdaa212779"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.14/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7bd6596ced742d36fc7230c249914065d8a355837268a82f989e171c7c0109cf"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.14/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d39e524b9df7ca6f81dc8654fe457be67ade5d35d27bba282c058bf6adc5fcf1"
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
