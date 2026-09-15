{ lib, ... }: {
  imports = map (file: ./. + "/${file}") (
    builtins.filter
      (file: file != "default.nix" && file != "flake.nix" && lib.strings.hasSuffix ".nix" file)
      (builtins.attrNames (builtins.readDir ./.))
  );
}
