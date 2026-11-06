class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.19"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.19/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "f0b48db5c81abf8340399445d99c5af07e01cc7f460f22f4c839c72901db8edc"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.19/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "78436eb3cf490baacbe14833c783eaecf168af705a6d1c3fa0b889e5fb527dee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.19/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2109c50eccfa1371be2399d0173ca3119c3305a5ef9ffabc76434a97c9ab123b"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.19/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2f3eac245c8f5db8b72e7287373f98a0acc9ed5ba87f510726aa482d744bdc7f"
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
