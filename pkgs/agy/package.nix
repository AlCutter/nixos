{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "antigravity-cli";
  version = "1.4.7";

  src = fetchurl {
    url = "https://github.com/google-antigravity/antigravity-cli/releases/download/1.4.7/agy_cli_linux_x64.tar.gz";
    hash = "sha256:67fd4e70be739b1f8b18f90b511da8cd2a7aef24e888e5837402e025bf7fdbfc";
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
