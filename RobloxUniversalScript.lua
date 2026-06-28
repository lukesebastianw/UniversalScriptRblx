local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Script by lukesebastianw",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Lux Hub",
   LoadingSubtitle = "by Scav",
   ShowText = "Rayfield", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "lukesw", -- Create a custom folder for your hub/game
      FileName = "lukesebastianw"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/rG9MePggE7", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = false -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Lux Hub",
      Subtitle = "Insert Key for Access",
      Note = "Join Discord for Key", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"bwvn2f7br", "rawr"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local FeaturesTab = Window:CreateTab("Features", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local InfiniteJumpEnabled = false
local InfiniteJumpConnection
local NoclipEnabled = false
local NoclipConnection

-- Main
Toggle = MainTab:CreateToggle({
    Name = "🌀 Infinite Jump",
    CurrentValue = false,
    Flag = "Toggle1",

    Callback = function(Value)
        InfiniteJumpEnabled = Value

        if Value and not InfiniteJumpConnection then
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if InfiniteJumpEnabled then
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:ChangeState("Jumping") end
                    end
                end
            end)
        elseif not Value and InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
            InfiniteJumpConnection = nil
        end
    end,
})

MainTab:CreateSlider({
    Name = "⚡ WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",

    Callback = function(Value)
        local Player = game.Players.LocalPlayer
        local Character = Player.Character

        if Character and Character:FindFirstChildOfClass("Humanoid") then
            Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end,
})

MainTab:CreateSlider({
    Name = "🦘 JumpPower",
    Range = {50, 200},
    Increment = 1,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "JumpPower",

    Callback = function(Value)
        local Player = game.Players.LocalPlayer
        local Character = Player.Character

        if Character and Character:FindFirstChildOfClass("Humanoid") then
            Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
    end,
})

MainTab:CreateToggle({
    Name = "🚧 Noclip",
    CurrentValue = false,
    Flag = "Noclip",

    Callback = function(Value)
        NoclipEnabled = Value

        if Value then
            NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end

            -- Re-enable collision saat dimatikan
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

-- Settings
-- Destroy UI
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Misc

local RunService = game:GetService("RunService")

local FPSGui
local FPSConnection

-- Rejoin Server
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end,
})

-- Reset Character
MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local Character = game.Players.LocalPlayer.Character

        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.Health = 0
        end
    end,
})

-- FPS Counter
MiscTab:CreateToggle({
    Name = "FPS Counter",
    CurrentValue = false,
    Flag = "Show FPS",

    Callback = function(Value)

        if Value then

            if FPSGui then return end

            FPSGui = Instance.new("ScreenGui")
            FPSGui.Name = "FPSCounter"

            pcall(function()
                FPSGui.Parent = game:GetService("CoreGui")
            end)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0, 120, 0, 35)
            Label.Position = UDim2.new(0, 10, 0, 10)
            Label.BackgroundTransparency = 0.3
            Label.TextScaled = true
            Label.Text = "FPS: 0"
            Label.Parent = FPSGui

            local Frames = 0
            local LastUpdate = tick()

            FPSConnection = RunService.RenderStepped:Connect(function()
                Frames += 1

                if tick() - LastUpdate >= 1 then
                    Label.Text = "FPS: " .. Frames
                    Frames = 0
                    LastUpdate = tick()
                end
            end)

        else

            if FPSConnection then
                FPSConnection:Disconnect()
                FPSConnection = nil
            end

            if FPSGui then
                FPSGui:Destroy()
                FPSGui = nil
            end

        end

    end
})

-- Copy Discord
MiscTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/rG9MePggE7")

        Rayfield:Notify({
            Title = "Discord",
            Content = "Invite copied to clipboard!",
            Duration = 5
        })
    end,
})

-- Credits
MiscTab:CreateParagraph({
    Title = "Credits",
    Content = "Lux Hub Created by Scav"
})


-- Settings
-- Destroy UI
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Misc

local RunService = game:GetService("RunService")

local FPSGui
local FPSConnection

-- Rejoin Server
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end,
})

-- Reset Character
MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local Character = game.Players.LocalPlayer.Character

        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.Health = 0
        end
    end,
})

-- FPS Counter
MiscTab:CreateToggle({
    Name = "FPS Counter",
    CurrentValue = false,
    Flag = "Show FPS",

    Callback = function(Value)

        if Value then

            if FPSGui then return end

            FPSGui = Instance.new("ScreenGui")
            FPSGui.Name = "FPSCounter"

            pcall(function()
                FPSGui.Parent = game:GetService("CoreGui")
            end)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0, 120, 0, 35)
            Label.Position = UDim2.new(0, 10, 0, 10)
            Label.BackgroundTransparency = 0.3
            Label.TextScaled = true
            Label.Text = "FPS: 0"
            Label.Parent = FPSGui

            local Frames = 0
            local LastUpdate = tick()

            FPSConnection = RunService.RenderStepped:Connect(function()
                Frames += 1

                if tick() - LastUpdate >= 1 then
                    Label.Text = "FPS: " .. Frames
                    Frames = 0
                    LastUpdate = tick()
                end
            end)

        else

            if FPSConnection then
                FPSConnection:Disconnect()
                FPSConnection = nil
            end

            if FPSGui then
                FPSGui:Destroy()
                FPSGui = nil
            end

        end

    end
})

-- Copy Discord
MiscTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/rG9MePggE7")

        Rayfield:Notify({
            Title = "Discord",
            Content = "Invite copied to clipboard!",
            Duration = 5
        })
    end,
})

-- Credits
MiscTab:CreateParagraph({
    Title = "Credits",
    Content = "Lux Hub Created by Scav"
})
