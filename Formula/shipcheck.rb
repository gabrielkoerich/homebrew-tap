class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.2"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.2/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "ed228ff2bf353d2ba92abd2c58ccaa0c119eaa6387fc0748e47609f4c0f2c158"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.2/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "d15cd6e1f7b41aabd2b74c28dff09d107b48866de18c7d2fc56206f05b71159c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.2/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf6d6cae65ff55a6ed2b9a6303b7a5be6f649c42e93dfb38431f381c5596d01e"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.2/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d76594681956890d2e1ac0d66e79b8917325102dd19bab89366bc9ad4420632f"
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
    assert_match "usage: shipcheck", shell_output("#{bin}/shipcheck --help")
  end
end
