{ stdenv, fetchzip, fetchurl, lib } :
let
  version = "0.6.1";
  arch = if (stdenv.system == "x86_64-linux" || stdenv.isDarwin) then "x86_64" else "386";
  sys = if stdenv.isDarwin then "apple-darwin" else "unknown-linux-gnu";
  ext = "tar.gz";
  sha = if stdenv.isDarwin then "1b6if0l7qjbiakgzgx6yzkdyasxfh0sma5w28475m0xx6vr4cbil" else "1a98zprcyfqjqahyjgb5aahnml3l11hk51pdw8jwnj5j37b21m5i";
  src = fetchurl {
    url = "https://github.com/sharkdp/bat/releases/download/v${version}/bat-v${version}-${arch}-${sys}.${ext}";
    sha256 = sha;
  };
in
stdenv.mkDerivation rec {
  inherit src;
  inherit version;

  name = "bat-v${version}";

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp bat $out/bin/bat
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}

