{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "antigravity-cli";
  version = "1.0.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.0-5288553236791296/linux-x64/cli_linux_x64.tar.gz";
    hash = "sha512-XM3MAfuGPH6OVkc8bJXbp1/tT9KiQiANgM/Ex/q4Ebcz9af6slMyEwqtKY5yYn4QGOaRGlZY9PBZ724BnyEZcg==";
  };

  # The source is a tarball containing the binary directly
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
              runHook preInstall
              install -m755 -D antigravity $out/bin/agy
              runHook postInstall
              '';

  meta = with lib; {
    description = "Antigravity CLI (agy)";
    homepage = "https://antigravity.google";
    platforms = platforms.linux;
  };
}
