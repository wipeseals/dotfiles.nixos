{ config, pkgs, ...}:

{
  home = {
    stateVersion = "25.11";
    username = "user";
    homeDirectory = "/home/user";
    packages = with pkgs; [
      # cli tools
      git
      gh # github cli

      # common apps
      google-chrome
      vscode

      # hobby usages apps
      discord
      steam
      steamcmd
      blender
    ];
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "wipeseals";
      userEmail = "wipeseals@gmail.com";
    };
    gh = {
      enable = true;
      settings.editor = "hx";
    };
  };
}
