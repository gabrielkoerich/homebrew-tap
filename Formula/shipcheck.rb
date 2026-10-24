class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.1.4"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.4/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "ffbad31855c34376eb8b6e3340d21f79dab6c9a65494f8459159035f56df50ba"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.4/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "bb113c5f26058284c81a12077ccc3908c7342bf1bad472c4bee0911c2f8231fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.4/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b29f95f1d36271b8560bd9e5f1e7a85a1b0d347de81ab003239bf47c31c815bf"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.1.4/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0a5331347891bc05769b6961bfd7632b05e05cc07a14bf348cb7b54c50f1310a"
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
