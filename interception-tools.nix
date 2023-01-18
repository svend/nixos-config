{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    evtest # Prints events for an input device, including key names
    interception-tools # For uinput command
  ];

  services.interception-tools =
    let
      dualFunctionKeysConfig = pkgs.writeText "dual-function-keys.yaml" ''
        TIMING:
          TAP_MILLISEC: 200
          DOUBLE_TAP_MILLISEC: 150

        # See https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
        MAPPINGS:

          # # Space as control key
          # - KEY: KEY_SPACE
          #   TAP: KEY_SPACE
          #   HOLD: KEY_RIGHTCTRL

          # Home row modifiers GACS

          - KEY: KEY_A
            TAP: KEY_A
            HOLD: KEY_LEFTMETA
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_SEMICOLON
            TAP: KEY_SEMICOLON
            HOLD: KEY_RIGHTMETA
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_S
            TAP: KEY_S
            HOLD: KEY_LEFTALT
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_L
            TAP: KEY_L
            HOLD: KEY_RIGHTALT
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_D
            TAP: KEY_D
            HOLD: KEY_LEFTCTRL
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_K
            TAP: KEY_K
            HOLD: KEY_RIGHTCTRL
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_F
            TAP: KEY_F
            HOLD: KEY_LEFTSHIFT
            HOLD_START: BEFORE_CONSUME

          - KEY: KEY_J
            TAP: KEY_J
            HOLD: KEY_RIGHTSHIFT
            HOLD_START: BEFORE_CONSUME

          # Left shift on Thinkpad X230 has developed an issue where pressing righ-shift
          # results in shift and pgup. Disable pgup (keycode 112). (Use `xev` to debug.)
          - KEY: KEY_PAGEUP
            TAP: KEY_RIGHTSHIFT
            HOLD: KEY_RIGHTSHIFT
      '';
    in
    {
      enable = true;
      # https://github.com/NixOS/nixpkgs/pull/94097
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dualFunctionKeysConfig} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            LINK: .*-event-kbd
      '';
    };
}
