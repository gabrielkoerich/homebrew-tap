class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "2.4.0"
  license "MIT"

  # Apple silicon only, since the Secure Enclave and Touch ID flow is built and tested there
  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v2.4.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "32baf0406c20fc000ab09e3438acba7a3ed3378d4049eda50fd19c7997d91f8a"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v2.4.0/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "d0b3910f26d061fc05c22c7e60ec0f7060e5b9277f4cafdd410b3e9c6cadcd59"
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

      After an upgrade, refresh the agent skill with `passbox skill install`.
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
