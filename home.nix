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
}
