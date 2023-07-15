# Tilde

Version N+1 of my dotfiles repository, combined with setup script (http://github.com/cceckman/debbie).

There's a few different cases where I want my dotfiles deployed.

1.  If I'm temporarily hopping to a host via SSH, I want to have a few default
    options set (`EDITOR=vim`, `set -o vi`).

2.  For hosts that I "own", I'd like to make some sticky modifications: install
    `tmux` and `zsh`, set `zsh` as the shell, and maybe install a couple other
    things.

    "Own" can be identified from context: username is `cceckman`, and I have
    `sudo` access.

3.  Finally, for hosts that I'm going to be on locally / persistently /
    regularly, I want to install a whole raft of programs, dotfiles, etc.

Planned strategy

1.  Adopt and adapt @aimeeble's [pssh](https://github.com/aimeeble/dotfiles/blob/b939b1d026df72dcd2c4fac216d1acd2ff04195d/bin/pssh) script for this purpose.
    I might want to use the [ControlPersist](https://unix.stackexchange.com/questions/669824/scpsshscp-in-a-single-connection)
    version with `scp` to avoid relying on `socat` being installed.
2.  Shallow-clone `Tilde` via HTTP. Link a minimal set of files / directories in
    place.
3.  Do (2); then replace the remote with an `ssh` remote and upgrade.

