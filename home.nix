{ lib, pkgs, ... }:
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

  programs.neovim = {
    enable = true;
    extraWrapperArgs = [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        pkgs.zlib
      ]}"
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
        pkgs.stdenv.cc.cc
        pkgs.zlib
      ]}"
    ];
  };

  home.packages = with pkgs; [
    steam
  ];

  gtk = {
    theme.name = "Adwaita-dark";
    enable = true;
    font.name = "DejaVu Sans Semi-Condensed 12";

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk3 = {
      theme.name = "adw-gtk3-dark";
      theme.package = pkgs.adw-gtk3;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    accent-color = "teal";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "DMZ-Black";
    size = 32;
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita";
    GTK_ENABLE_DARK_MODE = "1";
    GSETTINGS_BACKEND = "dconf";
  };
}
