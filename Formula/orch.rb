class Orch < Formula
  desc "Multi-agent task orchestrator for AI coding agents (claude, codex, opencode)"
  homepage "https://github.com/gabrielkoerich/orch"
  version "0.55.13"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.55.13/orch-arm64"
      sha256 "5f21f1a0f746c0f6b0b96ae7d9334b7472f9ae38bea3f19484fe4b60d587346c"
    else
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.55.13/orch-x86_64"
      sha256 "96f88872204bac9f1dc4519b2b78c1b6ab62a8362977a99d2348e0323e7dff8b"
    end
  end

  depends_on "gh"
  depends_on "tmux"

  def install
    bin.install "orch-arm64" => "orch" if Hardware::CPU.arm?
    bin.install "orch-x86_64" => "orch" if Hardware::CPU.intel?

    # Install additional resources
    (libexec/"prompts").install Dir["prompts/*"] if (buildpath/"prompts").exist?
    libexec.install Dir["*.example.yml"] if Dir.glob("*.example.yml").any?
    libexec.install "skills.yml" if (buildpath/"skills.yml").exist?
  end

  service do
    run [opt_bin/"orch", "serve"]
    keep_alive true
    log_path var/"log/orch.log"
    error_log_path var/"log/orch.error.log"
  end

  def caveats
    <<~EOS
      To get started:
        cd ~/your-project
        orch init                     # configure project
        orch task add "title"         # add a task
        brew services start orch      # start background server

      Required agent CLIs (install at least one):
        brew install --cask claude-code   # Claude
        brew install --cask codex         # Codex
        brew install opencode             # OpenCode

      GitHub CLI (installed automatically):
        gh auth login   # authenticate if not already logged in
    EOS
  end

  test do
    assert_match "orch", shell_output("#{bin}/orch --version 2>&1", 0)
  end
end
