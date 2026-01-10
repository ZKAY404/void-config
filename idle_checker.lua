local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId

-- === TELEPORT REMOTES ===
local PortalRF = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Packages")
    :WaitForChild("Knit")
    :WaitForChild("Services")
    :WaitForChild("PortalService")
    :WaitForChild("RF")
    :WaitForChild("TeleportToIsland")

-- === DIRECT PLACE CHECK ===
if PLACE_ID == 129009554587176 then
    local args = {
        "Frostspire Expanse"
    }
    PortalRF:InvokeServer(unpack(args))
    return -- stop script here
end

-- === IDLE CHECK SETTINGS ===
local IDLE_TIME = 180 -- 3 minutes

local function teleportIdle()
    local args = {
        "Forgotten Kingdom"
    }
    PortalRF:InvokeServer(unpack(args))
end

-- === CHARACTER HANDLING ===
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local hrp = getHRP()
local lastCFrame = hrp.CFrame
local idleTimer = 0

player.CharacterAdded:Connect(function()
    hrp = getHRP()
    lastCFrame = hrp.CFrame
    idleTimer = 0
end)

-- === MOVEMENT CHECK ===
RunService.Heartbeat:Connect(function(dt)
    if not hrp or not hrp.Parent then return end

    if hrp.CFrame ~= lastCFrame then
        lastCFrame = hrp.CFrame
        idleTimer = 0
    else
        idleTimer += dt
        if idleTimer >= IDLE_TIME then
            idleTimer = 0
            teleportIdle()
        end
    end
end)
