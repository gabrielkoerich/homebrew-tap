class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.40"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.40/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "30ceb367a2a593d85d5ce27e6efd18c5f6afec7ed3aa1c994a1a9ed2240e2f61"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.40/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "fa44ebef1bbc5bacd6099e247a04a39c8c724d75a59f8bef0c4b81c34af468cf"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.40/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "8b99d40d210345a3d314b50b92e109903fa14f4b8bd31df1883a21087dccf8dc"
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
