{ ... }@inputs:
let
  imports = [
    ./keys.nix
    ./deploy.nix
    ./secrets.nix
    ./misc.nix
  ];
  withInputs = builtins.map (f: import f inputs) imports;
  folded = builtins.foldl' (x: y: x // y) { } withInputs;
in
folded
