{
  packageOverrides = pkgs: with pkgs; {
    myPackages = buildEnv {
      name = "dev-tools";
      paths = [
        gcc
        gnumake
        gh
        neovim
        stow
        ripgrep
        tmux
        fzf
        nodejs_23
        python312
        python312Packages.pip
        lazygit
        yazi
        rustup
        libiconv
      ];
    };
  };
}

