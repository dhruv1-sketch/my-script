-- ====================================================================
-- AUTO-PLACER WITH RELAXED TIMER MATCHING & CONSOLE LOGGING
-- ====================================================================

local CONFIG = {
    DELAY_BETWEEN_PLACEMENTS = 1.0, -- Seconds between placements (gives time to earn cash)
    REPLICA_ID = 80,
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
   { type = "Place", slot = 4, cframe = CFrame.new(2949.4958496094, 1961.7807617188, 3018.5354003906, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 4, cframe = CFrame.new(2948.6328125, 1961.7807617188, 3015.5444335938, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 4, cframe = CFrame.new(2950.4658203125, 1961.7807617188, 3011.2854003906, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 1, cframe = CFrame.new(2952.0744628906, 1961.7807617188, 3016.830078125, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 5, cframe = CFrame.new(2977.3828125, 1962.3179931641, 3042.5661621094, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 6, cframe = CFrame.new(2988.6860351562, 1961.7801513672, 3048.1108398438, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
   { type = "Place", slot = 3, cframe = CFrame.new(3000.2465820312, 1961.7801513672, 3046, 1, 0, 0, 0, 1, 0, 0, 0, 1) }
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
