class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.16"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.16/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "107f02eff28a8dfbd6c69f8d2b371f0261b077b88a8046cdd526aa954a88a98c"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.16/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "d403d141bafff987cec87f957c9e66181ea50bbd8768b5380af980524874585d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.16/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "12deccb19740edfb437b0d0a1aa26abccc4637ceb3ce5b65417aa19f656d639b"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.16/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93ee80887d1e8ab3d06dddff1811ad1e955b65b708cd1315d3788daf0780920f"
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
