{
  inputs,
  cell,
  config,
  ...
}: let
  mkCifs = cell.lib.mkCifsWithCredentials config.age.secrets.lab-yyp-credentials.path;
in {
  age.secrets.lab-yyp-credentials.file = "${inputs.self}/secrets/lab-yyp-credentials.age";
  fileSystems = {
    "/mnt/lab-yyp/home" = mkCifs "//nas.ybh1998.space/home";
    "/mnt/lab-yyp/share" = mkCifs "//nas.ybh1998.space/share";
  };
}
