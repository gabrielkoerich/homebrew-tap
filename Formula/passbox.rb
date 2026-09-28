class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.24"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.24/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "444cd76adf0d7e0439118aa0091204ca42120363922973567fc4106570ccb1bc"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.24/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "a8645db59f9f1bd432234d8a8ac894e873b1fe797d95a393af00df8a6a917531"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.24/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "bf529710085ee4261f3d47e69917474b3572f5bc55d631c9486a706ff5e36feb"
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
