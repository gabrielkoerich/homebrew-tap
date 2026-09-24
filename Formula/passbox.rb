class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "7dcc27252ca813b5e69f8f99867dda7c759d410d13a737e2eee8decbea123057"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.0/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "c11a8631d3cabb82911f76e7eac0d42127a3cc0c92220411c3a062db3a4abf8f"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.0/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "776e8b81d24a43cb72d265dd140b8b488b80b2f29fedbbbac6077057b4d342b3"
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
