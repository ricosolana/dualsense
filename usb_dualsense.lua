-- Wireshark Dualsense USB Dissector
-- Useful display filters:
--  host -> controller
--      (_ws.col.info == "URB_INTERRUPT out") && (usb.src == "host")
-- 
--  controller -> host
--      (_ws.col.info == "URB_INTERRUPT in") && (usb.dst == "host") && (usb.bInterfaceClass == 0x03)
--
-- Written by crazicrafter1

usb_dualsense_protocol = Proto('USB_dualsense',  'USB Dualsense protocol')

local report_id   = ProtoField.uint8('usb_dualsense.report_id', 'Report ID', base.DEC)
local flag0 = ProtoField.uint8('usb_dualsense.flag0', 'Feature Compatibility', base.DEC)
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

usb_dualsense_protocol.fields = { 
    report_id, flag0, flag1, 
    right_motor, left_motor,
    headset_volume, speaker_volume, audio3, audio4,
    mic_mute_led,
    power_save_control,
    right_adaptive_mode, right_adaptive_0, right_adaptive_1, right_adaptive_2, right_adaptive_3, right_adaptive_4, right_adaptive_5, right_adaptive_6, right_adaptive_7, right_adaptive_8, right_adaptive_9,
    left_adaptive_mode, left_adaptive_0, left_adaptive_1, left_adaptive_2, left_adaptive_3, left_adaptive_4, left_adaptive_5, left_adaptive_6, left_adaptive_7, left_adaptive_8, left_adaptive_9,
}

function usb_dualsense_protocol.dissector(buffer, pinfo, tree)
  local length = buffer:len()
  if length == 0 then return end

  pinfo.cols.protocol = usb_dualsense_protocol.name

  local subtree = tree:add(usb_dualsense_protocol, buffer(), 'USB Dualsense Data')
  
  subtree:add_le(report_id, buffer(0, 1))
  subtree:add_le(flag0, buffer(1, 1))
  subtree:add_le(flag1, buffer(2, 1))
  
  local motor_tree = subtree:add(usb_dualsense_protocol, buffer(3, 2), 'Rumblers')
  motor_tree:add_le(right_motor, buffer(3, 1))
  motor_tree:add_le(left_motor, buffer(4, 1))



  local headset_volume_buffer = buffer(5, 1)
  local headset_volume_v = headset_volume_buffer:le_uint()
  local headset_volume_s
  if headset_volume_v > 0 then
    headset_volume_s = tostring(math.floor((headset_volume_v - 30) / (127 - 30))) .. '%'
  else
    headset_volume_s = 'Muted'
  end

  local speaker_volume_buffer = buffer(6, 1)
  local speaker_volume_v = headset_volume_buffer:le_uint()
  local speaker_volume_s
  if speaker_volume_v > 0 then
    speaker_volume_s = tostring(math.floor((speaker_volume_v - 61) / (100 - 61))) .. '%'
  else
    speaker_volume_s = 'Muted'
  end

  local audio_tree = subtree:add(usb_dualsense_protocol, buffer(5, 4), 'Audio (' .. headset_volume_s .. ', ' .. speaker_volume_s .. ')')
  audio_tree:add_le(headset_volume, headset_volume_buffer) --, tostring(headset_volume_v) .. '(' .. headset_volume_s .. ')')
  audio_tree:add_le(speaker_volume, speaker_volume_buffer)
  audio_tree:add_le(audio3, buffer(7, 1))
  audio_tree:add_le(audio4, buffer(8, 1))



  subtree:add_le(mic_mute_led, buffer(9, 1))

  subtree:add_le(power_save_control, buffer(10, 1))

  local right_adaptive_tree = subtree:add(usb_dualsense_protocol, buffer(11, 11), 'Right Adaptive Trigger Data')
  right_adaptive_tree:add_le(right_adaptive_mode, buffer(11, 1))
  right_adaptive_tree:add_le(right_adaptive_0, buffer(12, 1))
  right_adaptive_tree:add_le(right_adaptive_1, buffer(13, 1))
  right_adaptive_tree:add_le(right_adaptive_2, buffer(14, 1))
  right_adaptive_tree:add_le(right_adaptive_3, buffer(15, 1))
  right_adaptive_tree:add_le(right_adaptive_4, buffer(16, 1))
  right_adaptive_tree:add_le(right_adaptive_5, buffer(17, 1))
  right_adaptive_tree:add_le(right_adaptive_6, buffer(18, 1))
  right_adaptive_tree:add_le(right_adaptive_7, buffer(19, 1))
  right_adaptive_tree:add_le(right_adaptive_8, buffer(20, 1))
  right_adaptive_tree:add_le(right_adaptive_9, buffer(21, 1))

  local left_adaptive_tree = subtree:add(usb_dualsense_protocol, buffer(22, 11), 'Left Adaptive Trigger Data')
  left_adaptive_tree:add_le(left_adaptive_mode, buffer(22, 1))
  left_adaptive_tree:add_le(left_adaptive_0, buffer(23, 1))
  left_adaptive_tree:add_le(left_adaptive_1, buffer(24, 1))
  left_adaptive_tree:add_le(left_adaptive_2, buffer(25, 1))
  left_adaptive_tree:add_le(left_adaptive_3, buffer(26, 1))
  left_adaptive_tree:add_le(left_adaptive_4, buffer(27, 1))
  left_adaptive_tree:add_le(left_adaptive_5, buffer(28, 1))
  left_adaptive_tree:add_le(left_adaptive_6, buffer(29, 1))
  left_adaptive_tree:add_le(left_adaptive_7, buffer(30, 1))
  left_adaptive_tree:add_le(left_adaptive_8, buffer(31, 1))
  left_adaptive_tree:add_le(left_adaptive_9, buffer(32, 1))
end

DissectorTable.get('usb.interrupt'):add(0xffff, usb_dualsense_protocol)