
--moonsec down when i uploaded this :rage:

repeat task.wait() until game:IsLoaded()

local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/customLua/main/SimpleUiLib.lua'))()

_G.KeyInserted = ui.CreateKeySystem("link-hub.net/977929/script",nil,"Hub", "INPUT", "DESTROYNOW"    )

repeat task.wait() until _G.INPUT == _G.Scripts.o:reverse():lower()
_G.DESTROYNOW = true

loadstring(game:HttpGet(_G.Scripts[game.GameId][1]))()

