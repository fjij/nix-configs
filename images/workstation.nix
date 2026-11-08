# Dev workstation image: the workstation home-manager config on a minimal Nix-built root.
# Built by .github/workflows/workstation-image.yml; Coder runs it as a workspace (see the
# fjij/cluster repo), but nothing in it is specific to Coder.
#
# Runs as willh, who owns /nix, so Nix works inside (single-user, no daemon). Anything
# outside the home directory resets when the container restarts.
{ pkgs, home }:
let
  inherit (home.config.home) username homeDirectory;
  uid = 1000;
  gid = 1000;
  shell = "${pkgs.fish}/bin/fish";

  # Links the home-manager files into the home directory; run on every start
  activate = pkgs.writeShellScriptBin "workstation-activate" ''
    exec ${home.activationPackage}/activate "$@"
  '';

  locales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [ "en_US.UTF-8/UTF-8" ];
  };

  etc = pkgs.runCommand "workstation-etc" { } ''
    mkdir -p $out/etc/nix
    cat > $out/etc/passwd <<EOF
    root:x:0:0:root:/root:/bin/sh
    ${username}:x:${toString uid}:${toString gid}::${homeDirectory}:${shell}
    nobody:x:65534:65534:nobody:/var/empty:/bin/sh
    EOF
    cat > $out/etc/group <<EOF
    root:x:0:
    ${username}:x:${toString gid}:
    nobody:x:65534:
    EOF
    # Coder's agent refuses to start without one
    cat > $out/etc/os-release <<EOF
    NAME="Workstation"
    ID=workstation
    ID_LIKE=nixos
    VERSION_ID="${pkgs.lib.trivial.release}"
    PRETTY_NAME="Workstation (nixpkgs ${pkgs.lib.trivial.release})"
    EOF
    echo "hosts: files dns" > $out/etc/nsswitch.conf
    echo ${shell} > $out/etc/shells
    cat > $out/etc/nix/nix.conf <<EOF
    experimental-features = nix-command flakes
    # Unprivileged containers can't create the build sandbox
    sandbox = false
    build-users-group =
    EOF
  '';
in
pkgs.dockerTools.buildLayeredImageWithNixDb {
  name = "ghcr.io/fjij/workstation";
  tag = "latest";

  # Everything in the store belongs to the user, so they can add to it
  inherit uid gid;
  uname = username;
  gname = username;

  contents = with pkgs; [
    etc
    activate
    home.config.home.path
    dockerTools.binSh
    dockerTools.usrBinEnv
    dockerTools.caCertificates
    nix
    bashInteractive
    coreutils
    findutils
    gnugrep
    gnused
    gnutar
    gzip
    xz
    less
    procps
    which
    hostname
    openssh # client, for git over SSH
    ncurses # terminfo
    ghostty.terminfo
  ];

  fakeRootCommands = ''
    mkdir -p ./nix/store ./nix/var/nix .${homeDirectory} ./tmp ./var/tmp
    chown -R ${toString uid}:${toString gid} ./nix .${homeDirectory}
    chmod 1777 ./tmp ./var/tmp
  '';

  config = {
    User = "${toString uid}:${toString gid}";
    WorkingDir = homeDirectory;
    Cmd = [
      shell
      "--login"
    ];
    Env = [
      "USER=${username}"
      "HOME=${homeDirectory}"
      "SHELL=${shell}"
      # ~/.nix-profile is for one-off installs, which last until the next restart
      "PATH=${homeDirectory}/.nix-profile/bin:/bin"
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "LOCALE_ARCHIVE=${locales}/lib/locale/locale-archive"
      "TERMINFO_DIRS=/share/terminfo"
    ];
  };
}
