-- ====================================================================
-- AUTO-PLACER WITH RELAXED TIMER MATCHING & CONSOLE LOGGING
-- ====================================================================

local CONFIG = {
    DELAY_BETWEEN_PLACEMENTS = 1.0, -- Seconds between placements (gives time to earn cash)
    REPLICA_ID = 81,
}

local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Finds any time string (like "00:00", "0:00", " 00:01 ") anywhere in TopGameHUD
local function getCleanTimeText()
    local success, result = pcall(function()
        local topHUD = player.PlayerGui:FindFirstChild("TopGameHUD")
        if not topHUD then return nil end

        for _, descendant in ipairs(topHUD:GetDescendants()) do
            if descendant:IsA("TextLabel") and descendant.Text ~= "" then
                local foundTime = string.match(descendant.Text, "%d+:%d+")
                if foundTime then
                    return foundTime
                end
            end
        end
        return nil
    end)
    return success and result or nil
end

local placementQueue = {
   { type = "Place", slot = 4, cframe = CFrame.new(3021.3515625, 1969.2454833984, 2933.9638671875, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 4, cframe = CFrame.new(3025.6481933594, 1969.2454833984, 2934.025390625, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 4, cframe = CFrame.new(3030.4777832031, 1969.2454833984, 2933.6953125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 1, cframe = CFrame.new(3035.1518554688, 1969.2454833984, 2932.8630371094, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 5, cframe = CFrame.new(3016.3334960938, 1969.2454833984, 2906.6313476562, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 3, cframe = CFrame.new(3025.0090332031, 1969.2454833984, 2883.6979980469, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 2, cframe = CFrame.new(3013.0200195312, 1969.2454833984, 2907.5053710938, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 6, cframe = CFrame.new(3019.7932128906, 1969.2454833984, 2884.830078125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 6, cframe = CFrame.new(3019.556640625, 1969.2454833984, 2894.6218261719, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 6, cframe = CFrame.new(3023.4865722656, 1969.2454833984, 2894.7626953125, 1, 0, 0, 0, 1, 0, 0, 0, 1) }
}

task.spawn(function()
    print("[Auto-Placer]: Active. Open F9 to view live clock detection.")
    local matchCount = 0

    while true do
        print("[Auto-Placer]: Waiting for match start...")
        
        -- Loop until clock hits 00:00 or 00:01
        while true do
            local currentTime = getCleanTimeText()
            
            if currentTime then
                if currentTime == "00:00" or currentTime == "0:00" or currentTime == "00:01" or currentTime == "0:01" then
                    matchCount = matchCount + 1
                    print(string.format("[Auto-Placer]: MATCH #%d START DETECTED! (Clock read: '%s')", matchCount, currentTime))
                    task.wait(1) -- Buffer delay
                    break
                end
            else
                warn("[Auto-Placer]: Timer text label not found in TopGameHUD yet...")
            end
            
            task.wait(1)
        end

        -- Execute actions
        local remote = ReplicatedStorage.RemoteEvents:FindFirstChild("ReplicaSignal")
        if remote then
            for index, action in ipairs(placementQueue) do
                if action.type == "Place" then
                    remote:FireServer(CONFIG.REPLICA_ID, "PlaceGameUnit", action.slot, action.cframe)
                    print(string.format("  -> Placed Slot %d (%d/%d)", action.slot, index, #placementQueue))
                elseif action.type == "Priority" then
                    remote:FireServer(CONFIG.REPLICA_ID, "ChangeGameUnitAutoUpgradePriority", action.value)
                    print(string.format("  -> Priority set to %s", action.value))
                end

                task.wait(CONFIG.DELAY_BETWEEN_PLACEMENTS)
            end
            print("[Auto-Placer]: Placements done. Waiting for match to end...")
        else
            warn("[Auto-Placer Error]: ReplicaSignal remote missing!")
        end

        -- Wait 20 seconds before checking for 00:00 again to avoid re-triggering in the same game
        task.wait(20)
    end
end)
