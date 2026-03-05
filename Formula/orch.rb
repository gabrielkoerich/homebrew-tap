class Orch < Formula
  desc "Multi-agent task orchestrator for AI coding agents (claude, codex, opencode)"
  homepage "https://github.com/gabrielkoerich/orch"
  version "0.10.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.10.3/orch-arm64"
      sha256 "6a14ac249fd9a8c8c1e6ab68aebf5c769320fa229b2539fe114e6d2588da52ea"
    else
      url "https://github.com/gabrielkoerich/orch/releases/download/v0.10.3/orch-x86_64"
      sha256 "c63206ac644ba9413c2f5d1320ccaef9c2d1781e95c9714e5d0d7899b6db3aa0"
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
