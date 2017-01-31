# Defines the environment needed for ./build-gerbers.sh to run on NixOS.
# Users of other operating systems need not worry about this file.
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "build-gerbers-env";
  buildInputs = [ gerbv pcb zip ];
}
