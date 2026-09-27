class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.21/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "c8b927de2bf024fe16afa6bf3131d9bbff2861b1b8a2120c9fd041c3808d5523"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.21/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "3e5264fd9974a04ed626ef7ea472c2f644d8ae8c3b3e733cc67e5b9a470720f9"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.21/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "0a2f3217b7b0379b9ab2dda926e5a1b62c9cb2255d974586ec4f0e70f5f31b52"
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
