{
  packageOverrides = pkgs: with pkgs; {
    myPackages = buildEnv {
      name = "dev-tools";
      paths = [
        gcc
        glibc
        gnumake
        neovim
        stow
        ripgrep
        tmux
        fzf
        nodejs_23
        python312
        lazygit
        yazi
        rustup
        libiconv
      ];
    };
  };
}

