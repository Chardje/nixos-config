# themes/default.nix
{ pkgs ? import <nixpkgs> {} }:
let
  lib = pkgs.lib;
in
pkgs.callPackage ./sddm-astronaut-theme.nix { inherit lib; }