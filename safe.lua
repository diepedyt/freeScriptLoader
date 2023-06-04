
--moonsec down when i uploaded this :rage:

repeat task.wait() until game:IsLoaded()

local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/customLua/main/SimpleUiLib.lua'))()

_G.KeyInserted = ui.CreateKeySystem((_G.Scripts.o:reverse()):lower())

if _G.KeyInserted then
    local main = ui.CreateMain()
    for i,v in pairs(_G.Scripts) do
        if type(v) == "table" then
            local gameName = tostring(i)
            pcall(function()
                gameName = game:GetService("MarketplaceService"):GetProductInfo(i).Name
            end)
            ui.CreateSection(main, gameName)
            for i,v in pairs(v) do
                ui.CreateButton(main, i ,function() loadstring(game:HttpGet(v))() end)
            end
        end
    end
end
