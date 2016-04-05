let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry enumitem txfonts;
  };

in stdenv.mkDerivation {
  name = "cpt";
  src = ./.;
  buildInputs = [ tex-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
