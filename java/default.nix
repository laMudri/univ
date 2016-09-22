let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv jdk;

in stdenv.mkDerivation {
  name = "java-stuff";
  src = ./.;
  buildInputs = [ jdk ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
