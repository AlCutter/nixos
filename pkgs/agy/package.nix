{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "antigravity-cli";
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/google-antigravity/antigravity-cli/releases/download/1.2.3/agy_cli_linux_x64.tar.gz";
    hash = "sha256:57afb34f2a4be9296beb477e600761b6ac7401eb3a54a64a0014d573b7fc3af4";
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
