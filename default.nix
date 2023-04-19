{ nixpkgs ? import <nixpkgs>
, pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "skyhook";
  nativeBuildInputs = with pkgs; [
    gcc
    pkg-config
    meson
    ninja
    gtk4
    libadwaita
    vala
    vala-language-server
    json-glib
    libsoup_3
    desktop-file-utils
  ];
  src = ./.;
}