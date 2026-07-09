{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "antigravity-cli";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/google-antigravity/antigravity-cli/releases/download/1.1.0/agy_cli_linux_x64.tar.gz";
    hash = "sha256:7ee512440af5ed0c819065cd7cc14eec90699214df4be32280ac346f0100577e";
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
