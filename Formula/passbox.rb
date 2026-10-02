class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.38"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.38/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "bda93c96a9e41d7581f90ce5366567aae8de72431b13dfb6a5b515389186a370"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.38/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "7085ab45d38e85c5148b7c6a5ce2acbe0846b7a03c776d0df08b72a70dd8af02"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.38/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "96346e096faaee8b8bf872de981be76a1c09fcdf79a08e1cc95e42db73d639ae"
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
