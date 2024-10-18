-- Test instance/zomboid.lua
--
--"projectzomboid.sh", open that file and edit the line:
--GAMEDIR="${HOME}/Zomboid"


local utils = require "utils"
local config = require "config"
local server = require "server"
local version = require "version"
local instance = require "instance"

local msg_help = [[
Help Message

---Server---
  server add <server name>
  server del <server name>
  server help

    Example:
      Server add valheim

---version---
  version add <server name> <version name> <app_id>
  version del <server name> <version name>
  version help

    Example:
      version add valheim BN-15676529 896660

---instance---
  instance add <server name> <instance name> <version name>
  instance del <server name> <instance name> <version name>
  instance start <server name> <instance name>
  instance stop <server name> <instance name>
  instance help

    Example:
      instance add valheim modded-pvp-friendly BN-15676529

  ---Help---
  help

    Example:
      help
]]

local function main_help()
  return {
    output = "",
    success = false,
    msg = msg_help
  }
end


Arguments = {
  type = "",
  command = "",
  server_name = "",
  version_name = "",
  instance_name = "",
  appid = "",
  help = ""
}

local function main()
  Arguments.type = arg[1]
  Arguments.command = arg[2]
  local result

  if Arguments.type == "server" then
    Arguments.server_name = arg[3]
    result = server.call(Arguments.command, Arguments.server_name)
  elseif Arguments.type == "version" then
    Arguments.server_name = arg[3]
    Arguments.version_name = arg[4]
    Arguments.appid = arg[5]
    result = version.call(Arguments.command, Arguments.server_name, Arguments.version_name, Arguments.appid)
  elseif Arguments.type == "instance" then
    Arguments.instance_name = arg[3]
    Arguments.server_name = arg[4]
    Arguments.version_name = arg[5]
    result = instance.call(Arguments.command, Arguments.instance_name, Arguments.server_name, Arguments.version_name)
  else
    Arguments.type = "help"
    result = main_help()
  end

  ----------------------------------------------------------------------------------------

  if result.success then
    --os.execute("cat <<'EOF'\n" .. tostring(result.output) .. "\nEOF")
    os.execute(tostring(result.output))
  else
    print(result.msg)
  end
end

main()
