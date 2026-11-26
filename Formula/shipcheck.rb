class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.24"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.24/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "52183e73fb34996be12ef6c75e1fae5e1260d6bdc4da1836f4f3484439aa3eda"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.24/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "c4e1660806b56004601af05d4dcee170f21dc7b23be8054cd9adb2ff3c405940"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.24/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "12b0bc08cb79db6082fc2a50f1d81add7538963a52aebde36c988da54563413e"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.24/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5f1ed4f1e2ceeca7edc91f56324ad681f06eee9a70c235efbf4b3ac6b4c75899"
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
