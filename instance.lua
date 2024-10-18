--Make a table for all the games and determine which table/programs functions to use based on appid?

local utils = require "utils"
local config = require "config"

local instance = {}

function instance.call(command, server_name, version_name, instance_name)
  local instance_help = [[
  Instance help message

  ---Add---
  instance add <server name> <version name> <instance name> 

  ---Delete---                              
  instance del <server name> <version name> <instance name> 

  ---Start---
  instance start <server name> <instance name>

  ---Stop---
  instance stop <server name> <instance name>

  ---Help---
  instance help
  ]]
  --

  local function help(server_name, version_name, instance_name)
    return {
      output = "",
      success = false,
      msg = instance_help
    }
  end

  local function add(server_name, version_name, instance_name)
    local info_path = config.server_dir .. "/" .. server_name .. "/server-versions/" .. version_name .. "/version.info"
    local script_appid = "grep " .. info_path
    local script_mkdir = "mkdir -p " .. config.server_dir .. "/" .. server_name .. "/instances/" .. instance_name

    if server_name == nil or version_name == nil or instance_name == nil then
    return {
        output = "",
        success = false,
        msg = "[!]You must supply the <server name> <version name> and <instance name>"
      }
    end

    if utils.pathExists(config.server_dir .. server_name .. "/server-versions/" .. version_name) == false then
    return {
        output = "",
        success = false,
        msg = "The server or server version does not exist in the expected directory"
      }
    end

    return {
      output = script_mkdir,
      success = true,
      msg = ""
    }
  end

  local function del()
  end

  local function start()
  end

  local function stop()
  end


  if command == "add" then
    return add(server_name, version_name, instance_name)
  elseif command == "del" then
    return del()
  elseif command == "start" then
    return start()
  elseif command == "stop" then
    return stop()
  else
    return help()
  end
end

return instance
