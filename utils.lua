
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

return utils

