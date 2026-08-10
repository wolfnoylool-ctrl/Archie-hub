--==================================================
-- ARCHIE HUB
--==================================================

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

if not Rayfield then
    warn("Archie Hub: Rayfield failed to load.")
    return
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer

--==================================================
-- VARIABLES
--==================================================

local InfiniteJump = false
local Noclip = false
local AntiIdle = false
local Notifications = true
local SavedPosition = nil

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

    return nil
end

local function getRoot()
    local Character = getCharacter()

    if Character then
        return Character:FindFirstChild("HumanoidRootPart")
    end

    return nil
end

local function notify(title, message)
    if Notifications then
        Rayfield:Notify({
            Title = title,
            Content = message,
            Duration = 3
        })
    end
end

--==================================================
-- WINDOW
--==================================================

local Window = Rayfield:CreateWindow({
    Name = "Archie Hub",
    LoadingTitle = "Archie Hub",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = false
    }
})

--==================================================
-- TABS
--==================================================

local MainTab = Window:CreateTab(
    "Main",
    4483362458
)

local UtilityTab = Window:CreateTab(
    "Utilities",
    4483362458
)

local ObbyTab = Window:CreateTab(
    "Obby",
    4483362458
)

local SettingsTab = Window:CreateTab(
    "Settings",
    4483362458
)

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
    Name = "Reset Speed",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 16
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
            Humanoid.JumpPower = 50
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

UserInputService.JumpRequest:Connect(function()
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
    if not Noclip then
        return
    end

    local Character = getCharacter()

    if Character then
        for _, Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
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
                Root.CFrame +
                Vector3.new(0, -15, 0)

            notify(
                "Archie Hub",
                "Hidden under the floor"
            )
        else
            if SavedPosition then
                Root.CFrame = SavedPosition
                SavedPosition = nil
            end
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
                Root.CFrame +
                Vector3.new(0, 20, 0)
        end
    end
})

UtilityTab:CreateButton({
    Name = "Teleport Down",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.CFrame =
                Root.CFrame +
                Vector3.new(0, -20, 0)
        end
    end
})

UtilityTab:CreateButton({
    Name = "Freeze",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.Anchored = true
        end
    end
})

UtilityTab:CreateButton({
    Name = "Unfreeze",

    Callback = function()
        local Root = getRoot()

        if Root then
            Root.Anchored = false
        end
    end
})

UtilityTab:CreateButton({
    Name = "Reset Character",

    Callback = function()
        local Humanoid = getHumanoid()

        if Humanoid then
            Humanoid.Health = 0
        end
    end
})

UtilityTab:CreateButton({
    Name = "Rejoin Server",

    Callback = function()
        TeleportService:Teleport(
            game.PlaceId,
            Player
        )
    end
})

--==================================================
-- OBBY
--==================================================

local function findCheckpoints()
    local Results = {}

    for _, Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("BasePart") then
            local Name = Object.Name:lower()

            if Name:find("checkpoint")
                or Name:match("^cp%d+$")
                or Name:match("^stage%d+$") then

                table.insert(Results, Object)
            end
        end
    end

    table.sort(Results, function(A, B)
        local ANumber =
            tonumber(A.Name:match("%d+")) or 999999

        local BNumber =
            tonumber(B.Name:match("%d+")) or 999999

        return ANumber < BNumber
    end)

    return Results
end

ObbyTab:CreateButton({
    Name = "Find Checkpoints",

    Callback = function()
        local Checkpoints = findCheckpoints()

        notify(
            "Archie Hub",
            tostring(#Checkpoints) ..
            " checkpoints found"
        )
    end
})

ObbyTab:CreateButton({
    Name = "Teleport To First Checkpoint",

    Callback = function()
        local Checkpoints = findCheckpoints()
        local Root = getRoot()

        if Root and Checkpoints[1] then
            Root.CFrame =
                Checkpoints[1].CFrame +
                Vector3.new(0, 4, 0)

            notify(
                "Archie Hub",
                "Teleported to first checkpoint"
            )
        else
            notify(
                "Archie Hub",
                "No checkpoint found"
            )
        end
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
    Name = "Reset Lighting",

    Callback = function()
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
})

SettingsTab:CreateButton({
    Name = "Unload Archie Hub",

    Callback = function()
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
    Content = "Loaded successfully!",
    Duration = 5,
    Image = 4483362458
})

print("Archie Hub loaded successfully.")  local NPC, Distance = findNearestNPC()

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
