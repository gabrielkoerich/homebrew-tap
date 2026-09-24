class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.10.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.2/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "ca2b3a3f0cb510eef34a69f178fbe1235f93e73a70a7f546b4e8677f7ac1d3c3"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.2/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "de474920a448a5ba8e890ca572686862b65f5acd710292bda0aa7b89dc877a58"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.10.2/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "968fc678eb644585b8e290644b6cadfccbd352cd88ba13e11d357950eb973c98"
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
