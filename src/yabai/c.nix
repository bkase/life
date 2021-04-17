{ stdenv
, fetchFromGitHub
, Carbon
, Cocoa
, ScriptingBridge
, xxd
}:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.3.7";
  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "16y719384f9bx8zwfsjk5v2nyjyf43m154idsfzxpx0bbl8w5bpj";
  };

  preConfigure = ''
    export CC='/usr/bin/clang'
  '';

  buildInputs = [ Carbon Cocoa ScriptingBridge xxd ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1
  '';

  meta = with stdenv.lib; {
    description = "A tiling window manager for macOS based on binary space partitioning";
    homepage = https://github.com/koekeishiya/yabai;
    platforms = platforms.darwin;
    license = licenses.mit;
  };
}
