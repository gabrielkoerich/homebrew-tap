class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.19"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.19/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "a307f903f449ba49c02bd6dd1fdea0c0bdd16476e100a5a69758c6425e010bc3"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.19/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "876e581067681c4b112ba4d15a02fcc1ae9e44d25083f03dac363fa3d367c055"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.19/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5e15009431e160fb9ea5fed270e8feffc43a1ee4039cfc5a9edc8ed9a105d9de"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.19/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a4d4bc3fdc7653a2a9fccbcba36a24da17f15d33ba69b464838a9aee0fe5d67d"
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
