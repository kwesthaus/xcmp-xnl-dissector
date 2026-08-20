local proto = Proto("xcmp", "Motorola XCMP")

local opcodes_base = {
  [0x0001] = "SOFTPOT",
  [0x0002] = "TXCFG",
  [0x0003] = "RCVCFG",
  [0x0004] = "TX",
  [0x0005] = "RECEIVE",
  [0x0006] = "TXPWR",
  [0x0007] = "PREDEEMPH",
  [0x000a] = "RXFREQ",
  [0x000b] = "TXFREQ",
  [0x000c] = "TESTMODE",
  [0x000d] = "RDRESET",
  [0x000e] = "RSTATUS",
  [0x000f] = "VERINFO",
  [0x0010] = "RWMODELNUM",
  [0x0011] = "SERNUMOP",
  [0x0012] = "READUUID",
  [0x0016] = "RXBERCTRL",
  [0x0017] = "RXBERSYNCRPRT",
  [0x0019] = "DATECODE",
  [0x0023] = "DSCVRREMDEV",
  [0x0024] = "REMCON",
  [0x0025] = "REMDISCON",
  [0x002b] = "WRITEDELLANGPK",
  [0x002c] = "LANGPKINFO",
  [0x002e] = "SUPERBUNDLE",
  [0x0030] = "CNCTVTYTEST",
  [0x0037] = "CODEPLUGATTR",
  [0x003d] = "SECURECON",
  [0x0100] = "READISHITEM",
  [0x0101] = "WRITEISHITEM",
  [0x0102] = "DELISHID",
  [0x0103] = "DELISHTYPE",
  [0x0104] = "READISHIDSET",
  [0x0105] = "READISHTYPESET",
  [0x0106] = "ISHPROGMODE",
  [0x0107] = "ISHREORGCTRL",
  [0x0108] = "ISHUNLOCKPART",
  [0x0109] = "CLONEWR",
  [0x010a] = "CLONERD",
  [0x010b] = "PSDTACCESS",
  [0x010c] = "RDUPDCTRL",
  [0x010e] = "CMPNTREAD",
  [0x010f] = "CMPNTSESSION",
  [0x0200] = "BOOTMODE",
  [0x0201] = "READMEM",
  [0x0202] = "WRITEMEM",
  [0x0203] = "ERASEFLASH",
  [0x0204] = "BOOTJMPEXEC",
  [0x0206] = "BOOTWRITECOMMIT",
  [0x0207] = "REMDUPE",
  [0x0208] = "FPGAOP",
  [0x0300] = "READRDKEY",
  [0x0301] = "UNLOCKSEC",
  [0x0400] = "DEVINITSTS",
  [0x0401] = "DISPTXT",
  [0x0402] = "INDUPDRQ",
  [0x0405] = "PUINPUT",
  [0x0406] = "VOLCTRL",
  [0x0407] = "SPKRCTRL",
  [0x0408] = "TXPWRLVL",
  [0x0409] = "TONECTRL",
  [0x040a] = "SHUTDWN",
  [0x040c] = "MON",
  [0x040d] = "CHZNSEL",
  [0x040e] = "MICCTRL",
  [0x040f] = "SCAN",
  [0x0410] = "BATLVL",
  [0x0411] = "BRIGHTNESS",
  [0x0412] = "BTNCONF",
  [0x0413] = "EMG",
  [0x0414] = "AUDRTCTRL",
  [0x0415] = "KEY",
  [0x041b] = "SIG",
  [0x041c] = "RRCTRL",
  [0x041d] = "DATA",
  [0x041e] = "CALLCTRL",
  [0x041f] = "NAVCTRL",
  [0x0420] = "MENUCTRL",
  [0x0421] = "DEVCTRL",
  [0x0428] = "DEVMGMT",
  [0x042e] = "ALARMCTRL",
  [0x042f] = "ROSCTRL",
  [0x0432] = "DATETIME",
  [0x0434] = "NTWRKINFCFG",
  [0x0440] = "MEMSTRMREAD",
  [0x0441] = "MEMSTRMWRITE",
  [0x0442] = "MEMSTRMSTATUS",
  [0x0443] = "NANDACCESS",
  [0x0444] = "FTLACCESS",
  [0x0445] = "FILEACCESS",
  [0x0446] = "XFERDATA",
  [0x0447] = "RPTRCTRL",
  [0x0458] = "FD",
  [0x0461] = "MODINFO",
  [0x0467] = "CODEPLUGPASSWORD",
  [0x046c] = "UNKILL",
  [0x04a1] = "SWA_AUDIO",
}

