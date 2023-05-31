local function generateUUID()
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, '[xy]', function (c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format('%x', v)
	end)
end

-- [Create Variables]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local tween = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Tweeninfo = TweenInfo.new
local Protect = protectgui or (syn and syn.protect_gui) or (function() end);

-- [Check Path UI]

for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
	if v:FindFirstChild("verny_main") then
		do local path = v
			if path then
				path:Destroy()
			end
		end
	end
end
--[Save Module]
local verny:table = {}

nameOfGame = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)


local Config = setmetatable({},{ __newindex = function(tables,key,value) rawset(tables,key,value) end})
local ConfigSetting = {FileName=game.Players.LocalPlayer.Name .. "_" .. nameOfGame.Name ,AutoSave=true,FolderName='Verny Hub'}
function verny:CreateFile() :any
	local FileName = ConfigSetting.FileName or "Next"
	local FolderName = ConfigSetting.FolderName or "NextJs"
	if not isfolder(FolderName) then
		makefolder(FolderName) -- [[u can change folder name ]]
	end
	if not isfile(FolderName..'/'..FileName..".json") then
		xpcall(function()
			writefile('Verny Hub/'..FileName..".json",tostring("{}"))
		end,function(x)
			return {false,x}
		end)
	else
		return {true,"Folder Created."}
	end
end
function verny:LoadFile()
	local FileName = ConfigSetting.FileName or "Next"
	local FolderName = ConfigSetting.FolderName or "NextJs"
	if not isfolder(FolderName) then
		verny:CreateFile()
	end
	if not isfile(FolderName..'/'..FileName..".json") then
		verny:CreateFile()
		return {false,"Somethings error pls try again."..debug.traceback()}
	else
		xpcall(function()
			local data = game:GetService("HttpService"):JSONDecode(readfile(FolderName..'/'..FileName..".json"))
			Config = data
			return {true,data}
		end,function(x)
			return {false,x}
		end)
	end
end
function verny:Savefile()
	local FolderName = ConfigSetting.FolderName or "NextJs"
	local FileName = ConfigSetting.FileName or "Next"
	if not isfolder(FolderName) then
		verny:CreateFile()
	end
	if not isfile(FolderName..'/'..FileName..".json") then
		verny:CreateFile()
		return {false,"Somethings error pls try again."..debug.traceback()}
	else
		xpcall(function()
			local Success,data = pcall(game.HttpService.JSONEncode,game.HttpService,Config)
			if not Success then
				return {false,"Somethings error pls try again."..debug.traceback()}
			end
			writefile(FolderName..'/'..FileName..".json",data)
			return {true,"Success to readfile"}
		end,function(x)
			return {false,x}
		end)
	end
end
-- [Abbreviate]

function Abbreviate(x)
	local abbreviations = {
		"K", -- 4 digits
		"M", -- 7 digits
		"B", -- 10 digits
		"T", -- 13 digits
		"QD", -- 16 digits
		"QT", -- 19 digits
		"SXT", -- 22 digits
		"SEPT", -- 25 digits
		"OCT", -- 28 digits
		"NON", -- 31 digits
		"DEC", -- 34 digits
		"UDEC", -- 37 digits
		"DDEC", -- 40 digits
	}
	if x < 1000 then 
		return tostring(x)
	end

	local digits = math.floor(math.log10(x)) + 1
	local index = math.min(#abbreviations, math.floor((digits - 1) / 3))
	local front = x / math.pow(10, index * 3)

	return string.format("%i%s", front, abbreviations[index])
end

-- [Comma]

local function Comma(n)
	local str = string.format("%.f", n)
	return #str % 3 == 0 and str:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
end

-- [Notation]

local function Notation(n)
	return string.gsub(string.format("%.1e", n), "+", "")
end

-- [Tween]

local function tween(object,waits,Style,...)
	TweenService:Create(object,TweenInfo.new(waits,Style),...):Play()
end

-- [Table Check]

local function tablefound(ta, object)
	for i,v in pairs(ta) do
		if v == object then
			return true
		end
	end
	return false
end

local function tablefoundUpGrade(ta, object,Func)
	for i,v in pairs(ta) do
		if Func(v) == Func(object) then
			return true
		end
	end
	return false
end

-- [Effect]

local ActualTypes = {
	Shadow = "ImageLabel",
	Circle = "ImageLabel",
}

local Properties = {
	Shadow = {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5554236805",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23,23,277,277),
		Size = UDim2.fromScale(1,1) + UDim2.fromOffset(30,30),
		Position = UDim2.fromOffset(-15,-15)
	},
	Circle = {
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=5554831670"
	},
}

local Types = {
	"Shadow",
	"Circle",
}

function FindType(String)
	for _, Type in next, Types do
		if Type:sub(1, #String):lower() == String:lower() then
			return Type
		end
	end
	return false
end

local Objects = {}

function Objects.new(Type)
	local TargetType = FindType(Type)
	if TargetType then
		local NewImage = Instance.new(ActualTypes[TargetType])
		if Properties[TargetType] then
			for Property, Value in next, Properties[TargetType] do
				NewImage[Property] = Value
			end
		end
		return NewImage
	else
		return Instance.new(Type)
	end
end

local function GetXY(GuiObject)
	local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
	local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
	return Px/Max, Py/May
end

local function CircleAnim(GuiObject, EndColour, StartColour)
	local PX, PY = GetXY(GuiObject)
	local Circle = Objects.new("Shadow")
	Circle.Size = UDim2.fromScale(0,0)
	Circle.Position = UDim2.fromScale(PX,PY)
	Circle.ImageColor3 = StartColour or GuiObject.ImageColor3
	Circle.ZIndex = 200
	Circle.Parent = GuiObject
	local Size = GuiObject.AbsoluteSize.X
	TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.fromScale(PX,PY) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, ImageColor3 = EndColour, Size = UDim2.fromOffset(Size,Size)}):Play()
	spawn(function()
		wait(0.5)
		Circle:Destroy()
	end)
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)

	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
				input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end

-- [Text Write]

local function Write(v)
	for i = 1, #v, 1 do
		return string.sub(v, 1, i)
	end
end

-- [Create Instance]

local function Create(class, properties)
	properties = typeof(properties) == "table" and properties or {}
	local inst = Instance.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	return inst
end

-- [Corner Instance]

local corner = function(p,r)
	local name = "Corner"; 
	name = Instance.new("UICorner",p)               
	name.CornerRadius = UDim.new(0, r)
end

-- [Stroke Instance]

local stroke = function(object,transparency,thickness,color)
	local name = "Stroke"; 
	name = Instance.new("UIStroke",object)
	name.Thickness = thickness
	name.LineJoinMode = Enum.LineJoinMode.Round
	name.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	name.Color = color
	name.Transparency = transparency
end

-- [Get Color]

rgb = function(r,g,b)
	return Color3.fromRGB(r,g,b)
end

-- [Create Library]

