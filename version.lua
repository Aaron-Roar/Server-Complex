local utils = require "utils"
local config = require "config"

local version = {}

function version.call(command, server_name, version_name, appid)
  --Variables
  local version_help = [[
  Version help message

  ---Add---
  version add <server name> <version name> <app_id>

  ---Delete---
  version del <server name> <verison name>

  ---Help---
  version help
  ]]
  --

  local function help(game, version_name, appid)
    return {
      output = "",
      success = false,
      msg = version_help
    }
  end

  local function add(game, version_name, appid)
    local path = "" .. tostring(config.server_dir) .. tostring(game) .. "/server-versions/" .. tostring(version_name) .. "/"
    local script_mkdir = "mkdir -p " .. path .. "version-files/"
    local info = [[appid:"]] .. tostring(appid) .. [[";version:"]] .. version_name .. [["]]
    local script_info = "touch " .. path .. [[version.info; echo ']] .. info .. [[' >> ]] .. path .. "version.info"
    local script_steamcmd = "steamcmd +force_install_dir " .. path .. "version-files/" .. " +login " .. tostring(config.uname) .. " " .. tostring(config.passwd) .. " +app_update " .. tostring(appid) .. " validate +quit"

    --FIX BELOW
    -----------------------
    local script_server_name = "" --"echo " .. utils.getGameName(appid)

    if game == nil or game == "" or version_name == nil or version_name == "" or appid == nil or appid == "" then
      return {
        output = "",
        success = false,
        msg = "[!]You must provide a <server name> and <version name> and <appdi>"
      }
    end

    if utils.pathExists(path) then
      return {
        output = "",
        success = false,
        msg = "[!]Already Installed"
      }
    else
      return {
        output = "" .. script_mkdir .. ";".. script_info .. ";" .. script_steamcmd .. ";" .. script_server_name,
        success = true,
        msg = ""
      }
    end

  end

  local function del(game, version_name, appid)
    local path = "" .. tostring(config.server_dir) .. tostring(game) .. "/server-versions/" .. tostring(version_name) .. "/"
    local script_rm = "rm -rf " .. path

    if game == nil or game == "" or version_name == nil or version_name == "" then
      return {
        output = "",
        success = false,
        msg = "[!]You must provide a <server name> and <version name>"
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
        msg = "[!]The server does not exist"
      }
    else
      return {
        output = script_rm,
        success = true,
        msg = ""
      }
    end
  end

  if command == "add" then
    return add(server_name, version_name, appid)
  elseif command == "del" then
    return del(server_name, version_name)
  else
    return help()
  end
end

return version
