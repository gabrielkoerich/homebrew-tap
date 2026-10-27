class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.22"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.22/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "1aa266e4866a31a509a5199b779af9d6693c632f5da9d38c8d7a53d970cbacfd"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.22/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "8f60663577753d39092e8b31df04cb49349c2adcd3d1e38858985df3c0912259"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.22/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "621bcec601cdbea4b65349bda517504e70af1b1a7bfaee3ad50ace31dd1cf133"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.22/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e1b857a0b5ec6bdb3fc25a01bf6dcb620348425de59f6c0c14e735bd5e226b32"
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
