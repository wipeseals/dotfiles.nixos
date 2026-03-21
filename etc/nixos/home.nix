{ config, pkgs, ...}:

{
  home = {
    stateVersion = "25.11";
    username = "user";
    homeDirectory = "/home/user";
    packages = with pkgs; [
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
      settings.editor = "code";
    };
    vscode = {
      extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-ssh
      ];
    };
  };
}
