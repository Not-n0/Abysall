if Abysall then
    return 
end
getgenv().Abysall = {}

local GameList = {
  [2440500124] = "Doors"
}

local BaseUrl = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/"
getgenv().Abysall = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),
}

local function CloneReference(Object)
    if Abysall and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if Abysall.Environment.writefile and Abysall.Environment.readfile then
    if not Abysall.Environment.isfile("Abysall/UserData.json") then
        local Data = {
            TotalExecutions = 0,
            UILibrary = "Obsidian"
        }
        Abysall.Environment.writefile("Abysall/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = Abysall.Environment.readfile("Abysall/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded.TotalExecutions then
        Decoded.TotalExecutions = 0    
    end

    Decoded.TotalExecutions = Decoded.TotalExecutions + 1

    if not Decoded.UILibrary then
        Decoded.UILibrary = "Obsidian"
    end

    Abysall.TotalExecutions = Decoded.TotalExecutions
    Abysall.UILibrary = Decoded.UILibrary

    Abysall.Environment.writefile("Abysall/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

local function HashString(InputString)
    local EncodingService = game:GetService("EncodingService")

	local HashBuffer = EncodingService:ComputeStringHash(InputString, Enum.HashAlgorithm.Md5)
	local HexString = ""
	for Index = 1, #HashBuffer, 1 do
		local Char = HashBuffer:sub(Index, Index)
        HexString = HexString .. string.format("%02x", Char:byte())
	end
	return HexString
end

local function GenerateUser()
    local User = game:HttpGet("https://api.ipify.org")
    local Hashed = HashString(User)
    Hashed = Hashed:sub(1, 8) .. "-" .. Hashed:sub(9, 12) .. "-" .. Hashed:sub(13, 16) .. "-" .. Hashed:sub(17, 20) .. "-" .. Hashed:sub(18, 32)
    return Hashed
end

Abysall.ClientID = GenerateUser()
Abysall.Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()
Abysall.Analytics = loadstring(game:HttpGet(BaseUrl .. "Components/Analytics.luau"))()

local Success, Result = pcall(function()
    local Game = GameList[game.GameId]
    if Game then
        loadstring(game:HttpGet(BaseUrl .. "Games/" .. Game .. "/Loader.luau"))()
    end
end)
