{ globals, ... }: { config
                  , lib
                  , pkgs
                  , ...
                  }: {
  home.packages = with pkgs; [
    exiftool
    inetutils
    wafw00f
    # theharvester pypeter broken
    hashcat
    hashcat-utils
    thc-hydra # openvpn
    # john
    # metasploit nokogiri broken

    wireshark
    sqlmap
    poppler_utils #pdfinfo
    ffuf
    dirb
    rustscan
    nmap
    # mimikatz
    # bloodhound
    # aircrack-ng #no darwin
    # burpsuite via brew
  ];
}
