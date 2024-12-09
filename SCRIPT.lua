-- إعداد القيم الأساسية
local Speed = 50
local JumpPower = 150

-- ضبط القيم عند تغيير الشخصية
local function setupMovement()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = Speed
    humanoid.JumpPower = JumpPower
end

-- إنشاء واجهة متطورة
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AdvancedMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Advanced Features Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.SourceSans

-- إنشاء وظيفة لتوليد الأزرار والشروحات
local function createButton(parent, text, description, pos, color, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.6, 0, 0, 40)
    button.Position = pos
    button.Text = text
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.new(0, 0, 0)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSans
    button.MouseButton1Click:Connect(callback)

    -- وصف الزر
    local tooltip = Instance.new("TextLabel", parent)
    tooltip.Size = UDim2.new(0.3, 0, 0, 40)
    tooltip.Position = UDim2.new(pos.X.Scale + 0.65, 0, pos.Y.Scale, 0)
    tooltip.BackgroundTransparency = 1
    tooltip.Text = description
    tooltip.TextColor3 = Color3.new(1, 1, 1)
    tooltip.TextSize = 14
    tooltip.Font = Enum.Font.SourceSans
    tooltip.TextXAlignment = Enum.TextXAlignment.Left
end

-- إضافة الأزرار مع الشرح
createButton(frame, "Toggle High Jump", "تبديل بين القفز العالي والعادي", UDim2.new(0.05, 0, 0.2, 0), Color3.fromRGB(0, 255, 0), function()
    JumpPower = JumpPower == 150 and 50 or 150
    setupMovement()
end)

createButton(frame, "Toggle Speed", "تبديل بين السرعة العالية والعادية", UDim2.new(0.05, 0, 0.4, 0), Color3.fromRGB(0, 255, 255), function()
    Speed = Speed == 50 and 16 or 50
    setupMovement()
end)

createButton(frame, "Resize Menu", "تكبير وتصغير الواجهة", UDim2.new(0.05, 0, 0.6, 0), Color3.fromRGB(0, 0, 255), function()
    frame.Size = frame.Size == UDim2.new(0, 400, 0, 300) and UDim2.new(0, 500, 0, 400) or UDim2.new(0, 400, 0, 300)
end)

createButton(frame, "Delete Menu", "حذف الواجهة بالكامل", UDim2.new(0.05, 0, 0.8, 0), Color3.fromRGB(255, 0, 0), function()
    gui:Destroy()
end)

-- تطبيق الإعدادات الأولية
setupMovement()
