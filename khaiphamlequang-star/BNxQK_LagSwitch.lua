--// BNxQK Lag Switch (Fixed Intro)

local plrs = game:GetService("Players")
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local lp = plrs.LocalPlayer
local gui = lp:WaitForChild("PlayerGui")

-- Hàm tạo màu HSV
local function hsv(h,s,v)
	local i = math.floor(h*6)
	local f = h*6 - i
	local p = v*(1-s)
	local q = v*(1-f*s)
	local t = v*(1-(1-f)*s)
	i = i%6
	if i==0 then return Color3.new(v,t,p)
	elseif i==1 then return Color3.new(q,v,p)
	elseif i==2 then return Color3.new(p,v,t)
	elseif i==3 then return Color3.new(p,q,v)
	elseif i==4 then return Color3.new(t,p,v)
	else return Color3.new(v,p,q) end
end

-- ==========================================
-- INTRO (FIXED: HIỆN CHỮ 100%)
-- ==========================================
local function playIntro()
	local scr = Instance.new("ScreenGui", gui)
	scr.Name = "ANGEL_INTRO"
	scr.DisplayOrder = 100 -- Đảm bảo đè lên mọi UI khác
	scr.ResetOnSpawn = false

	local f = Instance.new("Frame", scr)
	f.Size = UDim2.new(1, 0, 1, 0)
	f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	f.BorderSizePixel = 0
	f.ZIndex = 1

	local txt = Instance.new("TextLabel", f)
	txt.AnchorPoint = Vector2.new(0.5, 0.5)
	txt.Position = UDim2.new(0.5, 0, 0.5, 0)
	txt.Size = UDim2.new(0.8, 0, 0.3, 0)
	txt.Font = Enum.Font.GothamBlack
	txt.TextScaled = true
	txt.BackgroundTransparency = 1
	txt.TextTransparency = 1
	txt.ZIndex = 2 -- Chữ phải nằm trên Frame đen

	local hue = 0
	local conn = run.RenderStepped:Connect(function(dt)
		hue = (hue + dt * 0.5) % 1
		txt.TextColor3 = hsv(hue, 1, 1)
	end)

	-- Logic xuất hiện chữ
	local function show(str)
		txt.Text = str
		for i = 1, 0, -0.05 do 
			txt.TextTransparency = i 
			task.wait(0.04) 
		end
		task.wait(0.8)
		for i = 0, 1, 0.05 do 
			txt.TextTransparency = i 
			task.wait(0.04) 
		end
	end

	show("Introducing")
	show("Bùi Nhật x Quang Khải")

	conn:Disconnect()
	scr:Destroy()
end

-- ==========================================
-- MAIN UI (SQUARE BNxQK)
-- ==========================================
local function makeUI()
	for _, v in pairs(gui:GetChildren()) do
		if v.Name == "BNxQK_LagUI" then v:Destroy() end
	end

	local scr = Instance.new("ScreenGui", gui)
	scr.Name = "BNxQK_LagUI"
	scr.ResetOnSpawn = false

	local MainPanel = Instance.new("Frame", scr)
	MainPanel.Size = UDim2.new(0, 110, 0, 110)
	MainPanel.Position = UDim2.new(0.5, -55, 0.4, 0)
	MainPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainPanel.Active = true
	MainPanel.BorderSizePixel = 0
	
	local Corner = Instance.new("UICorner", MainPanel)
	Corner.CornerRadius = UDim.new(0, 15)

	local Stroke = Instance.new("UIStroke", MainPanel)
	Stroke.Thickness = 4
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local Title = Instance.new("TextLabel", MainPanel)
	Title.Size = UDim2.new(1, 0, 0.6, 0)
	Title.Position = UDim2.new(0, 0, 0.1, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "BNxQK"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 20
	Title.ZIndex = 2

	local Status = Instance.new("TextLabel", MainPanel)
	Status.Size = UDim2.new(1, 0, 0.3, 0)
	Status.Position = UDim2.new(0, 0, 0.6, 0)
	Status.BackgroundTransparency = 1
	Status.Text = "READY"
	Status.TextColor3 = Color3.fromRGB(255, 255, 255)
	Status.Font = Enum.Font.Code
	Status.TextSize = 13
	Status.ZIndex = 2

	local ClickButton = Instance.new("TextButton", MainPanel)
	ClickButton.Size = UDim2.new(0.7, 0, 0.7, 0)
	ClickButton.Position = UDim2.new(0.15, 0, 0.15, 0)
	ClickButton.BackgroundTransparency = 1
	ClickButton.Text = ""
	ClickButton.ZIndex = 3

	-- Kéo thả
	local dragging, dragStart, startPos
	MainPanel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainPanel.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Lag Switch Logic
	local OnCooldown = false
	ClickButton.MouseButton1Click:Connect(function()
		if OnCooldown then return end
		OnCooldown = true
		Status.Text = "WAIT"
		Status.TextColor3 = Color3.fromRGB(255, 50, 50)

		local t = os.clock()
		while os.clock() - t < 0.4 do
			for i = 1, 1000000 do end 
		end

		task.wait(0.5)
		Status.Text = "READY"
		Status.TextColor3 = Color3.fromRGB(255, 255, 255)
		OnCooldown = false
	end)

	-- RGB Effect
	run.RenderStepped:Connect(function()
		local h = (tick() * 0.5) % 1
		local color = hsv(h, 1, 1)
		Stroke.Color = color
		Title.TextColor3 = color
	end)
end

-- Chạy Script
task.spawn(function()
	playIntro()
	makeUI()
end)
