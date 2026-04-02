class Orch < Formula
  desc "Multi-agent task orchestrator for AI coding agents (claude, codex, opencode)"
  homepage "https://github.com/gabrielkoerich/orch"
  version "0.56.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.56.9/orch-arm64"
      sha256 "1801f09ecb48201cbcc3565521a34d3a87c5e1c1b816cd3b480b2d1567a0f03d"
    else
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.56.9/orch-x86_64"
      sha256 "b9e724bc72d512268968a8422a0abba09fc1599d68b68a4f89fda8d0a85693e7"
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