local opcodes = {}
for base, name in pairs(opcodes_base) do
  opcodes[base] = name .. "_REQ"
  opcodes[base + 0x8000] = name .. "_RES"
  opcodes[base + 0xb000] = name .. "_BRDCST"
end


--[[
  ENUMS
]]

-- MULTIPLE

local results = {
  [0] = "Success",
  [1] = "Failure",
  [2] = "Incorrect Mode",
  [3] = "Unsupported Opcode",
  [4] = "Invalid Parameter",
  [5] = "Reply Too Big",
  [6] = "Security Locked",
  [7] = "Bundled Opcode Not Supported",
  [16] = "LockSeqFail/EraseInProg/Busy/PairDevFail",
  [17] = "BitLock/LangPackNoExist/PwVerifFail",
  [18] = "BitUnlock/RadioLocked/TTSNoExist",
  [19] = "Voltage Not Stable",
  [20] = "Program Failure",
  [22] = "Transfer Complete",
  [23] = "Request Not RXed",
  [64] = "Softpot Operation Not Supported",
  [65] = "Softpot Type Not Supported",
  [66] = "Softpot Value Out of Range",
  [128] = "Flash Write Failure",
  [129] = "ISH Item Not Found",
  [130] = "ISH Offset Out of Range",
  [131] = "ISH Insufficient Partition Space",
  [132] = "ISH Partition Does Not Exist",
  [133] = "ISH Partition Read Only",
  [134] = "ISH Reorg Needed",
  [135] = "Undefined",
}

local address_types = {
  [0] = "Local",
  [1] = "MotoTRBO",
  [2] = "IPv4",
  [5] = "MDC",
  [7] = "Phonenumber",
  [11] = "QuickCall",
  [13] = "5-Tone",
  [14] = "De-/Access Code",
}

-- 0x_00e RSTATUS
local rstatus_conditions = {
  [0] = "Squelch",
  [1] = "Synthesizer Lock Detect",
  [2] = "RSSI",
  [3] = "Battery Value",
  [4] = "Low Battery",
  [5] = "Powerup Status",
  [6] = "Abacus Tuning Status",
  [7] = "Model Number",
  [8] = "Serial Number",
  [9] = "Read ESN",
  [10] = "IF Input Signal Strength",
  [11] = "Read Product Serial Number",
  [12] = "Frequency Offset",
  [13] = "Current Signalling Mode",
  [14] = "Radio ID",
  [15] = "Radio Alias",
  [16] = "Generic Option Board Available",
  [17] = "Bandit Wireline Board Available",
  [18] = "Alt Image Status of Bandit Controller FPGA",
  [19] = "Alt Image Status of Bandit Wireline FPGA",
  [20] = "Neptune Feature Status",
  [21] = "Meter Status of Bandit FPGA",
  [22] = "Select 5 Radio ID",
  [23] = "Privacy Type",
  [24] = "Bluetooth Address",
  [25] = "Sideband Suppression",
  [45] = "Radio Update Status",
  [75] = "Physical Serial Number",
  [78] = "Default Gateway Network Attachment",
}

-- 0x_00f VERINFO
local verinfo_targets = {
  [0x00] = "Host Software Version",
  [0x02] = "Current BBF Bundle Version",
  [0x03] = "Pending BBF Bundle Version",
  [0x04] = "Codeplug Required Firmware Version",
  [0x10] = "DSP Software Version",
  [0x11] = "DSP Capability",
  [0x13] = "DTP Capability",
  [0x22] = "Mace Flash Version",
  [0x24] = "Mace Hardware Version",
  [0x25] = "Mace Hardware Type",
  [0x30] = "Flash Boot App Version",
  [0x32] = "RAM Downloader Version",
  [0x35] = "L3 Bootloader Version",
  [0x40] = "Tune Version",
  [0x41] = "Security Version",
  [0x42] = "Codeplug Version",
  [0x4b] = "Codeplug Session ID",
  [0x50] = "PSDT Version",
  [0x51] = "Configuration Version",
  [0x52] = "Kernel Version",
  [0x6d] = "Flash Size",
  [0x81] = "Option Board Firmware Version",
  [0x82] = "Option Board Name",
  [0x84] = "Option Board Hardware Type",
  [0x85] = "Option Board Main App Version",
  [0x87] = "Option Board Flash Image Type",
  [0x88] = "Option Board Flash Image Version",
  [0xa4] = "Consolette Brd Hardware Type",
  [0xa5] = "Consolette Brd Host Version",
  [0xb0] = "FPGA Controller Alt Version",
  [0xb1] = "FPGA Controller Factory Version",
  [0xb2] = "FPGA Controller Active Version",
  [0xb3] = "FPGA Wireline Alt Version",
  [0xb4] = "FPGA Wireline Factory Version",
  [0xb5] = "FPGA Wireline Active Version",
}

