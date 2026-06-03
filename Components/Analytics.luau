local function CloneReference(Object)
    if Abysall.Environment.cloneref then
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

if Abysall.Environment.identifyexecutor and Abysall.Environment.request then
    local Data = {
        Account = Services.Players.LocalPlayer.Name,
        Executor = Abysall.Environment.identifyexecutor(),
        Executions = tostring(Abysall.TotalExecutions)
    }

    Abysall.Environment.request({
        Url = "http://93.115.101.180:10577/send", 
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        },
        Body = Services.HttpService:JSONEncode(Data)
    })
end
