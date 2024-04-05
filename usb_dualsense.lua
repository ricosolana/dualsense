-- Wireshark Dualsense USB Dissector
-- Useful display filters:
--  host -> controller
--      (_ws.col.info == "URB_INTERRUPT out") && (usb.src == "host")
-- 
--  controller -> host
--      (_ws.col.info == "URB_INTERRUPT in") && (usb.dst == "host") && (usb.bInterfaceClass == 0x03)
--
-- This will NOT work for Bluetooth (encrypted)
--
-- Tutorial I used:
--  https://mika-s.github.io/wireshark/lua/dissector/usb/2019/07/23/creating-a-wireshark-usb-dissector-in-lua-1.html
--
-- Written by crazicrafter1

usb_dualsense_protocol = Proto('USB_dualsense',  'USB Dualsense protocol')



local flag0_types = {
    [0] = 'No',
    [3] = 'Vibration',
    [4] = 'Right Adaptive Trigger',
    [8] = 'Left Adaptive Trigger',
}




local report_id = ProtoField.uint8('usb_dualsense.report_id', 'Report ID', base.DEC)
local flag0 = ProtoField.uint8('usb_dualsense.flag0', 'Feature Compatibility', base.DEC, flag0_types, 255)
local flag1 = ProtoField.uint8('usb_dualsense.flag1', 'Feature Controls', base.DEC)

local right_motor = ProtoField.uint8('usb_dualsense.right_motor', 'Right Rumbler', base.DEC)
local left_motor = ProtoField.uint8('usb_dualsense.left_motor', 'Left Rumbler', base.DEC)

local headset_volume = ProtoField.uint8('usb_dualsense.headset_volume', 'Headset Volume', base.DEC)
local speaker_volume = ProtoField.uint8('usb_dualsense.speaker_volume', 'Speaker Volume', base.DEC)
local audio3 = ProtoField.uint8('usb_dualsense.audio3', 'Audio3', base.DEC)
local audio4 = ProtoField.uint8('usb_dualsense.audio4', 'Audio4', base.DEC)

local mic_mute_led = ProtoField.uint8('usb_dualsense.mic_mute_led', 'Mic Mute LED', base.DEC)

local power_save_control = ProtoField.uint8('usb_dualsense.power_save_control', 'Power Save Control', base.DEC)

local right_adaptive_mode = ProtoField.uint8('usb_dualsense.right_adaptive_mode', 'Right Adaptive Trigger Mode', base.DEC)
local right_adaptive_0 = ProtoField.uint8('usb_dualsense.right_adaptive_0', 'Right Adaptive Trigger Parameter[0]', base.DEC)
local right_adaptive_1 = ProtoField.uint8('usb_dualsense.right_adaptive_1', 'Right Adaptive Trigger Parameter[1]', base.DEC)
local right_adaptive_2 = ProtoField.uint8('usb_dualsense.right_adaptive_2', 'Right Adaptive Trigger Parameter[2]', base.DEC)
local right_adaptive_3 = ProtoField.uint8('usb_dualsense.right_adaptive_3', 'Right Adaptive Trigger Parameter[3]', base.DEC)
local right_adaptive_4 = ProtoField.uint8('usb_dualsense.right_adaptive_4', 'Right Adaptive Trigger Parameter[4]', base.DEC)
local right_adaptive_5 = ProtoField.uint8('usb_dualsense.right_adaptive_5', 'Right Adaptive Trigger Parameter[5]', base.DEC)
local right_adaptive_6 = ProtoField.uint8('usb_dualsense.right_adaptive_6', 'Right Adaptive Trigger Parameter[6]', base.DEC)
local right_adaptive_7 = ProtoField.uint8('usb_dualsense.right_adaptive_7', 'Right Adaptive Trigger Parameter[7]', base.DEC)
local right_adaptive_8 = ProtoField.uint8('usb_dualsense.right_adaptive_8', 'Right Adaptive Trigger Parameter[8]', base.DEC)
local right_adaptive_9 = ProtoField.uint8('usb_dualsense.right_adaptive_9', 'Right Adaptive Trigger Parameter[9]', base.DEC)

