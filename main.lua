--==============================
-- nazu hub - Fling Edition
--==============================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local PlayerList = Instance.new("ScrollingFrame")
local FlingButton = Instance.new("TextButton")
local FlingAllButton = Instance.new("TextButton")
local TargetLabel = Instance.new("TextLabel")

-- UIの基本設定
ScreenGui.Name = "nazu_hub"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true -- ドラッグ可能

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "nazu hub"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 25
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

TargetLabel.Parent = MainFrame
TargetLabel.Position = UDim2.new(0, 0, 0, 45)
TargetLabel.Size = UDim2.new(1, 0, 0, 20)
TargetLabel.Text = "Target: None"
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

PlayerList.Parent = MainFrame
PlayerList.Position = UDim2.new(0.05, 0, 0.2, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0.4, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 5, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

FlingButton.Name = "FlingButton"
FlingButton.Parent = MainFrame
FlingButton.Position = UDim2.new(0.05, 0, 0.65, 0)
FlingButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingButton.Text = "Fling Target (OFF)"
FlingButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)

FlingAllButton.Name = "FlingAllButton"
FlingAllButton.Parent = MainFrame
FlingAllButton.Position = UDim2.new(0.05, 0, 0.8, 0)
FlingAllButton.Size = UDim2.new(0.9, 0, 0, 40)
FlingAllButton.Text = "FLING ALL (CHAOS)"
FlingAllButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FlingAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)

--==============================
-- Fling ロジック (物理演算破壊)
--==============================
local target = nil
local flingActive = false

local function fling(targetChar)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHrp = targetChar:FindFirstChild("HumanoidRootPart")
    if hrp and tHrp then
        -- 自分の体を高速回転させて物理エンジンをバグらせる
        local oldVel = hrp.Velocity
        hrp.Velocity = Vector3.new(500000, 500000, 500000) -- 超高速移動
        hrp.CFrame = tHrp.CFrame
        task.wait(0.1)
        hrp.Velocity = oldVel
    end
end

-- プレイヤーリスト更新
local function updateList()
    for _, v in pairs(PlayerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local yPos = 0
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Parent = PlayerList
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, yPos)
            btn.Text = p.Name
            btn.Callback = function() end -- ボタンとして機能させるため
            btn.MouseButton1Click:Connect(function()
                target = p
                TargetLabel.Text = "Target: " .. p.Name
            end)
            yPos = yPos + 35
        end
    end
end
updateList()

-- Flingループ
task.spawn(function()
    while task.wait() do
        if flingActive and target and target.Character then
            fling(target.Character)
        end
    end
end)

FlingButton.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    FlingButton.Text = flingActive and "Fling Target (ON)" or "Fling Target (OFF)"
end)

FlingAllButton.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            fling(p.Character)
            task.wait(0.1)
        end
    end
end)

print("nazu hub loaded!")
