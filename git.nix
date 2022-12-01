{
  enable = true;
  includes = let
    configDir = ./config/git;
    configDirFiles = builtins.attrNames (builtins.readDir "${configDir}");
    pred = x: ((builtins.match ".*.gitconfig$" x) != null);
    configFiles = builtins.filter pred configDirFiles;
  in builtins.map (file: {
    path = "${configDir}/${file}";
  }) configFiles;
};
