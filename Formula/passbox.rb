class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "1.0.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v1.0.3/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "d451f56b97614e940d3585b03872f9de9733ee8c61fccd528d3508bb168e0a6f"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v1.0.3/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "852a9705372effa64bbc19296fedffdc69fa6de9d4f445985a35cceeb3568c79"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v1.0.3/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "899354cab28eeaa1b2f67399a8d6e7ec554ba913e947d1caeb797333a1a46d84"
  end

  # Source builds stay available for anyone who would rather compile what they can read
  head do
    url "https://github.com/gabrielkoerich/passbox.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
      system "codesign", "-s", "-", "--force", "--options", "runtime", bin/"passbox"
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

      To keep the broker running, start it as a user service, not with sudo:
        brew services start passbox
      A sudo service runs with no login session and cannot raise Touch ID.
    EOS
  end

  # A user agent, not a system daemon, so it runs in the login session and can raise Touch ID.
  # PATH carries Homebrew's bin and /usr/local/bin, so the broker finds tailscale and the plugin CLIs
  service do
    run [opt_bin/"passbox", "broker"]
    keep_alive true
    log_path "#{var}/log/passbox-broker.log"
    error_log_path "#{var}/log/passbox-broker.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    assert_match "passbox", shell_output("#{bin}/passbox --version")
  end
end
