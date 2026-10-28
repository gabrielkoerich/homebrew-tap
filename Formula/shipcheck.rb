class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.23"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.23/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "d81ef737bc41b64e11cb39014878c263204566ee28bd61f9253c6fe8d15739ef"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.23/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "acb7212dd2049f62031e47844f08d0fa0273e8225a45010d51730e4951eb70af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.23/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3ec23aae3bd6ca3c8b18a596ade44c2b8f7790f89da5bcf0e7bc063a2f6b572"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.23/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6aae794bd483db6a78fd9baadf77e8e38f34e9494a0bfbfc5b024cf2d9925f9f"
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
