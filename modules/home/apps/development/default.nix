{ lib, ... }:

{
  imports = builtins.filter 
    (file: file != "default.nix" && lib.strings.hasSuffix ".nix" file) 
    (builtins.attrNames (builtins.readDir ./.));
}
