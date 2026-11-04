class Shipcheck < Formula
  desc "Run your CI checks locally and post the result as the PR's required checks"
  homepage "https://shipcheck.run"
  version "0.2.18"
  license "MIT"

  depends_on "act"
  # The client only. A formula cannot depend on a Docker engine, the caveats name one
  depends_on "docker"
  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.18/shipcheck-aarch64-apple-darwin.tar.gz"
      sha256 "01cf938e3a3dbcf7c4268253fbbe9846d74201219b2d0356128c3fc8d4c6afaf"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.18/shipcheck-x86_64-apple-darwin.tar.gz"
      sha256 "8d11fb7167ed0386cd0264a3fe47d8947de29d04639ceb97c303d6320b33423b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.18/shipcheck-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3238510644f5b7f48eff95da8b911f1841199b955c66a22b3bf78f66f935766c"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/shipcheck/releases/download/v0.2.18/shipcheck-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3d626e7e0952aa26cba80e5ba2b542d8abb7f8f9bdf2080373c8be5a54a39ba2"
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
