-- إعداد القيم
local JumpPower = 5000  -- القوة التي تجعل اللاعب يقفز لمسافة كبيرة
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- وظيفة القفز العميق
local function highJump()
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    Humanoid.JumpPower = JumpPower
    Humanoid:Move(Vector3.new(0, 0, 0)) -- التأكد من أن اللاعب يتحرك

    -- تعيين القفز لمرة واحدة
    if not Humanoid:GetState() == Enum.HumanoidStateType.Seated then
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        Humanoid:Move(Vector3.new(0, JumpPower, 0))  -- القفز لمسافة عالية
    end
end

-- ربط القفز مع الضغط على زر القفز في اللعبة
game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end  -- إذا تم معالجة الإدخال من قبل آخر، لا نحتاج للمتابعة

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        highJump()  -- عندما يضغط اللاعب على مسافة، يتم القفز لمسافة بعيدة
    end
end)
