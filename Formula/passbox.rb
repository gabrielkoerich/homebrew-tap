class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.39"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.39/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "784bebf3b140fe5931bfc6d054e88d729e3b24ad638ab7da5c716c9947fc5ddf"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.39/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "d62ddde122c28a0dd8f57e85beeeb76eb68fc78d15b01fbd78acc92915638d5f"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.39/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "3cb0cd147e4b28f935f353b0575b74425a256bbed3372ef709b5987b24da9378"
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
