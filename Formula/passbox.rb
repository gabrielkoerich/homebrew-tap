class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  url "https://github.com/gabrielkoerich/passbox/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  head "https://github.com/gabrielkoerich/passbox.git", branch: "main"
  license "MIT"

  depends_on "rust" => :build
  # build.rs compiles the Secure Enclave helper with swiftc
  depends_on xcode: :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Run `passbox init` to create the store at ~/.passbox.

      Keep the recovery passphrase somewhere safe. It is the only way back if you
      lose this Mac, because the Secure Enclave key cannot leave it.
    EOS
  end

  test do
    assert_match "passbox", shell_output("#{bin}/passbox --version")
  end
end
