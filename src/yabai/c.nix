{ stdenv
, fetchFromGitHub
, Carbon
, Cocoa
, CoreServices
, IOKit
, ScriptingBridge
}:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.0.2";
  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "16y719384f9bx8zwfsjk5v2nyjyf43m154idsfzxpx0bbl8w5bpj";
  };

  buildInputs = [ Carbon Cocoa CoreServices IOKit ScriptingBridge ];

  installPhase = ''
    install -d $out/bin
    cp bin/yabai $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tiling window manager for macOS based on binary space partitioning";
    homepage = https://github.com/koekeishiya/yabai;
    platforms = platforms.darwin;
    license = licenses.mit;
  };
}
