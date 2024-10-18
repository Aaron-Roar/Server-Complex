
local utils = {}
-- File Checking
--
local function fileExists(path)
  if path == nil or path == "" then
    return false
  end

  local file = io.open(path, "r")

  if file then
    file:close()
    return true
  else
    return false
  end

end

local function directoryExists(path)
  if path == nil or path == "" then
    return false
  end
  return os.execute("cd " .. path .. " 2>/dev/null") == 0
end

function utils.pathExists(path)

  if fileExists(path) then
    return true

  elseif directoryExists(path) then
    return true

  else
    return false

  end

end
--
--

--Error Handling--
--
function utils.generateResult(output, success, msg)
return {
    output = output,
    success = success,
    msg = msg
  }
end

--Gets a struct of game info--
--
local function getGameInfo(appid)
  return [[steamcmd +app_info_print ]] .. tostring(appid)
  --use steamcmd and app_info_print <server_appid>
  --Outputs json
  --return all json
end

function utils.getGameName(appid)
  --Call getGameInfo
  --Return the name outof json
  return getGameInfo(appid)
end

--Turns a table into a string representaiton
function utils.tableToString(table, space)
  if type(table) == 'table' then
    local s = "" .. '{\n'
    for k,v in pairs(table) do
      if type(v) == 'table' then
        s = s .. space .. k .. " = " .. utils.tableToString(v, "" .. space .. "  ") .. ",\n"
      else
        s = s .. space .. k ..' = \"' .. utils.tableToString(v) .. '\",\n'
      end
    end
    return s .. space:gsub("  ", "", 1) ..  '}'
  else
    return tostring(table)
  end
end

--Make modifications to an existing config in memory
function utils.makeConfig(arg_table, lconf)
  for key,value in pairs(arg_table) do
    if lconf.JavaFlags[key] ~= nil then
      lconf.JavaFlags[key] = value
    end
  end

  for key,value in pairs(arg_table) do
    if lconf.ShellFlags[key] ~= nil then
      lconf.ShellFlags[key] = value
    end
  end

  return lconf
end

return utils

