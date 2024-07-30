# nixos-config

My NixOS config!

## Deploying the config using a remote copy of the repo

```sh
sudo nixos-rebuild switch --flake github:fjij/nixos-config#<hostname>
```

Where `<hostname>` is replaced by the hostname of the systems configuration you
want to use. After you reboot, it updates the hostname of the system, so you
don't need to declare the hostname in the future.

Instead, you can just do something like this:

```sh
sudo nixos-rebuild switch --flake github:fjij/nixos-config
```

## Deploying the config using a local copy of the repo

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```sh

Or, if the hostname is already set:

```
sudo nixos-rebuild switch --flake .
```
