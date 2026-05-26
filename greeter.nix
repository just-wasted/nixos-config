{
  config,
  pkgs,
  lib,
  ...
}:
let
  sessionDir = "${config.services.displayManager.sessionData.desktops}/share";
in
{

  users.users.greeter = {
    isNormalUser = false;
    extraGroups = [ "seat" ];
  };

  services.greetd = {
    enable = true;
    package = pkgs.greetd;
    settings = {
      default_session = {
        user = "greeter";
        command = ''
          ${lib.getExe pkgs.tuigreet} -r \
                    --remember-session --time --asterisks \
                    --sessions ${sessionDir}/wayland-sessions:${sessionDir}/xsessions'';
      };
    };
  };
}
