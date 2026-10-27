class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.15"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.15/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "f27ff2af57eb8be777d46c0307c58889e6890351ca79e863be181f5d5a319975"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.15/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "68aa35f40afc5816d92c5a635b120dc4f8b85c88908c68c2a99804599c73978c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.15/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c853695a430d08e0e60f44dcc331e44bca1bd8aceddf7fc6f18e5350956da263"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.15/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d22b73350ef96879aac7f26aec87d712b5781c2ef69a02c4117dcdeefa100c1"
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
