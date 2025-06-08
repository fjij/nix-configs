# Installation Process for NixOS on a Physical Device

1. Build the Graphical Installer ISO

```sh
sudo nix run .#buildGraphicalInstaller
```

`sudo` is required in order to utilize remote builders.

After running the command, you will find the ISO in the `result/iso` directory.

2. Create a bootable USB drive

Use a tool like [Etcher](https://etcher.balena.io) to create a bootable USB
drive from the ISO file.

After creating the drive, you can remove the `result` symlink:

```sh
rm result
```

The garbage collector will clean up the build artifacts automatically.

3. Boot from the USB drive

Plug the USB drive into the target device and boot from it. For my Beelink
devices, this can be done by pressing the `F7` key during boot to access the
device. For other devices, this might be another F key.

Use the graphical installer to connect to the network and find the device's IP
address. Do not use the graphical installer, since we can perform a remote
install. The graphical installer is only used to set up the network connection.

4. Perform a remote install

In order to install a specific NixOS configuration on the target device, you can
use the `remoteInstall` command. This command requires the IP address of the
target device, the name of the NixOS configuration to install, and the path
(within this repo) to generate the hardware configuration. The NixOS
configuration should import the generated hardware configuration, even though it
won't exist until the remote install command is run.

```sh
nix run .#remoteInstall <IP_ADDRESS> <NIXOS_CONFIG_NAME> <GENERATE_HARDWARE_CONFIG_PATH>
```
