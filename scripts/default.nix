{ ... }@inputs:
let
  imports = [
    ./help.nix
    ./keys.nix
    ./deploy.nix
    ./secrets.nix
  ];
  withInputs = builtins.map (f: import f inputs) imports;
  folded = builtins.foldl' (x: y: x // y) { } withInputs;
in
folded
