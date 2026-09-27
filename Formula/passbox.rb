class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.20/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "f4ec691628681ef7c07d37bb10f3e1ac49191c1347dadde1261db8accf37c812"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.20/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "23d3c256a3ce701bf11290db696da81404cdc900c9dd27f67d30411147783b72"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.20/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "507e394c48a0a7742b919ba0574db7926e9f12366482582fcd1440059496095a"
  end

  # Source builds stay available for anyone who would rather compile what they can read
  head do
    url "https://github.com/gabrielkoerich/passbox.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "passbox"
    end
  end

  def caveats
    <<~EOS
      Run `passbox init` to create the store at ~/.passbox. On a Mac it binds to
      the Secure Enclave and asks for nothing else.

      The store opens on that Mac only. Lose it and the secrets are gone.
      `passbox sync --enable` asks how a copy should be opened, a passphrase or
      a YubiKey, then asks where it goes.

      Install rclone only if you choose an rclone remote. iCloud Drive, a plain
      directory and a git remote need no extra tools.
    EOS
  end

  test do
    assert_match "passbox", shell_output("#{bin}/passbox --version")
  end
end
