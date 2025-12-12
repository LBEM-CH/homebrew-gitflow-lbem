class GitFlowLbem < Formula
  desc "LBEM edition of git-flow - Extensions for Vincent Driessen's branching model"
  homepage "https://github.com/LBEM-CH/gitflow-lbem"
  license "BSD-2-Clause"

  stable do
    url "https://github.com/LBEM-CH/gitflow-lbem/archive/refs/tags/null.tar.gz"
    sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"

    resource "completion" do
      url "https://github.com/LBEM-CH/gitflow-lbem-completion/archive/refs/tags/v0.6.0-lbem.1.tar.gz"
      sha256 "b0faf2007dc7f74e0ee55b4c793a93f50bdc5181b689f27fe6dc5a5a68aad5b2"
    end
  end

  head do
    url "https://github.com/LBEM-CH/gitflow-lbem.git", branch: "develop"

    resource "completion" do
      url "https://github.com/LBEM-CH/gitflow-lbem-completion.git", branch: "develop"
    end
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow", "git-flow-avh", "git-flow-cjs",
    because: "all install `git-flow` binaries and completions"

  def install
    system "make", "prefix=#{libexec}", "install"
    (bin/"git-flow").write <<~EOS
      #!/bin/bash
      export FLAGS_GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt
      exec "#{libexec}/bin/git-flow" "$@"
    EOS

    resource("completion").stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
      fish_completion.install "git.fish" => "git-flow.fish"
    end
  end

  def caveats
    <<~EOS
      git-flow LBEM Edition has been installed.

      Shell completions (bash/zsh/fish) have been installed automatically.

      LBEM Edition features:
        git flow feature sync    - Sync branch with base branch (rebase workflow)
        git flow feature propose - Create a pull/merge request
        git flow config export   - Export settings to .gitflow file
        .gitflow file support    - Shareable project configuration

      Documentation: https://github.com/LBEM-CH/gitflow-lbem/wiki

      Based on:
        CJS: https://github.com/CJ-Systems/gitflow-cjs
        AVH: https://github.com/petervanderdoes/gitflow-avh
    EOS
  end

  test do
    system "git", "init"
    system "#{bin}/git-flow", "init", "-d"
    system "#{bin}/git-flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
  end
end