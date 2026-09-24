class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.10.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.1/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "858217c8f5ffa8939ea02dfb0dfdc31e01e00790b01e285a8008d47392c106aa"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.1/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "8061653444b5482bffbcd5997d0ea182fe8aa364224fac265349fabe8f6013fd"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.1/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "3ec18a51fd6c3aa5526a4a52c7f838a7bbf1ca8c25735ca21f66bc5695e503e9"
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
      `passbox sync --enable` adds a recovery passphrase and a copy elsewhere.

      Install rclone only if you point PASSBOX_REMOTE at a cloud remote such as
      b2:passbox. A directory target needs no extra tools.
    EOS
  end

  test do
    assert_match "passbox", shell_output("#{bin}/passbox --version")
  end
end
