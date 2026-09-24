class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.11.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "a09bf29dc6bdcbb97a04bf2d0763c3f2c981687c9681a1c411b8055dfd16c624"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.11.0/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "b0dc16e7d64253088fe28ae8c4bfb2fa2d9dd959ee3ba59121d7579fdea51f87"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.11.0/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "953173dccc03a51fcdce30adb42801a3a318cc540eeffddb3d6dcaaba540e214"
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
