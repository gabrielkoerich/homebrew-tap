class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.9"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.9/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "af827cf7e3d6095dc1da1434d9bae8ec473bef47fe9bd8d1a93a096d30a59e2d"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.9/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "85c85d7c13dc2666b373ee035cb4357e35c5b2f37cf4daa659a556944da3e12d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.9/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "448376f3558bf5dd21fcac8c3fdf10d0b21bee11e39a0513a79824a9735dda6e"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.9/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f3453d91f9dcbaaf93b7be39d07e76846d44c1f6bec7adf8ebc3238726a4e725"
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
