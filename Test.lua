local HttpServ = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ChatService = game:GetService("Chat")

local lastJobId = "snow was here"

local function autoJoin()
    local response = HttpServ:RequestAsync({
        Url = "https://discord.com/api/v9/channels/"..channelId.."/messages?limit=1",
        Method = "GET",
        Headers = {
            ['Authorization'] = token,
            ['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36',
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        local messages = HttpServ:JSONDecode(response.Body)
        if #messages > 0 then
            local stuff = messages[1].content
            print("Received message:", stuff)  -- Print the received message

            local placeId, jobId = string.match(stuff, 'TeleportToPlaceInstance%((%d+),%s*["\']([%w%-]+)["\']%)')
            
            if placeId and jobId then
                print("Parsed Place ID:", placeId)  -- Print parsed place ID
                print("Parsed Job ID:", jobId)      -- Print parsed job ID

                if jobId ~= lastJobId then
                    lastJobId = jobId
                    queue_on_teleport("game:GetService('Chat'):Chat(game.Players.LocalPlayer.Character, 'yo wsg pablo')")
                    TeleportService:TeleportToPlaceInstance(placeId, jobId)
                end
            else
                print("No valid Place ID or Job ID found in message.")
            end
        end
    else
        warn("Failed to fetch messages. Status Code:", response.StatusCode)
    end
end

while wait(10) do
    autoJoin()
end
