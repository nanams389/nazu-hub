--==============================
-- nazu hub v3 - Chaos Fusion Fling
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

-- UIデザイン (維持)
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
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

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
Instance.new("UIListLayout", PlayerList).Padding = UDim.new(0, 5)

--==============================
-- 🌪️ 改良：カオス回転 Fling ロジック
--==============================
local target = nil
local flingActive = false
local flingAllActive = false
local flying = false
local flySpeed = 50

local function ChaosFling(TargetChar)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local tHrp = TargetChar:FindFirstChild("HumanoidRootPart")
    if not hrp or not tHrp then return end

    lp.Character.Humanoid.PlatformStand = true
    
    -- 🌪️ [強化] 全軸デタラメ回転 (Chaos Rotation)
    local bav = hrp:FindFirstChild("FlingEngine") or Instance.new("BodyAngularVelocity")
    bav.Name = "FlingEngine"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 10000000 -- 最大出力
    -- 全方向にデタラメな回転力を与える (変な方向に回転しまくる)
    bav.AngularVelocity = Vector3.new(math.random(-999999, 999999), math.random(-999999, 999999), math.random(-999999, 999999))
    bav.Parent = hrp

    -- 🌟 相手の「ど真ん中」に合体 ＋ 微振動
    local shake = Vector3.new(math.random(-5, 5)/100, math.random(-5, 5)/100, math.random(-5, 5)/100)
    hrp.CFrame = tHrp.CFrame * CFrame.new(shake)
    
    -- 自分のパーツの速度もバグらせる
    for _, v in pairs(lp.Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(100000, 100000, 100000)
            v.CanCollide = false
        end
    end
end

-- Fly ロジック (維持)
task.spawn(function()
    local bg = Instance.new("BodyGyro")
    local bv = Instance.new("BodyVelocity")
    bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    rs.RenderStepped:Connect(function()
        if flying then
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                bg.Parent = hrp; bv.Parent = hrp
                bg.CFrame = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
                bv.Velocity = dir * flySpeed
            end
        else
            bg.Parent = nil; bv.Parent = nil
        end
    end)
end)

-- 🌪️ メインループ
rs.RenderStepped:Connect(function()
    if not (flingActive or flingAllActive) then
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.PlatformStand = false
            if lp.Character.HumanoidRootPart:FindFirstChild("FlingEngine") then
                lp.Character.HumanoidRootPart.FlingEngine:Destroy()
            end
        end
        return 
    end

    if flingAllActive then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart
                if tHrp.Velocity.Magnitude < 200 then
                    ChaosFling(p.Character)
                    break 
                end
            end
        end
    elseif flingActive and target and target.Character then
        ChaosFling(target.Character)
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
            btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Text = p.Name; btn.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(function() target = p; TargetLabel.Text = "Target: "..p.Name end)
        end
    end
end
updateList()

local function StyleButton(btn, color)
    btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
end

FlingButton.Parent = MainFrame; FlingButton.Position = UDim2.new(0.05, 0, 0.58, 0); FlingButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingButton.Text = "CHAOS KILL (OFF)"; StyleButton(FlingButton, Color3.fromRGB(50, 0, 0))
FlingButton.MouseButton1Click:Connect(function()
    if not target then return end
    flingActive = not flingActive
    FlingButton.Text = flingActive and "KILLING..." or "CHAOS KILL (OFF)"
    FlingButton.BackgroundColor3 = flingActive and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 0, 0)
end)

FlingAllButton.Parent = MainFrame; FlingAllButton.Position = UDim2.new(0.05, 0, 0.7, 0); FlingAllButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingAllButton.Text = "GOD GENOCIDE (OFF)"; StyleButton(FlingAllButton, Color3.fromRGB(80, 0, 0))
FlingAllButton.MouseButton1Click:Connect(function()
    flingAllActive = not flingAllActive
    FlingAllButton.Text = flingAllActive and "GENOCIDE ON" or "GOD GENOCIDE (OFF)"
    FlingAllButton.BackgroundColor3 = flingAllActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 0, 0)
end)

FlyButton.Parent = MainFrame; FlyButton.Position = UDim2.new(0.05, 0, 0.82, 0); FlyButton.Size = UDim2.new(0.9, 0, 0, 40)
FlyButton.Text = "FLY MODE (OFF)"; StyleButton(FlyButton, Color3.fromRGB(0, 50, 0))
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    FlyButton.Text = flying and "FLYING ON" or "FLY MODE (OFF)"
    FlyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 50, 0)
end)
