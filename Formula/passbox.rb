class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.9/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "b04980e860844b44fa602710aa23a7b8be92307925ed24bacd1fcac1a1771c28"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.9/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "e7c5e0c491ca81e7e0bf41f56434878d57a3f995ac03510922cb58bbede78034"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.9/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "a560a9367f88ce13634dfe7e2ddf25445d21fe9c95cbc7dfb8521e3808c86092"
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
