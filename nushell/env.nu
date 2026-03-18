$env.PATH = ($env.PATH | split row (char esep) | prepend "~/.local/bin")

mkdir ~/.local/share/mise
^~/.local/bin/mise activate nu | save --force ~/.local/share/mise/init.nu

mkdir ~/.local/share/atuin
# atuin might not be installed immediately on first run by mise if it's just in config.toml
# So we run `mise exec atuin` to ensure it's available or we just use `~/.local/bin/mise exec atuin`
# but atuin could not exist if mise hasn't installed it yet.
# The install script runs `mise install --yes`, so it should be there.
^~/.local/bin/mise exec atuin -- atuin init nu | save --force ~/.local/share/atuin/init.nu
