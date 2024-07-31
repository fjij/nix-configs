# nixos-config

My NixOS config!

## Deploying the config without cloning the repo

```sh
sudo nixos-rebuild switch --flake github:fjij/nixos-config#<hostname>?submodules=1
```

Where `<hostname>` is replaced by the hostname of the systems configuration you
want to use. After you reboot, it updates the hostname of the system, so you
don't need to declare the hostname in the future.

Instead, you can just do something like this:

```sh
sudo nixos-rebuild switch --flake github:fjij/nixos-config?submodules=1
```

## Deploying the config using a local copy of the repo

```sh
sudo nixos-rebuild switch --flake .#<hostname>?submodules=1
```

Or, if the hostname is already set:

```sh
sudo nixos-rebuild switch --flake .?submodules=1
```

## Setup git hooks

```sh
just init-hooks
```
