let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive haskellPackages;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry enumitem siunitx;
  };

in stdenv.mkDerivation {
  name = "cds";
  src = ./.;
  buildInputs = [ tex-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
