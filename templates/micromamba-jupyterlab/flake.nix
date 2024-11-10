{
  description = "Bo Mamba";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }@inputs:
    flake-utils.lib.eachSystem flake-utils.lib.allSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fhs = pkgs.buildFHSUserEnv {
          name = "my-fhs-environment";

          targetPkgs = _: [
            pkgs.micromamba
          ];

          profile = ''
            set -e
            eval "$(micromamba shell hook --shell=posix)"
            export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.mamba
            micromamba create -q -n my-mamba-environment
            micromamba activate my-mamba-environment
            micromamba install --yes -f conda-requirements.txt -c conda-forge
            set +e
          '';

          runScript = "jupyter lab";
        };
      in
      {
        packages.default = fhs;

        # To use as a dev shell, remove `runScript` and use fhs.env
        # devShells.default = fhs.env;
      }
    );
}
