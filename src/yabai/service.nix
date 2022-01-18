{ config, pkgs, ... }:
{
  # yabai
  # TODO: Refactor this to be cleaner
  environment.etc."yabairc".source = pkgs.writeScript "etc-yabairc" (
    ''
      #!/usr/bin/env sh
      # global settings
      export _YABAI=/Users/bkase/yabai/bin/yabai

      $_YABAI -m config mouse_follows_focus          on
      $_YABAI -m config focus_follows_mouse          autofocus
      $_YABAI -m config window_origin_display        default
      $_YABAI -m config window_placement             second_child
      $_YABAI -m config window_topmost               off
      $_YABAI -m config window_opacity               off
      $_YABAI -m config window_shadow                off
      $_YABAI -m config window_border                off
      $_YABAI -m config active_window_opacity        1.0
      $_YABAI -m config normal_window_opacity        1.0
      $_YABAI -m config split_ratio                  0.50
      $_YABAI -m config auto_balance                 off
      $_YABAI -m config mouse_modifier               fn
      $_YABAI -m config mouse_action1                move
      $_YABAI -m config mouse_action2                resize

      # general space settings
      $_YABAI -m config layout                       bsp
      $_YABAI -m config top_padding                  5
      $_YABAI -m config bottom_padding               5
      $_YABAI -m config left_padding                 5
      $_YABAI -m config right_padding                5
      $_YABAI -m config window_gap                   5
    ''
  );

  launchd.user.agents.yabai = {
    path = [ "/bin" config.environment.systemPath ];
    serviceConfig.ProgramArguments = [
      "/Users/bkase/yabai/bin/yabai"
      "-c"
      "/etc/yabairc"
    ];
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;
    serviceConfig.ProcessType = "Interactive";
  };
}
