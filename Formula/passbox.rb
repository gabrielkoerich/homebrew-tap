class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "96ad04606461b9e1fbfbd8727b2bd41aa7af951088bd2db52f167c9cc66df7a4"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.0/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "473721d0815299e30a1bd3d4ea08e5bc2b9e6d7edf1a42ed43c107d1a1ec7b9e"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.0/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "08a7440d1b8a6a3ce55e49f3923ffbda0dbc5a897eeee5915e985041e1be06a0"
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
