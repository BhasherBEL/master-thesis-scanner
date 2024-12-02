{ pkgs, ... }:

{

  android = {
    enable = true;
    flutter.enable = true;
    platforms.version = [
      "33"
      "34"
    ];
  };

}