-- 0x_010 RWMODELNUM
local modelnum_ops = {
  [0] = "Read",
  [1] = "Write",
}

-- 0x_011 SERNUMOP
local sernum_ops = {
  [0] = "Read Radio SN",
  [1] = "Write Radio SN",
  [2] = "Read ESN",
  [3] = "Write ESN",
  [4] = "Read MAC Address",
  [5] = "Write MAC Address",
  [6] = "Read Product SN",
  [7] = "Write Product SN",
  [8] = "Read Option Board SN",
  [9] = "Write Option Board SN",
  [10] = "Read WiFi MAC Address",
  [11] = "Write WiFi MAC Address",
}

-- 0x_02c LANGPKINFO
local langpkinfo_targets = {
  [0] = "Single Language Pack",
  [1] = "All Language Pack",
  [2] = "Default Language Pack",
  [3] = "All TTS Language Pack",
}

-- 0x_037 CODEPLUGATTR
local codeplugattr_ops = {
  [0] = "None",
  [1] = "Read",
  [2] = "Write",
}
local codeplugattr_types = {
  [0] = "None",
  [1] = "Total Allowable Memory",
  [2] = "Current Memory Used",
  [3] = "Regional Information",
  [4] = "OEM Manufacturer ID",
  [7] = "Radio Security Information",
  [9] = "Certificate Supported ID",
}

-- 0x_10_ ISH
local partitions = {
  [0x80] = "APP?",
  [0x81] = "SECURITY?",
}

-- 0x_400 DEVINITSTS
local devinitsts_inits = {
  [0] = "STATUS",
  [1] = "COMPLETE",
  [2] = "UPDATE",
}
local devtypes = {
  [1] = "RF Transceiver",
  [10] = "IP Peripheral",
}
local devinitsts_attrs = {
  [0] = "Device Family",
  [2] = "Display",
  [3] = "Speaker",
  [4] = "RF Band",
  [5] = "GPIO",
  [7] = "Radio Type",
  [9] = "Keypad",
  [13] = "Channel Knob",
  [14] = "Virtual Personality",
  [17] = "Bluetooth",
  [19] = "Accelerometer",
  [20] = "GPS",
}

-- 0x_41E CALLCTRL
local calltypes = {
  [0] = "No Call",
  [1] = "Selective Call",
  [2] = "Call Alert",
  [4] = "Enhanced Private Call",
  [5] = "Private Phone Call",
  [6] = "Group Call",
  [8] = "Call Alert with Voice",
  [9] = "Telegram Call",
  [10] = "Group Phone Call",
}

-- 0x_467 CODEPLUGPASSWORD
local codeplugpassword_functions = {
  [0] = "Request Status",
  [1] = "Verify Password",
  [2] = "Pair Device",
  [3] = "Unpair Device",
  [4] = "Verify Pair",
}

