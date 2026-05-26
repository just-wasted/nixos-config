# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {

    loader.efi.efiSysMountPoint = "/boot/efi";
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.systemd.enable = true;
    initrd.luks.devices = lib.mkForce {
      cryptroot = {
        device = "/dev/nvme0n1p2";
      };
    };

    plymouth = {
      enable = true;
    };

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
  };

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot/efi" = lib.mkForce {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=boot"
      "compress=zstd"
      "noatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/persistent" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=persistent"
      "compress=zstd"
      "noatime"
    ];
    neededForBoot = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.power-profiles-daemon.enable = true;

  security.polkit.enable = true;

  security.rtkit.enable = true;

  # gnome virtual file system, for nautilus
  services.gvfs.enable = true;

  services.gnome.gcr-ssh-agent.enable = false;

  services.displayManager.enable = true;

  services.displayManager.sessionPackages = [ config.programs.niri.package ];

  services.avahi = {
    nssmdns4 = true;
    nssmdns6 = true;
    enable = true;
  };

  services.mullvad-vpn = {
    package = pkgs.mullvad-vpn;
    enable = true;
  };

  services.flatpak.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];

    xkb.layout = "de";
    xkb.variant = "nodeadkeys";
  };

  networking.hostName = "missingno"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # automount usb devices
  services.udisks2.enable = true;

  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
    earlySetup = true;
  };

  systemd.services.systemd-vconsole-setup.unitConfig.After = "local-fs.target";

  users.mutableUsers = false;

  users.users.root = {
    hashedPasswordFile = "/persistent/passwords/root";
  };

  users.users.wasted = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "gamemode"
    ];
    hashedPasswordFile = "/persistent/passwords/wasted";
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;

  environment.shells = with pkgs; [ zsh ];

  programs.gamemode.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";

    shellAliases = {
      ll = "ls -l";
      edf = "cd /etc/nixos/ && sudoedit flake.nix && cd -";
      edc = "cd /etc/nixos/ && sudoedit configuration.nix && cd -";
      edh = "cd /etc/nixos/ && sudoedit home.nix && cd -";
      update = "sudo nixos-rebuild switch";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      liberation_ttf
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Jetbrains Mono" ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  systemd.user.services.niri.enableDefaultPath = false;

  programs.niri = {
    enable = true;
    package = pkgs-unstable.niri;
    useNautilus = true;
  };

  programs.ssh.startAgent = false;

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "polkit-mate-authentication-agent-1" ''
      exec ${mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1 "$@"
    '')
    adwaita-icon-theme
    adw-gtk3
    alacritty
    bat
    dconf
    dconf-editor
    efibootmgr
    envsubst
    ffmpeg-full
    file
    fuzzel
    fzf
    gammastep
    gcc
    kdePackages.polkit-kde-agent-1
    glib
    gnome-calculator
    gnome-disk-utility
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    git
    htop
    libinput
    lua-language-server
    nautilus
    neovim
    nixfmt
    nwg-look
    pavucontrol
    python3
    kdePackages.qt6ct
    sbctl
    s-tui
    tmux
    tree-sitter
    tuigreet
    uv
    vim
    wget
    wl-clipboard
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-terminal-exec
    xdg-user-dirs
    xdg-utils
    zip
    zoxide
    pkgs-unstable.foot
    pkgs-unstable.neovim
    pkgs-unstable.noctalia-shell
    pkgs-unstable.xwayland-satellite
  ];

  networking.firewall.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
