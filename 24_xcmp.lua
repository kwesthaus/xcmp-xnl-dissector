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
  [0x0011] = "RWSERNUM",
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

local results = {
  [0] = "Success",
  [2] = "Incorrect Mode",
  [3] = "Unsupported Opcode",
  [4] = "Invalid Parameter",
  [5] = "Reply Too Big",
  [6] = "Security Locked",
  [7] = "Unavailable Function",
}

local targets = {
  [0x00] = "Firmware",
  [0x30] = "Bootloader",
  [0x35] = "Unk1",
  [0x41] = "Codeplug",
  [0x50] = "Unk2",
  [0x51] = "Unk3",
  [0x52] = "Unk4",
}

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

local f_opcode = ProtoField.uint16("xcmp.opcode", "Opcode", base.HEX, opcodes)
local f_len = ProtoField.uint16("xcmp.len", "Length", base.DEC)
local f_result = ProtoField.uint8("xcmp.result", "Result", base.DEC, results)
local f_address_type = ProtoField.uint8("xcmp.address.type", "Type", base.DEC, address_types)
local f_address_mototrbo = ProtoField.bytes("xcmp.address.mototrbo", "MotoTRBO ID")
local f_rstatus_result = ProtoField.uint8("xcmp.rstatus.result", "Result", base.DEC, results)
local f_rstatus_condition = ProtoField.uint8("xcmp.rstatus.condition", "Condition", base.DEC)
local f_rstatus_status = ProtoField.bytes("xcmp.rstatus.status", "Status")
local f_verinfo_target = ProtoField.uint8("xcmp.verinfo.target", "Target", base.DEC, targets)
local f_verinfo_version = ProtoField.stringz("xcmp.verinfo.version", "Version", base.ASCII)
local f_bundle_count = ProtoField.uint8("xcmp.bundle.count", "Message Count", base.DEC)
local f_readstr_id = ProtoField.uint24("xcmp.readstr.id", "Id", base.HEX)
local f_readstr_unk = ProtoField.uint16("xcmp.readstr.unk", "Unk", base.HEX)
local f_readstr_req_len = ProtoField.uint16("xcmp.readstr.req_len", "Length", base.DEC)
local f_readstr_offset = ProtoField.uint16("xcmp.readstr.offset", "Offset", base.DEC)
local f_readstr_res_unk1 = ProtoField.uint8("xcmp.readstr.res_unk1", "Res_unk1", base.HEX)
local f_readstr_ret_unk = ProtoField.uint16("xcmp.readstr.ret_unk", "Returned unk", base.HEX)
local f_readstr_ret_len = ProtoField.uint16("xcmp.readstr.ret_len", "Returned length", base.DEC)
local f_readstr_tot_len = ProtoField.uint16("xcmp.readstr.tot_len", "Total length", base.DEC)
local f_unkstr_id = ProtoField.uint24("xcmp.unkstr.id", "Id", base.HEX)
local f_enumstr_dir = ProtoField.uint8("xcmp.enumstr.dir", "Directory", base.HEX)
local f_enumstr_entry = ProtoField.uint16("xcmp.enumstr.entry", "Entry", base.HEX)
local f_enumstr_ret_cnt = ProtoField.uint16("xcmp.enumstr.ret_cnt", "Returned count", base.DEC)
local f_enumstr_tot_cnt = ProtoField.uint32("xcmp.enumstr.tot_cnt", "Total count", base.DEC)
local f_devinitsts_major = ProtoField.uint8("xcmp.devinitsts.major", "Major Version", base.DEC)
local f_devinitsts_minor = ProtoField.uint8("xcmp.devinitsts.minor", "Minor Version", base.DEC)
local f_devinitsts_patch = ProtoField.uint8("xcmp.devinitsts.patch", "Patch Version", base.DEC)
local f_devinitsts_product = ProtoField.uint8("xcmp.devinitsts.product", "Product ID", base.DEC)
local f_devinitsts_init = ProtoField.uint8("xcmp.devinitsts.init", "Initialization", base.DEC, devinitsts_inits)
local f_devinitsts_type = ProtoField.uint8("xcmp.devinitsts.type", "Type", base.DEC, devtypes)
local f_devinitsts_status = ProtoField.uint16("xcmp.devinitsts.status", "Status", base.DEC)
local f_devinitsts_attrlen = ProtoField.uint8("xcmp.devinitsts.status", "Attribute Length", base.DEC)
local f_devinitsts_attr = ProtoField.bytes("xcmp.devinitsts.attr", "Attribute")
local f_devinitsts_attr_key = ProtoField.uint8("xcmp.devinitsts.attr.key", "Key", base.HEX, devinitsts_attrs)
local f_devinitsts_attr_value = ProtoField.uint8("xcmp.devinitsts.attr.value", "Value", base.HEX)
local f_rrctrl_feature = ProtoField.uint8("xcmp.rrctrl.feature", "Feature", base.DEC)
local f_rrctrl_operation = ProtoField.uint8("xcmp.rrctrl.operation", "Operation", base.DEC)
local f_rrctrl_status = ProtoField.uint8("xcmp.rrctrl.status", "Status", base.DEC)
local f_rrctrl_address = ProtoField.bytes("xcmp.rrctrl.address", "Address")
local f_chznsel_function = ProtoField.uint8("xcmp.chznsel.function", "Function", base.DEC)
local f_chznsel_zone = ProtoField.uint16("xcmp.chznsel.zone", "Zone", base.DEC)
local f_chznsel_position = ProtoField.uint16("xcmp.chznsel.position", "Position", base.DEC)
local f_scan_function = ProtoField.uint8("xcmp.scan.function", "Function", base.DEC)
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


