local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FOV = 200 -- ขนาดของ FOV
local target = nil

-- ฟังก์ชันหาผู้เล่นที่ใกล้ที่สุดในระยะ FOV
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- สั่งให้กล้องเล็งไปที่หัว
RunService.RenderStepped:Connect(function()
    target = getClosestPlayer()
    if target and target.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
    end
end)
