-- ====================================================================
-- ULTIMATE ANTI-AFK & TELEPORT BLOCKER (4-LAYER PROTECTION)
-- ====================================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- --------------------------------------------------------------------
-- LAYER 1 & 2: HOOK & BLOCK TELEPORT SERVICE AND AFK REMOTES
-- --------------------------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Block direct TeleportService calls from client
    if self == TeleportService or (typeof(self) == "Instance" and self.ClassName == "TeleportService") then
        print("[Teleport Blocker]: Intercepted & Blocked TeleportService call ->", method)
        return nil
    end

    -- Block any RemoteEvents/RemoteFunctions attempting to trigger AFK/Teleport
    if method == "FireServer" or method == "InvokeServer" then
        local remoteName = tostring(self.Name):lower()
        local firstArg = tostring(args[1] or ""):lower()
        local secondArg = tostring(args[2] or ""):lower()

        if string.find(remoteName, "afk") or string.find(remoteName, "teleport") or string.find(remoteName, "hub")
            or string.find(firstArg, "afk") or string.find(firstArg, "teleport") or string.find(firstArg, "hub")
            or string.find(secondArg, "afk") or string.find(secondArg, "teleport") or string.find(secondArg, "hub") then
            
            print(string.format("[Remote Blocker]: Blocked AFK/Teleport remote -> %s ('%s', '%s')", self.Name, firstArg, secondArg))
            return nil
        end
    end

    return oldNamecall(self, ...)
end)

-- --------------------------------------------------------------------
-- LAYER 3: HARDWARE-LEVEL INPUT SIMULATION (Bypasses Client Detectors)
-- --------------------------------------------------------------------
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            -- Simulate pressing 'A' and 'D' keys at OS level
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.A, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)

            task.wait(0.2)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
        end)
    end
end)

-- --------------------------------------------------------------------
-- LAYER 4: PHYSICAL POSITION SHIFT (Bypasses Server Position Checks)
-- --------------------------------------------------------------------
task.spawn(function()
    while task.wait(20) do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                local humanoid = char.Humanoid
                local root = char.HumanoidRootPart
                
                -- Walk 2 studs forward, then step back to reset position
                local originalPos = root.Position
                humanoid:MoveTo(root.Position + (root.CFrame.LookVector * 2))
                task.wait(0.8)
                humanoid:MoveTo(originalPos)
            end
        end)
    end
end)

-- ROBLOX ENGINE IDLE FALLBACK
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    print("[Anti-AFK]: Engine idle kick prevented.")
end)

print("[ULTIMATE ANTI-AFK]: Protection Active! Teleports & AFK checks are blocked.")
