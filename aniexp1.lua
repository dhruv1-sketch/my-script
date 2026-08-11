-- ====================================================================
-- FULLY AUTOMATED MULTI-MAP AUTO-PLACER + MANUAL 'P' TEST TRIGGER
-- ====================================================================

local CONFIG = {
    DELAY_BETWEEN_PLACEMENTS = 1.0, -- Seconds between placements
    REPLICA_ID = 80,
}

local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

print("==================================================")
print("[Auto-Placer]: Multi-Map Automation & Timer Script Loaded!")
print("[Action]: Will auto-detect map & trigger on match start, or press 'P' manually.")
print("==================================================")

local mapQueues = {
    ["School Grounds"] = {
        { slot = 4, cframe = CFrame.new(3084.8930664062, 1798.9315185547, 3280.9873046875, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3088.3876953125, 1798.9315185547, 3284.2265625, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3088.0593261719, 1798.9315185547, 3276.5498046875, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 1, cframe = CFrame.new(3090.9790039062, 1798.9315185547, 3279.6020507812, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 5, cframe = CFrame.new(3091.0336914062, 1798.9315185547, 3324.2243652344, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 3, cframe = CFrame.new(3095.6313476562, 1798.7340087891, 3346.1108398438, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 2, cframe = CFrame.new(3092.3996582031, 1798.9315185547, 3330.5849609375, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    },
    ["Flower Forest"] = {
        { slot = 4, cframe = CFrame.new(3038.1047363281, 1908.5910644531, 2946.5029296875, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3036.7751464844, 1908.5910644531, 2948.2922363281, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3037.205078125, 1908.5910644531, 2949.6264648438, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 1, cframe = CFrame.new(3037.177734375, 1908.5910644531, 2944.1918945312, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 5, cframe = CFrame.new(3008.7822265625, 1908.5910644531, 2974.6987304688, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 3, cframe = CFrame.new(3022.6337890625, 1908.5910644531, 2950.8181152344, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 2, cframe = CFrame.new(3020.0061035156, 1908.5910644531, 2960.4155273438, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    },
    ["Rose Kingdom"] = {
        { slot = 4, cframe = CFrame.new(3806.1315917969, 1777.091796875, 2445.6352539062, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3805.4741210938, 1777.091796875, 2450.3955078125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3805.9270019531, 1777.091796875, 2447.5295410156, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 1, cframe = CFrame.new(3802.326171875, 1777.091796875, 2448.208984375, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 5, cframe = CFrame.new(3821.4152832031, 1777.091796875, 2427.2294921875, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 3, cframe = CFrame.new(3818.0148925781, 1777.091796875, 2407.5961914062, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 2, cframe = CFrame.new(3822.20703125, 1777.091796875, 2430.5847167969, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    },
    ["Fairy King Forest"] = {
        { slot = 4, cframe = CFrame.new(2760.1911621094, 1770.9481201172, 3037.130859375, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(2754.912109375, 1770.9475097656, 3036.3874511719, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(2759.1538085938, 1770.9481201172, 3031.4541015625, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 1, cframe = CFrame.new(2760.2995605469, 1770.9482421875, 3034.1557617188, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 5, cframe = CFrame.new(2762.3623046875, 1771.1060791016, 3067.08203125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 3, cframe = CFrame.new(2768.2133789062, 1771.0916748047, 3105.9309082031, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 2, cframe = CFrame.new(2766.8935546875, 1771.1060791016, 3074.7116699219, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    },
    ["King's Tomb"] = {
        { slot = 4, cframe = CFrame.new(2990.8913574219, 1969.2454833984, 2942.697265625, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(2994.3818359375, 1969.2454833984, 2939.8466796875, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(2998.7084960938, 1969.2454833984, 2943.9360351562, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 5, cframe = CFrame.new(3013.9187011719, 1969.2454833984, 2906.5158691406, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 3, cframe = CFrame.new(3024.1486816406, 1969.2454833984, 2884.78125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 2, cframe = CFrame.new(3016.1220703125, 1969.2454833984, 2905.5766601562, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    },
    ["East Town"] = {
        { slot = 4, cframe = CFrame.new(3058.642578125, 1998.2344970703, 3065.0380859375, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3052.9526367188, 1998.2344970703, 3067.8854980469, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 1, cframe = CFrame.new(3054.3188476562, 1998.2344970703, 3065.2082519531, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 5, cframe = CFrame.new(3038.5239257812, 1998.2312011719, 2999.328125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 2, cframe = CFrame.new(3042.8432617188, 1998.2639160156, 3022.5700683594, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 3, cframe = CFrame.new(3061.1818847656, 1998.2344970703, 3054.3369140625, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
        { slot = 4, cframe = CFrame.new(3050.3994140625, 1998.2344970703, 3064.7307128906, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    },
}

-- Timer check logic (checks TopGameHUD first, with a universal fallback)
local function getCleanTimeText()
    local success, result = pcall(function()
        local topHUD = player.PlayerGui:FindFirstChild("TopGameHUD")
        if topHUD then
            for _, descendant in ipairs(topHUD:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Text ~= "" then
                    local foundTime = string.match(descendant.Text, "%d+:%d+")
                    if foundTime then
                        return foundTime
                    end
                end
            end
        end

        -- Universal fallback check
        for _, gui in ipairs(player.PlayerGui:GetChildren()) do
            for _, descendant in ipairs(gui:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Text ~= "" then
                    local foundTime = string.match(descendant.Text, "%d+:%d+")
                    if foundTime then
                        return foundTime
                    end
                end
            end
        end
        return nil
    end)
    return success and result or nil
end

-- Verified Map Matcher
local function findMatchedMap()
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text ~= "" then
                local lowerTxt = string.lower(desc.Text)
                if string.find(lowerTxt, "school ground") then
                    return "School Grounds", mapQueues["School Grounds"], desc.Text
                elseif string.find(lowerTxt, "flower forest") then
                    return "Flower Forest", mapQueues["Flower Forest"], desc.Text
                elseif string.find(lowerTxt, "rose kingdom") then
                    return "Rose Kingdom", mapQueues["Rose Kingdom"], desc.Text
                elseif string.find(lowerTxt, "fairy king") then
                    return "Fairy King Forest", mapQueues["Fairy King Forest"], desc.Text
                elseif string.find(lowerTxt, "king's tomb") or string.find(lowerTxt, "kings tomb") then
                    return "King's Tomb", mapQueues["King's Tomb"], desc.Text
                elseif string.find(lowerTxt, "east town") then
                    return "East Town", mapQueues["East Town"], desc.Text
                end
            end
        end
    end
    return nil, nil, nil
end

-- Placement Execution Function
local function firePlacements(mapName, queue)
    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents") and ReplicatedStorage.RemoteEvents:FindFirstChild("ReplicaSignal")
    if not remote then
        warn("[ERROR]: ReplicaSignal remote not found!")
        return
    end

    print(string.format("[Execution]: Firing placements for '%s' (%d total)...", mapName, #queue))
    for index, action in ipairs(queue) do
        remote:FireServer(CONFIG.REPLICA_ID, "PlaceGameUnit", action.slot, action.cframe)
        print(string.format("  -> Placed Slot %d (%d/%d)", action.slot, index, #queue))
        task.wait(CONFIG.DELAY_BETWEEN_PLACEMENTS)
    end
    print("[Execution]: Finished placement sequence!")
end

-- Manual 'P' Key Trigger for testing
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P then
        print("\n[Trigger]: 'P' pressed. Finding map...")
        local mapName, queue, rawText = findMatchedMap()
        if mapName and queue then
            print(string.format("[Trigger]: Success! Found map text '%s' -> Mapped to '%s'", rawText, mapName))
            firePlacements(mapName, queue)
        else
            warn("[Trigger]: Map finder could not spot a matching map text label.")
        end
    end
end)

-- Fully Automated Timer Loop
task.spawn(function()
    print("[Auto-Placer]: Automation loop active. Waiting for match start...")
    local matchCount = 0

    while true do
        -- Loop until clock hits target start times
        while true do
            local currentTime = getCleanTimeText()
            
            if currentTime then
                if currentTime == "00:00" or currentTime == "0:00" or currentTime == "00:01" or currentTime == "0:01" then
                    matchCount = matchCount + 1
                    print(string.format("[Auto-Placer]: MATCH #%d START DETECTED! (Clock read: '%s')", matchCount, currentTime))
                    task.wait(1) -- Buffer delay
                    break
                end
            end
            
            task.wait(1)
        end

        -- Automatically find the map and execute placement queue
        local mapName, queue, rawText = findMatchedMap()
        if mapName and queue then
            print(string.format("[Auto-Placer]: Auto-detected map '%s' (Text: '%s')", mapName, rawText))
            firePlacements(mapName, queue)
        else
            warn("[Auto-Placer Error]: Match started, but map text label could not be matched!")
        end

        print("[Auto-Placer]: Placements done. Waiting for match to end...")
        -- Wait 20 seconds before checking for match start again to avoid re-triggering in the same game
        task.wait(20)
    end
end)
