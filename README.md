# Sony DualSense Wireless Controller for PlayStation 5

This is a fork aimed at better documentation and an extension of the parent project.

For some reason, there is hardly any publicly available documentation regarding
the Dualsense controller. I have scraped through multiple sources, including:
- Google Android Dualsense driver
- DualsenseX
- Dualsense (Steam)
- This project

[95% fleshed out explorer tool](https://PeriodicSeizures.github.io/dualsense/dualsense-explorer.html)

[My highly detailed Dualsense HID protocol](https://PeriodicSeizures.github.io/dualsense/protocol.html)

## Findings
- Accurate/Legacy rumble:
  - Ds4Windows sets a different bit that seems undocumented. Immediately
    before the flag2 byte is a value different from the Accurate rumble.
  - Legacy `common[flag2 - 1]` = 0x02
    
    Accurate `common[flag2 - 1]` = 0x06

## Sources
- Android Dualsense driver: https://android.googlesource.com/kernel/msm.git/+/9882769164efdf1f2e1673bce4be1d1092ed89b2%5E%21/

## Wireshark
    Filter to relevant USB packets only

    // host -> controller
    (_ws.col.info == "URB_INTERRUPT out") && (usb.src == "host")

    // controller -> host
    ((_ws.col.info == "URB_INTERRUPT in") && (usb.dst == "host")) && (usb.bInterfaceClass == 0x03)

## Getting haptics to work on PC

System Sounds -> Playback
    Right-Click on Wireless Controller
    
    Properties -> Enhancements
    
    Select Speaker Fill Checkbox
    
    Is that option missing?
        Bottom Left, Configure

        Setup Surround Sound, 4 channels
        
    Now check enhancements again
    
    Still missing?
    
    Unplug and replug your controller
    
    Still missing?
    
    Restart system sounds
    
    Still missing?
    
    rESTART YOUR CompuTER
    
    Still missing?
    
    Hmm, out of luck.
    
You should hear something faint from the controller when doing a sound test

Open Firefox (it sesm to be the only one which works for this),

Play Blade Runner 2049

Turn the volume up

You should feel and might hear something.

