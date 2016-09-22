let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive haskellPackages;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry enumitem;
  };

  hask-env = haskellPackages.ghcWithPackages (pkgs: [ ]);

in stdenv.mkDerivation {
  name = "sec";
  src = ./.;
  buildInputs = [ tex-env hask-env ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
