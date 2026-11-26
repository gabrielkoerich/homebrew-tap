class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.25"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.25/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "3132016fa532c5c394c7fee32f010ea8432fa43cea3da001574cc632e0ee4c26"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.25/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "694b3a77eda96e77650330de884e90d7f12c6dbf7c5efb4c0a8c9d859b4fb680"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.25/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "414216d8f520f0d01e1ea5472851c7d9d593cd4c9d3ea90e2d0ffb27e511c0c1"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.25/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "04b0e4224c103fa0f7350fa59a93124bb58eb02dd4bb13c901c9383d7718845e"
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
