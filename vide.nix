{ stdenv
, pkgs
, lib
, writeShellScript
, callPackage

, zjstatus
}:

let
  helixConfig = callPackage ./helix.nix {};
  zellijConfig = callPackage ./zellij.nix { inherit zjstatus helixConfig; };
in
  stdenv.mkDerivation rec {
    name = "vide";

    src = writeShellScript "vide" ''
      export ZELLIJ_CONFIG_DIR=${zellijConfig}
      ${pkgs.zellij}/bin/zellij
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/vide
      chmod +x $out/bin/vide
    '';

    dontUnpack = true;

    meta = {
      description = "Nix-powered modal IDE composed of individual tools.";
      homepage = "https://github.com/lokasku/vide";
      mainProgram = "vide";
    };
  }
