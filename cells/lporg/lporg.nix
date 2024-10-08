{
  pkgs,
  lib,
  pname,
  version,
  src,
}:
pkgs.buildGoModule {
  inherit pname src;

  version = lib.removePrefix "v" version;

  vendorHash = "sha256-a3bmTZKMcPvDEDp1RZ9iGEfPuJNXJN0s6NLVVDCPrFo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/blacktop/lporg/constant.Version=${version}"
  ];

  # skip check phase
  checkPhase = '''';

  meta = with lib; {
    description = "Organize Your macOS Launchpad Apps";
    longDescription = ''
      lporg is meant to help people setting up a brand
      new Mac or to keep all of their Launchpad Folders
      in sync across devices.
    '';
    homepage = "https://github.com/blacktop/lporg";
    changelog = "https://github.com/blacktop/lporg/releases/tag/${version}";
    mainProgram = "lporg";
    platforms = platforms.darwin;
    license = with licenses; [mit];
    maintainers = with maintainers; [yousiki];
  };
}
