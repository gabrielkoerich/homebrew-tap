class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.37"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.37/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "23cb0d4e916143d0557321cbcbeaa3a49d31be7023806acc8a5025a0ceabea18"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.37/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "21415a4f9f454b277fa578185abd0439df37b9d4b6d59804c461f2f8e2d7db63"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.37/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "b6c1a40362103a6a58e499bc2466cb785f213a7297138fe78d33f1fc66297ddb"
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
