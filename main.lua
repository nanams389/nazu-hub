--==============================
-- nazu hub - Ultimate Fling V2
--==============================
local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local PlayerList = Instance.new("ScrollingFrame")
local FlingButton = Instance.new("TextButton")
local FlingAllButton = Instance.new("TextButton")
local TargetLabel = Instance.new("TextLabel")

-- UI親設定
ScreenGui.Name = "nazu_hub_v2"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- UIデザイン (さらにリアルに)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "nazu hub v2"
Title.TextColor3 = Color3.fromRGB(255, 0, 50)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

TargetLabel.Parent = MainFrame
TargetLabel.Position = UDim2.new(0, 0, 0, 50)
TargetLabel.Size = UDim2.new(1, 0, 0, 25)
TargetLabel.Text = "Target: None"
TargetLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
TargetLabel.BackgroundTransparency = 1

PlayerList.Parent = MainFrame
PlayerList.Position = UDim2.new(0.05, 0, 0.22, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0.4, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerList.BorderSizePixel = 0
local UIList = Instance.new("UIListLayout", PlayerList)
UIList.Padding = UDim.new(0, 5)

--==============================
-- 🌪️ Fling 心臓部 (超高速回転ロジック)
--==============================
local target = nil
local flingActive = false
local flingAllActive = false

-- 自分の体を「武器」に変える関数
local function setupFling()
    local c = lp.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- 古い回転パーツを掃除
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "FlingEngine" then v:Destroy() end
    end

    -- 超高速回転パーツ作成
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "FlingEngine"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 1000000
    bav.AngularVelocity = Vector3.new(0, 999999, 0) -- 秒間約100万回転
    bav.Parent = hrp

    -- 物理的な衝突を強化
    for _, part in pairs(c:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false -- 自分が引っかからないように
            part.Velocity = Vector3.new(99999, 99999, 99999)
        end
    end
end

-- メイン実行ループ
rs.Stepped:Connect(function()
    if not (flingActive or flingAllActive) then return end
    
    local c = lp.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    setupFling() -- 回転を維持

    if flingAllActive then
        -- 全員を順番に吹っ飛ばす (Fling All)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.05)
            end
        end
    elseif flingActive and target and target.Character then
        -- 特定のターゲットを吹っ飛ばす
        local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if tHrp then
            hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 0.01) -- 中心にめり込む
        end
    end
end)

--==============================
-- ボタンとリストの更新
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

FlingButton.Parent = MainFrame
FlingButton.Position = UDim2.new(0.05, 0, 0.65, 0)
FlingButton.Size = UDim2.new(0.9, 0, 0, 45)
FlingButton.Text = "Fling Target (OFF)"
FlingButton.BackgroundColor3 = Color3.fromRGB(40, 5, 5)
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", FlingButton).CornerRadius = UDim.new(0, 8)

FlingButton.MouseButton1Click:Connect(function()
    if not target then return end
    flingActive = not flingActive
    FlingButton.Text = flingActive and "Flinging Target... (ON)" or "Fling Target (OFF)"
    FlingButton.BackgroundColor3 = flingActive and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 5, 5)
end)

FlingAllButton.Parent = MainFrame
FlingAllButton.Position = UDim2.new(0.05, 0, 0.8, 0)
FlingAllButton.Size = UDim2.new(0.9, 0, 0, 45)
FlingAllButton.Text = "FLING ALL (OFF)"
FlingAllButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
FlingAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingAllButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", FlingAllButton).CornerRadius = UDim.new(0, 8)

FlingAllButton.MouseButton1Click:Connect(function()
    flingAllActive = not flingAllActive
    FlingAllButton.Text = flingAllActive and "CHAOS MODE (ON)" or "FLING ALL (OFF)"
    FlingAllButton.BackgroundColor3 = flingAllActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
end)
