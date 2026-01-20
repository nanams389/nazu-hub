--==============================
-- nazu hub v2 - Exterminate Edition
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

-- UIデザイン維持
ScreenGui.Name = "nazu_hub_v2"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

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
-- 🌪️ 殲滅型 Fling ロジック
--==============================
local target = nil
local flingActive = false
local flingAllActive = false

-- 物理破壊エネルギー最大化
local function SuperPowerUp()
    local c = lp.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    c.Humanoid.PlatformStand = true
    
    -- 高速回転と疑似的な重力無視
    local bav = hrp:FindFirstChild("FlingEngine") or Instance.new("BodyAngularVelocity")
    bav.Name = "FlingEngine"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 1250000 -- 出力アップ
    bav.AngularVelocity = Vector3.new(0, 999999, 0)
    bav.Parent = hrp

    for _, v in pairs(c:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Velocity = Vector3.new(25000, 25000, 25000) -- 衝突エネルギー強化
        end
    end
end

-- ターゲットを飛ばしたか判定する関数
local function isFlinged(targetChar)
    if not targetChar then return true end
    local tHrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not tHrp then return true end
    
    -- 相手の速度が異常に速い、または高度が極端に変わったら「飛ばした」とみなす
    if tHrp.Velocity.Magnitude > 150 or tHrp.Position.Y > 500 or tHrp.Position.Y < -50 then
        return true
    end
    return false
end

-- メインループ (最速処理)
rs.RenderStepped:Connect(function()
    if not (flingActive or flingAllActive) then
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.PlatformStand = false
        end
        return 
    end
    
    local c = lp.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    SuperPowerUp()

    if flingAllActive then
        -- サーバー内の全員をスキャンして未吹っ飛ばしの人を探す
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart
                -- まだ飛んでいない奴がいたらワープして仕留める
                if not isFlinged(p.Character) then
                    hrp.CFrame = tHrp.CFrame * CFrame.new(0, -1.8, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    break -- 一人仕留めるまで集中
                end
            end
        end
    elseif flingActive and target and target.Character then
        local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if tHrp then
            -- ターゲットの真下から高速バイブレーション攻撃
            hrp.CFrame = tHrp.CFrame * CFrame.new(math.random(-1,1)/10, -1.8, math.random(-1,1)/10)
        end
    end
end)

--==============================
-- UI更新・ボタン設定
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
FlingButton.Text = "Kill Target (OFF)"
FlingButton.BackgroundColor3 = Color3.fromRGB(40, 5, 5)
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", FlingButton).CornerRadius = UDim.new(0, 8)

FlingButton.MouseButton1Click:Connect(function()
    if not target then return end
    flingActive = not flingActive
    FlingButton.Text = flingActive and "KILLING... (ON)" or "Kill Target (OFF)"
    FlingButton.BackgroundColor3 = flingActive and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 5, 5)
end)

FlingAllButton.Parent = MainFrame
FlingAllButton.Position = UDim2.new(0.05, 0, 0.8, 0)
FlingAllButton.Size = UDim2.new(0.9, 0, 0, 45)
FlingAllButton.Text = "GENOCIDE MODE (OFF)"
FlingAllButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
FlingAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingAllButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", FlingAllButton).CornerRadius = UDim.new(0, 8)

FlingAllButton.MouseButton1Click:Connect(function()
    flingAllActive = not flingAllActive
    FlingAllButton.Text = flingAllActive and "GENOCIDE (ON)" or "GENOCIDE MODE (OFF)"
    FlingAllButton.BackgroundColor3 = flingAllActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
end)
