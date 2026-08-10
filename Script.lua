```lua
--// Archie Hub
--// Roblox Utility Hub
--// Includes general utilities + Blox Fruits navigation helpers

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer

--==================================================
-- WINDOW
--==================================================

local Window = Rayfield:CreateWindow({
    Name = "Archie Hub",
    LoadingTitle = "Archie Hub",
    LoadingSubtitle = "Loading features...",
    ConfigurationSaving = {
        Enabled = false
    }
})

--==================================================
-- TABS
--==================================================

local MainTab = Window:CreateTab("Main", 4483362458)
local UtilityTab = Window:CreateTab("Utilities", 4483362458)
local BloxTab = Window:CreateTab("Blox Fruits", 4483362458)
local ObbyTab = Window:CreateTab("Obby", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

--==================================================
-- VARIABLES
--==================================================

local InfiniteJump = false
local Noclip = false
local Notifications = true
local AntiIdle = false
local FullBright = false

local NPCHighlights = {}
local FruitHighlights = {}

local SavedPosition = nil
local CurrentCheckpoint = 1
local Checkpoints = {}

local DefaultWalkSpeed = 16
local DefaultJumpPower = 50

--==================================================
-- HELPERS
--==================================================

local function getCharacter()
    return Player.Character
end

local function getHumanoid()
    local Character = getCharacter()

    if Character then
        return Character:FindFirstChildOfClass("Humanoid")
    end
end

local function getRoot()
    local Character = getCharacter()

    if Character then
        return Character:FindFirstChild("HumanoidRootPart")
    end
end

local function notify(title, content)
    if Notifications then
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = 3
        })
    end
end

--==================================================
-- MAIN
--==================================================

MainTab:CreateButton({
    Name = "Speed 25",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 25
            notify("Archie Hub", "Speed set to 25")
        end
    end
})

MainTab:CreateButton({
    Name = "Super Speed 50",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 50
            notify("Archie Hub", "Speed set to 50")
        end
    end
})

MainTab:CreateButton({
    Name = "Ultra Speed 100",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 100
            notify("Archie Hub", "Speed set to 100")
        end
    end
})

MainTab:CreateButton({
    Name = "Reset Speed",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = DefaultWalkSpeed
        end
    end
})

MainTab:CreateButton({
    Name = "High Jump",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = 100
        end
    end
})

MainTab:CreateButton({
    Name = "Reset Jump",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = DefaultJumpPower
        end
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,

    Callback = function(Value)
        InfiniteJump = Value
    end
})

UIS.JumpRequest:Connect(function()
    if InfiniteJump then
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end
end)

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,

    Callback = function(Value)
        Noclip = Value
    end
})

RunService.Stepped:Connect(function()
    if Noclip then
        local Character = getCharacter()

        if Character then
            for _, Part in ipairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = false
                end
            end
        end
    end
end)

MainTab:CreateButton({
    Name = "Sit",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.Sit = true
        end
    end
})

MainTab:CreateButton({
    Name = "Stand",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.Sit = false
        end
    end
})

MainTab:CreateToggle({
    Name = "Hide Under Floor",
    CurrentValue = false,

    Callback = function(Value)
        local Root = getRoot()

        if not Root then
            return
        end

        if Value then
            SavedPosition = Root.CFrame
            Root.CFrame =
                Root.CFrame + Vector3.new(0, -15, 0)

            notify(
                "Archie Hub",
                "Hidden under the floor"
            )
        elseif SavedPosition then
            Root.CFrame = SavedPosition
            SavedPosition = nil

            notify(
                "Archie Hub",
                "Returned to previous position"
            )
        end
    end
})

MainTab:CreateButton({
    Name = "Reset Character",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.Health = 0
        end
    end
})

--==================================================
-- UTILITIES
--==================================================

UtilityTab:CreateButton({
    Name = "Teleport Up",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.CFrame =
                Root.CFrame + Vector3.new(0, 20, 0)
        end
    end
})

UtilityTab:CreateButton({
    Name = "Teleport Down",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.CFrame =
                Root.CFrame + Vector3.new(0, -20, 0)
        end
    end
})

UtilityTab:CreateButton({
    Name = "Freeze Character",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.Anchored = true
        end
    end
})

UtilityTab:CreateButton({
    Name = "Unfreeze Character",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.Anchored = false
        end
    end
})

UtilityTab:CreateButton({
    Name = "Rejoin Server",

    Callback = function()
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            Player
        )
    end
})

--==================================================
-- BLOX FRUITS UTILITIES
--==================================================

local function clearHighlights(folder)
    for _, Highlight in ipairs(folder) do
        if Highlight and Highlight.Parent then
            Highlight:Destroy()
        end
    end

    table.clear(folder)
end

local function isLikelyNPC(Model)
    if not Model:IsA("Model") then
        return false
    end

    local Humanoid =
        Model:FindFirstChildOfClass("Humanoid")

    local Root =
        Model:FindFirstChild("HumanoidRootPart")

    return Humanoid ~= nil
        and Root ~= nil
        and Model ~= Player.Character
end

local function findNPCs()
    local Results = {}

    for _, Object in ipairs(workspace:GetDescendants()) do
        if isLikelyNPC(Object) then
            table.insert(Results, Object)
        end
    end

    return Results
end

local function highlightNPCs()
    clearHighlights(NPCHighlights)

    local NPCs = findNPCs()

    for _, NPC in ipairs(NPCs) do
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "ArchieNPCHighlight"
        Highlight.Adornee = NPC
        Highlight.FillTransparency = 0.65
        Highlight.OutlineTransparency = 0

        Highlight.Parent = NPC

        table.insert(NPCHighlights, Highlight)
    end

    notify(
        "Archie Hub",
        tostring(#NPCs) .. " NPCs highlighted"
    )
end

local function findNearestNPC()
    local Root = getRoot()

    if not Root then
        return nil
    end

    local Nearest = nil
    local Distance = math.huge

    for _, NPC in ipairs(findNPCs()) do
        local NPCRoot =
            NPC:FindFirstChild("HumanoidRootPart")

        local Humanoid =
            NPC:FindFirstChildOfClass("Humanoid")

        if NPCRoot and Humanoid and Humanoid.Health > 0 then
            local CurrentDistance =
                (Root.Position - NPCRoot.Position).Magnitude

            if CurrentDistance < Distance then
                Distance = CurrentDistance
                Nearest = NPC
            end
        end
    end

    return Nearest, Distance
end

BloxTab:CreateButton({
    Name = "Find NPCs",

    Callback = function()
        local NPCs = findNPCs()

        notify(
            "Archie Hub",
            tostring(#NPCs) .. " NPCs detected"
        )
    end
})

BloxTab:CreateToggle({
    Name = "Highlight NPCs",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            highlightNPCs()
        else
            clearHighlights(NPCHighlights)
        end
    end
})

BloxTab:CreateButton({
    Name = "Find Nearest NPC",

    Callback = function()
        local NPC, Distance = findNearestNPC()

        if not NPC then
            notify(
                "Archie Hub",
                "No nearby NPC found"
            )
            return
        end

        notify(
            "Nearest NPC",
            NPC.Name ..
            " | Distance: " ..
            math.floor(Distance)
        )
    end
})

BloxTab:CreateButton({
    Name = "Walk To Nearest NPC",

    Callback = function()
        local Humanoid = getHumanoid()
        local NPC = findNearestNPC()

        if not Humanoid or not NPC then
            notify(
                "Archie Hub",
                "No NPC available"
            )
            return
        end

        local NPCRoot =
            NPC:FindFirstChild("HumanoidRootPart")

        if NPCRoot then
            -- Navigation only: the player remains
            -- responsible for combat.
            Humanoid:MoveTo(NPCRoot.Position)

            notify(
                "Archie Hub",
                "Walking toward " .. NPC.Name
            )
        end
    end
})

BloxTab:CreateButton({
    Name = "Stop Walking",

    Callback = function()
        local Humanoid = getHumanoid()
        local Root = getRoot()

        if Humanoid and Root then
            Humanoid:MoveTo(Root.Position)
        end
    end
})

--==================================================
-- FRUIT FINDER
--==================================================

local function findFruitObjects()
    local Fruits = {}

    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("Tool")
            or Object:IsA("Model") then

            local Name = Object.Name:lower()

            if Name:find("fruit") then
                table.insert(Fruits, Object)
            end
        end
    end

    return Fruits
end

local function highlightFruits()
    clearHighlights(FruitHighlights)

    local Fruits = findFruitObjects()

    for _, Fruit in ipairs(Fruits) do
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "ArchieFruitHighlight"
        Highlight.Adornee = Fruit
        Highlight.FillTransparency = 0.45
        Highlight.OutlineTransparency = 0

        Highlight.Parent = Fruit

        table.insert(FruitHighlights, Highlight)
    end

    notify(
        "Archie Hub",
        tostring(#Fruits) .. " possible fruits highlighted"
    )
end

BloxTab:CreateButton({
    Name = "Find Fruits",

    Callback = function()
        local Fruits = findFruitObjects()

        notify(
            "Archie Hub",
            tostring(#Fruits) .. " possible fruits found"
        )
    end
})

BloxTab:CreateToggle({
    Name = "Highlight Fruits",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            highlightFruits()
        else
            clearHighlights(FruitHighlights)
        end
    end
})

--==================================================
-- OBBY
--==================================================

local function findCheckpoints()
    Checkpoints = {}

    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("BasePart") then
            local Name = Object.Name:lower()

            if Name:find("checkpoint")
                or Name:match("^cp%d+$")
                or Name:match("^stage%d+$") then

                table.insert(Checkpoints, Object)
            end
        end
    end

    table.sort(Checkpoints, function(A, B)
        local ANum =
            tonumber(A.Name:match("%d+")) or 999999

        local BNum =
            tonumber(B.Name:match("%d+")) or 999999

        return ANum < BNum
    end)
end

ObbyTab:CreateButton({
    Name = "Find Checkpoints",

    Callback = function()
        findCheckpoints()

        notify(
            "Archie Hub",
            tostring(#Checkpoints) ..
            " checkpoints found"
        )
    end
})

ObbyTab:CreateButton({
    Name = "Teleport To Next Checkpoint",

    Callback = function()
        findCheckpoints()

        local Root = getRoot()

        if not Root or #Checkpoints == 0 then
            notify(
                "Archie Hub",
                "No checkpoints detected"
            )
            return
        end

        if CurrentCheckpoint > #Checkpoints then
            CurrentCheckpoint = 1
        end

        local Checkpoint =
            Checkpoints[CurrentCheckpoint]

        Root.CFrame =
            Checkpoint.CFrame +
            Vector3.new(0, 4, 0)

        notify(
            "Archie Hub",
            "Checkpoint " ..
            CurrentCheckpoint ..
            " selected"
        )

        CurrentCheckpoint += 1
    end
})

ObbyTab:CreateButton({
    Name = "Reset Checkpoint Progress",

    Callback = function()
        CurrentCheckpoint = 1
    end
})

--==================================================
-- SETTINGS
--==================================================

SettingsTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 150},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,

    Callback = function(Value)
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

SettingsTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 5,
    Suffix = " Jump",
    CurrentValue = 50,

    Callback = function(Value)
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Value
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,

    Callback = function(Value)
        FullBright = Value

        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = true,

    Callback = function(Value)
        Notifications = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Anti Idle",
    CurrentValue = false,

    Callback = function(Value)
        AntiIdle = Value
    end
})

SettingsTab:CreateButton({
    Name = "Reset Movement",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 16
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = 50
        end
    end
})

SettingsTab:CreateButton({
    Name = "Clear ESP",

    Callback = function()
        clearHighlights(NPCHighlights)
        clearHighlights(FruitHighlights)

        notify(
            "Archie Hub",
            "Highlights cleared"
        )
    end
})

SettingsTab:CreateButton({
    Name = "Unload Archie Hub",

    Callback = function()
        clearHighlights(NPCHighlights)
        clearHighlights(FruitHighlights)

        Rayfield:Destroy()
    end
})

--==================================================
-- ANTI IDLE
--==================================================

Player.Idled:Connect(function()
    if AntiIdle then
        VirtualUser:CaptureController()

        VirtualUser:ClickButton2(
            Vector2.new(0, 0)
        )
    end
end)

--==================================================
-- LOADED
--==================================================

Rayfield:Notify({
    Title = "Archie Hub",
    Content = "Archie Hub loaded successfully!",
    Duration = 5,
    Image = 4483362458
})
```
