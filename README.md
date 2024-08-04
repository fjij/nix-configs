# nixos-config

My NixOS config!

## Repo Usage

All the commands are in the `justfile`! Use the
[just](https://github.com/casey/just) command to list them and read
documentation.

## How to setup a new machine

1. Install the OS with an image generated from `just build-iso` or
  `just build-vdi`
2. Distribute keys using `just distribute-keys <ip>`
3. Deploy a configuration using `just deploy <config> <ip>`
