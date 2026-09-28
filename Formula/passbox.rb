class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.29"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.29/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "f5578f8a62982faabaa1e1b13fe04149e7a3395132cd5ab5d7616b1bcddcef6e"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.29/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "9888b5f8a4fd71011235e9caff29a223100d633ebd7b36b1ede06cae391ed9f4"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.29/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "bd742a247b3aed8ad2f22affcb2e478227da24b748e95fdea49f0faad70c78fd"
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
