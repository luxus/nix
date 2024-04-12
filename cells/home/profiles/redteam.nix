{ globals, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    exiftool
    inetutils
    wafw00f
    theharvester
    hashcat
    hashcat-utils
    thc-hydra
    openvpn
    john

    # wireshark
    sqlmap
    poppler_utils
    ffuf
    dirb
    rustscan
    nmap
    # metasploit nokogiri is broken on darwin
    # mimikatz -- not available
    # bloodhound -- no darwin
    # aircrack-ng #no darwin
    # burpsuite # broken 
  ];
}
