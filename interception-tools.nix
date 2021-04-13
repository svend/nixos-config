{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    evtest
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

          # - KEY: BTN_RIGHT
          #   TAP: BTN_RIGHT
          #   HOLD: KEY_RIGHTCTRL

          # - KEY: BTN_MIDDLE
          #   TAP: BTN_MIDDLE
          #   HOLD: KEY_RIGHTCTRL

          # - KEY: BTN_LEFT
          #   TAP: BTN_LEFT
          #   HOLD: KEY_RIGHTCTRL
      '';

      hybridConfig = pkgs.writeText "hybrid.yaml" ''
        NAME: Lenovo ThinkPad Compact USB Keyboard with TrackPoint
        PRODUCT: 24647
        VENDOR: 6127
        BUSTYPE: BUS_USB
        DRIVER_VERSION: 65537
        PROPERTIES:
          - INPUT_PROP_POINTER
          - INPUT_PROP_POINTING_STICK
        EVENTS:
          EV_SYN: [SYN_REPORT, SYN_CONFIG, SYN_MT_REPORT, SYN_DROPPED]
          EV_KEY: [KEY_ESC, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0, KEY_MINUS, KEY_EQUAL, KEY_BACKSPACE, KEY_TAB, KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P, KEY_LEFTBRACE, KEY_RIGHTBRACE, KEY_ENTER, KEY_LEFTCTRL, KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L, KEY_SEMICOLON, KEY_APOSTROPHE, KEY_GRAVE, KEY_LEFTSHIFT, KEY_BACKSLASH, KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M, KEY_COMMA, KEY_DOT, KEY_SLASH, KEY_RIGHTSHIFT, KEY_KPASTERISK, KEY_LEFTALT, KEY_SPACE, KEY_CAPSLOCK, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_NUMLOCK, KEY_SCROLLLOCK, KEY_KP7, KEY_KP8, KEY_KP9, KEY_KPMINUS, KEY_KP4, KEY_KP5, KEY_KP6, KEY_KPPLUS, KEY_KP1, KEY_KP2, KEY_KP3, KEY_KP0, KEY_KPDOT, KEY_ZENKAKUHANKAKU, KEY_102ND, KEY_F11, KEY_F12, KEY_RO, KEY_KATAKANA, KEY_HIRAGANA, KEY_HENKAN, KEY_KATAKANAHIRAGANA, KEY_MUHENKAN, KEY_KPJPCOMMA, KEY_KPENTER, KEY_RIGHTCTRL, KEY_KPSLASH, KEY_SYSRQ, KEY_RIGHTALT, KEY_HOME, KEY_UP, KEY_PAGEUP, KEY_LEFT, KEY_RIGHT, KEY_END, KEY_DOWN, KEY_PAGEDOWN, KEY_INSERT, KEY_DELETE, KEY_MUTE, KEY_VOLUMEDOWN, KEY_VOLUMEUP, KEY_POWER, KEY_KPEQUAL, KEY_PAUSE, KEY_SCALE, KEY_KPCOMMA, KEY_HANGEUL, KEY_HANJA, KEY_YEN, KEY_LEFTMETA, KEY_RIGHTMETA, KEY_COMPOSE, KEY_STOP, KEY_AGAIN, KEY_PROPS, KEY_UNDO, KEY_FRONT, KEY_COPY, KEY_OPEN, KEY_PASTE, KEY_FIND, KEY_CUT, KEY_HELP, KEY_MENU, KEY_CALC, KEY_SLEEP, KEY_FILE, KEY_WWW, KEY_COFFEE, KEY_MAIL, KEY_BOOKMARKS, KEY_BACK, KEY_FORWARD, KEY_EJECTCD, KEY_NEXTSONG, KEY_PLAYPAUSE, KEY_PREVIOUSSONG, KEY_STOPCD, KEY_RECORD, KEY_REWIND, KEY_PHONE, KEY_CONFIG, KEY_HOMEPAGE, KEY_REFRESH, KEY_EXIT, KEY_SCROLLUP, KEY_SCROLLDOWN, KEY_NEW, KEY_F13, KEY_F14, KEY_F15, KEY_F16, KEY_F17, KEY_F18, KEY_F19, KEY_F20, KEY_F21, KEY_F22, KEY_F23, KEY_F24, KEY_CLOSE, KEY_PLAY, KEY_FASTFORWARD, KEY_BASSBOOST, KEY_PRINT, KEY_CAMERA, KEY_CHAT, KEY_SEARCH, KEY_FINANCE, KEY_BRIGHTNESSDOWN, KEY_BRIGHTNESSUP, KEY_SWITCHVIDEOMODE, KEY_KBDILLUMTOGGLE, KEY_KBDILLUMDOWN, KEY_KBDILLUMUP, KEY_SAVE, KEY_DOCUMENTS, KEY_WLAN, KEY_UNKNOWN, KEY_VIDEO_NEXT, KEY_BRIGHTNESS_AUTO, KEY_MICMUTE, BTN_0, BTN_LEFT, BTN_RIGHT, BTN_MIDDLE, BTN_SIDE, BTN_EXTRA, KEY_SELECT, KEY_GOTO, KEY_INFO, KEY_PROGRAM, KEY_PVR, KEY_SUBTITLE, KEY_FULL_SCREEN, KEY_KEYBOARD, KEY_ASPECT_RATIO, KEY_PC, KEY_TV, KEY_TV2, KEY_VCR, KEY_VCR2, KEY_SAT, KEY_CD, KEY_TAPE, KEY_TUNER, KEY_PLAYER, KEY_DVD, KEY_AUDIO, KEY_VIDEO, KEY_MEMO, KEY_CALENDAR, KEY_RED, KEY_GREEN, KEY_YELLOW, KEY_BLUE, KEY_CHANNELUP, KEY_CHANNELDOWN, KEY_LAST, KEY_NEXT, KEY_RESTART, KEY_SLOW, KEY_SHUFFLE, KEY_PREVIOUS, KEY_VIDEOPHONE, KEY_GAMES, KEY_ZOOMIN, KEY_ZOOMOUT, KEY_ZOOMRESET, KEY_WORDPROCESSOR, KEY_EDITOR, KEY_SPREADSHEET, KEY_GRAPHICSEDITOR, KEY_PRESENTATION, KEY_DATABASE, KEY_NEWS, KEY_VOICEMAIL, KEY_ADDRESSBOOK, KEY_MESSENGER, KEY_DISPLAYTOGGLE, KEY_SPELLCHECK, KEY_LOGOFF, KEY_MEDIA_REPEAT, KEY_IMAGES, KEY_FN_ESC, KEY_BUTTONCONFIG, KEY_TASKMANAGER, KEY_JOURNAL, KEY_CONTROLPANEL, KEY_APPSELECT, KEY_SCREENSAVER, KEY_VOICECOMMAND, KEY_ASSISTANT, KEY_BRIGHTNESS_MIN, KEY_BRIGHTNESS_MAX]
          EV_REL: [REL_X, REL_Y, REL_HWHEEL, REL_WHEEL]
          EV_ABS:
            ABS_VOLUME:
              VALUE: 0
              MIN: 0
              MAX: 572
            ABS_MISC:
              VALUE: 0
              MIN: 0
              MAX: 255
          EV_MSC: [MSC_SCAN]
          EV_LED: [LED_NUML, LED_CAPSL, LED_SCROLLL, LED_COMPOSE, LED_KANA]
          EV_REP:
            REP_DELAY: 250
            REP_PERIOD: 33
      '';
    in
    {
      enable = true;
      # https://github.com/NixOS/nixpkgs/pull/94097
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        # - CMD: /nix/store/q7dfvnklx0nr7issxg0vpyk5skyynccd-interception-tools-0.6.4/bin/mux -c mouse-modifiers
        # - JOB: /nix/store/q7dfvnklx0nr7issxg0vpyk5skyynccd-interception-tools-0.6.4/bin/mux -i mouse-modifiers | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -c ${hybridConfig}
        # - JOB: intercept $DEVNODE | /nix/store/q7dfvnklx0nr7issxg0vpyk5skyynccd-interception-tools-0.6.4/bin/mux -o mouse-modifiers
        #   DEVICE:
        #     LINK: /dev/input/by-id/usb-Lenovo_ThinkPad_Compact_USB_Keyboard_with_TrackPoint-event-kbd
        # - JOB: intercept -g $DEVNODE | /nix/store/q7dfvnklx0nr7issxg0vpyk5skyynccd-interception-tools-0.6.4/bin/mux -o mouse-modifiers
        #   DEVICE:
        #     LINK: /dev/input/by-id/usb-Lenovo_ThinkPad_Compact_USB_Keyboard_with_TrackPoint-if01-event-mouse
        - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_SPACE]
      '';
    };
}
