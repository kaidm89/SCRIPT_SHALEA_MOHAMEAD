local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local settings = {
    speed = 50,
    jumpPower = 150,
    flySpeed = 100,
    noclip = false,
    flyEnabled = false,
    guiVisible = true
}

-- إعدادات الطيران
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
flyVelocity.Velocity = Vector3.zero

-- تفعيل الطيران
local function toggleFly(state)
    settings.flyEnabled = state
    if state then
        flyVelocity.Parent = Character:FindFirstChild("HumanoidRootPart")
        RunService.Heartbeat:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                flyVelocity.Velocity = Vector3.new(0, settings.flySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.W) then
                flyVelocity.Velocity = Character.HumanoidRootPart.CFrame.LookVector * settings.flySpeed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                flyVelocity.Velocity = -Character.HumanoidRootPart.CFrame.LookVector * settings.flySpeed
            else
                flyVelocity.Velocity = Vector3.zero
            end
        end)
    else
        flyVelocity.Parent = nil
    end
end

-- اختراق الجدران
local function toggleNoclip(state)
    settings.noclip = state
    RunService.Stepped:Connect(function()
        if settings.noclip and Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- تعديل السرعة والقفز
local function modifySpeedAndJump()
    if Character and Character:FindFirstChild("Humanoid") then
        local humanoid = Character:FindFirstChild("Humanoid")
        humanoid.WalkSpeed = settings.speed
        humanoid.JumpPower = settings.jumpPower
    end
end

-- الطيران عند الاقتراب من شخص آخر
local function flyToOtherPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge

    -- تحديد أقرب لاعب
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                nearestPlayer = player
                shortestDistance = distance
            end
        end
    end

    -- إذا كان هناك لاعب قريب، الطيران نحوه
    if nearestPlayer and shortestDistance <= 15 then
        local targetPosition = nearestPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 1000000, 0)  -- الطيران للأعلى بمقدار 1,000,000 متر
        flyVelocity.Velocity = (targetPosition - Character.HumanoidRootPart.Position).unit * settings.flySpeed
    end
end

-- إنشاء واجهة المستخدم المتقدمة
local gui = Instance.new("ScreenGui", game.CoreGui)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
title.Text = "لوحة التحكم المتقدمة"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26

local sectionsFrame = Instance.new("Frame", mainFrame)
sectionsFrame.Size = UDim2.new(1, 0, 1, -100)
sectionsFrame.Position = UDim2.new(0, 0, 0, 50)
sectionsFrame.BackgroundTransparency = 1

-- دالة لإنشاء الأزرار
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 50)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.AutoButtonColor = true
    button.MouseButton1Click:Connect(callback)
    return button
end

-- دالة لإنشاء منزلقات
local function createSlider(parent, labelText, minValue, maxValue, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.9, 0, 0, 50)
    frame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 50)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.TextSize = 16

    local slider = Instance.new("TextButton", frame)
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    slider.Text = ""
    slider.MouseButton1Down:Connect(function()
        local mousePosition = UserInputService:GetMouseLocation()
        local startPos = slider.AbsolutePosition.X
        local endPos = slider.AbsolutePosition.X + slider.AbsoluteSize.X
        local newValue = math.clamp((mousePosition.X - startPos) / (endPos - startPos), 0, 1)
        callback(minValue + newValue * (maxValue - minValue))
    end)
end

-- إضافة الأزرار والخيارات للواجهة
createButton(sectionsFrame, "تفعيل الطيران", function()
    toggleFly(not settings.flyEnabled)
end)

createButton(sectionsFrame, "اختراق الجدران", function()
    toggleNoclip(not settings.noclip)
end)

createButton(sectionsFrame, "الطيران إلى لاعب قريب", function()
    flyToOtherPlayer()
end)

createSlider(sectionsFrame, "سرعة المشي", 10, 150, function(value)
    settings.speed = value
    modifySpeedAndJump()
end)

createSlider(sectionsFrame, "القفز", 50, 300, function(value)
    settings.jumpPower = value
    modifySpeedAndJump()
end)

modifySpeedAndJump()
