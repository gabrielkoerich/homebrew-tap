class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.20"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.20/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "805520f35b07aa0c2e71d8441fc054dd18a973e5d07678be0bdf7f0a0fe8d0a2"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.20/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "f9bf5e2e93efe96f07b3503dee909d4ee525d47ca05a72d5061746528306ce78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.20/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "962d9c54f6302da4c1185550d6c7b46d5a7742fe46399aa8afae3e0ad40a6f14"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.20/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "77eb4086062a22593ef39326d3635c88f431c310328e3d8a4d550285e59f3c11"
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
