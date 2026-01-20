--==============================
-- nazu hub v3 - GOD SPEED & FLY
--==============================
local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local PlayerList = Instance.new("ScrollingFrame")
local FlingButton = Instance.new("TextButton")
local FlingAllButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local TargetLabel = Instance.new("TextLabel")

-- UIデザイン強化 (ネオンブラック & 角丸)
ScreenGui.Name = "nazu_hub_v3"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "NAZU HUB V3"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 26
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

TargetLabel.Parent = MainFrame
TargetLabel.Position = UDim2.new(0, 0, 0, 55)
TargetLabel.Size = UDim2.new(1, 0, 0, 25)
TargetLabel.Text = "Target: None"
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.BackgroundTransparency = 1

PlayerList.Parent = MainFrame
PlayerList.Position = UDim2.new(0.05, 0, 0.2, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0.35, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerList.BorderSizePixel = 0
local UIList = Instance.new("UIListLayout", PlayerList)
UIList.Padding = UDim.new(0, 5)

--==============================
-- 🚀 Fling & Fly ロジック
--==============================
local target = nil
local flingActive = false
local flingAllActive = false
local flying = false
local flySpeed = 50

-- 物理破壊最大化 (God Speed)
local function GodFling()
    local c = lp.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    c.Humanoid.PlatformStand = true
    
    local bav = hrp:FindFirstChild("FlingEngine") or Instance.new("BodyAngularVelocity")
    bav.Name = "FlingEngine"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 2000000 
    bav.AngularVelocity = Vector3.new(0, 999999, 0)
    bav.Parent = hrp

    for _, v in pairs(c:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Velocity = Vector3.new(50000, 50000, 50000) -- 出力倍増
        end
    end
end

-- Fly 機能
task.spawn(function()
    local bg = Instance.new("BodyGyro")
    local bv = Instance.new("BodyVelocity")
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    rs.RenderStepped:Connect(function()
        if flying then
            local c = lp.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                bg.Parent = hrp
                bv.Parent = hrp
                bg.CFrame = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
                bv.Velocity = dir * flySpeed
            end
        else
            bg.Parent = nil
            bv.Parent = nil
        end
    end)
end)

-- メイン実行ループ (Fling All 爆速化)
rs.RenderStepped:Connect(function()
    if not (flingActive or flingAllActive) then return end
    GodFling()

    local hrp = lp.Character.HumanoidRootPart
    if flingAllActive then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart
                -- 吹っ飛び判定を甘くして次へ行く速度を上げる
                if tHrp.Velocity.Magnitude < 200 then
                    hrp.CFrame = tHrp.CFrame * CFrame.new(0, -1.8, 0)
                    break
                end
            end
        end
    elseif flingActive and target and target.Character then
        local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if tHrp then
            hrp.CFrame = tHrp.CFrame * CFrame.new(0, -1.8, 0)
        end
    end
end)

--==============================
-- UIインタラクション
--==============================
local function updateList()
    for _, v in pairs(PlayerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", PlayerList)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(function()
                target = p
                TargetLabel.Text = "Target: " .. p.Name
            end)
        end
    end
end
updateList()

local function StyleButton(btn, color)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
end

FlingButton.Parent = MainFrame
FlingButton.Position = UDim2.new(0.05, 0, 0.58, 0)
FlingButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingButton.Text = "FAST KILL (OFF)"
StyleButton(FlingButton, Color3.fromRGB(50, 0, 0))

FlingButton.MouseButton1Click:Connect(function()
    if not target then return end
    flingActive = not flingActive
    FlingButton.Text = flingActive and "KILLING... (ON)" or "FAST KILL (OFF)"
    FlingButton.BackgroundColor3 = flingActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 0, 0)
end)

FlingAllButton.Parent = MainFrame
FlingAllButton.Position = UDim2.new(0.05, 0, 0.7, 0)
FlingAllButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingAllButton.Text = "GOD GENOCIDE (OFF)"
StyleButton(FlingAllButton, Color3.fromRGB(80, 0, 0))

FlingAllButton.MouseButton1Click:Connect(function()
    flingAllActive = not flingAllActive
    FlingAllButton.Text = flingAllActive and "GENOCIDE (ON)" or "GOD GENOCIDE (OFF)"
    FlingAllButton.BackgroundColor3 = flingAllActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 0, 0)
end)

FlyButton.Parent = MainFrame
FlyButton.Position = UDim2.new(0.05, 0, 0.82, 0)
FlyButton.Size = UDim2.new(0.9, 0, 0, 40)
FlyButton.Text = "FLY MODE (OFF)"
StyleButton(FlyButton, Color3.fromRGB(0, 50, 0))

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    FlyButton.Text = flying and "FLYING (ON)" or "FLY MODE (OFF)"
    FlyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 50, 0)
end)
