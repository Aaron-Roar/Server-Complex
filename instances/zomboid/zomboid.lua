--https://pzwiki.net/wiki/Startup_parameters
--Most of the "configuration" code should go to general instances and not this

--Load Config
local lconfig =""-- require"lconfig"

local zomboid = {}

local zomboid_start_script = [[
#!/bin/bash

SC_FLAGS=

INSTDIR="`dirname $0`" ; cd "${INSTDIR}" ; INSTDIR="`pwd`"
JARPATH="./:./commons-compress-1.18.jar:./istack-commons-runtime.jar:./jassimp.jar:./javacord-2.0.17-shaded.jar:./javax.activation-api.jar:./jaxb-api.jar:./jaxb-runtime.jar:./lwjgl.jar:./lwjgl-natives-linux.jar:./lwjgl-glfw.jar:./lwjgl-glfw-natives-linux.jar:./lwjgl-jemalloc.jar:./lwjgl-jemalloc-natives-linux.jar:./lwjgl-opengl.jar:./lwjgl-opengl-natives-linux.jar:./lwjgl_util.jar:./sqlite-jdbc-3.27.2.1.jar:./trove-3.0.3.jar:./uncommons-maths-1.2.3.jar"

if "${INSTDIR}/jre64/bin/java" -version > /dev/null 2>&1; then
        echo "64-bit java detected"
        export PATH="${INSTDIR}/jre64/bin:$PATH"
        export LD_LIBRARY_PATH="${INSTDIR}/linux64:${INSTDIR}:${INSTDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
        JSIG="libjsig.so"
        LD_PRELOAD="${LD_PRELOAD}:${JSIG}" "${INSTDIR}/jre64/bin/java" \
                -cp "${JARPATH}"  \
                $SC_FLAGS
                zombie/network/GameServer "$@"
elif "${INSTDIR}/jre/bin/java" -client -version > /dev/null 2>&1; then
        echo "32-bit java detected"
        export PATH="${INSTDIR}/jre/bin:$PATH"
        export LD_LIBRARY_PATH="${INSTDIR}/linux32:${INSTDIR}:${INSTDIR}/jre/lib/i386:${LD_LIBRARY_PATH}"
        JSIG="libjsig.so"
        LD_PRELOAD="${LD_PRELOAD}:${JSIG}" "${INSTDIR}/jre/bin/java" -client \
                -cp "${JARPATH}"  \
                $SC_FLAGS \
                zombie/network/GameServer "$@"
else
        echo "couldn't determine 32/64 bit of java"
fi
exit 0
]]


local JavaFlags = {
  std = " %s",
  mem_max = " -Xmx%s",
  mem_min = " -Xms%s",
  steam = " -Dzomboid.steam=%s",
  home = " -Duser.home=%s"
}

local ShellFlags = {
  cachedir = " -cachedir=%s",
  modfolders = " -modfolders %s",
  adminpass = " -adminpassword %s",
  name = " -servername %s",
  port = " -port %s",
  udpport = " -udpport %s",
  steamvac = " -steamvac %s",
  debug = ""
}



--Modify Config
--print(genFlags(JavaFlags, lconfig.JavaFlags))
--print(genFlags(ShellFlags, lconfig.ShellFlags))

local myTable = {
  name = "Aaron",
  port = "123456",
  steam = "200",
}

function zomboid.add(instance_dir)
  local script_cp_config = "cp ./instances/zomboid/default.lua " .. instance_dir .. "/" .. "lconfig.lua"
  return script_cp_config
end

--local output = writeConfig("./", makeConfig(myTable, lconfig))
--os.execute(output)
--print(output)
--Update Config

return zomboid


--local serv_dir = "/home/admin/env/"
--local serv_name = "project-zomboid"
--local vers_name = "v1"
--local inst_name = "DOUGS-WORLD"
--    os.execute("cat <<'EOF'\n" .. tostring(setup_zomboid(serv_dir, serv_name, vers_name, inst_name)) .. "\nEOF")