-- Multiple
local f_opcode = ProtoField.uint16("xcmp.opcode", "Opcode", base.HEX, opcodes)
local f_len = ProtoField.uint16("xcmp.len", "Length", base.DEC)
local f_result = ProtoField.uint8("xcmp.result", "Result", base.DEC, results)
local f_address_type = ProtoField.uint8("xcmp.address.type", "Type", base.DEC, address_types)
local f_address_mototrbo = ProtoField.bytes("xcmp.address.mototrbo", "MotoTRBO ID")
-- 0x_0__
local f_rstatus_result = ProtoField.uint8("xcmp.rstatus.result", "Result", base.DEC, results)
local f_rstatus_condition = ProtoField.uint8("xcmp.rstatus.condition", "Condition", base.DEC, rstatus_conditions)
local f_rstatus_status = ProtoField.bytes("xcmp.rstatus.status", "Status")
local f_verinfo_target = ProtoField.uint8("xcmp.verinfo.target", "Target", base.DEC, verinfo_targets)
local f_verinfo_version = ProtoField.stringz("xcmp.verinfo.version", "Version", base.ASCII)
local f_modelnum_op = ProtoField.uint8("xcmp.modelnum.op", "Operation", base.DEC, modelnum_ops)
local f_modelnum_data = ProtoField.stringz("xcmp.modelnum.data", "Data", base.ASCII)
local f_sernum_op = ProtoField.uint8("xcmp.sernum.op", "Operation", base.DEC, sernum_ops)
local f_sernum_data = ProtoField.stringz("xcmp.sernum.data", "Data", base.ASCII)
local f_uuid_data = ProtoField.bytes("xcmp.uuid.data", "Data")
local f_langpkinfo_target = ProtoField.uint8("xcmp.langpkinfo.target", "Target", base.DEC, langpkinfo_targets)
local f_langpkinfo_avail = ProtoField.uint32("xcmp.langpkinfo.avail", "Available Space", base.DEC)
local f_langpkinfo_count = ProtoField.uint8("xcmp.langpkinfo.count", "Language Pack Count", base.DEC)
local f_langpkinfo_entry_len = ProtoField.uint8("xcmp.langpkinfo.entry_len", "Language Pack Entry Length", base.DEC)
local f_langpkinfo_entry = ProtoField.bytes("xcmp.langpkinfo.entry", "Language Pack Data")
local f_bundle_count = ProtoField.uint8("xcmp.bundle.count", "Message Count", base.DEC)
local f_codeplugattr_op = ProtoField.uint8("xcmp.codeplugattr.ops", "Operation", base.DEC, codeplugattr_ops)
local f_codeplugattr_type = ProtoField.uint8("xcmp.codeplugattr.type", "Type", base.DEC, codeplugattr_types)
local f_codeplugattr_data_len = ProtoField.uint8("xcmp.codeplugattr.data.len", "Length", base.DEC)
local f_codeplugattr_data = ProtoField.bytes("xcmp.codeplugattr.data", "Data")
-- 0x_1__
local f_ish_part = ProtoField.uint8("xcmp.ish.partition", "Partition", base.HEX, partitions)
local f_ish_type = ProtoField.uint16("xcmp.ish.type", "Type", base.HEX)
local f_ish_id = ProtoField.uint16("xcmp.ish.id", "ID", base.HEX)
local f_ish_req_len = ProtoField.uint16("xcmp.ish.req_len", "Length", base.DEC)
local f_ish_offset = ProtoField.uint16("xcmp.ish.offset", "Offset", base.DEC)
local f_ish_ret_len = ProtoField.uint16("xcmp.ish.ret_len", "Returned length", base.DEC)
local f_ish_tot_len = ProtoField.uint16("xcmp.ish.tot_len", "Total length", base.DEC)
local f_ish_value = ProtoField.bytes("xcmp.ish.value", "Value")
local f_readishidset_entry = ProtoField.uint16("xcmp.readishidset.entry", "Entry", base.HEX)
local f_readishtypeset_entry = ProtoField.uint16("xcmp.readishtypeset.entry", "Entry", base.HEX)
-- 0x_4__
local f_devinitsts_major = ProtoField.uint8("xcmp.devinitsts.major", "Major Version", base.DEC)
local f_devinitsts_minor = ProtoField.uint8("xcmp.devinitsts.minor", "Minor Version", base.DEC)
local f_devinitsts_patch = ProtoField.uint8("xcmp.devinitsts.patch", "Patch Version", base.DEC)
local f_devinitsts_product = ProtoField.uint8("xcmp.devinitsts.product", "Product ID", base.DEC)
local f_devinitsts_init = ProtoField.uint8("xcmp.devinitsts.init", "Initialization", base.DEC, devinitsts_inits)
local f_devinitsts_type = ProtoField.uint8("xcmp.devinitsts.type", "Type", base.DEC, devtypes)
local f_devinitsts_status = ProtoField.uint16("xcmp.devinitsts.status", "Status", base.DEC)
local f_devinitsts_attrlen = ProtoField.uint8("xcmp.devinitsts.attrlen", "Attribute Length", base.DEC)
local f_devinitsts_attr = ProtoField.bytes("xcmp.devinitsts.attr", "Attribute")
local f_devinitsts_attr_key = ProtoField.uint8("xcmp.devinitsts.attr.key", "Key", base.HEX, devinitsts_attrs)
local f_devinitsts_attr_value = ProtoField.uint8("xcmp.devinitsts.attr.value", "Value", base.HEX)
local f_chznsel_function = ProtoField.uint8("xcmp.chznsel.function", "Function", base.DEC)
local f_chznsel_zone = ProtoField.uint16("xcmp.chznsel.zone", "Zone", base.DEC)
local f_chznsel_position = ProtoField.uint16("xcmp.chznsel.position", "Position", base.DEC)
local f_scan_function = ProtoField.uint8("xcmp.scan.function", "Function", base.DEC)
local f_rrctrl_feature = ProtoField.uint8("xcmp.rrctrl.feature", "Feature", base.DEC)
local f_rrctrl_operation = ProtoField.uint8("xcmp.rrctrl.operation", "Operation", base.DEC)
local f_rrctrl_status = ProtoField.uint8("xcmp.rrctrl.status", "Status", base.DEC)
local f_rrctrl_address = ProtoField.bytes("xcmp.rrctrl.address", "Address")
local f_callctrl_function = ProtoField.uint8("xcmp.callctrl.function", "Function", base.DEC)
local f_callctrl_calltype = ProtoField.uint8("xcmp.callctrl.calltype", "Call Type", base.DEC, calltypes)
local f_callctrl_address = ProtoField.bytes("xcmp.callctrl.address", "Address")
local f_callctrl_group = ProtoField.bytes("xcmp.callctrl.group", "Group ID")
local f_fileaccess_xfertype = ProtoField.uint16("xcmp.fileaccess.xfertype", "Transfer Type", base.DEC)
local f_fileaccess_partitionid = ProtoField.uint8("xcmp.fileaccess.partitionid", "Partition ID", base.DEC)
local f_fileaccess_optionflag = ProtoField.uint32("xcmp.fileaccess.optionflag", "Option Flag", base.HEX)
local f_fileaccess_filesize = ProtoField.uint32("xcmp.fileaccess.filesize", "File Size", base.DEC)
local f_fileaccess_fileoffset = ProtoField.uint32("xcmp.fileaccess.fileoffset", "File Offset", base.DEC)
local f_fileaccess_pathlen = ProtoField.uint16("xcmp.fileaccess.pathlen", "Path Length", base.DEC)
local f_fileaccess_path = ProtoField.stringz("xcmp.fileaccess.path", "Path", base.ASCII)
local f_codeplugpassword_function = ProtoField.uint8("xcmp.codeplugpassword.function", "Function", base.DEC, codeplugpassword_functions)
local f_codeplugpassword_policy = ProtoField.uint8("xcmp.codeplugpassword.policy", "Policy", base.DEC)
local f_codeplugpassword_algid = ProtoField.uint16("xcmp.codeplugpassword.algid", "Algorithm ID", base.DEC)
local f_codeplugpassword_saltlen = ProtoField.uint8("xcmp.codeplugpassword.saltlen", "Salt Length", base.DEC)
local f_codeplugpassword_salt = ProtoField.bytes("xcmp.codeplugpassword.salt", "Salt")
local f_codeplugpassword_islocked = ProtoField.bool("xcmp.codeplugpassword.islocked", "Is Locked")
local f_codeplugpassword_remaining = ProtoField.uint8("xcmp.codeplugpassword.remaining", "Remaining Attempts", base.DEC)