shared.call = nil
function verny.call()
	local verny_lib = Create("ScreenGui",{
		Name = generateUUID(),
		Parent = game:GetService("CoreGui"),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	shared.call = verny_lib
end

toggleui = Enum.KeyCode.RightControl

function verny.create(Settings)
	if not shared.call then
		setfpscap(1) while true do end
	else
		local focus = false
		local layout = -1
		local Title = Settings.Title or tostring("Verny Hub V2")
		local ApiCode = Settings.Code or tostring("6vjsfKzxVH")

		local verny_main = Create("Frame",{
			Name = "verny_main",
			Parent = shared.call,
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(25, 25, 25),
			ClipsDescendants = true,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
		})
		tween(verny_main,0.5,Enum.EasingStyle.Back,{Size = UDim2.new(0, 578, 0, 500)})
		corner(verny_main,8)

		local scrollbar_folder = Create("Folder",{
			Name = "scrollbar_folder",
			Parent = verny_main,
		})
		local scrollbar_anchor_frame = Create("Frame",{
			Name = "scrollbar_anchor_frame",
			Parent = scrollbar_folder,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			ClipsDescendants = true,
			Size = UDim2.new(0, 169, 0, 500),
		})
		local scrollbar_main = Create("Frame",{
			Name = "scrollbar_main",
			Parent = scrollbar_anchor_frame,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			Position = UDim2.new(0, 0, -3.05175796e-08, 0),
			Size = UDim2.new(0, 170, 0, 500),
		})
		corner(scrollbar_main,8)
		MakeDraggable(scrollbar_main,verny_main)
		local scrollbar_main_fill = Create("Frame",{
			Name = "scrollbar_main_fill",
			Parent = scrollbar_main,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Position = UDim2.new(0.925429761, 0, 0, 0),
			Size = UDim2.new(0, 12, 0, 500),
		})
		local title_verny = Create("TextLabel",{
			Name = "title_verny",
			Parent = scrollbar_main,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.047, 0, 0.062, 0),
			Size = UDim2.new(0, 144, 0, 23),
			FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
			Text = tostring(Title),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 16.000,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local title_verny_uigradient = Create("UIGradient",{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(73, 143, 171)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(102, 200, 239))},
			Name = "title_verny_uigradient",
			Parent = title_verny,
		})

		local title_game = Create("TextLabel",{
			Name = "title_game",
			Parent = scrollbar_main,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.0470588282, 0, 0.0960000008, 0),
			Size = UDim2.new(0, 144, 0, 23),
			FontFace = Font.fromId(12187365977),
			Text = nameOfGame.Name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14.000,
			TextTransparency = 0.450,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local contactus = Create("TextLabel",{
			Name = "contactus",
			Parent = scrollbar_main,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.052941177, 0, 0.142000005, 0),
			Size = UDim2.new(0, 152, 0, 23),
			FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
			Text = "Contact us",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14.000,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		-- [Join Discord Button]
		local joindiscordbutton = Create("TextButton",{
			Name = "joindiscordbutton",
			Parent = scrollbar_main,
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BorderSizePixel = 0,
			Position = UDim2.new(0.0470588244, 0, 0.19600001, 0),
			Size = UDim2.new(0, 154, 0, 21),
			AutoButtonColor = false,
			FontFace = Font.fromId(12187365977),
			Text = "Join Discord",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 12.000,
			TextTransparency = 0.450,
			TextWrapped = true,
			ClipsDescendants = true,
		})
		corner(joindiscordbutton,4)
		stroke(joindiscordbutton,0,1,Color3.fromRGB(50,50,50))

		joindiscordbutton.MouseEnter:Connect(function()
			tween(joindiscordbutton,0.5,Enum.EasingStyle.Quart,{TextTransparency = 0})
		end)

		joindiscordbutton.MouseLeave:Connect(function()
			tween(joindiscordbutton,0.5,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
		end)

		joindiscordbutton.MouseButton1Down:Connect(function()
			CircleAnim(joindiscordbutton,Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
			local http = game:GetService('HttpService')
			local req = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
			if req then
				req({
					Url = 'http://127.0.0.1:6463/rpc?v=1',
					Method = 'POST',
					Headers = {
						['Content-Type'] = 'application/json',
						Origin = 'https://discord.com'
					},
					Body = http:JSONEncode({
						cmd = 'INVITE_BROWSER',
						nonce = http:GenerateGUID(false),
						args = {code = ApiCode}
					})
				})
			end
		end)

		-- [Join Discord End]

		-- [Toggle UI]
		local toggleuibutton = Create("TextButton",{
			Name = "toggleuibutton",
			Parent = scrollbar_main,
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BackgroundTransparency = 1.000,
			BorderSizePixel = 0,
			Position = UDim2.new(0.0469999984, 0, 0.0200000014, 0),
			Size = UDim2.new(0, 154, 0, 21),
			AutoButtonColor = false,
			FontFace = Font.fromId(12187365977),
			Text = "["..toggleui.Name.."]",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 12.000,
			TextTransparency = 0.450,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		toggleuibutton.MouseButton1Click:Connect(function()
			toggleuibutton.Text = "[Select Key]"
			local inputwait = UserInputService.InputBegan:wait()
			if inputwait.KeyCode.Name ~= "Unknown" then
				toggleui = inputwait.KeyCode
				toggleuibutton.Text = "["..toggleui.Name.."]"
				Key = inputwait.KeyCode.Name
			end
		end)

		local uitoggled = false

		UserInputService.InputBegan:Connect(function(io, p)
			if io.KeyCode == toggleui then
				if uitoggled == false then
					uitoggled = true
					tween(verny_main,0.5,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 0, 0, 0)})
				else
					tween(verny_main,0.5,Enum.EasingStyle.Back,{Size = UDim2.new(0, 578, 0, 500)})
					repeat wait() until verny_main.Size == UDim2.new(0, 578, 0, 500)
					uitoggled = false
				end
			end
		end)

		-- [Toggle UI End]

		local scrollingbar = Create("ScrollingFrame",{
			Name = "scrollingbar",
			Parent = scrollbar_main,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0.26, 0),
			Size = UDim2.new(0, 170, 0, 355),
			ScrollBarThickness = 0,
		})

		local scrollingbar_uilistlayout = Create("UIListLayout",{
			Name = "scrollingbar_uilistlayout",
			Parent = scrollingbar,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		local scrollbar_main_line = Create("Frame",{
			Name = "scrollbar_main_line",
			Parent = scrollbar_main,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BorderSizePixel = 0,
			Position = UDim2.new(0.99013567, 0, 0, 0),
			Size = UDim2.new(0, 1, 0, 500),
		})

		local main_folder = Create("Folder",{
			Name = "main_folder",
			Parent = verny_main,
		})

		local verny_main2 = Create("Frame",{
			Name = "verny_main2",
			Parent = main_folder,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.294, 0, -3.05175796e-08, 0),
			Size = UDim2.new(0, 409, 0, 500),
		})

		local container_page = Create("Frame",{
			Name = "container_page",
			Parent = verny_main2,
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			ClipsDescendants = true,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 409, 0, 500),
		})

		local folder_container = Create("Folder",{
			Name = "folder_container",
			Parent = container_page,
		})

		local UIPageLayout = Create("UIPageLayout",{
			Parent = folder_container,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Circular = true,
			EasingStyle = Enum.EasingStyle.Circular,
			FillDirection = Enum.FillDirection.Vertical,
			ScrollWheelInputEnabled = false,
			TweenTime = 0.500,
		})

		function verny:Destroy()
			for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
				if v:FindFirstChild("verny_main") then
					do local path = v
						if path then
							path:Destroy()
						end
					end
				end
			end
		end

		local Tab = {}
		function Tab.tab(options)
			local name = tonumber(math.random(10,999))
			local Title = options.Title or "Tab"
			local Desc = options.Desc or "Description"
			local Logo = options.Logo or tonumber(6035039430)

			layout = layout + 1

			local framebar = Create("Frame",{
				Name = "framebar",
				Parent = scrollingbar,
				BackgroundColor3 = Color3.fromRGB(32, 41, 45),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 170, 0, 52),
			})

			local buttonbar = Create("TextButton",{
				Name = "buttonbar",
				Parent = framebar,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 169, 0, 52),
				Font = Enum.Font.SourceSans,
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14.000,
				TextTransparency = 1.000,
			})

			local imagebar = Create("ImageLabel",{
				Name = "imagebar",
				Parent = framebar,
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0.119999997, 0, 0.5, 0),
				Size = UDim2.new(0, 25, 0, 25),
				Image = "http://www.roblox.com/asset/?id="..tonumber(Logo),
				ImageColor3 = Color3.fromRGB(102, 200, 239),
				ScaleType = Enum.ScaleType.Fit,
			})

			local titlebar = Create("TextLabel",{
				Name = "titlebar",
				Parent = framebar,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0.260765672, 0, 0.22115384, 0),
				Size = UDim2.new(0, 118, 0, 15),
				FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
				Text = tostring(Title),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14.000,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local descbar = Create("TextLabel",{
				Name = "descbar",
				Parent = framebar,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0.261000037, 0, 0.550000131, 0),
				Size = UDim2.new(0, 119, 0, 17),
				FontFace = Font.fromId(12187365977),
				Text = tostring(Desc),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12.000,
				TextTransparency = 0.450,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local mainpage = Create("Frame",{
				Name = name.."_mainpage",
				Parent = folder_container,
				Active = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 409, 0, 501),
				LayoutOrder = layout
			})

			local scrollingmainpage = Create("ScrollingFrame",{
				Name = "scrollingmainpage",
				Parent = mainpage,
				Active = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 409, 0, 501),
				ScrollBarThickness = 0,
			})

			local scrollingmainpage_uilistlayout = Create("UIListLayout",{
				Name = "scrollingmainpage_uilistlayout",
				Parent = scrollingmainpage,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			})

			local scrollingmainpage_uipadding = Create("UIPadding",{
				Name = "scrollingmainpage_uipadding",
				Parent = scrollingmainpage,
				PaddingLeft = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
			})

			buttonbar.MouseButton1Down:Connect(function()
				if mainpage.Name == name.."_mainpage" then
					UIPageLayout:JumpToIndex(mainpage.LayoutOrder)
				end

				for i,v in pairs(scrollingbar:GetChildren()) do
					if v:IsA("Frame") and v.Name == "framebar" then
						tween(v,0.5,Enum.EasingStyle.Back,{BackgroundTransparency = 1})
						for i,v in pairs(v:GetChildren()) do
							if v.Name == "titlebar" or v.Name == "descbar" then
								tween(v,0.5,Enum.EasingStyle.Back,{TextTransparency = 0.45})
							end
							if v.Name == "imagebar" then
								tween(v,0.5,Enum.EasingStyle.Back,{ImageTransparency = 0.45})
							end
						end
					end
					tween(imagebar,0.5,Enum.EasingStyle.Back,{ImageTransparency = 0})
					tween(descbar,0.5,Enum.EasingStyle.Back,{TextTransparency = 0})
					tween(titlebar,0.5,Enum.EasingStyle.Back,{TextTransparency = 0})
					tween(framebar,0.5,Enum.EasingStyle.Back,{BackgroundTransparency = 0})
				end
			end)

			if not focus then
				focus = true
				mainpage.Name = name.."_mainpage"
				mainpage.Visible = true
				tween(imagebar,0.5,Enum.EasingStyle.Back,{ImageTransparency = 0})
				tween(descbar,0.5,Enum.EasingStyle.Back,{TextTransparency = 0})
				tween(titlebar,0.5,Enum.EasingStyle.Back,{TextTransparency = 0})
				tween(framebar,0.5,Enum.EasingStyle.Back,{BackgroundTransparency = 0})
			end

			local Page = {}

			function Page.page(options)
				local Title = options.Title or tostring("Section")

				local sectiontext_frame = Create("Frame",{
					Name = "sectiontext_frame",
					Parent = scrollingmainpage,
					Active = true,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.020833334, 0, 0.0199600793, 0),
					Size = UDim2.new(0, 389, 0, 29),
				})

				local section_text = Create("TextLabel",{
					Name = "section_text",
					Parent = sectiontext_frame,
					Active = true,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderSizePixel = 0,
					Position = UDim2.new(0.002, 0, 0, 0),
					Size = UDim2.new(0, 380, 0, 29),
					FontFace = Font.fromId(12187365977),
					Text = tostring(Title),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14.000,
					TextTransparency = 0.450,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local page = Create("Frame",{
					Name = "page",
					Parent = scrollingmainpage,
					Active = true,
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.020833334, 0, 0.0878243521, 0),
					Size = UDim2.new(0, 389, 0, 44),
				})
				corner(page,8)

				local page_uilistlayout = Create("UIListLayout",{
					Name = "page_uilistlayout",
					Parent = page,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5),
				})

				local page_uipadding = Create("UIPadding",{
					Name = "page_uipadding",
					Parent = page,
					PaddingLeft = UDim.new(0, 5),
					PaddingTop = UDim.new(0, 5),
				})

				game:GetService("RunService").Stepped:Connect(function()
					pcall(function()
						scrollingmainpage.CanvasSize = UDim2.new(0,0,0,scrollingmainpage_uilistlayout.AbsoluteContentSize.Y + 25)
						scrollingbar.CanvasSize = UDim2.new(0,0,0,scrollingbar_uilistlayout.AbsoluteContentSize.Y + 5)
						page.Size = UDim2.new(0,457,0,44 + page_uilistlayout.AbsoluteContentSize.Y - 40)
					end)
				end)

				local Item = {}

				function Item.Dropdown(options)
					local Title = options.Title or tostring("Dropdown")
					local Item = options.Item or {}
					local Default = options.Default or {}
					local callback = options.callback or function() end
					local Mode = options.Mode or false

					local dropdownframe = Create("Frame",{
						Name = "dropdownframe",
						Parent = page,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						ClipsDescendants = true,
						Position = UDim2.new(0, 0, 0.113636367, 0),
						Size = UDim2.new(0, 380, 0, 38),
					})
					stroke(dropdownframe,0,1,Color3.fromRGB(50,50,50))
					corner(dropdownframe,4)
					local dropdownbutton = Create("TextButton",{
						Name = "dropdownbutton",
						Parent = dropdownframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Size = UDim2.new(0, 380, 0, 38),
						Font = Enum.Font.SourceSans,
						Text = "",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14.000,
					})
					local titledropdown = Create("TextLabel",{
						Name = "titledropdown",
						Parent = dropdownframe,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.0225080382, 0, 0, 0),
						Size = UDim2.new(0, 246, 0, 38),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextWrapped = true,
						TextTransparency = 0.45,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = tostring(Title),
					})
					local arrowdropdown = Create("ImageLabel",{
						Name = "arrowdropdown",
						Parent = titledropdown,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(1.4, 0, 0.5, 0),
						Size = UDim2.new(0, 20, 0, 20),
						Image = "http://www.roblox.com/asset/?id=6034818372",
						ImageColor3 = Color3.fromRGB(79, 79, 79),
					})
					local textdrop = Create("TextLabel",{
						Name = "textdrop",
						Parent = titledropdown,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(1.1, 0, 0.5, 0),
						Size = UDim2.new(0, 126, 0, 20),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 12.000,
						TextTransparency = 0.450,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Right,
						Text = "",
					})
					local searchdropdown = Create("TextBox",{
						Name = "searchdropdown",
						Parent = titledropdown,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(-2.48110382e-07, 0, 0.77, 0),
						Size = UDim2.new(0, 365, 0, 27),
						FontFace = Font.fromId(12187365977),
						PlaceholderText = "Search . . .",
						Text = "",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 12.000,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					})
					local dropdownscrollingframe = Create("ScrollingFrame",{
						Name = "dropdownscrollingframe",
						Parent = titledropdown,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						BorderSizePixel = 0,
						Position = UDim2.new(-0.00500016892, 0, 1.5, 0),
						Size = UDim2.new(0, 365, 0, 175),
						ZIndex = 2,
					})
					local dropdownscrollingframe_uipadding = Create("UIPadding",{
						Name = "dropdownscrollingframe_uipadding",
						Parent = dropdownscrollingframe,
						PaddingLeft = UDim.new(0, 5),
						PaddingTop = UDim.new(0, 5),
					})
					local dropdownscrollingframe_uilistlayout = Create("UIListLayout",{
						Name = "dropdownscrollingframe_uilistlayout",
						Parent = dropdownscrollingframe,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 5),
					})

					local dropdownfocus = false

					dropdownbutton.MouseButton1Down:Connect(function()
						if not dropdownfocus then
							tween(dropdownframe,0.5,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 380, 0, 241)})
							tween(titledropdown,0.5,Enum.EasingStyle.Quart,{TextTransparency = 0})
							tween(arrowdropdown,0.5,Enum.EasingStyle.Quart,{Rotation = 180})
							tween(arrowdropdown,0.5,Enum.EasingStyle.Quart,{ImageColor3 = Color3.fromRGB(255, 255, 255)})
						else
							tween(dropdownframe,0.5,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 380, 0, 38)})
							tween(titledropdown,0.5,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
							tween(arrowdropdown,0.5,Enum.EasingStyle.Quart,{Rotation = 0})
							tween(arrowdropdown,0.5,Enum.EasingStyle.Quart,{ImageColor3 = Color3.fromRGB(79,79,79)})
						end
						dropdownfocus = not dropdownfocus
						dropdownscrollingframe.CanvasSize = UDim2.new(0,0,0,dropdownscrollingframe_uilistlayout.AbsoluteContentSize.Y + 5)
					end)

					function UpdateInputOfSearchText()
						local InputText = string.upper(searchdropdown.Text)
						for _,button in pairs(dropdownscrollingframe:GetChildren()) do
							if button:IsA("TextButton") then
								for i,v in pairs(button:GetChildren()) do
									if v:IsA("TextLabel") then
										if InputText == "" or string.find(string.upper(v.Text),InputText) ~= nil then
											button.Visible = true
										else
											button.Visible = false
										end
									end
								end
							end
						end
					end

					searchdropdown.Changed:Connect(UpdateInputOfSearchText)

					if not Mode then
						for i,v in pairs(Item) do
							local buttonbar = Create("TextButton",{
								Name = "buttonbar",
								Parent = dropdownscrollingframe,
								BackgroundColor3 = Color3.fromRGB(51, 59, 67),
								BackgroundTransparency = 1.000,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								Position = UDim2.new(0.0113895219, 0, 0.0285714287, 0),
								Size = UDim2.new(0, 365, 0, 29),
								AutoButtonColor = false,
								Font = Enum.Font.GothamBold,
								Text = "",
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 12.000,
								TextTransparency = 0.450,
							})

							local CheckBox1 = Create("Frame",{
								Name = "CheckBox1",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(35, 35, 35),
								Position = UDim2.new(0.0500000007, 0, 0.5, 0),
								Size = UDim2.new(0, 23, 0, 23),
							})
							corner(CheckBox1,4)
							local CheckBox2 = Create("Frame",{
								Name = "CheckBox2",
								Parent = CheckBox1,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(102, 200, 239),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 0, 0, 0),
								ClipsDescendants = true,
								BorderSizePixel = 0,
							})
							corner(CheckBox2,4)
							local ImageLabel = Create("ImageLabel",{
								Parent = CheckBox2,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 15, 0, 15),
								Image = "rbxassetid://11287988323",
								ScaleType = Enum.ScaleType.Crop,
							})
							local TextHead = Create("TextLabel",{
								Name = "TextHead",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.61, 0, 0.5, 0),
								Size = UDim2.new(0, 365, 0, 27),
								FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 14.000,
								Text = tostring(v),
								TextTransparency = 0.450,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							})

							if Default == v then
								for i,v in next,dropdownscrollingframe:GetChildren() do
									if v:IsA("TextButton") then
										for i,v in pairs(v:GetChildren()) do
											if v:IsA("Frame") then
												for i,v in pairs(v:GetChildren()) do
													if v:IsA("Frame") then
														tween(v,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
													end
												end
											end
											if v:IsA("TextLabel") then
												tween(v,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
											end
										end
										tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
										tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
									end
								end
								textdrop.Text = v
								callback(Default)
							end

							if Config[Title] ~= nil and Config[Title] == v then
								textdrop.Text = Config[Title]
								for i,v in next,dropdownscrollingframe:GetChildren() do
									if v:IsA("TextButton") then
										for i,v in pairs(v:GetChildren()) do
											if v:IsA("Frame") then
												for i,v in pairs(v:GetChildren()) do
													if v:IsA("Frame") then
														tween(v,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
													end
												end
											end
											if v:IsA("TextLabel") then
												tween(v,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
											end
										end
										tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
										tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
									end
								end
								Config[Title] = v
								if ConfigSetting.AutoSave then
									verny:Savefile()
								end
								textdrop.Text = v
								callback(v)
							end
							buttonbar.MouseButton1Down:Connect(function()
								for i,v in next,dropdownscrollingframe:GetChildren() do
									if v:IsA("TextButton") then
										for i,v in pairs(v:GetChildren()) do
											if v:IsA("Frame") then
												for i,v in pairs(v:GetChildren()) do
													if v:IsA("Frame") then
														tween(v,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
													end
												end
											end
											if v:IsA("TextLabel") then
												tween(v,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
											end
										end
										tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
										tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
									end
								end
								Config[Title] = v
								if ConfigSetting.AutoSave then
									verny:Savefile()
								end
								textdrop.Text = v
								callback(v)
							end)
						end

						local dropfunc = {}

						function dropfunc.Clear()
							for i,v in pairs(dropdownscrollingframe:GetChildren())do
								if v:IsA("TextButton") then
									v:Destroy()
								end
							end
							textdrop.Text = ""
						end

						function dropfunc.ClearName(TableName)

							for i,v in pairs(dropdownscrollingframe:GetChildren())do
								if v:IsA("TextButton") then
									if v:FindFirstChild("TextHead") then 
										if tablefoundUpGrade(TableName,v:FindFirstChild("TextHead").Text,tostring) then 
											v:Destroy()
										end
									end
								end
							end
							textdrop.Text = ""
						end

						function dropfunc.Add(v)
							local buttonbar = Create("TextButton",{
								Name = "buttonbar",
								Parent = dropdownscrollingframe,
								BackgroundColor3 = Color3.fromRGB(51, 59, 67),
								BackgroundTransparency = 1.000,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								Position = UDim2.new(0.0113895219, 0, 0.0285714287, 0),
								Size = UDim2.new(0, 365, 0, 29),
								AutoButtonColor = false,
								Font = Enum.Font.GothamBold,
								Text = "",
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 12.000,
								TextTransparency = 0.450,
							})

							local CheckBox1 = Create("Frame",{
								Name = "CheckBox1",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(35, 35, 35),
								Position = UDim2.new(0.0500000007, 0, 0.5, 0),
								Size = UDim2.new(0, 23, 0, 23),
							})
							corner(CheckBox1,4)
							local CheckBox2 = Create("Frame",{
								Name = "CheckBox2",
								Parent = CheckBox1,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(102, 200, 239),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 0, 0, 0),
								ClipsDescendants = true,
								BorderSizePixel = 0,
							})
							corner(CheckBox2,4)
							local ImageLabel = Create("ImageLabel",{
								Parent = CheckBox2,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 15, 0, 15),
								Image = "rbxassetid://11287988323",
								ScaleType = Enum.ScaleType.Crop,
							})
							local TextHead = Create("TextLabel",{
								Name = "TextHead",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.61, 0, 0.5, 0),
								Size = UDim2.new(0, 365, 0, 27),
								FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 14.000,
								Text = tostring(v),
								TextTransparency = 0.450,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							})
							if Config[Title] ~= nil and Config[Title] == v then
								textdrop.Text = Config[Title]
								for i,v in next,dropdownscrollingframe:GetChildren() do
									if v:IsA("TextButton") then
										for i,v in pairs(v:GetChildren()) do
											if v:IsA("Frame") then
												for i,v in pairs(v:GetChildren()) do
													if v:IsA("Frame") then
														tween(v,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
													end
												end
											end
											if v:IsA("TextLabel") then
												tween(v,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
											end
										end
										tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
										tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
									end
								end
								Config[Title] = v
								if ConfigSetting.AutoSave then
									verny:Savefile()
								end
								textdrop.Text = v
								callback(v)
							end
							buttonbar.MouseButton1Down:Connect(function()
								for i,v in next,dropdownscrollingframe:GetChildren() do
									if v:IsA("TextButton") then
										for i,v in pairs(v:GetChildren()) do
											if v:IsA("Frame") then
												for i,v in pairs(v:GetChildren()) do
													if v:IsA("Frame") then
														tween(v,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
													end
												end
											end
											if v:IsA("TextLabel") then
												tween(v,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
											end
										end
										tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
										tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
									end
								end
								Config[Title] = v
								if ConfigSetting.AutoSave then
									verny:Savefile()
								end
								textdrop.Text = v
								callback(v)
							end)
						end

						function dropfunc:Refresh(ClearSelect,Item)
							dropfunc.ClearName(ClearSelect)
							for i,v in pairs(Item) do 
								dropfunc.Add(v)
							end
						end
						function dropfunc:Update(Item)
							dropfunc.Add(Item)
						end
						return dropfunc
					else -- Multi Dropdown
						local MultiDropdown = {}

						for i,v in pairs(Item) do
							local buttonbar = Create("TextButton",{
								Name = "buttonbar",
								Parent = dropdownscrollingframe,
								BackgroundColor3 = Color3.fromRGB(51, 59, 67),
								BackgroundTransparency = 1.000,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								Position = UDim2.new(0.0113895219, 0, 0.0285714287, 0),
								Size = UDim2.new(0, 365, 0, 29),
								AutoButtonColor = false,
								Font = Enum.Font.GothamBold,
								Text = "",
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 12.000,
								TextTransparency = 0.450,
							})

							local CheckBox1 = Create("Frame",{
								Name = "CheckBox1",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(35, 35, 35),
								Position = UDim2.new(0.0500000007, 0, 0.5, 0),
								Size = UDim2.new(0, 23, 0, 23),
							})
							corner(CheckBox1,4)
							local CheckBox2 = Create("Frame",{
								Name = "CheckBox2",
								Parent = CheckBox1,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(102, 200, 239),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 0, 0, 0),
								ClipsDescendants = true,
								BorderSizePixel = 0,
							})
							corner(CheckBox2,4)
							local ImageLabel = Create("ImageLabel",{
								Parent = CheckBox2,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 15, 0, 15),
								Image = "rbxassetid://11287988323",
								ScaleType = Enum.ScaleType.Crop,
							})
							local TextHead = Create("TextLabel",{
								Name = "TextHead",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.61, 0, 0.5, 0),
								Size = UDim2.new(0, 365, 0, 27),
								FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 14.000,
								Text = tostring(v),
								TextTransparency = 0.450,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							})
							if Config[Title] ~= nil then
								Default = Config[Title]
							end
							for o,p in pairs(Default) do
								if v == p  then
									tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
									tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
									table.insert(MultiDropdown,p)
									textdrop.Text = (table.concat(MultiDropdown,","))
									pcall(callback,p)
									pcall(callback,MultiDropdown)
								end
							end

							buttonbar.MouseButton1Down:Connect(function()
								if tablefound(MultiDropdown,v) == false then
									table.insert(MultiDropdown,v)
									tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
									tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
								else
									for ine,va in pairs(MultiDropdown) do
										if va == v then
											table.remove(MultiDropdown,ine)
										end
									end
									tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
									tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
								end
								textdrop.Text = (table.concat(MultiDropdown,","))
								Config[Title] = MultiDropdown
								if ConfigSetting.AutoSave then
									verny:Savefile()
								end
								print(Config[Title])
								pcall(callback,MultiDropdown)
							end)
						end

						local dropfunc = {}
						
						function dropfunc.ClearName(TableName)

							for i,v in pairs(dropdownscrollingframe:GetChildren())do
								if v:IsA("TextButton") then
									if v:FindFirstChild("TextHead") then 
										if tablefoundUpGrade(TableName,v:FindFirstChild("TextHead").Text,tostring) then 
											v:Destroy()
										end
									end
								end
							end
							textdrop.Text = ""
						end
						
						function dropfunc:Refresh(ClearSelect,Item)
							dropfunc.ClearName(ClearSelect)
							for i,v in pairs(Item) do 
								dropfunc.Add(v)
							end
						end
						
						function dropfunc.Clear()
							for i,v in pairs(dropdownscrollingframe:GetChildren())do
								if v:IsA("TextButton") then
									v:Destroy()
								end
							end
							table.clear(Item)
							table.clear(MultiDropdown)
							textdrop.Text = ""
						end

						function dropfunc.Add(v)

							local buttonbar = Create("TextButton",{
								Name = "buttonbar",
								Parent = dropdownscrollingframe,
								BackgroundColor3 = Color3.fromRGB(51, 59, 67),
								BackgroundTransparency = 1.000,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								Position = UDim2.new(0.0113895219, 0, 0.0285714287, 0),
								Size = UDim2.new(0, 365, 0, 29),
								AutoButtonColor = false,
								Font = Enum.Font.GothamBold,
								Text = "",
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 12.000,
								TextTransparency = 0.450,
							})

							local CheckBox1 = Create("Frame",{
								Name = "CheckBox1",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(35, 35, 35),
								Position = UDim2.new(0.0500000007, 0, 0.5, 0),
								Size = UDim2.new(0, 23, 0, 23),
							})
							corner(CheckBox1,4)
							local CheckBox2 = Create("Frame",{
								Name = "CheckBox2",
								Parent = CheckBox1,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(102, 200, 239),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 0, 0, 0),
								ClipsDescendants = true,
								BorderSizePixel = 0,
							})
							corner(CheckBox2,4)
							local ImageLabel = Create("ImageLabel",{
								Parent = CheckBox2,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 15, 0, 15),
								Image = "rbxassetid://11287988323",
								ScaleType = Enum.ScaleType.Crop,
							})
							local TextHead = Create("TextLabel",{
								Name = "TextHead",
								Parent = buttonbar,
								Active = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0.61, 0, 0.5, 0),
								Size = UDim2.new(0, 365, 0, 27),
								FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 14.000,
								Text = tostring(v),
								TextTransparency = 0.450,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							})


							buttonbar.MouseButton1Down:Connect(function()
								if tablefound(MultiDropdown,v) == false then
									table.insert(MultiDropdown,v)
									tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
									tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
								else
									for ine,va in pairs(MultiDropdown) do
										if va == v then
											table.remove(MultiDropdown,ine)
										end
									end
									tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
									tween(TextHead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
								end
								textdrop.Text = (table.concat(MultiDropdown,","))
								Config[Title] = MultiDropdown
								if ConfigSetting.AutoSave then
									verny:Savefile()
								end
								print(Config[Title])
								pcall(callback,MultiDropdown)
							end)
						end
					end
				end

				function Item.Toggle(options)

					local Title = options.Title or tostring("Toggle")
					local Default = options.Default or false
					local callback = options.callback or function() end
					local toggleframe = Create("Frame",{
						Name = "toggleframe",
						Parent = page,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						ClipsDescendants = true,
						Position = UDim2.new(0, 0, 0.113636367, 0),
						Size = UDim2.new(0, 380, 0, 38),
					})
					corner(toggleframe,4)
					stroke(toggleframe,0,1,Color3.fromRGB(50,50,50))
					local togglebutton = Create("TextButton",{
						Name = "togglebutton",
						Parent = toggleframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Size = UDim2.new(0, 380, 0, 38),
						Font = Enum.Font.SourceSans,
						Text = "",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14.000,
					})
					local titletoggle = Create("TextLabel",{
						Name = "titletoggle",
						Parent = toggleframe,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.0225080829, 0, 0, 0),
						Size = UDim2.new(0, 360, 0, 38),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = tostring(Title),
						TextTransparency = 0.45
					})

					local CheckBox1 = Create("Frame",{
						Name = "CheckBox1",
						Parent = toggleframe,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(20,20,20),
						Position = UDim2.new(0.93, 0, 0.5, 0),
						Size = UDim2.new(0, 23, 0, 23),
					})
					stroke(CheckBox1,0,1,Color3.fromRGB(50,50,50))
					corner(CheckBox1,4)
					local CheckBox2 = Create("Frame",{
						Name = "CheckBox2",
						Parent = CheckBox1,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(102, 200, 239),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 0, 0, 0),
						ClipsDescendants = true,
						BorderSizePixel = 0,
					})
					corner(CheckBox2,4)
					local ImageLabel = Create("ImageLabel",{
						Parent = CheckBox2,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 15, 0, 15),
						Image = "rbxassetid://11287988323",
						ScaleType = Enum.ScaleType.Crop,
					})

					local togglefocus = false
					--[SaveModule]
					if Config[Title] ~= nil then
						Default = Config[Title]
						print(Config[Title])
					elseif Config[Title] == nil then
						Config[Title] = Default
						print(Config)
					end
					togglebutton.MouseButton1Down:Connect(function()
						if not togglefocus then
							Config[Title] = true
							if ConfigSetting.AutoSave then
								verny:Savefile()
							end
							tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
							tween(titletoggle,0.25,Enum.EasingStyle.Quart,{TextTransparency = 0})
						else
							Config[Title] = false
							if ConfigSetting.AutoSave then
								verny:Savefile()
							end
							tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
							tween(titletoggle,0.25,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
						end
						togglefocus = not togglefocus
						callback(togglefocus)
					end)

					if Default == true then
						tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
						tween(titletoggle,0.25,Enum.EasingStyle.Quart,{TextTransparency = 0})
						togglefocus = not togglefocus
						callback(togglefocus)
					end

					local togglefunc = {}

					function togglefunc.Update(value)
						if value then
							Config[Title] = value
							if ConfigSetting.AutoSave then
								verny:Savefile()
							end
							tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 23, 0, 23)})
							tween(titletoggle,0.25,Enum.EasingStyle.Quart,{TextTransparency = 0})
							togglefocus = not togglefocus
							callback(togglefocus)
						else
							Config[Title] = value
							if ConfigSetting.AutoSave then
								verny:Savefile()
							end
							tween(CheckBox2,0.2,Enum.EasingStyle.Back,{Size = UDim2.new(0, 0, 0, 0)})
							tween(titletoggle,0.25,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
							togglefocus = not togglefocus
							callback(value)
						end
					end

					return togglefunc
				end

				function Item.Button(options)

					local Title = options.Title or tostring("Button")
					local callback = options.callback or function() end

					local buttonframe = Create("Frame",{
						Name = "buttonframe",
						Parent = page,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						BackgroundTransparency = 1.000,
						ClipsDescendants = true,
						Position = UDim2.new(0, 0, 6.68181801, 0),
						Size = UDim2.new(0, 380, 0, 26),
					})

					local button = Create("TextButton",{
						Name = "button",
						Parent = buttonframe,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(100, 200, 239),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 380, 0, 25),
						AutoButtonColor = false,
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						Text = tostring(Title),
					})
					corner(button,4)

					button.MouseButton1Down:Connect(function()
						CircleAnim(button,Color3.fromRGB(0,0,0),Color3.fromRGB(0,0,0))
						pcall(callback)
					end)
				end

				function Item.Slider(options)

					local sliderfunc = {}

					local Title = options.Title or "Slider"
					local Max = options.Max or 100
					local Min = options.Min or 0
					local Dec = options.Dec or false
					local Default = options.Default or 50
					local callback = options.callback or function() end

					local sliderframe = Create("Frame",{
						Name = "sliderframe",
						Parent = page,
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new(0, 0, 7.38636351, 0),
						Size = UDim2.new(0, 380, 0, 38),
					})

					stroke(sliderframe,0,1,Color3.fromRGB(50,50,50))

					local sliderframe2 = Create("Frame",{
						Name = "sliderframe2",
						Parent = sliderframe,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(45, 45, 45),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new(0.499921471, 0, 0.524316072, 0),
						Size = UDim2.new(0, 378, 0, 38),
					})

					corner(sliderframe2,4)
					local slidervalueframe = Create("Frame",{
						Name = "slidervalueframe",
						Parent = sliderframe2,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Position = UDim2.new(0.761227548, 0, 0.5, 0),
						Size = UDim2.new(0, 164, 0, 25),
					})
					local SliderValueFrame = Create("Frame",{
						Name = "SliderValueFrame",
						Parent = slidervalueframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Size = UDim2.new((Default or 0) / Max, 0, 0, 25),
					})
					local ButtonBarUIGradient = Create("UIGradient",{
						Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(21, 41, 49)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 99, 118))},
						Name = "ButtonBarUIGradient",
						Parent = SliderValueFrame,
					})
					corner(SliderValueFrame,4)
					local SliderValueFrame_2 = Create("Frame",{
						Name = "SliderValueFrame",
						Parent = slidervalueframe,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new((Default or 0)/Max, 0.5, 0.5,0.5, 0),
						Size = UDim2.new(0, 9, 0, 9),
					})
					corner(SliderValueFrame_2,4)

					stroke(slidervalueframe,0,1,Color3.fromRGB(50,50,50))
					corner(slidervalueframe,4)
					local slidervalueframeuigradient = Create("UIGradient",{
						Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 18, 18)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(35, 35, 35))},
						Name = "slidervalueframeuigradient",
						Parent = slidervalueframe,
					})
					local number_text = Create("TextLabel",{
						Name = "number_text",
						Parent = slidervalueframe,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.0853658542, 0, 0, 0),
						Size = UDim2.new(0, 44, 0, 25),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						Text = "0",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 12.000,
						TextTransparency = 0.450,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					})
					if Dec == true then
						number_text.Text =  tostring(Default and string.format("%.1f",(Default / Max) * (Max - Min) + Min) or 0)
					else
						number_text.Text = tostring(Default and math.floor( (Default / Max) * (Max - Min) + Min) or 0)
					end
					local texthead = Create("TextLabel",{
						Name = "texthead",
						Parent = sliderframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.0351544842, 0, 0.196608692, 0),
						Size = UDim2.new(0, 114, 0, 23),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextWrapped = true,
						TextTransparency = 0.45,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = Title,
					})
					corner(sliderframe,4)

					local function move(input)
						local pos =
							UDim2.new(
								math.clamp((input.Position.X - SliderValueFrame.AbsolutePosition.X) / SliderValueFrame.AbsoluteSize.X, 0, 1),
								0,
								0.5,
								0
							)
						local pos1 =
							UDim2.new(
								math.clamp((input.Position.X - SliderValueFrame.AbsolutePosition.X) / SliderValueFrame.AbsoluteSize.X, 0, 1),
								0,
								0,
								25
							)

						SliderValueFrame:TweenSize(pos1, "Out", "Sine", 0.25, true)
						SliderValueFrame_2:TweenPosition(pos, "Out", "Sine", 0.25, true)
						if Dec == true then
							local value = string.format("%.1f",((pos.X.Scale * Max) / Max) * (Max - Min) + Min)
							number_text.Text = tostring(value)
							callback(value)
						else
							local value = math.floor(((pos.X.Scale * Max) / Max) * (Max - Min) + Min)
							number_text.Text = tostring(value)
							callback(value)
						end
					end

					if Default <= Min then
						number_text.Text = Min
					else
						number_text.Text = Default
						callback(Default)
					end

					local dragging = false

					slidervalueframe.InputBegan:Connect(
						function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragging = true
								tween(texthead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
							end
						end
					)
					slidervalueframe.InputEnded:Connect(
						function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragging = false
								tween(texthead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
							end
						end
					)


					SliderValueFrame.InputBegan:Connect(
						function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragging = true
								tween(texthead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
							end
						end
					)
					SliderValueFrame.InputEnded:Connect(
						function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragging = false
								tween(texthead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
							end
						end
					)
					game:GetService("UserInputService").InputChanged:Connect(function(input)
						if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
							move(input)
						end
					end)

					function sliderfunc.Update(value)
						local pos = UDim2.new(math.clamp((value) / Max, 0, 1), 0, 0.5, 0)
						SliderValueFrame_2:TweenPosition(pos, "Out", "Sine", 0.25, true)
						SliderValueFrame:TweenSize(UDim2.new((value or 0) / Max, 0, 0, 25), "Out", "Sine", 0.2, true)
						if value > Max then
							number_text.Text = Max
						elseif value < Min then
							number_text.Text = Min
						else
							number_text.Text = value
						end
						callback(number_text.Text)
					end
					return sliderfunc
				end

				function Item.TextBox(options)

					local Title = options.Title or tostring("TextBox")
					local Holder = options.Holder or tostring("Holder")
					local callback = options.callback or function() end

					local textboxframe = Create("Frame",{
						Name = "textboxframe",
						Parent = page,
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new(0, 0, 7.38636351, 0),
						Size = UDim2.new(0, 380, 0, 38),
					})

					local texthead = Create("TextLabel",{
						Name = "texthead",
						Parent = textboxframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.0351544842, 0, 0.196608692, 0),
						Size = UDim2.new(0, 114, 0, 23),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextTransparency = 0.450,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = Title,
					})
					corner(textboxframe,4)
					stroke(textboxframe,0,1,Color3.fromRGB(50,50,50))

					local textboxholderframe = Create("Frame",{
						Name = "textboxholderframe",
						Parent = textboxframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Position = UDim2.new(0.821052611, 0, 0.184210524, 0),
						Size = UDim2.new(0, 58, 0, 25),
					})

					local slidervalueframeuigradient = Create("UIGradient",{
						Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 18, 18)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(35, 35, 35))},
						Name = "slidervalueframeuigradient",
						Parent = textboxholderframe,
					})
					corner(textboxholderframe,4)
					stroke(textboxholderframe,0,1,Color3.fromRGB(50,50,50))

					local textbox = Create("TextBox",{
						Name = "textbox",
						Parent = textboxholderframe,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 52, 0, 24),
						FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold),
						PlaceholderText = tostring(Holder),
						Text = "",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 12.000,
						TextTransparency = 0.9,
						TextWrapped = false,
						TextXAlignment = Enum.TextXAlignment.Right,
						ClipsDescendants = true,
					})

					textbox.Focused:Connect(function()
						tween(texthead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
						tween(textbox,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0})
						tween(textboxholderframe,0.2,Enum.EasingStyle.Quart,{Position = UDim2.new(0.693, 0, 0.184210524, 0)})
						tween(textboxholderframe,0.2,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 100, 0, 25)})
						tween(textbox,0.2,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 80, 0, 25)})
						tween(textbox,0.2,Enum.EasingStyle.Quart,{Position = UDim2.new(0.1, 0, 0, 0)})
					end)

					textbox.FocusLost:Connect(function(ep)
						tween(texthead,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.45})
						tween(textbox,0.2,Enum.EasingStyle.Quart,{TextTransparency = 0.9})
						tween(textboxholderframe,0.2,Enum.EasingStyle.Quart,{Position = UDim2.new(0.821052611, 0, 0.184210524, 0)})
						tween(textboxholderframe,0.2,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 58, 0, 25)})
						tween(textbox,0.2,Enum.EasingStyle.Quart,{Size = UDim2.new(0, 52, 0, 25)})
						tween(textbox,0.2,Enum.EasingStyle.Quart,{Position = UDim2.new(0, 0, 0, 0)})
						if ep then
							if #textbox.Text > 0 then
								pcall(callback, textbox.Text)
							end
						end
					end)
				end

				function Item.Label(options)

					local Title = options.Title or tostring("Label")
					local Refresh = {}

					local labelframe = Instance.new("Frame")
					local texthead = Instance.new("TextLabel")
					local labelframe_uicorner = Instance.new("UICorner")

					labelframe.Name = "labelframe"
					labelframe.Parent = page
					labelframe.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
					labelframe.BackgroundTransparency = 1.000
					labelframe.BorderSizePixel = 0
					labelframe.ClipsDescendants = true
					labelframe.Position = UDim2.new(0, 0, 7.38636351, 0)
					labelframe.Size = UDim2.new(0, 380, 0, 38)

					texthead.Name = "texthead"
					texthead.Parent = labelframe
					texthead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					texthead.BackgroundTransparency = 1.000
					texthead.Position = UDim2.new(0.0351544842, 0, 0.196608692, 0)
					texthead.Size = UDim2.new(0, 353, 0, 23)
					texthead.FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold)
					texthead.TextColor3 = Color3.fromRGB(255, 255, 255)
					texthead.TextSize = 12.000
					texthead.TextWrapped = true
					texthead.TextXAlignment = Enum.TextXAlignment.Left
					texthead.Text = tostring(Title)

					labelframe_uicorner.CornerRadius = UDim.new(0, 4)
					labelframe_uicorner.Name = "labelframe_uicorner"
					labelframe_uicorner.Parent = labelframe

					stroke(labelframe,0,1,Color3.fromRGB(50,50,50))

					function Refresh.Update(v)
						texthead.Text = v
					end

					function Refresh.UpdateColor(v)
						texthead.TextColor3 = v
					end
					return Refresh
				end

				function Item.Paragraph(options)

					local Title = options.Title or tostring("Paragraph")
					local Desc = options.Desc or tostring("Description")
					local Refresh = {}

					local paragraphframe = Instance.new("Frame")
					local paragraph = Instance.new("TextLabel")
					local paragraphframe_uicorner = Instance.new("UICorner")
					local content = Instance.new("TextLabel")

					paragraphframe.Name = "paragraphframe"
					paragraphframe.Parent = page
					paragraphframe.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
					paragraphframe.BackgroundTransparency = 1.000
					paragraphframe.BorderSizePixel = 0
					paragraphframe.ClipsDescendants = true
					paragraphframe.Position = UDim2.new(0, 0, 10.318182, 0)
					paragraphframe.Size = UDim2.new(0, 380, 0, 50)

					stroke(paragraphframe,0,1,Color3.fromRGB(50,50,50))

					paragraph.Name = "paragraph"
					paragraph.Parent = paragraphframe
					paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraph.BackgroundTransparency = 1.000
					paragraph.Position = UDim2.new(0.0351544842, 0, 0.0913455337, 0)
					paragraph.Size = UDim2.new(0, 353, 0, 23)
					paragraph.FontFace = Font.fromId(12187365977,Enum.FontWeight.Bold)
					paragraph.Text = tostring(Title)
					paragraph.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraph.TextSize = 14.000
					paragraph.TextWrapped = true
					paragraph.TextXAlignment = Enum.TextXAlignment.Left

					paragraphframe_uicorner.CornerRadius = UDim.new(0, 4)
					paragraphframe_uicorner.Name = "paragraphframe_uicorner"
					paragraphframe_uicorner.Parent = paragraphframe

					content.Name = "content"
					content.Parent = paragraphframe
					content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					content.BackgroundTransparency = 1.000
					content.Position = UDim2.new(0.0351544842, 0, 0.540819108, 0)
					content.Size = UDim2.new(0, 353, 0, 19)
					content.FontFace = Font.fromId(12187365977)
					content.Text = tostring(Desc)
					content.TextColor3 = Color3.fromRGB(255, 255, 255)
					content.TextSize = 12.000
					content.TextTransparency = 0.450
					content.TextWrapped = true
					content.TextXAlignment = Enum.TextXAlignment.Left

					function Refresh.Update(v)
						paragraph.Text = tostring(v)
					end

					function Refresh.UpdateDesc(v)
						content.Text = tostring(v)
					end

					function Refresh.UpdateColor(v)
						paragraph.TextColor3 = v
					end

					function Refresh.UpdateColorDesc(v)
						content.TextColor3 = v
					end
					return Refresh
				end

				return Item
			end
			return Page
		end
		return Tab
	end
end
return verny
