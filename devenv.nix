{ pkgs, ... }:

{

  android = {
    enable = true;
    flutter.enable = true;
    buildTools.version = [ "33.0.1" ];
    platforms.version = [
      "33"
      "34"
    ];
  };
}
