let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry enumitem prftree;
  };

in stdenv.mkDerivation {
  name = "cipl";
  src = ./.;
  buildInputs = [ tex-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
