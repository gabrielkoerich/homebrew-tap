class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.3/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "e648f21e322b8e92a42089561ec646c273a7973a4b8316215b2d84b635bca147"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.3/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "66fdaef3c2c602c328d90aa28bbd2d9e7435b9a8c870888e86810ee72259f904"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.3/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "f7d7c7f03918926501f7fd0ac761471ba8546aa586227b5f0809090bf73fc70e"
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
