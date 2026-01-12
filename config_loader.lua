-- ===============================
-- Services
-- ===============================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ===============================
-- Executor FS safety
-- ===============================
assert(writefile and readfile and isfile and isfolder and makefolder, "Executor filesystem not supported")

-- ===============================
-- Paths
-- ===============================
local ROOT_CONFIG = "Void Configs"
local USER_FOLDER = ROOT_CONFIG .. "/" .. player.Name

local NONNY_ROOT = "Nonny Services"
local NONNY_SETTINGS = NONNY_ROOT .. "/Settings"

local FILES = {
    "AutoFarm_Settings.json",
    "webhook.json"
}

-- ===============================
-- Ensure folders exist
-- ===============================
if not isfolder(ROOT_CONFIG) then makefolder(ROOT_CONFIG) end
if not isfolder(USER_FOLDER) then makefolder(USER_FOLDER) end
if not isfolder(NONNY_ROOT) then makefolder(NONNY_ROOT) end
if not isfolder(NONNY_SETTINGS) then makefolder(NONNY_SETTINGS) end

-- ===============================
-- AUTO LOAD (Player → Nonny)
-- ===============================
local function LoadSettingsFromUserFolder()
    for _, filename in ipairs(FILES) do
        local sourcePath = USER_FOLDER .. "/" .. filename
        local targetPath = NONNY_SETTINGS .. "/" .. filename

        if isfile(sourcePath) then
            writefile(targetPath, readfile(sourcePath))
            print("[AUTO-LOADED]", filename)
        else
            if not isfile(targetPath) then
                writefile(targetPath, "")
                print("[CREATED BLANK]", filename)
            end
        end
    end
end

LoadSettingsFromUserFolder() -- 🔥 AUTO LOAD FIRST

-- ===============================
-- SAVE FUNCTION (Nonny → Player)
-- ===============================
local function SaveSettingsToUserFolder()
    for _, filename in ipairs(FILES) do
        local sourcePath = NONNY_SETTINGS .. "/" .. filename
        local targetPath = USER_FOLDER .. "/" .. filename

        if isfile(sourcePath) then
            writefile(targetPath, readfile(sourcePath))
            print("[SAVED]", filename)
        end
    end
end

-- ===============================
-- UI CREATION
-- ===============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZKAY_Void_Config_Manager"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(420, 220)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- ===============================
-- Title
-- ===============================
local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromOffset(400, 40)
Title.Position = UDim2.fromOffset(10, 10)
Title.BackgroundTransparency = 1
Title.Text = "ZKAY Void Configs Manager"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- ===============================
-- Save Button
-- ===============================
local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.fromOffset(380, 55)
SaveButton.Position = UDim2.fromOffset(20, 110)
SaveButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SaveButton.Text = "Save Settings to Player Config"
SaveButton.Font = Enum.Font.GothamSemibold
SaveButton.TextSize = 15
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = SaveButton

SaveButton.MouseButton1Click:Connect(function()
    SaveSettingsToUserFolder()
    SaveButton.Text = "Saved ✔"
    task.wait(1.2)
    SaveButton.Text = "Save Settings to Player Config"
end)

-- ===============================
-- DRAGGABLE UI
-- ===============================
local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

print("✔ ZKAY Void Configs Manager fully loaded")
