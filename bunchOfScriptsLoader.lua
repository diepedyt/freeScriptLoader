
local s,f = pcall(function()

repeat task.wait() until game:IsLoaded()

_G.Scripts = {
    o = "etaMyeKyzarC",
    d = "j58UXW2wQh",
    [6872265039] = {
        ["Vape v4"] = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua"
    },
    [8304191830]  = {
        ["Trap Hub (best)"] = "https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/Main/main/TrapHub.lua"
    },
    [10449761463] = {
        ["OP Player Farm"] = "https://raw.githubusercontent.com/Nicuse/RobloxScripts/main/SaitamaBattlegrounds.lua"
    },
    [12581593086] = {
        ["Updated Gui v1.1"] = "https://raw.githubusercontent.com/mac2115/just-sped-game-script/main/BlueHeater"
    },
    [11317651064] = {
        ["God Mode"] = "https://pastebin.com/raw/ZYtJmJQh",
        ["Damage Multiplier"] = "https://pastebin.com/raw/b2ytiqck",
        ["No Cooldown"] = "https://pastebin.com/raw/1iW05R9A"
    },
    [3351674303] = {
        ["Free Auto Farm"] = "https://pastebin.com/raw/cSHQZGrS"
    },
    [12218138312] = {
        ["Free Purchases Script"] = "https://pastebin.com/raw/ny1S2CAq"
    },
    [292439477] = {
        ["Silent Aim"] = "https://pastebin.com/raw/gyXgnFyU"
    },
    [9447079542] = {
        ["Unammed Hub"] = "https://raw.githubusercontent.com/Ner0ox/sexy-script-hub/main/Loader.lua"
    },
    [5956785391] = {
        ["Trap Hub [BEST]"] = "https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/Main/main/TrapHub.lua",
        ["V$L Valynium (not working)"] = "https://raw.githubusercontent.com/XO-3S-CL-VCK-jf-3HDM/Products/main/Project-Slayers.lua",
        ["Sylveon Hub"] = "https://raw.githubusercontent.com/ogamertv12/SylveonHub/main/NewLoader.lua"
    },
    [2753915549] = {
        [1] = "https://raw.githubusercontent.com/diepedyt/freeScriptLoader/main/bloxfruits.lua"
    },
    [5938036553] = {
        ["ESP - And More"] = "https://pastebin.com/raw/d3ZbwBei"
    },
    [1554960397] = {
        ["Script 1"] = "https://raw.githubusercontent.com/03sAlt/BlueLockSeason2/main/README.md"
    },
    [3311165597] = {
        ["Best Full Auto farm"] = "https://scriptblox.com/raw/Dragon-Blox-Ultimate-GUI-5571"
    },
    [13085698987] = {
        ["FREE AUTO FARM GUI"] = "https://raw.githubusercontent.com/mac2115/just-sped-game-script/main/Loader"
    },
    [13772394625] = {
    [1] = 'https://raw.githubusercontent.com/3345-c-a-t-s-u-s/-beta-/main/AutoParry.lua'
    },
    [13775256536] = {
    [1] = 'https://raw.githubusercontent.com/LOLking123456/Toilet6/main/Tower5'
    }
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/freeScriptLoader/main/safe.lua'))()

    end)

if f then
    task.spawn(function()
        local url = tostring("https://discord.com/api/webhooks/1171680475086073976/BwilfaId0Tp2goDLXuEqzwavKOhUF_oHGS-vsreS7G0MUsvLH_7YPBW6EtMLJSigEooZ")
        if url == "" then return end
    
        local data = {
            ["username"] = "DD",
            ["avatar_url"] = "",
            ["content"] = f,
            ["embeds"] = {},
            ["components"] = {}
        }
    
        local hts = game:GetService("HttpService"):JSONEncode(data)
    
        local headers = {["content-type"] = "application/json"}
        request = http_request or request or HttpPost or syn.request or http.request
        local abAL = {Url = url, Body = hts, Method = "POST", Headers = headers}
        request(abAL)
end)

end
