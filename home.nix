{ pkgs, ... }:
{
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user.name = "wasted";
      user.email = "67445572+just-wasted@users.noreply.github.com";
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  home.packages = with pkgs; [
    steam
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "DMZ-Black";
    size = 32;
  };

  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    GTK_ENABLE_DARK_MODE = "1";
  };
}
