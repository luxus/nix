{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.adrive-webdav = {
    image = "messense/aliyundrive-webdav:latest";
    dependsOn = ["traefik"];
    volumes = [
      "/etc/adrive-webdav/:/etc/adrive-webdav/"
    ];
    labels = {
      "traefik.http.services.adrive-webdav.loadbalancer.server.port" = "8080";
      "traefik.http.routers.adrive-webdav.rule" = "HostRegexp(`adrive.{domain:[a-z.]+}`)";
    };
    environmentFiles = [
      config.age.secrets.adrive-webdav-envs.path
    ];
  };

  age.secrets.adrive-webdav-envs = {
    file = globals.root + /secrets/adrive-webdav/envs.age;
  };
}
