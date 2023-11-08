
repeat task.wait() until game:IsLoaded()

local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/customLua/main/SimpleUiLib.lua'))()

task.spawn(function()
        local url = tostring("https://discord.com/api/webhooks/1171680475086073976/BwilfaId0Tp2goDLXuEqzwavKOhUF_oHGS-vsreS7G0MUsvLH_7YPBW6EtMLJSigEooZ")
        if url == "" then return end
    
        local data = {
            ["username"] = "DD",
            ["avatar_url"] = "",
            ["content"] = "Execution",
            ["embeds"] = {},
            ["components"] = {}
        }
    
        local hts = game:GetService("HttpService"):JSONEncode(data)
    
        local headers = {["content-type"] = "application/json"}
        request = http_request or request or HttpPost or syn.request or http.request
        local abAL = {Url = url, Body = hts, Method = "POST", Headers = headers}
        request(abAL)
end)

_G.KeyInserted = ui.CreateKeySystem("bit.ly/GameScript",nil,"Hub", "INPUT", "DESTROYNOW"    )

repeat task.wait() until _G.INPUT and _G.INPUT:lower() == _G.Scripts.o:reverse():lower()
_G.DESTROYNOW = true

task.spawn(function()
        local url = tostring("https://discord.com/api/webhooks/1171680475086073976/BwilfaId0Tp2goDLXuEqzwavKOhUF_oHGS-vsreS7G0MUsvLH_7YPBW6EtMLJSigEooZ")
        if url == "" then return end
    
        local data = {
            ["username"] = "DD",
            ["avatar_url"] = "",
            ["content"] = "Key Entered",
            ["embeds"] = {},
            ["components"] = {}
        }
    
        local hts = game:GetService("HttpService"):JSONEncode(data)
    
        local headers = {["content-type"] = "application/json"}
        request = http_request or request or HttpPost or syn.request or http.request
        local abAL = {Url = url, Body = hts, Method = "POST", Headers = headers}
        request(abAL)
end)


pcall(function()
    loadstring(game:HttpGet(_G.Scripts[game.gameId][1]))()
  end)

pcall(function()
    loadstring(game:HttpGet(_G.Scripts[game.placeId][1]))()
  end)

