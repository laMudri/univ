let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive haskellPackages;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry bussproofs qtree pict2e;
  };
in stdenv.mkDerivation {
  name = "cgip";
  src = ./.;
  buildInputs = [ tex-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