local left_adaptive_mode = ProtoField.uint8('usb_dualsense.left_adaptive_mode', 'Left Adaptive Trigger Mode', base.DEC)
local left_adaptive_0 = ProtoField.uint8('usb_dualsense.left_adaptive_0', 'Left Adaptive Trigger Parameter[0]', base.DEC)
local left_adaptive_1 = ProtoField.uint8('usb_dualsense.left_adaptive_1', 'Left Adaptive Trigger Parameter[1]', base.DEC)
local left_adaptive_2 = ProtoField.uint8('usb_dualsense.left_adaptive_2', 'Left Adaptive Trigger Parameter[2]', base.DEC)
local left_adaptive_3 = ProtoField.uint8('usb_dualsense.left_adaptive_3', 'Left Adaptive Trigger Parameter[3]', base.DEC)
local left_adaptive_4 = ProtoField.uint8('usb_dualsense.left_adaptive_4', 'Left Adaptive Trigger Parameter[4]', base.DEC)
local left_adaptive_5 = ProtoField.uint8('usb_dualsense.left_adaptive_5', 'Left Adaptive Trigger Parameter[5]', base.DEC)
local left_adaptive_6 = ProtoField.uint8('usb_dualsense.left_adaptive_6', 'Left Adaptive Trigger Parameter[6]', base.DEC)
local left_adaptive_7 = ProtoField.uint8('usb_dualsense.left_adaptive_7', 'Left Adaptive Trigger Parameter[7]', base.DEC)
local left_adaptive_8 = ProtoField.uint8('usb_dualsense.left_adaptive_8', 'Left Adaptive Trigger Parameter[8]', base.DEC)
local left_adaptive_9 = ProtoField.uint8('usb_dualsense.left_adaptive_9', 'Left Adaptive Trigger Parameter[9]', base.DEC)

local rumble_intensity = ProtoField.uint8('usb_dualsense.rumble_intensity', 'Rumble Intensity', base.DEC)

local flag2 = ProtoField.uint8('usb_dualsense.flag2', 'Flag2', base.DEC)

local lightbar_setup = ProtoField.uint8('usb_dualsense.lightbar_setup', 'Lightbar Setup', base.DEC)
local mic_mute_brightness = ProtoField.uint8('usb_dualsense.mic_mute_brightness', 'Mic Mute Brightness', base.DEC)
local player_leds = ProtoField.uint8('usb_dualsense.player_leds', 'Player LED\'s', base.DEC)

local lightbar_red = ProtoField.uint8('usb_dualsense.lightbar_red', 'Red', base.DEC)
local lightbar_green = ProtoField.uint8('usb_dualsense.lightbar_green', 'Green', base.DEC)
local lightbar_blue = ProtoField.uint8('usb_dualsense.lightbar_blue', 'Blue', base.DEC)

usb_dualsense_protocol.fields = { 
    -- usb header
    report_id, 
    -- common
    flag0, flag1, 
    right_motor, left_motor,
    headset_volume, speaker_volume, audio3, audio4,
    mic_mute_led,
    power_save_control,
    right_adaptive_mode, right_adaptive_0, right_adaptive_1, right_adaptive_2, right_adaptive_3, right_adaptive_4, right_adaptive_5, right_adaptive_6, right_adaptive_7, right_adaptive_8, right_adaptive_9,
    left_adaptive_mode, left_adaptive_0, left_adaptive_1, left_adaptive_2, left_adaptive_3, left_adaptive_4, left_adaptive_5, left_adaptive_6, left_adaptive_7, left_adaptive_8, left_adaptive_9,
    rumble_intensity,
    flag2,
    lightbar_setup,
    mic_mute_brightness,
    player_leds,
    lightbar_red, lightbar_green, lightbar_blue,
}



