--============================--
--==     EBEPUMM HUB        ==--
--==      By Manh           ==--
--============================--

--== LOADER GITHUB ==--
loadstring(game:HttpGet("https://raw.githubusercontent.com/EBEPUMM/EBEPUMMhub/main/Main.lua"))()

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

--============================--
--==       UI LIBRARY        ==--
--============================--
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

--============================--
--==  FLOAT ICON (DRAGGABLE) ==--
--============================--

local Icon = Instance.new("ImageButton")
Icon.Name = "EBEPUMM_Float_Button"
Icon.Parent = game.CoreGui
Icon.Size = UDim2.new(0, 65, 0, 65)
Icon.Position = UDim2.new(0.05, 0, 0.5, 0)
Icon.Image = "rbxassetid://96694253417585"
Icon.BackgroundTransparency = 1
Icon.Active = true
Icon.Draggable = true

--============================--
--==   CREATE MAIN WINDOW    ==--
--============================--

local Window = OrionLib:MakeWindow({
    Name = "🍃 EBEPUMM Hub | By Manh",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

Window.WindowFrame.Active = true
Window.WindowFrame.Draggable = true
Window.WindowFrame.Visible = false

--============================--
--==   LOGO TRÊN TOPBAR      ==--
--============================--

task.wait(0.4)

local Topbar = Window.WindowFrame:WaitForChild("TopBar")

local LogoText = Instance.new("TextLabel")
LogoText.Name = "EBEPUMM_Logo"
LogoText.Parent = Topbar
LogoText.Size = UDim2.new(0, 200, 1, 0)
LogoText.Position = UDim2.new(0, 10, 0, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "🍃 EBEPUMM"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.Font = Enum.Font.GothamBold
LogoText.TextScaled = true
LogoText.TextXAlignment = Enum.TextXAlignment.Left

--============================--
--==     SLIDE RIGHT MENU    ==--
--============================--

local MenuOpened = false

Icon.MouseButton1Click:Connect(function()
    MenuOpened = not MenuOpened

    if MenuOpened then
        Window.WindowFrame.Position = UDim2.new(-1, 0, 0.2, 0)
        Window.WindowFrame.Visible = true

        for i = -1, 0.3, 0.1 do
            Window.WindowFrame.Position = UDim2.new(i, 0, 0.2, 0)
            task.wait(0.02)
        end
        Window.WindowFrame.Position = UDim2.new(0.3, 0, 0.2, 0)

    else
        for i = 0.3, -1, -0.1 do
            Window.WindowFrame.Position = UDim2.new(i, 0, 0.2, 0)
            task.wait(0.02)
        end
        Window.WindowFrame.Visible = false
    end
end)

--============================--
--==     MENU COLOR THEME    ==--
--============================--

OrionLib.ThemeObjects.BackgroundColor = Color3.fromRGB(30, 120, 40)
OrionLib.ThemeObjects.TopbarColor = Color3.fromRGB(40, 150, 40)
OrionLib.ThemeObjects.TabColor = Color3.fromRGB(25, 90, 25)
OrionLib.ThemeObjects.ElementColor = Color3.fromRGB(20, 70, 20)

--============================--
--==       TAB FARMING       ==--
--============================--

local TabFarm = Window:MakeTab({
    Name = "🌱 Farm",
    Icon = "rbxassetid://7734053426"
})

local seeds = {
    "Hạt Táo", "Hạt Khoai", "Hạt Cà Rốt", 
    "Hạt Lúa", "Hạt Lúa Mạch", "Hạt Đậu Xanh",
    "Hạt Dâu", "Hạt Bí Ngô", "Hạt Bắp"
}

local selectedSeed = nil
local AutoFarm = false

TabFarm:AddDropdown({
    Name = "Chọn Hạt Giống",
    Options = seeds,
    Callback = function(v)
        selectedSeed = v
    end
})

TabFarm:AddToggle({
    Name = "Tự động trồng cây",
    Default = false,
    Callback = function(v)
        AutoFarm = v
        while AutoFarm do
            task.wait(1)
            if selectedSeed then
                game.ReplicatedStorage.Events.Plant:FireServer(selectedSeed)
            end
        end
    end
})

TabFarm:AddToggle({
    Name = "Tự động thu hoạch",
    Default = false,
    Callback = function(v)
        while v do
            task.wait(0.5)
            game.ReplicatedStorage.Events.Harvest:FireServer()
        end
    end
})

--============================--
--==         TAB SHOP        ==--
--============================--

local TabShop = Window:MakeTab({
    Name = "🛒 Cửa Hàng",
    Icon = "rbxassetid://7733960981"
})

TabShop:AddLabel("Mua Hạt Giống")

for _, s in ipairs(seeds) do
    TabShop:AddButton({
        Name = "Mua " .. s,
        Callback = function()
            game.ReplicatedStorage.Events.BuySeed:FireServer(s)
        end
    })
end

TabShop:AddLabel("Mua Gear")

local GearList = {
    "Cuốc Sắt", "Cuốc Vàng", "Cuốc Kim Cương",
    "Bình Tưới", "Rìu Gỗ", "Rìu Sắt"
}

for _, g in ipairs(GearList) do
    TabShop:AddButton({
        Name = "Mua " .. g,
        Callback = function()
            game.ReplicatedStorage.Events.BuyGear:FireServer(g)
        end
    })
end

--============================--
--==        TAB SETTING      ==--
--============================--

local TabSetting = Window:MakeTab({
    Name = "⚙ Cài Đặt",
    Icon = "rbxassetid://7733998505"
})

TabSetting:AddToggle({
    Name = "Noclip (xuyên vật thể)",
    Default = false,
    Callback = function(v)
        for _, part in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not v
            end
        end
    end
})

TabSetting:AddSlider({
    Name = "Nhảy cao",
    Min = 50, Max = 300, Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

TabSetting:AddSlider({
    Name = "Tốc độ chạy",
    Min = 16, Max = 200, Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

TabSetting:AddToggle({
    Name = "Tăng FPS",
    Default = false,
    Callback = function(v)
        setfpscap(v and 240 or 60)
    end
})

TabSetting:AddToggle({
    Name = "ESP Người Chơi",
    Default = false,
    Callback = function(v)
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                if v then
                    local esp = Instance.new("Highlight")
                    esp.Name = "ESP_BOX"
                    esp.Parent = plr.Character
                    esp.FillTransparency = 1
                    esp.OutlineColor = Color3.fromRGB(255, 0, 0)
                else
                    if plr.Character and plr.Character:FindFirstChild("ESP_BOX") then
                        plr.Character.ESP_BOX:Destroy()
                    end
                end
            end
        end
    end
})

--============================--
--==     TAB MOVEMENT        ==--
--============================--

local TabMovement = Window:MakeTab({
    Name = "🕊 Di Chuyển",
    Icon = "rbxassetid://7734053426"
})

local Flying = false
local SpeedHack = false

TabMovement:AddToggle({
    Name = "Fly (Bay)",
    Default = false,
    Callback = function(v)
        Flying = v
        local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

        while Flying do
            task.wait()
            hrp.Velocity = hrp.CFrame.LookVector * 50
        end
    end
})

TabMovement:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(v)
        SpeedHack = v
        while SpeedHack do
            task.wait()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 200
        end
    end
})

--============================--
--==     START UI            ==--
--============================--
OrionLib:Init()
