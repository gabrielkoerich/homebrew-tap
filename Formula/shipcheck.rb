class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.6"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.6/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "f6a0e5c98d2567e23091e0de99156933bbe3d6750d01658e84602ae3c908e9a1"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.6/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "9795b36e7f84e701ee039c8bb45db0cb89c318fe049043c1427f64ed701c830b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.6/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "65554438de6fd9aff905934b0993f75d911eb1a86fbb309a2f95710cc5261a1c"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.6/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "adc6d9fd159cc50b55129a521f4dd444b2c44dc1301cd8a96b8bdfc11785b1e7"
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
