--==============================
-- nazu hub - Ultimate Fling (Universal)
--==============================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local PlayerList = Instance.new("ScrollingFrame")
local FlingButton = Instance.new("TextButton")
local FlingAllButton = Instance.new("TextButton")
local TargetLabel = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")

-- UIの親設定
ScreenGui.Name = "nazu_hub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- メインフレーム (デザイン強化)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- タイトル
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "nazu hub"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

-- ターゲット表示
TargetLabel.Parent = MainFrame
TargetLabel.Position = UDim2.new(0, 0, 0, 45)
TargetLabel.Size = UDim2.new(1, 0, 0, 25)
TargetLabel.Text = "Target: None"
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.BackgroundTransparency = 1

-- プレイヤーリスト
PlayerList.Parent = MainFrame
PlayerList.Position = UDim2.new(0.05, 0, 0.22, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0.45, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0) -- 自動調整
PlayerList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerList.BorderSizePixel = 0

UIListLayout.Parent = PlayerList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

--==============================
-- 🚀 Fling 心臓部ロジック (R15対応)
--==============================
local Target = nil
local Flinging = false

local function PowerFling(TargetChar)
    local lp = game.Players.LocalPlayer
    local c = lp.Character
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local tHrp = TargetChar:FindFirstChild("HumanoidRootPart")
    
    if hrp and tHrp then
        -- 物理エンジンを破壊するトルク設定
        local Vel = Instance.new("BodyAngularVelocity")
        Vel.MaxTorque = Vector3.new(1, 1, 1) * math.huge
        Vel.P = math.huge
        Vel.AngularVelocity = Vector3.new(0, 99999, 0) -- 超高速回転
        Vel.Parent = hrp
        
        -- 相手の座標に一瞬でめり込む
        hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 0.1)
        hrp.Velocity = Vector3.new(99999, 99999, 99999)
        
        task.wait(0.1)
        Vel:Destroy()
    end
end

-- リスト更新
local function RefreshList()
    for _, v in pairs(PlayerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Parent = PlayerList
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                Target = p
                TargetLabel.Text = "Target: " .. p.Name
            end)
        end
    end
end
RefreshList()

-- ボタン動作
FlingButton.Parent = MainFrame
FlingButton.Position = UDim2.new(0.05, 0, 0.7, 0)
FlingButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingButton.Text = "Fling Target (OFF)"
FlingButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local fbCorner = Instance.new("UICorner")
fbCorner.Parent = FlingButton

FlingButton.MouseButton1Click:Connect(function()
    if not Target then return end
    Flinging = not Flinging
    FlingButton.Text = Flinging and "Flinging... (ON)" or "Fling Target (OFF)"
    FlingButton.BackgroundColor3 = Flinging and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(40, 0, 0)
end)

FlingAllButton.Parent = MainFrame
FlingAllButton.Position = UDim2.new(0.05, 0, 0.85, 0)
FlingAllButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingAllButton.Text = "FLING ALL"
FlingAllButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
local fabCorner = Instance.new("UICorner")
fabCorner.Parent = FlingAllButton

FlingAllButton.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            PowerFling(p.Character)
        end
    end
end)

-- ループ処理
task.spawn(function()
    while task.wait() do
        if Flinging and Target and Target.Character then
            PowerFling(Target.Character)
        end
    end
end)
