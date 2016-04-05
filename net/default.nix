let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv texlive jdk;

  tex-env = texlive.combine {
    inherit (texlive) scheme-small geometry enumitem siunitx cm-super;
  };

in stdenv.mkDerivation {
  name = "net";
  src = ./.;
  buildInputs = [ tex-env jdk ];
  buildPhase = ''
    make
  '';
  installPhase = "";
}
