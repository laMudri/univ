let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive haskellPackages;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry siunitx qtree pict2e;
  };

  hask-env = haskellPackages.ghcWithPackages (pkgs:
    with pkgs; [ JuicyPixels ]);
in stdenv.mkDerivation {
  name = "cgip";
  src = ./.;
  buildInputs = [ tex-env hask-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
