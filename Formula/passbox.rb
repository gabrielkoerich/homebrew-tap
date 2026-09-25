class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.8/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "fa6840fefec53ed67630b75e8740514c28771d2b3ab95b7337e210e01901c034"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.8/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "b6dc3a0ed2db88a95b2a20fb99c198b3a0cf1d5bbaf7e62ad260e91c31a66f4f"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.8/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "20c42e1231004075968af52bdf18f77f6753ee050a4d77063505dae098a0739a"
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