proto.fields = {
-- Multiple
  f_opcode,
  f_len,
  f_result,
  f_address_type,
  f_address_mototrbo,
-- 0x_0__
  f_rstatus_result,
  f_rstatus_condition,
  f_rstatus_status,
  f_verinfo_target,
  f_verinfo_version,
  f_modelnum_op,
  f_modelnum_data,
  f_sernum_op,
  f_sernum_data,
  f_uuid_data,
  f_langpkinfo_target,
  f_langpkinfo_avail,
  f_langpkinfo_count,
  f_langpkinfo_entry,
  f_langpkinfo_entry_len,
  f_bundle_count,
  f_codeplugattr_op,
  f_codeplugattr_type,
  f_codeplugattr_data_len,
  f_codeplugattr_data,
-- 0x_1__
  f_ish_part,
  f_ish_type,
  f_ish_id,
  f_ish_req_len,
  f_ish_offset,
  f_ish_ret_len,
  f_ish_tot_len,
  f_ish_value,
  f_readishidset_entry,
  f_readishtypeset_entry,
-- 0x_4__
  f_devinitsts_major,
  f_devinitsts_minor,
  f_devinitsts_patch,
  f_devinitsts_product,
  f_devinitsts_init,
  f_devinitsts_type,
  f_devinitsts_status,
  f_devinitsts_attrlen,
  f_devinitsts_attr,
  f_devinitsts_attr_key,
  f_devinitsts_attr_value,
  f_chznsel_function,
  f_chznsel_zone,
  f_chznsel_position,
  f_scan_function,
  f_rrctrl_feature,
  f_rrctrl_operation,
  f_rrctrl_status,
  f_rrctrl_address,
  f_callctrl_function,
  f_callctrl_calltype,
  f_callctrl_address,
  f_callctrl_group,
  f_fileaccess_xfertype,
  f_fileaccess_partitionid,
  f_fileaccess_optionflag,
  f_fileaccess_filesize,
  f_fileaccess_fileoffset,
  f_fileaccess_pathlen,
  f_fileaccess_path,
  f_codeplugpassword_function,
  f_codeplugpassword_policy,
  f_codeplugpassword_algid,
  f_codeplugpassword_saltlen,
  f_codeplugpassword_salt,
  f_codeplugpassword_islocked,
  f_codeplugpassword_remaining,
}

