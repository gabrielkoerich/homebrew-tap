class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.28"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.28/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "a17d08753c46ead8804aa1c3c9689d1b42c4cdecf8de3afae1a700f47c700266"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.28/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "636b2ec057fdacb8286eefde6921d45a3a74bda9b63b98d9f39bad8d70970191"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.28/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "38bba7f8c0c2f39ec5071b84955289bf152e7e065f22753def19d3cc6d9b5900"
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
