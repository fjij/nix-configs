inputs: let
  fjij = rec {
    nixos = import ./nixos inputs fjij;
    darwin = import ./darwin inputs fjij;
    home-manager = import ./home-manager inputs fjij;
  };
in
  fjij