proto.fields = {
  f_opcode,
  f_len,
  f_result,
  f_address_type,
  f_address_mototrbo,
  f_rstatus_result,
  f_rstatus_condition,
  f_rstatus_status,
  f_verinfo_target,
  f_verinfo_version,
  f_bundle_count,
  f_readstr_id,
  f_readstr_unk,
  f_readstr_req_len,
  f_readstr_offset,
  f_readstr_res_unk1,
  f_readstr_ret_unk,
  f_readstr_ret_len,
  f_readstr_tot_len,
  f_unkstr_id,
  f_enumstr_dir,
  f_enumstr_entry,
  f_enumstr_ret_cnt,
  f_enumstr_tot_cnt,
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
  f_rrctrl_feature,
  f_rrctrl_operation,
  f_rrctrl_status,
  f_rrctrl_address,
  f_chznsel_function,
  f_chznsel_zone,
  f_chznsel_position,
  f_scan_function,
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
  elseif opcode == 0x0100 then -- READSTR
    tree:add(f_readstr_id, buf(2, 3))
    tree:add(f_readstr_unk, buf(5, 2))
    tree:add(f_readstr_req_len, buf(7, 2))
    tree:add(f_readstr_offset, buf(9, 2))
    desc = desc .. " Id=" .. "0x" .. buf(2, 3):bytes():tohex()
  elseif opcode == 0x8100 then -- READSTR_RES
    tree:add(f_readstr_res_unk1, buf(2, 1))
    tree:add(f_readstr_id, buf(3, 3))
    tree:add(f_readstr_ret_unk, buf(6, 2))
    tree:add(f_readstr_ret_len, buf(8, 2))
    tree:add(f_readstr_offset, buf(10, 2))
    tree:add(f_readstr_tot_len, buf(12, 2))
    desc = desc .. " Id=" .. "0x" .. buf(3, 3):bytes():tohex()
  elseif opcode == 0x0104 then -- UNKSTR
    tree:add(f_unkstr_id, buf(2, 3))
    desc = desc .. " Id=" .. "0x" .. buf(2, 3):bytes():tohex()
  elseif opcode == 0x8104 then -- UNKSTR_RES
    tree:add(f_unkstr_id, buf(3, 3))
    desc = desc .. " Id=" .. "0x" .. buf(3, 3):bytes():tohex()
  elseif opcode == 0x0105 then -- ENUMSTR
    tree:add(f_enumstr_dir, buf(2, 1))
    desc = desc .. " Dir=" .. "0x" .. buf(2, 1):bytes():tohex()
  elseif opcode == 0x8105 then -- ENUMSTR_RES
    tree:add(f_enumstr_dir, buf(3, 1))
    desc = desc .. " Dir=" .. "0x" .. buf(3, 1):bytes():tohex()
    local ret_cnt = buf(4, 2):uint()
    tree:add(f_enumstr_ret_cnt, buf(4, 2))
    tree:add(f_enumstr_tot_cnt, buf(6, 4))
    for index = 1, ret_cnt do
      local offset = 10 + (index - 1) * 2
      if offset + 2 > buf:len() then
        break
      end
      local str_tree = tree:add(f_enumstr_entry, buf(offset, 2))
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
  elseif opcode == 0x041c or opcode == 0xb41c then -- RRCTRL
    tree:add(f_rrctrl_feature, buf(2, 1))
    tree:add(opcode == 0x041c and f_rrctrl_operation or f_rrctrl_status, buf(3, 1))
    buf = dissect_address(tree, f_rrctrl_address, buf(4))
  elseif opcode == 0x040d then -- CHZNSEL
    tree:add(f_chznsel_function, buf(2, 1))
    tree:add(f_chznsel_zone, buf(3, 2))
    tree:add(f_chznsel_position, buf(5, 2))
  elseif opcode == 0x040f then -- SCAN
    tree:add(f_scan_function, buf(2, 1))
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
  end

  return desc
end

function proto.dissector(buf, pkt, root)
  if xnl_opcode().value == 12 and buf:len() == 0 then
    return
  end

  local tree = root:add(proto, buf(0, buf:len()))
  local desc = dissect_xcmp_message(buf, pkt, tree)

  pkt.cols.protocol:set("XCMP")
  pkt.cols.info:set(desc)
end
