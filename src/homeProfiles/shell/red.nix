{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [

    exiftool
    inetutils
    # aircrack-ng #no darwin
    thc-hydra
    openvpn
    john
    metasploit
    wireshark
    sqlmap
    poppler_utils #pdfinfo
    ffuf
    dirb
    nmap
  ];
}
