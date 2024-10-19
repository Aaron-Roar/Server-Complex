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
  input = {},
}

local function popList(pop_amount, in_list)
  local out_list = {}
  for i=pop_amount + 1,#in_list do
    table.insert(out_list, in_list[i])
  end
  return out_list
end

local function main()
  local result
  Arguments.type = arg[1]
  Arguments.command = arg[2]

  local list = popList(2, arg)

  if Arguments.type == "server" then
    result = server.call(Arguments.command, list)
  elseif Arguments.type == "version" then
    result = version.call(Arguments.command, list)
  elseif Arguments.type == "instance" then
    result = instance.call(Arguments.command, list)
  else
    Arguments.type = "help"
    result = main_help()
  end

  ----------------------------------------------------------------------------------------

  if result.success then
    os.execute("cat <<'ABCDEFG'\n" .. tostring(result.output) .. "\nABCDEFG")
    --os.execute(tostring(result.output))
  else
    print(result.msg)
  end
end

main()
