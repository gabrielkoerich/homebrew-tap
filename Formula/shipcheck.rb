class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.13"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.13/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "fe2a59bf345cde564f90093b82d9a94e298dfe43943853e03031a1a27d81d740"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.13/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "5ea0140f84fe72d6eace403fa3cddb02faa1c8ef898dffcbe4b272fe11532824"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.13/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c34c1d4b62990b4ed7180677009d4388bb7d3fdce4f1219ad288a83396e57af"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.13/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6bcff65f78c3b01079234ee651ff2c8fd6ecde32d82feef7c10c926e7e62f993"
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
