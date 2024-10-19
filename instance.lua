--Make a table for all the games and determine which table/programs functions to use based on appid?

local utils = require "utils"
local config = require "config"
local zomboid = require "instances.zomboid.zomboid"

local instance = {}


local function genConfig(table)
return "lconfig = " .. utils.tableToString(table, "  ") .. "\nreturn lconfig"
end

local function genInstanceInfo(table)
  return "iinfo = " .. utils.tableToString(table, "  ") .. "\n return iinfo"
end

local function genFlags(prefix, input)
  local output = ""
  for key,_ in pairs(prefix) do
    if input[key] ~= "" and type(input[key]) == 'string' then
      output = output .. string.format(prefix[key], input[key])
    else
      print("[?]Config Missing Property: " .. key .. "\n")
    end
  end
  return output
end

local function writeConfig(instance_dir, lstring)
  return [[cat << 'EOF' > ]] .. instance_dir .. [[lconfig.lua]] .. "\n" .. lstring .. "\n" .. [[EOF]]
end

local function writeInstanceInfo(instance_dir, lstring)
  return [[cat << 'EOF' > ]] .. instance_dir .. [[/iinfo.lua]] .. "\n" .. lstring .. "\n" .. [[EOF]] .. "\n"
end

function instance.call(command, inputs)
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

  --A help message to guide the user
  local function help(server_name, version_name, instance_name)
    return {
      output = "",
      success = false,
      msg = instance_help
    }
  end

  --Creates a new instance
  local function add(server_name, version_name, instance_name)
    local info_path = config.server_dir .. server_name .. "/server-versions/" .. version_name .. "/version.info"
    local instance_info = {
      appid = "108600",
      vname = "v1",
      iname = tostring(instance_name),
    }
    local instance_dir = "" .. config.server_dir .. server_name .. "/instances/" .. instance_name
    local script_mkdir = "mkdir -p " .. instance_dir 
    local script_mkinfo = writeInstanceInfo(instance_dir, genInstanceInfo(instance_info))

    package.path = ";" .. config.server_dir .. server_name .. "/?.lua"
    local sinfo = require "sinfo"
    local script_cp_config = "cp ./instances/" .. sinfo.name .. "/default.lua " .. instance_dir .. "/lconfig.lua"

    local instance_specific = zomboid.add(instance_dir)

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
      output = script_mkdir .. ";" .. script_mkinfo .. script_cp_config .. ";" .. instance_specific,
      success = true,
      msg = ""
    }
  end

  --Sets the config values based on input
  local function set(server_name, version_name, instance_name)
    local instance_dir = "" .. config.server_dir .. server_name .. "/instances/" .. instance_name

    package.path = ";" .. instance_dir .. "/?.lua"
    local lconfig = require "lconfig"
    
    return {
      output = "",
      success = true,
      msg = tostring(lconfig.name)
    }
  end

  --Deletes the instance and all data
  local function del()
  end

  --Starts the instance based on the config
  local function start()

  end

  --Stops the instance
  local function stop()
  end


  if command == "add" then
    local server_name = inputs[1]
    local version_name = inputs[2]
    local instance_name = inputs[3]
    return add(server_name, version_name, instance_name)
  elseif command == "del" then
    return del()
  elseif command == "start" then
    return start()
  elseif command == "stop" then
    return stop()
  elseif command == "set" then
    local server_name = inputs[1]
    local version_name = inputs[2]
    local instance_name = inputs[3]
    return set(server_name, version_name, instance_name)
  else
    return help()
  end
end

return instance
