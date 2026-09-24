class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.1/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "9f4a0d32f15b32f2bc2b4230f66ca12b3f43f7e9ece2106135eae0408801fd93"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.1/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "811ea2ef6e3202daa759d10bad028fcc057380501f2505353a1018e09e462690"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.1/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "c2a8b0a7ae7f2bf5ee540355a6985120408e2e7656c32ebe1a7156fac8f2322e"
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
