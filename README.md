# chezmoi-dotfiles
dotfiles repository for use with [Chezmoi](https://www.chezmoi.io/).
```
$ chezmoi init git.xtnet.link/angel  # gitLab mirror
$ chezmoi init Sartron --apply  # github mirror
```

# Configurations
File provisioning is controlled via `.chezmoiignore` currently based on two conditions:
* Is runtime OS Linux?
* Is runtime kernel **_WSL2_** Linux?
