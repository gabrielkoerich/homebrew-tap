class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.21"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.21/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "e39cd970cd27723507634938e4d22d26d969684a398536be24191f83882f1b45"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.21/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "72f4ead555cb3a730c6c3589693ae3843cd4afafae6b9ebad487b7a57e8533ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.21/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8e22f35fee7a3283f3c7face769eaa25e26649481d59ca0e0f94aec9173a149b"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.21/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5a1570fccbb2c5b058ad168eb0ea25af5dff8a77b25db25905da2fe0f41d4e59"
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
