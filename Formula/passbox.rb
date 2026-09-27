class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.18/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "0fec310ebd269ba15fcb2132debdcc649b65231882c262f175e024bf07bf5673"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.18/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "a1d69cb71aead741fa954beebb1549722eab386ce0a71e2692c4081462268187"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.18/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "e8a6d05e871bc0c52c82b2432d38ea90f6bc43a980066dba8b97cb66c4aef38d"
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