local parse_common = function(buffer, subtree)
    subtree:add_le(flag0, buffer(0, 1))
    subtree:add_le(flag1, buffer(1, 1))

    local motor_tree = subtree:add(usb_dualsense_protocol, buffer(2, 2), 'Rumblers')
    motor_tree:add_le(right_motor, buffer(2, 1))
    motor_tree:add_le(left_motor, buffer(3, 1))



    local headset_volume_buffer = buffer(4, 1)
    local headset_volume_v = headset_volume_buffer:le_uint()
    local headset_volume_s
    if headset_volume_v > 0 then
        headset_volume_s = tostring(math.floor((headset_volume_v - 30) / (127 - 30))) .. '%'
    else
        headset_volume_s = 'Muted'
    end

    local speaker_volume_buffer = buffer(5, 1)
    local speaker_volume_v = headset_volume_buffer:le_uint()
    local speaker_volume_s
    if speaker_volume_v > 0 then
        speaker_volume_s = tostring(math.floor((speaker_volume_v - 61) / (100 - 61))) .. '%'
    else
        speaker_volume_s = 'Muted'
    end

    local audio_tree = subtree:add(usb_dualsense_protocol, buffer(5, 4), 'Audio (' .. headset_volume_s .. ', ' .. speaker_volume_s .. ')')
    audio_tree:add_le(headset_volume, headset_volume_buffer)
    audio_tree:add_le(speaker_volume, speaker_volume_buffer)
    audio_tree:add_le(audio3, buffer(6, 1))
    audio_tree:add_le(audio4, buffer(7, 1))



    subtree:add_le(mic_mute_led, buffer(8, 1))

    subtree:add_le(power_save_control, buffer(9, 1))

    local right_adaptive_tree = subtree:add(usb_dualsense_protocol, buffer(10, 11), 'Right Adaptive Trigger Data')
    right_adaptive_tree:add_le(right_adaptive_mode, buffer(10, 1))
    right_adaptive_tree:add_le(right_adaptive_0, buffer(11, 1))
    right_adaptive_tree:add_le(right_adaptive_1, buffer(12, 1))
    right_adaptive_tree:add_le(right_adaptive_2, buffer(13, 1))
    right_adaptive_tree:add_le(right_adaptive_3, buffer(14, 1))
    right_adaptive_tree:add_le(right_adaptive_4, buffer(15, 1))
    right_adaptive_tree:add_le(right_adaptive_5, buffer(16, 1))
    right_adaptive_tree:add_le(right_adaptive_6, buffer(17, 1))
    right_adaptive_tree:add_le(right_adaptive_7, buffer(18, 1))
    right_adaptive_tree:add_le(right_adaptive_8, buffer(19, 1))
    right_adaptive_tree:add_le(right_adaptive_9, buffer(20, 1))

    local left_adaptive_tree = subtree:add(usb_dualsense_protocol, buffer(21, 11), 'Left Adaptive Trigger Data')
    left_adaptive_tree:add_le(left_adaptive_mode, buffer(21, 1))
    left_adaptive_tree:add_le(left_adaptive_0, buffer(22, 1))
    left_adaptive_tree:add_le(left_adaptive_1, buffer(23, 1))
    left_adaptive_tree:add_le(left_adaptive_2, buffer(24, 1))
    left_adaptive_tree:add_le(left_adaptive_3, buffer(25, 1))
    left_adaptive_tree:add_le(left_adaptive_4, buffer(26, 1))
    left_adaptive_tree:add_le(left_adaptive_5, buffer(27, 1))
    left_adaptive_tree:add_le(left_adaptive_6, buffer(28, 1))
    left_adaptive_tree:add_le(left_adaptive_7, buffer(29, 1))
    left_adaptive_tree:add_le(left_adaptive_8, buffer(30, 1))
    left_adaptive_tree:add_le(left_adaptive_9, buffer(31, 1))

    subtree:add_le(rumble_intensity, buffer(36, 1))
    subtree:add_le(flag2, buffer(39, 1))
    subtree:add_le(lightbar_setup, buffer(41, 1))
    subtree:add_le(mic_mute_brightness, buffer(42, 1))
    subtree:add_le(player_leds, buffer(43, 1))

    local lightbar_color_buffer = buffer(44, 3)
    --local lightbar_red_buffer = buffer(44, 1)
    --local lightbar_green_buffer = buffer(45, 1)
    --local lightbar_blue_buffer = buffer(46, 1)
    local lightbar_color_s = '#' .. lightbar_color_buffer:bytes():tohex()
    --local lightbar_color_s = lightbar_red_buffer:bytes():tohex() .. lightbar_red_buffer:bytes():tohex() .. lightbar_red_buffer:bytes():tohex()
    local lightbar_color_tree = subtree:add(usb_dualsense_protocol, lightbar_color_buffer, 'Lightbar Color (' .. lightbar_color_s .. ')')
    --lightbar_color:add_le(lightbar_red, lightbar_red_buffer)
    --lightbar_color:add_le(lightbar_green, lightbar_green_buffer)
    --lightbar_color:add_le(lightbar_blue, lightbar_blue_buffer)
    lightbar_color_tree:add_le(lightbar_blue, lightbar_color_buffer(0, 1))
    lightbar_color_tree:add_le(lightbar_blue, lightbar_color_buffer(1, 1))
    lightbar_color_tree:add_le(lightbar_blue, lightbar_color_buffer(2, 1))
end

function usb_dualsense_protocol.dissector(buffer, pinfo, tree)
    local length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = usb_dualsense_protocol.name

    local subtree = tree:add(usb_dualsense_protocol, buffer(), 'USB Dualsense Data')

    subtree:add_le(report_id, buffer(0, 1))

    parse_common(buffer(1), subtree)
end

local usb_table = DissectorTable.get('usb.interrupt')
usb_table:add(0x0003, usb_dualsense_protocol) -- HID (DS4Windows, )
usb_table:add(0xffff, usb_dualsense_protocol) -- Unknown (Haptic Composer, )