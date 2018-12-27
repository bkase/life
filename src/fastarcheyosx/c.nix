{ stdenv, fetchFromGitHub } :

stdenv.mkDerivation rec {
  version = "0.1.0";

  name = "fast-archey-osx-${version}";

  src = fetchFromGitHub {
    owner = "bkase";
    repo = "archey-osx";
    rev = "4bc53e4d0a11f488fed6d23bfc6b5e12cb1dad8a";
    sha256 = "005nz6jirkj7214i1n557xjr69rkzmj6wbkswh90cz3441b40xy8";
  };

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/archey $out/bin/archey
  '';

  meta = {
    description = "Fast fork of Archey for OSX";
    homepage = "https://github.com/bkase/archey-osx";
  };
}


