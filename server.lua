local config = require "config"
local utils = require "utils"

local server = {}

local function genServerInfo(table)
  return "sinfo = " .. utils.tableToString(table, "  ") .. "\n return sinfo"
end

local function writeServerInfo(server_dir, lstring)
  return [[cat << 'EOF' > ]] .. server_dir .. [[/sinfo.lua]] .. "\n" .. lstring .. "\n" .. [[EOF]] .. "\n"
end

function server.call(command, server_name)
  ---Variables---
  local server_help = [[
  Server help message

  ---Add---
  server add <server name>

  ---Delete---
  server del <server name>

  ---Help---
  server help
  ]]

  local function add(name)
    local path = "" .. tostring(config.server_dir) .. tostring(name) .. "/"
    local script_mkdir = "mkdir -p " .. path
    local script_info = "touch " .. path .. "sinfo.lua"
    local server_info = {
      name = tostring(name),
    }
    local script_write_info = writeServerInfo(path, genServerInfo(server_info))

    if name == nil or name == "" then
      return {
        output = "",
        success = false,
        msg = "[!]You must provide a <server name>"
      }
    end

    if utils.pathExists(path) then
      return {
        output = "",
        success = false,
        msg = "[!]Game Already Set Up"
      }
    else
      return {
        output = "" .. script_mkdir .. ";" .. script_info .. ";" .. script_write_info, true, "",
        success = true,
        msg = ""
      }
    end
  end

  local function del(name)
    local path = "" .. tostring(config.server_dir) .. tostring(name)
    local script_rm = "rm -rf " .. path

    if name == nil or name == "" then
      return {
        output = "",
        success = false,
        msg = "[!]You must provide a <name>"
      }
    elseif config.server_dir == nil or config.server_dir == "" then
      return {
        output = "",
        success = false,
        msg = "[!]You must set the <server_dir> in the config"
      }
    elseif utils.pathExists(path)==false then
      return {
        output = "",
        success = false,
        msg = "[!]The game does not exist in the expected directory"
      }
    else
      return {
        output = script_rm,
        success = true,
        msg = ""
      }
    end
  end

  local function help()
    return {
      output = "",
      success = false,
      msg = server_help
    }
  end
  ---

  if command == "add" then
    return add(server_name)
  elseif command == "del" then
    return del(server_name)
  else
    return help()
  end
end

return server