-- dofile("xnl.luainc") -- uncomment to fix dependency order
local xnl_opcode = Field.new("xnl.opcode")
local xnl_transaction = Field.new("xnl.transaction")

function dissect_address(root, field, buf)
  local type = buf(0, 1):uint()
  local size = buf(1, 1):uint()
  local tree = root:add(field, buf(0, 2 + size))
  tree:add(f_address_type, buf(0, 1))
  if type == 1 then
    tree:add(f_address_mototrbo, buf(2, size))
  end
  return buf(2 + size)
end

function proto.init()
  DissectorTable.get("xnl.proto"):add(1, proto)
end

local function describe_opcode(opcode)
  if opcodes[opcode] then
    return opcodes[opcode]
  end

  if (opcode & 0x8000) ~= 0 then
    return "UNK_RES:" .. string.format("0x%x", opcode)
  elseif (opcode & 0xb000) ~= 0 then
    return "UNK_BRDCST:" .. string.format("0x%x", opcode)
  end

  return "UNK_REQ:" .. string.format("0x%x", opcode)
end

local function dissect_xcmp_message(buf, pkt, tree)
  local opcode = buf(0, 2):uint()
  tree:add(f_opcode, buf(0, 2))
  local desc = describe_opcode(opcode) .. " Transaction=" .. xnl_transaction().value

  if opcode == 0x000e then -- RSTATUS
    tree:add(f_rstatus_condition, buf(2, 1))
    desc = desc .. " Condition=" .. buf(2, 1):uint()
  elseif opcode == 0x800e then -- RSTATUS_RES
    local rstatus_result = buf(2, 1):uint()
    tree:add(f_rstatus_result, buf(2, 1))
    if rstatus_result == 0 then
      tree:add(f_rstatus_condition, buf(3, 1))
      tree:add(f_rstatus_status, buf(4, buf:len() - 4))
      desc = desc .. " Condition=" .. buf(3, 1):uint()
    end
  elseif opcode == 0x000f then -- VERINFO
    tree:add(f_verinfo_target, buf(2, 1))
  elseif opcode == 0x800f then -- VERINFO_RES
    tree:add(f_verinfo_version, buf(3, buf:len() - 3))
  elseif opcode == 0x0010 then -- RWMODELNUM
    tree:add(f_modelnum_op, buf(2, 1))
  elseif opcode == 0x8010 then -- RWMODELNUM_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_modelnum_data, buf(3, buf:len() - 3))
  elseif opcode == 0x0011 then -- SERNUMOP
    tree:add(f_sernum_op, buf(2, 1))
  elseif opcode == 0x8011 then -- SERNUMOP_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_sernum_data, buf(3, buf:len() - 3))
  elseif opcode == 0x8012 then -- READUUID_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_uuid_data, buf(3, buf:len() - 3))
  elseif opcode == 0x002c then -- LANGPKINFO
    tree:add(f_langpkinfo_target, buf(2, 1))
  elseif opcode == 0x802c then -- LANGPKINFO_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_langpkinfo_avail, buf(3, 4))
    tree:add(f_langpkinfo_count, buf(7, 1))
    local count = buf(7, 1):uint()
    local offset = 8
    for index = 1, count do
      local entry_len = buf(offset, 1):uint()
      tree:add(f_langpkinfo_entry_len, buf(offset, 1))
      tree:add(f_langpkinfo_entry, buf(offset+1, entry_len-1))
      offset = offset + entry_len
    end
  elseif opcode == 0x002e then -- SUPERBUNDLE
    local bundle_count = buf(2, 1):uint()
    tree:add(f_bundle_count, buf(2, 1))
    local offset = 4

    for index = 1, bundle_count do
      if offset + 2 > buf:len() then
        break
      end

      local child_len = buf(offset, 2):uint()
      local child_offset = offset + 2

      if child_len < 2 or child_offset + child_len > buf:len() then
        break
      end

      local bundle_tree = tree:add(proto, buf(offset, child_len + 2))
      bundle_tree:add(f_len, buf(offset, 2))
      local child_buf = buf(child_offset, child_len)
      local child_tree = bundle_tree:add(proto, child_buf)
      local child_desc = dissect_xcmp_message(child_buf, pkt, child_tree)

      bundle_tree:set_text(string.format("Bundle Message %d", index))
      child_tree:set_text(child_desc)
      offset = child_offset + child_len
    end
  elseif opcode == 0x802e then -- SUPERBUNDLE_RES
    local bundle_count = buf(3, 1):uint()
    tree:add(f_bundle_count, buf(3, 1))
    local offset = 4

    for index = 1, bundle_count do
      if offset + 2 > buf:len() then
        break
      end

      local child_len = buf(offset, 2):uint()
      local child_offset = offset + 2

      if child_len < 2 or child_offset + child_len > buf:len() then
        break
      end

      local bundle_tree = tree:add(proto, buf(offset, child_len + 2))
      bundle_tree:add(f_len, buf(offset, 2))
      local child_buf = buf(child_offset, child_len)
      local child_tree = bundle_tree:add(proto, child_buf)
      local child_desc = dissect_xcmp_message(child_buf, pkt, child_tree)

      bundle_tree:set_text(string.format("Bundle Message %d", index))
      child_tree:set_text(child_desc)
      offset = child_offset + child_len
    end
  elseif opcode == 0x0037 then -- CODEPLUGATTR
    tree:add(f_codeplugattr_op, buf(2, 1))
    tree:add(f_codeplugattr_type, buf(3, 1))
    tree:add(f_codeplugattr_data_len, buf(4, 1))
  elseif opcode == 0x8037 then -- CODEPLUGATTR_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_codeplugattr_op, buf(3, 1))
    tree:add(f_codeplugattr_type, buf(4, 1))
    tree:add(f_codeplugattr_data_len, buf(5, 1))
    local data_len = buf(5, 1):uint()
    if data_len > 0 then
      tree:add(f_codeplugattr_data, buf(6, data_len))
    end
  elseif opcode == 0x0100 then -- READISHITEM
    tree:add(f_ish_part, buf(2, 1))
    tree:add(f_ish_type, buf(3, 2))
    tree:add(f_ish_id, buf(5, 2))
    tree:add(f_ish_req_len, buf(7, 2))
    tree:add(f_ish_offset, buf(9, 2))
    desc = desc .. " Part/Type/Id=" .. "0x" .. buf(2, 5):bytes():tohex()
  elseif opcode == 0x8100 then -- READISHITEM_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_ish_part, buf(3, 1))
    tree:add(f_ish_type, buf(4, 2))
    tree:add(f_ish_id, buf(6, 2))
    tree:add(f_ish_ret_len, buf(8, 2))
    local ret_len = buf(8, 2):uint()
    tree:add(f_ish_offset, buf(10, 2))
    tree:add(f_ish_tot_len, buf(12, 2))
    if ret_len > 0 then
      tree:add(f_ish_value, buf(14, ret_len))
    end
    desc = desc .. " Part/Type/Id=" .. "0x" .. buf(3, 5):bytes():tohex()
  elseif opcode == 0x0104 then -- READISHIDSET
    tree:add(f_ish_part, buf(2, 1))
    tree:add(f_ish_type, buf(3, 2))
    tree:add(f_ish_req_len, buf(5, 2))
    tree:add(f_ish_offset, buf(7, 2))
    desc = desc .. " Part/Type=" .. "0x" .. buf(2, 3):bytes():tohex()
  elseif opcode == 0x8104 then -- READISHIDSET_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_ish_part, buf(3, 1))
    tree:add(f_ish_type, buf(4, 2))
    tree:add(f_ish_ret_len, buf(6, 2))
    local ret_cnt = buf(6, 2):uint()
    tree:add(f_ish_offset, buf(8, 2))
    tree:add(f_ish_tot_len, buf(10, 2))
    desc = desc .. " Part/Type=" .. "0x" .. buf(3, 3):bytes():tohex()
    for index = 1, ret_cnt do
      local offset = 12 + (index - 1) * 2
      if offset + 2 > buf:len() then
        break
      end
      tree:add(f_readishidset_entry, buf(offset, 2))
    end
  elseif opcode == 0x0105 then -- READISHTYPESET
    tree:add(f_ish_part, buf(2, 1))
    tree:add(f_ish_req_len, buf(3, 2))
    tree:add(f_ish_offset, buf(5, 2))
    desc = desc .. " Part=" .. "0x" .. buf(2, 1):bytes():tohex()
  elseif opcode == 0x8105 then -- READISHTYPESET_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_ish_part, buf(3, 1))
    desc = desc .. " Part=" .. "0x" .. buf(3, 1):bytes():tohex()
    local ret_cnt = buf(4, 2):uint()
    tree:add(f_ish_ret_len, buf(4, 2))
    tree:add(f_ish_offset, buf(6, 2))
    tree:add(f_ish_tot_len, buf(8, 2))
    for index = 1, ret_cnt do
      local offset = 10 + (index - 1) * 2
      if offset + 2 > buf:len() then
        break
      end
      tree:add(f_readishtypeset_entry, buf(offset, 2))
    end
  elseif opcode == 0xb400 then -- DEVINITSTS_BRDCST
    tree:add(f_devinitsts_major, buf(2, 1))
    tree:add(f_devinitsts_minor, buf(3, 1))
    tree:add(f_devinitsts_patch, buf(4, 1))
    tree:add(f_devinitsts_product, buf(5, 1))
    local devinitsts_init = buf(6, 1):uint()
    tree:add(f_devinitsts_init, buf(6, 1))
    desc = desc .. " Init=" .. (devinitsts_inits[devinitsts_init] or devinitsts_init)
    if devinitsts_init ~= 1 then
      tree:add(f_devinitsts_type, buf(7, 1))
      tree:add(f_devinitsts_status, buf(8, 2))
      local attrlen = buf(10, 1):uint()
      tree:add(f_devinitsts_attrlen, buf(10, 1))
      for i = 0, (attrlen - 1), 2 do
        local attr_tree = tree:add(f_devinitsts_attr, buf(11 + i, 2))
        local attr_key = buf(11 + i, 1):uint()
        attr_tree:add(f_devinitsts_attr_key, buf(11 + i, 1))
        local attr_value = buf(11 + i + 1, 1):uint()
        attr_tree:add(f_devinitsts_attr_value, buf(11 + i + 1, 1))
        if devinitsts_attrs[attr_key] then
          attr_tree:set_text(string.format("%s: 0x%02x", devinitsts_attrs[attr_key], attr_value))
        end
      end
    end
  elseif opcode == 0x040d then -- CHZNSEL
    tree:add(f_chznsel_function, buf(2, 1))
    tree:add(f_chznsel_zone, buf(3, 2))
    tree:add(f_chznsel_position, buf(5, 2))
  elseif opcode == 0x040f then -- SCAN
    tree:add(f_scan_function, buf(2, 1))
  elseif opcode == 0x041c or opcode == 0xb41c then -- RRCTRL
    tree:add(f_rrctrl_feature, buf(2, 1))
    tree:add(opcode == 0x041c and f_rrctrl_operation or f_rrctrl_status, buf(3, 1))
    buf = dissect_address(tree, f_rrctrl_address, buf(4))
  elseif opcode == 0x041e then -- CALLCTRL
    tree:add(f_callctrl_function, buf(2, 1))
    tree:add(f_callctrl_calltype, buf(3, 1))
    buf = dissect_address(tree, f_callctrl_address, buf(4))
    if buf:len() > 0 then
      tree:add(f_callctrl_group, buf)
    end
  elseif opcode & 0x0fff == 0x0445 then -- FILEACCESS
    local offset = 2
    if opcode == 0x8445 then
      tree:add(f_result, buf(offset, 1))
      offset = offset + 1
    end
    tree:add(f_fileaccess_xfertype, buf(offset, 2))
    tree:add(f_fileaccess_partitionid, buf(offset + 2, 1))
    tree:add(f_fileaccess_optionflag, buf(offset + 3, 4))
    tree:add(f_fileaccess_filesize, buf(offset + 7, 4))
    tree:add(f_fileaccess_fileoffset, buf(offset + 11, 4))
    tree:add(f_fileaccess_pathlen, buf(offset + 15, 2))
    local pathlen = buf(offset + 15, 2):uint()
    tree:add(f_fileaccess_path, buf(offset + 17, pathlen))
  elseif opcode == 0x0467 then -- CODEPLUGPASSWORD
    tree:add(f_codeplugpassword_function, buf(2, 1))
  elseif opcode == 0x8467 then -- CODEPLUGPASSWORD_RES
    tree:add(f_result, buf(2, 1))
    tree:add(f_codeplugpassword_function, buf(3, 1))
    local func = buf(3, 1):uint()
    if func == 0 then -- Request Status
      tree:add(f_codeplugpassword_policy, buf(4, 1))
      tree:add(f_codeplugpassword_algid, buf(5, 2))
      tree:add(f_codeplugpassword_saltlen, buf(7, 1))
      local saltlen = buf(7, 1):uint()
      local offset = 8
      if saltlen > 0 then
        tree:add(f_codeplugpassword_salt, buf(offset, saltlen))
        offset = offset + saltlen
      end
      tree:add(f_codeplugpassword_islocked, buf(offset, 1))
      tree:add(f_codeplugpassword_remaining, buf(offset + 1, 1))
    end
  end

  return desc
end

function proto.dissector(buf, pkt, root)
  -- DATA_MSG_ACK
  if xnl_opcode().value == 12 and buf:len() == 0 then
    return
  end

  local tree = root:add(proto, buf(0, buf:len()))
  local desc = dissect_xcmp_message(buf, pkt, tree)

  pkt.cols.protocol:set("XCMP")
  pkt.cols.info:set(desc)
end
