class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.7"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.7/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "d960aec7f24bfef0f0fb6f957bde2437f7877a2422bf04a017c477c2905c0112"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.7/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "cdb2008d143a17cb9070b42f52b0a318950f574408d25bddb118b03aa9e43adf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.7/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a9a5b56fb84b60208f42e34c4f2483c865e137e9a76053162b5a07b4551d382c"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.7/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f8626d4f9ce87738155308c30dc0f8d311681f4f93e28d632ff41be757dec3a"
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
