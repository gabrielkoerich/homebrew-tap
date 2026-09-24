class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.9.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "1d643a9a25d2b39039238513a39f19266cd9e75093f84e3b2c5bcf0f642d8abc"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.9.0/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "881fd6c0b393642b1bf504cad37e9b7ae52cb1e651923dc20d460fed8a22a592"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.9.0/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ba92ee9474c844b5cc896bbd7b0ebe4d69cd818ff09f09efa06cb7f7c169aceb"
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
