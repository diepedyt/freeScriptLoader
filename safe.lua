
--moonsec down when i uploaded this :rage:

repeat task.wait() until game:IsLoaded()

local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/customLua/main/SimpleUiLib.lua'))()

_G.KeyInserted = ui.CreateKeySystem("link-hub.net/977929/script",nil,"Hub", "INPUT", "DESTROYNOW"    )

repeat task.wait() until _G.INPUT == _G.Scripts.o:reverse():lower()

    local main = ui.CreateMain()

for i,v in pairs(_G.Scripts) do
        if type(v) == "table" then
            local gameName = tostring(i)
            pcall(function()
                gameName = game:GetService("MarketplaceService"):GetProductInfo(i).Name
            end)
            ui.CreateSection(main, gameName)
            for i,v in pairs(v) do
                ui.CreateButton(main, i ,function()
                        task.spawn(function()
                                            loadstring(game:HttpGet(v))()
                                end)
                                            main:Destroy()
                end)
            end
        end
    

