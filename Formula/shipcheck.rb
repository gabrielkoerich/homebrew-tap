class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.9"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.9/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "ab2265440b2a7630d81e7e8530969304276869b4f80845f15b0174a54d9d2d99"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.9/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "ddcb7e4dfa6551eaf2bcef2210d05fa8c42109ca72092d204b9082e04adedae7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.9/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c7fbdb5d4cdebfa504eda9c4578b550600ac9a49096bddaea9f9bfd7c1a2ab2"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.9/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "634afec357afb00dba10d25354b63a758bf8d92a90ca3b865a22cbc4dea68122"
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
