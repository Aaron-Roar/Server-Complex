lconfig = {
  ShellFlags = {
    name = "Aaron",
    modfolders = "",
    adminpass = "",
    steamvac = "",
    port = "123456",
    cachedir = "",
    udpport = "",
  },
  JavaFlags = {
    debug = "",
    mem_min = "2048",
    mem_max = "2048",
    steam = "200",
    std = "-Djava.awt.headless=true -XX:+UseZGC -Dzomboid.znetlog=1 -Djava.library.path=linux64/:./ -XX:-OmitStackTraceInFastThrow -Djava.security.egd=file:/dev/urandom",
  },
}
return lconfig
