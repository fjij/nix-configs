{
  username,
  homeDirectory,
}: {
  home = {
    inherit username;
    inherit homeDirectory;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
