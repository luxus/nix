{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.traefik = {
    image = "traefik:latest";
    cmd = [
      "--api.insecure=true"
      "--providers.docker"
    ];
    ports = [
      "80:80"
      "8080:8080"
    ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
    labels = {
      "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
      "traefik.http.routers.traefik.rule" = "HostRegexp(`traefik.{domain:[a-z.]+}`)";
    };
  };

  virtualisation.oci-containers.containers.whoami = {
    image = "traefik/whoami";
    dependsOn = ["traefik"];
    labels = {
      "traefik.http.routers.whoami.rule" = "HostRegexp(`whoami.{domain:[a-z.]+}`)";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    8080
  ];
}
