class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.12.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.12.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "91a7290aad7342ee6e463762aed3c849cc71185b0954c001ba8f0892f3c9d61d"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.12.0/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "15d9001779cfb0d3271a9d90110aade4fd69f820bd234cd8772bf1cb0e6ece47"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.12.0/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "34fe29d5f384ba4fdf6eb9582f2e51e1310f9b40713654b1ccaca3436be3d234"
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
