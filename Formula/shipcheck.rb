class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.15"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.15/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "d4c6b49b931e6a1225dce3cfdfdd514956f9e79edb4b5a8a549812d113bff3fc"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.15/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "3f9ddcf8af2f4857b5b42f521d2959b54890c86ddb72ca43fd5b2aef653b9bb7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.15/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2b757d77da2a2f521bf0cafad19c9b3948f47729f72b44360366f77bb1febae"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.15/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d80a19b7f4a734901468fe8c8e649fd9d1969822352634d780e47772406236c0"
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
