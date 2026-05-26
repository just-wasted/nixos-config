{ lib, ... }:
{

  services.flatpak.uninstallUnmanaged = false;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };

  services.flatpak.packages = [
    "io.github.kolunmi.Bazaar"
    "com.discordapp.Discord"
  ];
}
