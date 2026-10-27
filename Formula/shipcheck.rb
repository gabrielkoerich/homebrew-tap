class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.17"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.17/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "382968654bff5e80c7388a56978b9895404c220bc01ef908f4f3091373dfcd94"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.17/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "6f15aa313e8719fb9983558c7273462fbf1c5464b6fbc50b4a2180a898264ad1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.17/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "11f1a101e2dc08f4adec45f06cb58875d8a68aefd2aa570dfdfb4ae8337e1095"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.17/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "24ea5f17a4c943b7023d1f465af827cfb3627f445e8bd7ba1a752e7c79c7cee2"
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
