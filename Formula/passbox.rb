class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.2/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "1a6e7808720bf498f68637f9d71dba8353c22fdf86e11b61aa9962b2fb96601f"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.2/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "ff87dcb6a160520a534d852829846f2c648881eb598b3dd58ed9dc14882fc5a9"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.2/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "cc7d47a8973ba2b464d3d02d69b2b44025fcdba417950db34d04e3b69df8b96e"
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
