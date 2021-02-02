{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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

          # Space as control key
          - KEY: KEY_SPACE
            TAP: KEY_SPACE
            HOLD: KEY_RIGHTCTRL

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
      # sudo nixos-rebuild -I nixpkgs=/home/svend/src/nixpkgs switch
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
          DEVICE:
            NAME: AT Translated Set 2 keyboard
        - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
          DEVICE:
            NAME: Lenovo ThinkPad Compact USB Keyboard with TrackPoint
        - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
          DEVICE:
            NAME: Keychron Keychron C1
      '';
    };
}
