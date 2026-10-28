class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.24"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.24/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "20de90326506b00ae0636f7e0e8abe5669f1c7d832a2f1fd85658adcaee32521"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.24/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "7c80ef8ee2c84f4f783f19ec87bee7b0b6fe3b755673517f27733289a750448e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.24/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1b3e40dd37fdc68e2d39f464b44722e9c30b8760ebb020bb74b23d9371861e90"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.24/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c5fcacc3c953470838c1deeb629a9ebc9b7fd3ec8ac734ced0a0b57435cef2ac"
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
