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

