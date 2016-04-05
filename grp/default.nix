let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry;
  };

in stdenv.mkDerivation {
  name = "grp";
  src = ./.;
  buildInputs = [ tex-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
