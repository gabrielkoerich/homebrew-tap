class Orch < Formula
  desc "Multi-agent task orchestrator for AI coding agents (claude, codex, opencode)"
  homepage "https://github.com/gabrielkoerich/orch"
  version "0.4.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.4.6/orch-macos-universal.tar.gz"
      sha256 "ca3cd904cd3abbf76d66ff5f86d239f24806b1f02ba4f502eac224244bde67d1"
    else
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.4.6/orch-macos-universal.tar.gz"
      sha256 "ca3cd904cd3abbf76d66ff5f86d239f24806b1f02ba4f502eac224244bde67d1"
    end
  end

  depends_on "gh"
  depends_on "tmux"

  def install
    bin.install "orch"

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
