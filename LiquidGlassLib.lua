--[[
╔══════════════════════════════════════════════════════════════════════════════╗
║         LIQUID GLASS UI LIBRARY  ·  Roblox LocalScript                      ║
║         macOS Sequoia-style settings window — fully configurable             ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  QUICK START                                                                 ║
║  ─────────────────────────────────────────────────────────────────────────  ║
║  1. Drop this LocalScript into StarterPlayerScripts or StarterGui            ║
║  2. Scroll to the "USER CONFIGURATION" section at the very bottom            ║
║  3. Add your own tabs, sections, and controls using the LiquidGlass API      ║
╚══════════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  DOCUMENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  LiquidGlass:SetConfig(opts)
  ─────────────────────────────────────────────────────────
  Call once before AddTab to customise the window.
  opts fields (all optional):
    title          string   Title in the top bar           default "System Settings"
    profileName    string   Name shown on the profile card default "Player"
    profileSub     string   Sub-text under the name        default "Apple ID · iCloud"
    profileInitial string   Single letter avatar initial   default first letter of name
    accentColor    Color3   Main accent / active colour    default RGB(10,132,255)
    windowAlpha    number   0–1 window opacity (0=glass)   default 0.18

  ─────────────────────────────────────────────────────────
  LiquidGlass:AddTab(tabName, iconName, subText?)
  ─────────────────────────────────────────────────────────
  Registers a new sidebar tab.
    tabName   string   Unique identifier AND display label
    iconName  string   Built-in icon key (see ICON LIST below)
                       or "custom" to draw a blank badge
    subText   string?  Optional subtitle under the tab name
                       (shown when provided, e.g. "Connected")
  Returns: tab handle used by AddSection / AddControl

  Built-in icon keys:
    "Wi-Fi"  "Bluetooth"  "Network"  "Notifications"  "Sound"
    "Focus"  "Screen Time"  "General"  "Appearance"  "Accessibility"
    "Privacy"  "Desktop"  "Display"  "Battery"  "Keyboard"
    "Mouse"  "Trackpad"  "Users"  "Passwords"  "Software Update"

  ─────────────────────────────────────────────────────────
  tab:AddSection(header?)
  ─────────────────────────────────────────────────────────
  Adds a new card (group of controls) to the tab.
    header   string?   Optional bold header label above the card
  Returns: section handle used by AddControl methods

  ─────────────────────────────────────────────────────────
  section:AddToggle(label, defaultValue, callback?)
  ─────────────────────────────────────────────────────────
    label         string    Row label
    defaultValue  bool      Initial on/off state
    callback      function? Called with (newValue: bool) on change
  Returns: control handle with :SetValue(bool) / :GetValue()

  ─────────────────────────────────────────────────────────
  section:AddSlider(label, defaultValue, callback?)
  ─────────────────────────────────────────────────────────
    label         string    Row label
    defaultValue  number    0.0 – 1.0 initial position
    callback      function? Called with (newValue: number) on change
  Returns: control handle with :SetValue(number) / :GetValue()

  ─────────────────────────────────────────────────────────
  section:AddInfo(label, value)
  ─────────────────────────────────────────────────────────
    label   string   Left label
    value   string   Right value text (chevron › appended automatically)
  Returns: control handle with :SetValue(string) to update the right text

  ─────────────────────────────────────────────────────────
  section:AddDropdown(label, options, defaultIndex, callback?)
  ─────────────────────────────────────────────────────────
    label         string      Row label
    options       {string}    Table of option strings
    defaultIndex  number      1-based index of initial selection
    callback      function?   Called with (selectedIndex, selectedLabel)
  Returns: control handle with :SetValue(index) / :GetValue()

  ─────────────────────────────────────────────────────────
  section:AddButton(label, buttonText, callback?)
  ─────────────────────────────────────────────────────────
    label       string    Row label (left side)
    buttonText  string    Text inside the clickable button
    callback    function? Called when button is clicked
  Returns: control handle

  ─────────────────────────────────────────────────────────
  CONTROLS BEHAVIOUR NOTES
  ─────────────────────────────────────────────────────────
  Toggles    — pill squeezes and springs back on click.
               Knob slides with a springy overshoot.
  Sliders    — scrolling is locked while dragging.
               If opted into notifications via Notif.Slider,
               the Dynamic Island tracks the value live while
               dragging. On release the progress bar jiggles.
               Switching sliders quickly collapses the island
               back to a dot and reopens for the new one.
  Dropdowns  — opens with a spring-expand animation.
               Dismisses with a bounce when closed without
               selecting. Panel repositions on scroll.
  Buttons    — press-down then spring-back from centre.

  DYNAMIC ISLAND BEHAVIOUR
  ─────────────────────────────────────────────────────────
  A permanent black dot is always visible at the top-centre
  of the screen. Notifications spring open from it and
  collapse back to it when dismissed.
  Island width auto-sizes to fit the label and badge text.
  Slider notifications show a progress bar that jiggles
  once after the island is fully expanded.

  LiquidGlass:Open()  /  LiquidGlass:Close()

  ─────────────────────────────────────────────────────────
  DYNAMIC ISLAND — OPT-IN PER CONTROL
  ─────────────────────────────────────────────────────────
  Controls do NOT auto-notify. You opt in per control by
  passing a notify function as the callback.

  OPTION 1 — Convenience helpers (recommended):
    LiquidGlass.Notif.Toggle("Label")    → callback for toggles
    LiquidGlass.Notif.Slider("Label")    → callback for sliders
    LiquidGlass.Notif.Dropdown("Label")  → callback for dropdowns
    LiquidGlass.Notif.Button("Label")    → callback for buttons

  Usage:
    sec:AddToggle("Shadows", true, LiquidGlass.Notif.Toggle("Shadows"))
    sec:AddSlider("Volume",  0.5,  LiquidGlass.Notif.Slider("Volume"))
    sec:AddDropdown("Quality", {...}, 1, LiquidGlass.Notif.Dropdown("Quality"))
    sec:AddButton("Save", "Go", LiquidGlass.Notif.Button("Save"))

  OPTION 2 — Custom callback, call Notify yourself:
    sec:AddToggle("Feature", false, function(on)
        if on then LiquidGlass:Notify("Enabled", "On")
        else LiquidGlass:NotifyWarning("Disabled", "Off") end
    end)

  ─────────────────────────────────────────────────────────
  LiquidGlass:Notify(label, value?, notifType?)
  ─────────────────────────────────────────────────────────
  Fire a Dynamic Island notification manually.
    label     string   Main text shown in the island
    value     string?  Right-side badge text (optional)
    notifType string?  Icon/colour style (default "custom"):
                         "toggle"   green  ◉
                         "slider"   blue   ≡
                         "dropdown" blue   ◆
                         "button"   blue   ▶
                         "custom"   orange ●
                         "error"    red    ✕
                         "warning"  yellow ⚠
  Examples:
    LiquidGlass:Notify("Game saved")
    LiquidGlass:Notify("Round started", "Wave 3")
    LiquidGlass:Notify("Volume", "72%", "slider")

  ─────────────────────────────────────────────────────────
  LiquidGlass:NotifyError(label, value?)
  ─────────────────────────────────────────────────────────
  Shorthand for a red error notification.
  Examples:
    LiquidGlass:NotifyError("Connection failed")
    LiquidGlass:NotifyError("Load failed", "Timeout")

  ─────────────────────────────────────────────────────────
  LiquidGlass:NotifyWarning(label, value?)
  ─────────────────────────────────────────────────────────
  Shorthand for a yellow warning notification.
  Examples:
    LiquidGlass:NotifyWarning("Low memory", "128MB")
    LiquidGlass:NotifyWarning("Unsaved changes")

  ─────────────────────────────────────────────────────────
  LiquidGlass:Open()  /  LiquidGlass:Close()
  ─────────────────────────────────────────────────────────
  Show or hide the window with animation.

  ─────────────────────────────────────────────────────────
  LiquidGlass:SelectTab(tabName)
  ─────────────────────────────────────────────────────────
  Programmatically navigate to a tab by name.
  Example: LiquidGlass:SelectTab("Graphics")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EXAMPLE (copy-paste into USER CONFIGURATION at the bottom)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  LiquidGlass:SetConfig({
      title       = "Game Settings",
      profileName = "CoolPlayer123",
      profileSub  = "Level 42 · Premium",
      accentColor = Color3.fromRGB(255, 80, 120),
  })

  local graphicsTab = LiquidGlass:AddTab("Graphics", "Display")

  local qualitySection = graphicsTab:AddSection("Quality")
  qualitySection:AddDropdown("Render Quality", {"Low","Medium","High","Ultra"}, 3, function(idx, label)
      print("Quality set to", label)
  end)
  qualitySection:AddSlider("Brightness", 0.85, function(v)
      Lighting.Brightness = v * 3
  end)
  qualitySection:AddToggle("Shadows", true, function(on)
      Lighting.GlobalShadows = on
  end)

  local audioTab = LiquidGlass:AddTab("Audio", "Sound")
  local audioSection = audioTab:AddSection("Volume")
  local masterSlider = audioSection:AddSlider("Master Volume", 1.0)
  audioSection:AddSlider("Music", 0.7, function(v)
      -- use masterSlider:GetValue() * v for final volume
  end)
  audioSection:AddToggle("Mute All", false, function(on)
      masterSlider:SetValue(on and 0 or 1)
  end)
  audioSection:AddButton("Test Sound", "Play", function()
      print("Ping!")
  end)

  local networkTab = LiquidGlass:AddTab("Network", "Wi-Fi", "Connected")
  local netSection = networkTab:AddSection("Status")
  local statusInfo = netSection:AddInfo("Region", "US East")
  netSection:AddToggle("Auto-connect", true)
  -- later update it:
  -- statusInfo:SetValue("EU West")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local GuiService       = game:GetService("GuiService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- TWEEN HELPER
-- ============================================================
local function tween(inst, dur, props, style, dir)
	local t = TweenService:Create(inst,
		TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
		props)
	t:Play(); return t
end

-- ============================================================
-- THEME
-- ============================================================
local T = {
	sidebarBg    = Color3.fromRGB(28, 28, 32),
	windowBg     = Color3.fromRGB(34, 34, 38),
	cardBg       = Color3.fromRGB(58, 58, 66),
	stroke       = Color3.fromRGB(140, 140, 160),
	textPrimary  = Color3.fromRGB(255, 255, 255),
	textSecond   = Color3.fromRGB(180, 180, 192),
	textTertiary = Color3.fromRGB(120, 120, 135),
	blue         = Color3.fromRGB(10, 132, 255),
	green        = Color3.fromRGB(48, 209,  88),
	orange       = Color3.fromRGB(255, 159, 10),
	red          = Color3.fromRGB(255,  69, 58),
	yellow       = Color3.fromRGB(255, 214, 10),
	toggleOn     = Color3.fromRGB(50, 215, 75),
	toggleOff    = Color3.fromRGB(72, 72, 80),
	sliderFill   = Color3.fromRGB(10, 132, 255),
	sliderTrack  = Color3.fromRGB(86, 86, 96),
	activeItem   = Color3.fromRGB(10, 132, 255),
	hoverItem    = Color3.fromRGB(70, 70, 80),
	dropdownBg   = Color3.fromRGB(46, 46, 52),
	dropdownHov  = Color3.fromRGB(68, 68, 80),
	btnBg        = Color3.fromRGB(60, 60, 70),
	btnHov       = Color3.fromRGB(80, 80, 96),
}

-- ============================================================
-- LIQUID GLASS HELPER
-- ============================================================
local function liquidGlass(frame, opts)
	opts = opts or {}
	local radius = opts.radius or 14
	frame.BorderSizePixel = 0
	local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(0, radius); uc.Parent = frame
	local grad = Instance.new("UIGradient"); grad.Rotation = 90
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(210,210,220)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150,150,165)),
	})
	grad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.00, 0.55),
		NumberSequenceKeypoint.new(0.50, 0.78),
		NumberSequenceKeypoint.new(1.00, 0.62),
	})
	grad.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255,255,255); stroke.Thickness = 1.2
	stroke.Transparency = opts.strokeT or 0.55
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; stroke.Parent = frame
	local sg = Instance.new("UIGradient"); sg.Rotation = 90
	sg.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.00, 0.25),
		NumberSequenceKeypoint.new(0.50, 0.85),
		NumberSequenceKeypoint.new(1.00, 0.45),
	})
	sg.Parent = stroke
	if opts.sheen ~= false then
		local sheenF = Instance.new("Frame"); sheenF.Name = "Sheen"
		sheenF.BackgroundColor3 = Color3.fromRGB(255,255,255); sheenF.BackgroundTransparency = 0.88
		sheenF.BorderSizePixel = 0; sheenF.Size = UDim2.new(1,-4,0.45,0)
		sheenF.Position = UDim2.new(0,2,0,2); sheenF.ZIndex = (frame.ZIndex or 1)+1; sheenF.Parent = frame
		local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,radius); sc.Parent = sheenF
		local ssg = Instance.new("UIGradient"); ssg.Rotation = 90
		ssg.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0.55),
			NumberSequenceKeypoint.new(1.00, 1.00),
		})
		ssg.Parent = sheenF
	end
	return stroke
end

-- ============================================================
-- ICON ACCENT COLOURS
-- ============================================================
local ICON_COLOR = {
	["Wi-Fi"]="b",["Bluetooth"]="b",["Network"]=Color3.fromRGB(80,100,255),
	["Notifications"]="r",["Sound"]="o",["Focus"]=Color3.fromRGB(100,200,100),
	["Screen Time"]="r",["General"]=Color3.fromRGB(140,140,150),
	["Appearance"]=Color3.fromRGB(110,100,255),["Accessibility"]="b",
	["Privacy"]="g",["Desktop"]="b",["Display"]=Color3.fromRGB(0,199,190),
	["Battery"]="g",["Keyboard"]=Color3.fromRGB(140,140,150),
	["Mouse"]=Color3.fromRGB(140,140,150),["Trackpad"]=Color3.fromRGB(140,140,150),
	["Users"]=Color3.fromRGB(100,180,255),["Passwords"]="y",
	["Software Update"]="b",
}
local function resolveIconColor(key)
	local v = ICON_COLOR[key]
	if not v then return T.blue end
	if type(v)=="string" then
		local m={b=T.blue,g=T.green,r=T.red,o=T.orange,y=T.yellow}
		return m[v] or T.blue
	end
	return v
end

-- ============================================================
-- ICON RENDERER
-- ============================================================
local function newRect(parent,x,y,w,h,color,radius)
	local f=Instance.new("Frame")
	f.Position=UDim2.fromOffset(x,y); f.Size=UDim2.fromOffset(w,h)
	f.BackgroundColor3=color or T.textPrimary; f.BackgroundTransparency=0
	f.BorderSizePixel=0; f.ZIndex=(parent.ZIndex or 1)+1; f.Parent=parent
	if radius and radius>0 then Instance.new("UICorner",f).CornerRadius=UDim.new(0,radius) end
	return f
end

local function buildIcon(parent,name,S)
	S=S or 18; local c=T.textPrimary; local s=S/18
	local function px(x,y,w,h,col,rad)
		return newRect(parent,math.round(x*s),math.round(y*s),
			math.max(1,math.round(w*s)),math.max(1,math.round(h*s)),col,rad)
	end
	local function r(x,y,w,h,col,rad) return px(x,y,w,h,col or c,rad) end
	if name=="Wi-Fi" then
		r(6,12,6,2,c,1);r(3,8,12,2,c,1);r(0,4,18,2,c,1);r(7,15,4,4,c,2)
	elseif name=="Bluetooth" then r(8,1,2,16,c,1);r(8,1,8,8,c,1);r(8,9,8,8,c,1)
	elseif name=="Sound" then r(2,6,4,6,c,1);r(6,3,4,12,c,2);r(12,5,2,2,c,1);r(14,3,2,2,c,1);r(14,7,2,2,c,1)
	elseif name=="General" then r(2,3,14,3,c,1);r(2,8,14,3,c,1);r(2,13,14,3,c,1)
	elseif name=="Display" then r(1,2,16,12,c,3);r(6,14,6,2,c,1);r(3,16,12,1,c,1)
	elseif name=="Battery" then r(1,5,14,8,c,3);r(15,7,2,4,c,1);r(3,7,8,4,T.green,2)
	elseif name=="Keyboard" then r(1,5,16,9,c,3);r(3,7,2,2,c,1);r(6,7,2,2,c,1);r(9,7,2,2,c,1);r(12,7,2,2,c,1);r(5,10,8,2,c,1)
	elseif name=="Notifications" then r(4,2,10,12,c,4);r(2,10,14,4,c,2);r(6,14,6,2,c,1);r(8,16,2,2,c,2)
	elseif name=="Privacy" then r(4,8,10,9,c,3);r(5,2,8,8,c,2);r(5,5,8,6,T.sidebarBg,1);r(7,10,4,4,T.green,2)
	elseif name=="Appearance" then r(1,1,16,16,c,8);r(9,1,9,16,T.sidebarBg,0)
	elseif name=="Accessibility" then r(7,0,4,4,c,2);r(2,5,14,2,c,1);r(6,7,2,10,c,1);r(10,7,2,10,c,1)
	elseif name=="Network" then r(7,7,4,4,c,2);r(8,0,2,6,c,1);r(8,12,2,6,c,1);r(0,8,6,2,c,1);r(12,8,6,2,c,1)
	elseif name=="Users" then r(6,1,6,6,c,3);r(2,9,14,8,c,4)
	elseif name=="Passwords" then r(4,7,10,9,c,3);r(5,2,8,8,c,3);r(5,5,8,5,T.sidebarBg,1);r(8,10,2,3,T.yellow,1)
	elseif name=="Software Update" then r(1,1,16,16,c,8);r(3,3,12,12,T.sidebarBg,6);r(7,3,4,9,c,2);r(4,10,10,2,c,1)
	elseif name=="Mouse" then r(5,1,8,13,c,5);r(5,1,4,7,c,2);r(9,1,4,7,c,2);r(9,1,2,7,T.sidebarBg,0)
	elseif name=="Trackpad" then r(1,1,16,16,c,5);r(2,2,14,14,T.sidebarBg,4);r(8,1,2,16,c,0)
	elseif name=="Screen Time" then r(1,2,16,12,c,3);r(6,14,6,2,c,1);r(3,16,12,1,c,1);r(8,5,2,6,T.red,1);r(8,5,4,2,T.red,1)
	elseif name=="Focus" then r(1,1,16,16,c,8);r(4,4,10,10,T.sidebarBg,5);r(7,7,4,4,c,2)
	elseif name=="Desktop" then r(1,2,16,11,c,3);r(3,4,12,7,T.blue,2);r(6,13,6,2,c,1);r(3,15,12,1,c,1)
	else r(1,1,16,16,c,4) end
end

-- ============================================================
-- SCREEN GUI SETUP
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name="LiquidGlassUI"; ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset=true; ScreenGui.Parent=playerGui

local Blur = Instance.new("BlurEffect"); Blur.Name="LGBlur"; Blur.Size=0; Blur.Parent=Lighting

-- Forward declarations — these are built later but referenced in traffic button handlers
local SRF
local SearchBox

local Overlay = Instance.new("Frame")
Overlay.Size=UDim2.fromScale(1,1); Overlay.BackgroundColor3=Color3.fromRGB(8,10,18)
Overlay.BackgroundTransparency=0.15; Overlay.BorderSizePixel=0; Overlay.ZIndex=10; Overlay.Parent=ScreenGui

local Shadow = Instance.new("ImageLabel")
Shadow.AnchorPoint=Vector2.new(0.5,0.5); Shadow.Position=UDim2.fromScale(0.5,0.5)
Shadow.BackgroundTransparency=1; Shadow.Image="rbxasset://textures/ui/Controls/DropShadow.png"
Shadow.ImageColor3=Color3.new(0,0,0); Shadow.ImageTransparency=0.45
Shadow.ScaleType=Enum.ScaleType.Slice; Shadow.SliceCenter=Rect.new(12,12,244,244)
Shadow.ZIndex=10; Shadow.Parent=ScreenGui

local Window = Instance.new("Frame")
Window.AnchorPoint=Vector2.new(0.5,0.5); Window.Position=UDim2.fromScale(0.5,0.5)
Window.BackgroundColor3=T.windowBg; Window.BackgroundTransparency=0.18
Window.BorderSizePixel=0; Window.ZIndex=11; Window.ClipsDescendants=true; Window.Parent=ScreenGui
liquidGlass(Window,{radius=18,sheen=true,strokeT=0.45})

-- Responsive size
local minimized,maximized=false,false
local function getWinSize()
	local vp=workspace.CurrentCamera.ViewportSize
	return math.clamp(vp.X*0.84,520,1080), math.clamp(vp.Y*0.84,420,760)
end
local function applyWinSize()
	if maximized or minimized then return end
	local w,h=getWinSize()
	Window.Size=UDim2.fromOffset(w,h); Shadow.Size=UDim2.fromOffset(w+80,h+80)
end
applyWinSize()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyWinSize)

-- ============================================================
-- TITLE BAR
-- ============================================================
local TitleBar = Instance.new("Frame")
TitleBar.Size=UDim2.new(1,0,0,50); TitleBar.BackgroundColor3=T.sidebarBg
TitleBar.BackgroundTransparency=0.25; TitleBar.BorderSizePixel=0; TitleBar.ZIndex=14; TitleBar.Parent=Window
liquidGlass(TitleBar,{radius=18,sheen=true,strokeT=0.7})
local TBMask=Instance.new("Frame"); TBMask.Size=UDim2.new(1,0,0,18)
TBMask.Position=UDim2.new(0,0,1,-18); TBMask.BackgroundColor3=T.sidebarBg
TBMask.BackgroundTransparency=0.25; TBMask.BorderSizePixel=0; TBMask.ZIndex=14; TBMask.Parent=TitleBar

local TitleLbl=Instance.new("TextLabel"); TitleLbl.Size=UDim2.fromScale(1,1)
TitleLbl.BackgroundTransparency=1; TitleLbl.Text="System Settings"
TitleLbl.Font=Enum.Font.GothamBold; TitleLbl.TextSize=14
TitleLbl.TextColor3=T.textPrimary; TitleLbl.ZIndex=16; TitleLbl.Parent=TitleBar

-- Traffic lights
local tColors={Color3.fromRGB(255,105,97),Color3.fromRGB(255,189,68),Color3.fromRGB(85,220,95)}
local tIcons={"×","−","+"}
local trafficButtons={}
for i,col in ipairs(tColors) do
	local b=Instance.new("TextButton")
	b.Size=UDim2.fromOffset(14,14); b.Position=UDim2.fromOffset(14+(i-1)*22,18)
	b.BackgroundColor3=col; b.BorderSizePixel=0; b.AutoButtonColor=false
	b.Text=""; b.Font=Enum.Font.GothamBold; b.TextSize=10
	b.TextColor3=Color3.fromRGB(60,30,10); b.ZIndex=16; b.Parent=TitleBar
	Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
	-- Subtle top highlight only — keep them vivid
	local hl=Instance.new("UIGradient"); hl.Rotation=90
	hl.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(230,230,230))})
	hl.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.55),NumberSequenceKeypoint.new(1,1)}); hl.Parent=b
	local s=Instance.new("UIStroke"); s.Color=Color3.new(0,0,0); s.Transparency=0.88; s.Thickness=0.5; s.Parent=b
	trafficButtons[i]=b
	b.MouseEnter:Connect(function() b.Text=tIcons[i] end)
	b.MouseLeave:Connect(function() b.Text="" end)
end

-- Close
local DockIcon=nil
trafficButtons[1].MouseButton1Click:Connect(function()
	SRF.Visible = false
	tween(Window,0.3,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1})
	tween(Shadow,0.3,{ImageTransparency=1}); tween(Overlay,0.3,{BackgroundTransparency=1}); tween(Blur,0.3,{Size=0})
	task.delay(0.35,function()
		if DockIcon then DockIcon:Destroy() end
		ScreenGui:Destroy(); Blur:Destroy()
	end)
end)

-- Minimize
local function createDockIcon()
	if DockIcon then DockIcon:Destroy() end
	DockIcon=Instance.new("ImageButton"); DockIcon.Name="DockIcon"
	DockIcon.Size=UDim2.fromOffset(56,56); DockIcon.AnchorPoint=Vector2.new(0.5,0.5)
	DockIcon.Position=UDim2.new(0.5,0,1,-60); DockIcon.BackgroundColor3=T.blue
	DockIcon.BorderSizePixel=0; DockIcon.AutoButtonColor=false; DockIcon.Image=""
	DockIcon.ZIndex=30; DockIcon.Parent=ScreenGui
	local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,14); corner.Parent=DockIcon
	local grad=Instance.new("UIGradient"); grad.Rotation=135
	grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(80,170,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,100,220))})
	grad.Parent=DockIcon
	local gear=Instance.new("TextLabel"); gear.Size=UDim2.fromScale(1,1); gear.BackgroundTransparency=1
	gear.Text="⚙"; gear.Font=Enum.Font.GothamBold; gear.TextSize=32
	gear.TextColor3=Color3.fromRGB(255,255,255); gear.ZIndex=32; gear.Parent=DockIcon
	local dragging,dragStart,startPos,moved=false,nil,nil,false
	DockIcon.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true; moved=false; dragStart=input.Position; startPos=DockIcon.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end
		local delta=input.Position-dragStart
		if delta.Magnitude>4 then moved=true end
		DockIcon.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
	end)
	DockIcon.MouseButton1Click:Connect(function()
		if moved then return end
		minimized=false
		Overlay.BackgroundTransparency=1; Blur.Size=0
		Window.BackgroundTransparency=1; Shadow.ImageTransparency=1
		Overlay.Visible=true; Window.Visible=true; Shadow.Visible=true
		local w,h=getWinSize()
		tween(Window,0.4,{Size=UDim2.fromOffset(w,h),Position=UDim2.fromScale(0.5,0.5),BackgroundTransparency=0.18},Enum.EasingStyle.Back)
		tween(Shadow,0.4,{Size=UDim2.fromOffset(w+80,h+80),Position=UDim2.fromScale(0.5,0.5),ImageTransparency=0.45})
		tween(Overlay,0.4,{BackgroundTransparency=0.15}); tween(Blur,0.3,{Size=24})
		task.delay(0.4,function() if DockIcon then DockIcon:Destroy(); DockIcon=nil end end)
	end)
	DockIcon.MouseEnter:Connect(function() tween(DockIcon,0.15,{Size=UDim2.fromOffset(62,62)},Enum.EasingStyle.Back) end)
	DockIcon.MouseLeave:Connect(function() tween(DockIcon,0.15,{Size=UDim2.fromOffset(56,56)}) end)
end

trafficButtons[2].MouseButton1Click:Connect(function()
	if minimized then return end
	minimized=true; maximized=false
	SRF.Visible = false
	SearchBox.Text = ""
	tween(Window,0.3,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1})
	tween(Shadow,0.3,{ImageTransparency=1}); tween(Overlay,0.3,{BackgroundTransparency=1}); tween(Blur,0.3,{Size=0})
	task.delay(0.3,function()
		if minimized then Window.Visible=false; Shadow.Visible=false; createDockIcon() end
	end)
end)

trafficButtons[3].MouseButton1Click:Connect(function()
	if minimized then return end
	-- Hide results during resize — reshow after tween if search is active
	local hadSearch = SRF.Visible
	SRF.Visible = false
	if maximized then
		maximized=false; local w,h=getWinSize()
		tween(Window,0.35,{Size=UDim2.fromOffset(w,h),Position=UDim2.fromScale(0.5,0.5)})
		tween(Shadow,0.35,{Size=UDim2.fromOffset(w+80,h+80),Position=UDim2.fromScale(0.5,0.5)})
	else
		maximized=true
		local vp=workspace.CurrentCamera.ViewportSize
		local inset=GuiService:GetGuiInset()
		local aw,ah=vp.X-40,vp.Y-inset.Y-40
		tween(Window,0.35,{Size=UDim2.fromOffset(aw,ah),Position=UDim2.new(0.5,0,0,inset.Y+20+ah/2)})
		tween(Shadow,0.35,{Size=UDim2.fromOffset(aw+80,ah+80),Position=UDim2.new(0.5,0,0,inset.Y+20+ah/2)})
	end
	if hadSearch then
		-- Reposition after tween completes
		task.delay(0.38, function()
			task.spawn(function()
				RunService.RenderStepped:Wait()
				RunService.RenderStepped:Wait()
				local sideX  = Sidebar.AbsolutePosition.X
				local sideY  = Sidebar.AbsolutePosition.Y
				local panelH = SRF.Size.Y.Offset
				SRF.Position = UDim2.fromOffset(sideX + 8, sideY + 10 + 32 + 6 + GuiService:GetGuiInset().Y)
				SRF.Size     = UDim2.fromOffset(Sidebar.AbsoluteSize.X - 16, panelH)
				SRF.Visible  = true
			end)
		end)
	end
end)

-- ============================================================
-- SIDEBAR
-- ============================================================
local SIDEBAR_W=228
local Sidebar=Instance.new("Frame")
Sidebar.Size=UDim2.new(0,SIDEBAR_W,1,-50); Sidebar.Position=UDim2.fromOffset(0,50)
Sidebar.BackgroundColor3=T.sidebarBg; Sidebar.BackgroundTransparency=0.22
Sidebar.BorderSizePixel=0; Sidebar.ClipsDescendants=true; Sidebar.ZIndex=12; Sidebar.Parent=Window
liquidGlass(Sidebar,{radius=16,sheen=true,strokeT=0.75})

local SBDiv=Instance.new("Frame"); SBDiv.Size=UDim2.new(0,1,1,0); SBDiv.Position=UDim2.new(1,-1,0,0)
SBDiv.BackgroundColor3=Color3.fromRGB(255,255,255); SBDiv.BackgroundTransparency=0.85
SBDiv.BorderSizePixel=0; SBDiv.ZIndex=14; SBDiv.Parent=Sidebar

local SearchWrap=Instance.new("Frame"); SearchWrap.Size=UDim2.new(1,-16,0,32); SearchWrap.Position=UDim2.fromOffset(8,10)
SearchWrap.BackgroundColor3=Color3.fromRGB(255,255,255); SearchWrap.BackgroundTransparency=0.85
SearchWrap.BorderSizePixel=0; SearchWrap.ZIndex=15; SearchWrap.Parent=Sidebar
liquidGlass(SearchWrap,{radius=9,sheen=false,strokeT=0.7})
local SearchIco=Instance.new("TextLabel"); SearchIco.Size=UDim2.fromOffset(22,32); SearchIco.Position=UDim2.fromOffset(8,0)
SearchIco.BackgroundTransparency=1; SearchIco.Text="⌕"; SearchIco.Font=Enum.Font.GothamBold; SearchIco.TextSize=16
SearchIco.TextColor3=T.textTertiary; SearchIco.ZIndex=16; SearchIco.Parent=SearchWrap
SearchBox=Instance.new("TextBox"); SearchBox.Size=UDim2.new(1,-38,1,0); SearchBox.Position=UDim2.fromOffset(30,0)
SearchBox.BackgroundTransparency=1; SearchBox.PlaceholderText="Search"; SearchBox.PlaceholderColor3=T.textTertiary
SearchBox.Text=""; SearchBox.Font=Enum.Font.Gotham; SearchBox.TextSize=14
SearchBox.TextColor3=T.textPrimary; SearchBox.ClearTextOnFocus=false; SearchBox.ZIndex=16; SearchBox.Parent=SearchWrap

local ProfileCard=Instance.new("Frame"); ProfileCard.Size=UDim2.new(1,-16,0,64); ProfileCard.Position=UDim2.fromOffset(8,50)
ProfileCard.BackgroundColor3=T.cardBg; ProfileCard.BackgroundTransparency=0.4
ProfileCard.BorderSizePixel=0; ProfileCard.ZIndex=15; ProfileCard.Parent=Sidebar
liquidGlass(ProfileCard,{radius=10,sheen=true,strokeT=0.65})

-- Avatar container (circle crop via UICorner + ClipsDescendants)
local Avatar=Instance.new("Frame"); Avatar.Size=UDim2.fromOffset(42,42); Avatar.Position=UDim2.fromOffset(10,11)
Avatar.BackgroundColor3=T.blue; Avatar.BorderSizePixel=0; Avatar.ClipsDescendants=true; Avatar.ZIndex=16; Avatar.Parent=ProfileCard
Instance.new("UICorner",Avatar).CornerRadius=UDim.new(1,0)
-- Gradient fallback shown while thumbnail loads
local avGrad=Instance.new("UIGradient"); avGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,160,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,0,230))}); avGrad.Rotation=135; avGrad.Parent=Avatar
-- Fallback initial letter (hidden once image loads)
local AvatarLbl=Instance.new("TextLabel"); AvatarLbl.Size=UDim2.fromScale(1,1); AvatarLbl.BackgroundTransparency=1
AvatarLbl.Text=player.Name:sub(1,1):upper(); AvatarLbl.Font=Enum.Font.GothamBold; AvatarLbl.TextSize=20
AvatarLbl.TextColor3=Color3.new(1,1,1); AvatarLbl.ZIndex=17; AvatarLbl.Parent=Avatar
-- Actual avatar image (filled async below)
local AvatarImg=Instance.new("ImageLabel"); AvatarImg.Size=UDim2.fromScale(1,1)
AvatarImg.BackgroundTransparency=1; AvatarImg.Image=""; AvatarImg.ScaleType=Enum.ScaleType.Fit
AvatarImg.ZIndex=18; AvatarImg.Visible=false; AvatarImg.Parent=Avatar
-- White ring border on top of image
local avStroke=Instance.new("UIStroke"); avStroke.Color=Color3.fromRGB(255,255,255); avStroke.Transparency=0.6; avStroke.Thickness=1; avStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; avStroke.Parent=Avatar

local ProfName=Instance.new("TextLabel"); ProfName.Size=UDim2.new(1,-62,0,20); ProfName.Position=UDim2.fromOffset(58,12)
ProfName.BackgroundTransparency=1; ProfName.Text=player.DisplayName; ProfName.Font=Enum.Font.GothamBold; ProfName.TextSize=14
ProfName.TextColor3=T.textPrimary; ProfName.TextXAlignment=Enum.TextXAlignment.Left; ProfName.ZIndex=16; ProfName.Parent=ProfileCard
local ProfSub=Instance.new("TextLabel"); ProfSub.Size=UDim2.new(1,-62,0,16); ProfSub.Position=UDim2.fromOffset(58,32)
ProfSub.BackgroundTransparency=1; ProfSub.Text="@"..player.Name; ProfSub.Font=Enum.Font.Gotham; ProfSub.TextSize=11
ProfSub.TextColor3=T.textTertiary; ProfSub.TextXAlignment=Enum.TextXAlignment.Left; ProfSub.ZIndex=16; ProfSub.Parent=ProfileCard

-- Fetch avatar thumbnail asynchronously so it never blocks the UI
task.spawn(function()
	local ok, thumb = pcall(function()
		return Players:GetUserThumbnailAsync(
			player.UserId,
			Enum.ThumbnailType.AvatarBust,
			Enum.ThumbnailSize.Size100x100
		)
	end)
	if ok and thumb and thumb ~= "" then
		AvatarImg.Image   = thumb
		AvatarImg.Visible = true
		AvatarLbl.Visible = false  -- hide the fallback initial
		avGrad.Enabled    = false  -- hide the gradient background
		Avatar.BackgroundColor3 = Color3.fromRGB(30,30,36)  -- neutral dark behind the image
	end
end)

local SBScroll=Instance.new("ScrollingFrame")
SBScroll.Size=UDim2.new(1,0,1,-122); SBScroll.Position=UDim2.fromOffset(0,122)
SBScroll.BackgroundTransparency=1; SBScroll.BorderSizePixel=0; SBScroll.ScrollBarThickness=0
SBScroll.CanvasSize=UDim2.fromScale(1,0); SBScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
SBScroll.ZIndex=14; SBScroll.Parent=Sidebar
local SBList=Instance.new("Frame"); SBList.Size=UDim2.fromScale(1,0); SBList.AutomaticSize=Enum.AutomaticSize.Y
SBList.BackgroundTransparency=1; SBList.ZIndex=14; SBList.Parent=SBScroll
local sbl=Instance.new("UIListLayout"); sbl.Padding=UDim.new(0,0); sbl.SortOrder=Enum.SortOrder.LayoutOrder; sbl.Parent=SBList
local sbp=Instance.new("UIPadding"); sbp.PaddingLeft=UDim.new(0,8); sbp.PaddingRight=UDim.new(0,8); sbp.PaddingTop=UDim.new(0,4); sbp.Parent=SBList

-- ============================================================
-- CONTENT AREA
-- ============================================================
local ContentArea=Instance.new("Frame")
ContentArea.Size=UDim2.new(1,-(SIDEBAR_W+2),1,-50); ContentArea.Position=UDim2.fromOffset(SIDEBAR_W+2,50)
ContentArea.BackgroundTransparency=1; ContentArea.BorderSizePixel=0
ContentArea.ClipsDescendants=true; ContentArea.ZIndex=12; ContentArea.Parent=Window
local ContentScroll=Instance.new("ScrollingFrame")
ContentScroll.Size=UDim2.fromScale(1,1); ContentScroll.BackgroundTransparency=1
ContentScroll.BorderSizePixel=0; ContentScroll.ScrollBarThickness=4
ContentScroll.ScrollBarImageColor3=Color3.fromRGB(255,255,255); ContentScroll.ScrollBarImageTransparency=0.6
ContentScroll.CanvasSize=UDim2.fromScale(1,0); ContentScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
ContentScroll.ZIndex=12; ContentScroll.Parent=ContentArea
local ContentList=Instance.new("CanvasGroup")
ContentList.Size=UDim2.fromScale(1,0); ContentList.AutomaticSize=Enum.AutomaticSize.Y
ContentList.BackgroundTransparency=1; ContentList.ZIndex=12; ContentList.Parent=ContentScroll
local cl=Instance.new("UIListLayout"); cl.Padding=UDim.new(0,0); cl.SortOrder=Enum.SortOrder.LayoutOrder; cl.Parent=ContentList
local clp=Instance.new("UIPadding"); clp.PaddingLeft=UDim.new(0,24); clp.PaddingRight=UDim.new(0,24); clp.PaddingTop=UDim.new(0,22); clp.PaddingBottom=UDim.new(0,28); clp.Parent=ContentList


-- ============================================================
-- DYNAMIC ISLAND NOTIFICATION SYSTEM
-- ============================================================
local DI_QUEUE     = {}
local DI_SHOWING   = false
local DI_HOLD_TIME = 2.2
local DI_COOLDOWN  = 0.08

local DI_TYPE_ICON = { toggle="◉", slider="≡", dropdown="◆", button="▶", custom="●", error="✕", warning="⚠" }
local DI_TYPE_COLOR = {
	toggle=T.toggleOn, slider=T.sliderFill, dropdown=T.blue, button=T.blue, custom=T.orange,
	error=T.red, warning=T.yellow
}

-- Island frame
local DI_Frame = Instance.new("Frame")
DI_Frame.Name="DynamicIsland"; DI_Frame.AnchorPoint=Vector2.new(0.5,0)
DI_Frame.Position=UDim2.new(0.5,0,0,0); DI_Frame.Size=UDim2.fromOffset(0,36)
-- Position is set properly at first show, after GuiInset is known
DI_Frame.BackgroundColor3=Color3.fromRGB(10,10,14); DI_Frame.BackgroundTransparency=0
DI_Frame.BorderSizePixel=0; DI_Frame.ClipsDescendants=true
-- DI_Frame starts as a visible dot and stays visible always — it expands and contracts
DI_Frame.ZIndex=100; DI_Frame.Visible=true; DI_Frame.Parent=ScreenGui
DI_Frame.Position=UDim2.new(0.5,0,0,8); DI_Frame.Size=UDim2.fromOffset(36,36)
local diCorner=Instance.new("UICorner"); diCorner.CornerRadius=UDim.new(1,0); diCorner.Parent=DI_Frame
local diStroke=Instance.new("UIStroke"); diStroke.Color=Color3.fromRGB(255,255,255)
diStroke.Transparency=0.78; diStroke.Thickness=1
diStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; diStroke.Parent=DI_Frame

-- Top sheen
local diSheen=Instance.new("Frame"); diSheen.Size=UDim2.new(1,-4,0.5,0)
diSheen.Position=UDim2.new(0,2,0,2); diSheen.BackgroundColor3=Color3.fromRGB(255,255,255)
diSheen.BackgroundTransparency=0.88; diSheen.BorderSizePixel=0; diSheen.ZIndex=101; diSheen.Parent=DI_Frame
Instance.new("UICorner",diSheen).CornerRadius=UDim.new(1,0)
local diSG=Instance.new("UIGradient"); diSG.Rotation=90
diSG.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.5),NumberSequenceKeypoint.new(1,1)}); diSG.Parent=diSheen

-- Accent bar
local diAccent=Instance.new("Frame"); diAccent.Size=UDim2.new(0,3,0.6,0)
diAccent.AnchorPoint=Vector2.new(0,0.5); diAccent.Position=UDim2.new(0,10,0.5,0)
diAccent.BackgroundColor3=T.blue; diAccent.BorderSizePixel=0; diAccent.ZIndex=102
diAccent.Visible=false; diAccent.Parent=DI_Frame
Instance.new("UICorner",diAccent).CornerRadius=UDim.new(1,0)

-- Icon
local diIcon=Instance.new("TextLabel"); diIcon.Size=UDim2.fromOffset(22,36)
diIcon.Position=UDim2.fromOffset(18,0); diIcon.BackgroundTransparency=1
diIcon.Font=Enum.Font.GothamBold; diIcon.TextSize=14
diIcon.TextColor3=Color3.fromRGB(255,255,255); diIcon.ZIndex=102; diIcon.Parent=DI_Frame

-- Main label
local diLabel=Instance.new("TextLabel"); diLabel.Size=UDim2.new(1,-100,1,0)
diLabel.Position=UDim2.fromOffset(44,0); diLabel.BackgroundTransparency=1
diLabel.Font=Enum.Font.GothamSemibold; diLabel.TextSize=13
diLabel.TextColor3=Color3.fromRGB(255,255,255); diLabel.TextXAlignment=Enum.TextXAlignment.Left
diLabel.TextTruncate=Enum.TextTruncate.AtEnd; diLabel.ZIndex=102; diLabel.Parent=DI_Frame

-- Value badge
local diBadge=Instance.new("Frame"); diBadge.Size=UDim2.fromOffset(0,22)
diBadge.AnchorPoint=Vector2.new(1,0.5); diBadge.Position=UDim2.new(1,-10,0.5,0)
diBadge.BackgroundColor3=Color3.fromRGB(40,40,50); diBadge.BorderSizePixel=0
diBadge.ZIndex=102; diBadge.Visible=false; diBadge.Parent=DI_Frame
Instance.new("UICorner",diBadge).CornerRadius=UDim.new(0,6)
local diBStr=Instance.new("UIStroke"); diBStr.Color=Color3.fromRGB(255,255,255)
diBStr.Transparency=0.82; diBStr.Thickness=0.8; diBStr.Parent=diBadge
local diBadgeLbl=Instance.new("TextLabel"); diBadgeLbl.Size=UDim2.fromScale(1,1)
diBadgeLbl.BackgroundTransparency=1; diBadgeLbl.Font=Enum.Font.GothamBold; diBadgeLbl.TextSize=11
diBadgeLbl.TextColor3=Color3.fromRGB(220,220,230); diBadgeLbl.ZIndex=103; diBadgeLbl.Parent=diBadge

-- Slider progress bar (bottom edge of island)
local diProgress=Instance.new("Frame"); diProgress.Size=UDim2.fromOffset(0,2)
diProgress.AnchorPoint=Vector2.new(0,1); diProgress.Position=UDim2.new(0,0,1,0)
diProgress.BackgroundColor3=T.sliderFill; diProgress.BorderSizePixel=0
diProgress.ZIndex=103; diProgress.Visible=false; diProgress.Parent=DI_Frame
Instance.new("UICorner",diProgress).CornerRadius=UDim.new(1,0)

-- ── Dismiss / show logic ─────────────────────────────────────
local diDismissThread  = nil
local diCollapseThread = nil
local diCurrentLabel   = nil
local diCurrentTotalW  = 190
local diOpening        = false  -- true while expand animation is in progress

local function diCancelAll()
	if diDismissThread  then task.cancel(diDismissThread);  diDismissThread  = nil end
	if diCollapseThread then task.cancel(diCollapseThread); diCollapseThread = nil end
	diOpening = false
end

local function diHide()
	diCollapseThread = nil
	-- Snap back to dot — frame stays visible
	DI_Frame.Size = UDim2.fromOffset(36, 36)
	DI_Frame.BackgroundTransparency = 0
	diProgress.Size = UDim2.fromOffset(0, 2)
	diProgress.Visible = false
	diAccent.Visible = false
	diIcon.Text = ""; diLabel.Text = ""; diBadgeLbl.Text = ""
	diBadge.Visible = false
	DI_SHOWING = false
	diCurrentLabel = nil
	if #DI_QUEUE > 0 then
		local nxt = table.remove(DI_QUEUE, 1)
		task.delay(DI_COOLDOWN, nxt)
	end
end

local function diDismiss()
	diDismissThread = nil
	diAccent.Visible = false
	diIcon.Text = ""; diLabel.Text = ""; diBadgeLbl.Text = ""
	diBadge.Visible = false; diProgress.Visible = false
	tween(DI_Frame, 0.25, {Size=UDim2.fromOffset(36, 36)}, Enum.EasingStyle.Quart)
	diCollapseThread = task.delay(0.26, diHide)
end

local function diExpand(ctrlType, labelText, valueText)
	local icon   = DI_TYPE_ICON[ctrlType] or "●"
	local accent = DI_TYPE_COLOR[ctrlType] or T.blue
	local hasVal = (valueText ~= nil and valueText ~= "")
	local badgeW = math.max(40, #(valueText or "") * 9 + 16)
	local labelW = math.max(90, #(labelText or "") * 10)
	local totalW = math.clamp(18 + 22 + 8 + labelW + (hasVal and badgeW + 12 or 0) + 20, 140, 460)

	-- Hide text content while frame is still a dot so clipping looks like a clean circle
	diIcon.Text = ""; diLabel.Text = ""; diBadgeLbl.Text = ""
	diBadge.Visible = false
	diProgress.Visible = false
	diProgress.Size = UDim2.fromOffset(0, 3)
	diAccent.BackgroundColor3 = accent

	diCurrentTotalW = totalW

	-- Frame is always visible as a dot — spring open from current dot size
	DI_Frame.Position = UDim2.new(0.5, 0, 0, 8)
	DI_Frame.BackgroundTransparency = 0
	DI_Frame.Size = UDim2.fromOffset(36, 36)

	diOpening = true
	tween(DI_Frame, 0.5, {Size=UDim2.fromOffset(totalW, 36)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	task.delay(0.5, function() diOpening = false end)

	task.delay(0.2, function()
		diAccent.Visible = true
		diIcon.Text     = icon
		diLabel.Text    = labelText or ""
		diBadgeLbl.Text = valueText or ""
		diBadge.Size    = UDim2.fromOffset(badgeW, 22)
		diBadge.Visible = (valueText ~= nil and valueText ~= "")
	end)
	-- Jiggle after island fully expanded
	if ctrlType == "slider" then
		task.delay(0.55, function()
			local pct    = tonumber(((valueText or "0"):gsub("%%",""))) or 0
			local innerW = math.max(0, (pct/100) * (totalW - 20))
			diProgress.BackgroundColor3 = accent
			diProgress.AnchorPoint = Vector2.new(0, 1)
			diProgress.Position    = UDim2.new(0, 10, 1, -3)
			diProgress.Visible     = true
			local overshoot = math.min(innerW + 18, totalW - 20)
			tween(diProgress, 0.12, {Size=UDim2.fromOffset(overshoot, 3)}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			task.delay(0.12, function()
				tween(diProgress, 0.3, {Size=UDim2.fromOffset(innerW, 3)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end)
		end)
	end

	diDismissThread = task.delay(DI_HOLD_TIME, diDismiss)
end

local function diShow(ctrlType, labelText, valueText)
	diCancelAll()
	diCurrentLabel = labelText
	if DI_SHOWING then
		-- Clear content and snap back to dot, then expand fresh
		DI_SHOWING = false
		diOpening = false
		diAccent.Visible = false
		diIcon.Text = ""; diLabel.Text = ""; diBadgeLbl.Text = ""
		diBadge.Visible = false; diProgress.Visible = false
		tween(DI_Frame, 0.12, {Size=UDim2.fromOffset(36, 36)}, Enum.EasingStyle.Quart)
		diCollapseThread = task.delay(0.12, function()
			diCollapseThread = nil
			DI_SHOWING = true
			diExpand(ctrlType, labelText, valueText)
		end)
	else
		DI_SHOWING = true
		diExpand(ctrlType, labelText, valueText)
	end
end

local function notify(ctrlType, label, value)
	if DI_SHOWING then
		if #DI_QUEUE < 3 then
			table.insert(DI_QUEUE, function() diShow(ctrlType, label, value) end)
		end
	else
		diShow(ctrlType, label, value)
	end
end

-- ============================================================
-- LIBRARY STATE
-- ============================================================
local LG_tabs       = {}  -- ordered list of tab names
local LG_tabData    = {}  -- [name] = { iconName, subText, sections=[] }
local LG_sidebarBtns= {}  -- [name] = {bg, lbl}
local LG_sbOrder    = 0
local LG_config     = {}
local LG_selected   = nil

-- ============================================================
-- INTERNAL BUILDERS
-- ============================================================
local function spacer(parent,h,order)
	local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,h or 8)
	f.BackgroundTransparency=1; f.LayoutOrder=order or 0; f.Parent=parent
end

local function addDivider(card,order)
	local d=Instance.new("Frame"); d.Size=UDim2.new(1,-18,0,1); d.Position=UDim2.fromOffset(18,0)
	d.BackgroundColor3=Color3.fromRGB(255,255,255); d.BackgroundTransparency=0.85
	d.BorderSizePixel=0; d.LayoutOrder=order; d.ZIndex=15; d.Parent=card
end

local function makeCard(parent,order)
	local card=Instance.new("Frame"); card.Size=UDim2.new(1,0,0,0); card.AutomaticSize=Enum.AutomaticSize.Y
	card.BackgroundColor3=T.cardBg; card.BackgroundTransparency=0.35
	card.BorderSizePixel=0; card.LayoutOrder=order; card.ZIndex=13; card.Parent=parent
	liquidGlass(card,{radius=12,sheen=false,strokeT=0.65})
	local content=Instance.new("Frame"); content.Name="Content"
	content.Size=UDim2.new(1,0,0,0); content.AutomaticSize=Enum.AutomaticSize.Y
	content.BackgroundTransparency=1; content.BorderSizePixel=0; content.ZIndex=14; content.Parent=card
	local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,0); l.SortOrder=Enum.SortOrder.LayoutOrder
	l.FillDirection=Enum.FillDirection.Vertical; l.HorizontalAlignment=Enum.HorizontalAlignment.Left; l.Parent=content
	return content
end

-- ── Toggle ──────────────────────────────────────────────────
local function buildToggle(card, label, defaultVal, callback, rowOrder, divOrder)
	local val = defaultVal
	local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,44); row.BackgroundTransparency=1
	row.BorderSizePixel=0; row.LayoutOrder=rowOrder; row.ZIndex=15; row.Parent=card
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.6,0,1,0); lbl.Position=UDim2.fromOffset(16,0)
	lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=14
	lbl.TextColor3=T.textPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=16; lbl.Parent=row
	local tBg=Instance.new("TextButton"); tBg.Size=UDim2.fromOffset(48,27); tBg.AnchorPoint=Vector2.new(1,0.5)
	tBg.Position=UDim2.new(1,-16,0.5,0); tBg.BackgroundColor3=val and T.toggleOn or T.toggleOff
	tBg.BackgroundTransparency=0.1; tBg.AutoButtonColor=false; tBg.BorderSizePixel=0
	tBg.Text=""; tBg.ZIndex=16; tBg.Parent=row
	liquidGlass(tBg,{radius=14,sheen=true,strokeT=0.6})
	local knob=Instance.new("Frame"); knob.Size=UDim2.fromOffset(21,21); knob.BackgroundColor3=Color3.new(1,1,1)
	knob.Position=val and UDim2.fromOffset(24,3) or UDim2.fromOffset(3,3)
	knob.BorderSizePixel=0; knob.ZIndex=18; knob.Parent=tBg
	Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
	local kg=Instance.new("UIGradient"); kg.Rotation=90
	kg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(220,220,228))}); kg.Parent=knob
	local ks=Instance.new("UIStroke"); ks.Color=Color3.fromRGB(180,180,190); ks.Transparency=0.5; ks.Parent=knob
	-- Keep knob centred vertically so squeeze doesn't shift it
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Position    = val and UDim2.new(0,24,0.5,0) or UDim2.new(0,3,0.5,0)
	tBg.AnchorPoint  = Vector2.new(1, 0.5)
	tBg.MouseButton1Click:Connect(function()
		val=not val
		tween(tBg,0.08,{Size=UDim2.fromOffset(44,24)},Enum.EasingStyle.Quad)
		task.delay(0.08,function()
			tween(tBg,0.35,{Size=UDim2.fromOffset(48,27)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		end)
		tween(tBg,0.2,{BackgroundColor3=val and T.toggleOn or T.toggleOff})
		tween(knob,0.4,{Position=val and UDim2.new(0,24,0.5,0) or UDim2.new(0,3,0.5,0)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		if callback then callback(val) end
	end)
	if divOrder then addDivider(card,divOrder) end
	-- control handle
	return {
		GetValue=function() return val end,
		SetValue=function(_,v)
			val=v
			tBg.BackgroundColor3=val and T.toggleOn or T.toggleOff
			knob.Position=val and UDim2.new(0,24,0.5,0) or UDim2.new(0,3,0.5,0)
		end
	}
end

-- ── Slider ──────────────────────────────────────────────────
local function buildSlider(card, label, defaultVal, callback, rowOrder, divOrder)
	local val = math.clamp(defaultVal or 0.5, 0, 1)
	local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,56); row.BackgroundTransparency=1
	row.BorderSizePixel=0; row.LayoutOrder=rowOrder; row.ZIndex=15; row.Parent=card
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.55,0,0,20); lbl.Position=UDim2.fromOffset(16,8)
	lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=14
	lbl.TextColor3=T.textPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=16; lbl.Parent=row
	local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0.38,0,0,20); valLbl.Position=UDim2.new(0.55,0,0,8)
	valLbl.BackgroundTransparency=1; valLbl.Text=math.round(val*100).."%"
	valLbl.Font=Enum.Font.Gotham; valLbl.TextSize=13; valLbl.TextColor3=T.textSecond
	valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.ZIndex=16; valLbl.Parent=row
	local track=Instance.new("Frame"); track.Size=UDim2.new(1,-32,0,5); track.Position=UDim2.fromOffset(16,36)
	track.BackgroundColor3=T.sliderTrack; track.BackgroundTransparency=0.2
	track.BorderSizePixel=0; track.ZIndex=16; track.Parent=row
	Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
	local ts=Instance.new("UIStroke"); ts.Color=Color3.fromRGB(255,255,255); ts.Transparency=0.8; ts.Parent=track
	local fill=Instance.new("Frame"); fill.Size=UDim2.fromScale(val,1); fill.BackgroundColor3=T.sliderFill
	fill.BorderSizePixel=0; fill.ZIndex=17; fill.Parent=track
	Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
	local fg=Instance.new("UIGradient"); fg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(80,180,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,100,230))}); fg.Parent=fill
	local knob=Instance.new("Frame"); knob.Size=UDim2.fromOffset(17,17); knob.AnchorPoint=Vector2.new(0.5,0.5)
	knob.Position=UDim2.new(val,0,0.5,0); knob.BackgroundColor3=Color3.new(1,1,1)
	knob.BorderSizePixel=0; knob.ZIndex=18; knob.Parent=track
	Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
	local kg=Instance.new("UIGradient"); kg.Rotation=90
	kg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(220,220,228))}); kg.Parent=knob
	local ks=Instance.new("UIStroke"); ks.Color=Color3.fromRGB(160,160,170); ks.Transparency=0.4; ks.Thickness=1; ks.Parent=knob
	local dragging=false

	-- Start drag from anywhere on the track OR the knob
	local function startDrag(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			-- Lock all scrolling so drag doesn't scroll the page
			ContentScroll.ScrollingEnabled = false
			SBScroll.ScrollingEnabled      = false
			-- Snap value immediately to click position on track
			local tp=track.AbsolutePosition; local ts2=track.AbsoluteSize
			val=math.clamp((i.Position.X-tp.X)/ts2.X,0,1)
			fill.Size=UDim2.fromScale(val,1); knob.Position=UDim2.new(val,0,0.5,0)
			valLbl.Text=math.round(val*100).."%"
			if callback then callback(val) end
		end
	end
	track.InputBegan:Connect(startDrag)
	knob.InputBegan:Connect(startDrag)

	-- Use a scoped connection stored in a variable so we can manage it cleanly
	local moveConn, endConn

	-- Throttle: only update DI every N seconds while dragging
	local DI_THROTTLE  = 0
	local lastDIUpdate = 0

	moveConn = UserInputService.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
		local tp=track.AbsolutePosition; local ts2=track.AbsoluteSize
		val=math.clamp((i.Position.X-tp.X)/ts2.X,0,1)
		fill.Size=UDim2.fromScale(val,1); knob.Position=UDim2.new(val,0,0.5,0)
		valLbl.Text=math.round(val*100).."%"
		if callback then callback(val) end
		-- Live update the Dynamic Island while dragging (throttled)
		if not callback then return end  -- only live-update if user passed a callback (opted in)
		local now = tick()
		if now - lastDIUpdate >= DI_THROTTLE then
			lastDIUpdate = now
			if (DI_SHOWING or diCurrentLabel ~= nil) and diCurrentLabel == label then
				-- Same slider — update text and progress bar in place, reset timer
				diBadgeLbl.Text = math.round(val*100).."%"
				local pct = val
				local innerW = math.max(0, pct * (diCurrentTotalW - 20))
				diProgress.Visible = true
				-- Smooth linear track while dragging — jiggle happens on release
				tween(diProgress, 0.08, {Size=UDim2.fromOffset(innerW, 3)}, Enum.EasingStyle.Linear)
				if diDismissThread  then task.cancel(diDismissThread);  diDismissThread  = nil end
				if diCollapseThread then task.cancel(diCollapseThread); diCollapseThread = nil end
				diDismissThread = task.delay(DI_HOLD_TIME, diDismiss)
			else
				-- Different slider — only trigger if not already opening/showing this label
				if diCurrentLabel ~= label and not diOpening then
					diShow("slider", label, math.round(val*100).."%")
				end
			end
		end
	end)

	endConn = UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			if dragging then
				-- Re-enable scrolling
				ContentScroll.ScrollingEnabled = true
				SBScroll.ScrollingEnabled      = true
				if callback then
					DI_QUEUE = {}
					if DI_SHOWING then
						-- Island already open — fire jiggle once on release then hold
						if diDismissThread  then task.cancel(diDismissThread);  diDismissThread  = nil end
						if diCollapseThread then task.cancel(diCollapseThread); diCollapseThread = nil end
						local innerW = math.max(0, val * (diCurrentTotalW - 20))
						local overshoot = math.min(innerW + 18, diCurrentTotalW - 20)
						tween(diProgress, 0.12, {Size=UDim2.fromOffset(overshoot, 3)}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						task.delay(0.12, function()
							tween(diProgress, 0.3, {Size=UDim2.fromOffset(innerW, 3)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
						end)
						diDismissThread = task.delay(DI_HOLD_TIME, diDismiss)
					else
						-- Island not open (e.g. very quick tap) — show it once
						notify("slider", label, math.round(val*100).."%")
					end
				end
			end
			dragging=false
		end
	end)

	-- Clean up connections when the row is removed (page switch destroys it)
	row.AncestryChanged:Connect(function()
		if not row.Parent then
			moveConn:Disconnect()
			endConn:Disconnect()
		end
	end)
	if divOrder then addDivider(card,divOrder) end
	return {
		GetValue=function() return val end,
		SetValue=function(_,v)
			val=math.clamp(v,0,1)
			fill.Size=UDim2.fromScale(val,1); knob.Position=UDim2.new(val,0,0.5,0)
			valLbl.Text=math.round(val*100).."%"
		end
	}
end

-- ── Info ────────────────────────────────────────────────────
local function buildInfo(card, label, value, rowOrder, divOrder)
	local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,44); row.BackgroundTransparency=1
	row.BorderSizePixel=0; row.LayoutOrder=rowOrder; row.ZIndex=15; row.Parent=card
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.55,0,1,0); lbl.Position=UDim2.fromOffset(16,0)
	lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=14
	lbl.TextColor3=T.textPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=16; lbl.Parent=row
	local val=Instance.new("TextLabel"); val.Size=UDim2.new(0.42,-16,1,0); val.Position=UDim2.new(0.55,0,0,0)
	val.BackgroundTransparency=1; val.Text=tostring(value).."  ›"; val.Font=Enum.Font.Gotham; val.TextSize=14
	val.TextColor3=T.textSecond; val.TextXAlignment=Enum.TextXAlignment.Right; val.ZIndex=16; val.Parent=row
	local hit=Instance.new("TextButton"); hit.Size=UDim2.fromScale(1,1); hit.BackgroundTransparency=1
	hit.Text=""; hit.AutoButtonColor=false; hit.ZIndex=17; hit.Parent=row
	hit.MouseEnter:Connect(function() tween(row,0.1,{BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.92}) end)
	hit.MouseLeave:Connect(function() tween(row,0.1,{BackgroundTransparency=1}) end)
	if divOrder then addDivider(card,divOrder) end
	return {
		GetValue=function() return val.Text:gsub("  ›","") end,
		SetValue=function(_,v) val.Text=tostring(v).."  ›" end
	}
end

-- ── Dropdown ────────────────────────────────────────────────
local activeDropdown = nil  -- only one open at a time

local function buildDropdown(card, label, options, defaultIndex, callback, rowOrder, divOrder)
	local selectedIdx = math.clamp(defaultIndex or 1, 1, #options)
	local open = false

	local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,44); row.BackgroundTransparency=1
	row.BorderSizePixel=0; row.LayoutOrder=rowOrder; row.ZIndex=15; row.Parent=card
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.5,0,1,0); lbl.Position=UDim2.fromOffset(16,0)
	lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=14
	lbl.TextColor3=T.textPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=16; lbl.Parent=row

	-- Pill button
	local pill=Instance.new("TextButton"); pill.Size=UDim2.fromOffset(130,28)
	pill.AnchorPoint=Vector2.new(1,0.5); pill.Position=UDim2.new(1,-16,0.5,0)
	pill.BackgroundColor3=T.btnBg; pill.BackgroundTransparency=0.15; pill.BorderSizePixel=0
	pill.AutoButtonColor=false; pill.Text=""; pill.ZIndex=16; pill.Parent=row
	liquidGlass(pill,{radius=8,sheen=false,strokeT=0.6})
	local pillLbl=Instance.new("TextLabel"); pillLbl.Size=UDim2.new(1,-28,1,0); pillLbl.Position=UDim2.fromOffset(10,0)
	pillLbl.BackgroundTransparency=1; pillLbl.Text=options[selectedIdx]; pillLbl.Font=Enum.Font.GothamMedium
	pillLbl.TextSize=13; pillLbl.TextColor3=T.textPrimary; pillLbl.TextXAlignment=Enum.TextXAlignment.Left
	pillLbl.ZIndex=17; pillLbl.Parent=pill
	local chevron=Instance.new("TextLabel"); chevron.Size=UDim2.fromOffset(20,28); chevron.AnchorPoint=Vector2.new(1,0.5)
	chevron.Position=UDim2.new(1,-4,0.5,0); chevron.BackgroundTransparency=1; chevron.Text="⌄"
	chevron.Font=Enum.Font.GothamBold; chevron.TextSize=12; chevron.TextColor3=T.textSecond; chevron.ZIndex=17; chevron.Parent=pill

	-- Dropdown panel (floats in ScreenGui, solid dark — same style as search results)
	local panel=Instance.new("Frame")
	panel.Name="DropPanel"; panel.Visible=false
	panel.BackgroundColor3=Color3.fromRGB(22,22,28); panel.BackgroundTransparency=0
	panel.BorderSizePixel=0; panel.ZIndex=50; panel.Parent=ScreenGui
	local panelCorner=Instance.new("UICorner"); panelCorner.CornerRadius=UDim.new(0,10); panelCorner.Parent=panel
	local panelStroke=Instance.new("UIStroke"); panelStroke.Color=Color3.fromRGB(255,255,255)
	panelStroke.Transparency=0.78; panelStroke.Thickness=1
	panelStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; panelStroke.Parent=panel
	local panelList=Instance.new("Frame"); panelList.Size=UDim2.fromScale(1,0); panelList.AutomaticSize=Enum.AutomaticSize.Y
	panelList.BackgroundTransparency=1; panelList.ZIndex=51; panelList.Parent=panel
	local pll=Instance.new("UIListLayout"); pll.Padding=UDim.new(0,0); pll.SortOrder=Enum.SortOrder.LayoutOrder; pll.Parent=panelList
	local plp=Instance.new("UIPadding"); plp.PaddingTop=UDim.new(0,4); plp.PaddingBottom=UDim.new(0,4); plp.Parent=panelList

	local optionBtns={}
	for i,opt in ipairs(options) do
		local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,0,0,34)
		ob.BackgroundColor3=T.dropdownHov; ob.BackgroundTransparency=1
		ob.BorderSizePixel=0; ob.AutoButtonColor=false; ob.Text=""
		ob.LayoutOrder=i; ob.ZIndex=52; ob.Parent=panelList
		local ol=Instance.new("TextLabel"); ol.Size=UDim2.new(1,-16,1,0); ol.Position=UDim2.fromOffset(14,0)
		ol.BackgroundTransparency=1; ol.Text=opt; ol.Font=Enum.Font.Gotham; ol.TextSize=13
		ol.TextColor3=i==selectedIdx and T.textPrimary or T.textSecond
		ol.TextXAlignment=Enum.TextXAlignment.Left; ol.ZIndex=53; ol.Parent=ob
		local checkLbl=Instance.new("TextLabel"); checkLbl.Size=UDim2.fromOffset(18,34)
		checkLbl.AnchorPoint=Vector2.new(1,0.5); checkLbl.Position=UDim2.new(1,-8,0.5,0)
		checkLbl.BackgroundTransparency=1; checkLbl.Text=i==selectedIdx and "✓" or ""
		checkLbl.Font=Enum.Font.GothamBold; checkLbl.TextSize=12; checkLbl.TextColor3=T.blue
		checkLbl.ZIndex=53; checkLbl.Parent=ob
		optionBtns[i]={btn=ob,lbl=ol,check=checkLbl}
		ob.MouseEnter:Connect(function() tween(ob,0.08,{BackgroundTransparency=0.55}) end)
		ob.MouseLeave:Connect(function() tween(ob,0.08,{BackgroundTransparency=1}) end)
		ob.MouseButton1Click:Connect(function()
			-- deselect old
			if optionBtns[selectedIdx] then
				optionBtns[selectedIdx].lbl.TextColor3=T.textSecond
				optionBtns[selectedIdx].check.Text=""
			end
			selectedIdx=i; pillLbl.Text=opt
			ol.TextColor3=T.textPrimary; checkLbl.Text="✓"
			if callback then callback(selectedIdx, opt) end
			-- close
			open=false; tween(panel,0.15,{BackgroundTransparency=1}); task.delay(0.15,function() panel.Visible=false end)
			activeDropdown=nil
		end)
	end

	local function positionPanel()
		local abs=pill.AbsolutePosition; local sz=pill.AbsoluteSize
		local itemH=34; local padV=8
		local totalH=itemH*#options+padV
		panel.Size=UDim2.fromOffset(math.max(sz.X,160),totalH)
		-- try to open below, fallback above if near bottom of screen
		local vp=workspace.CurrentCamera.ViewportSize
		if abs.Y+sz.Y+totalH+8 < vp.Y then
			panel.Position=UDim2.fromOffset(abs.X+sz.X-panel.Size.X.Offset, abs.Y+sz.Y+4)
		else
			panel.Position=UDim2.fromOffset(abs.X+sz.X-panel.Size.X.Offset, abs.Y-totalH-4)
		end
	end

	-- Reposition the panel whenever the content area scrolls
	ContentScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if open then positionPanel() end
	end)

	pill.MouseEnter:Connect(function() tween(pill,0.08,{BackgroundColor3=T.btnHov,BackgroundTransparency=0.1}) end)
	pill.MouseLeave:Connect(function() tween(pill,0.08,{BackgroundColor3=T.btnBg,BackgroundTransparency=0.15}) end)

	local function openPanel()
		positionPanel()
		panel.BackgroundTransparency=1
		panel.Size=UDim2.fromOffset(panel.Size.X.Offset, 0)
		panel.Visible=true
		tween(panel,0.2,{BackgroundTransparency=0,Size=UDim2.fromOffset(panel.Size.X.Offset,#options*34+8)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		activeDropdown=panel
	end

	local function closePanel()
		open=false
		tween(panel,0.08,{Size=UDim2.fromOffset(panel.Size.X.Offset, math.max(0,panel.Size.Y.Offset-6))},Enum.EasingStyle.Quad)
		task.delay(0.06,function()
			tween(panel,0.25,{Size=UDim2.fromOffset(panel.Size.X.Offset,0),BackgroundTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In)
			task.delay(0.25,function() panel.Visible=false; panel.BackgroundTransparency=0 end)
		end)
		activeDropdown=nil
	end

	pill.MouseButton1Click:Connect(function()
		-- close other dropdown if open
		if activeDropdown and activeDropdown~=panel then
			activeDropdown.Visible=false; activeDropdown=nil
		end
		open=not open
		if open then openPanel() else closePanel() end
	end)

	-- Close when clicking elsewhere
	UserInputService.InputBegan:Connect(function(input,gp)
		if not gp and open and input.UserInputType==Enum.UserInputType.MouseButton1 then
			task.defer(function()
				if open then
					closePanel()
				end
			end)
		end
	end)

	if divOrder then addDivider(card,divOrder) end
	return {
		GetValue=function() return selectedIdx end,
		SetValue=function(_,idx)
			if optionBtns[selectedIdx] then
				optionBtns[selectedIdx].lbl.TextColor3=T.textSecond
				optionBtns[selectedIdx].check.Text=""
			end
			selectedIdx=math.clamp(idx,1,#options)
			pillLbl.Text=options[selectedIdx]
			if optionBtns[selectedIdx] then
				optionBtns[selectedIdx].lbl.TextColor3=T.textPrimary
				optionBtns[selectedIdx].check.Text="✓"
			end
		end
	}
end

-- ── Button ───────────────────────────────────────────────────
local function buildButton(card, label, btnText, callback, rowOrder, divOrder)
	local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,44); row.BackgroundTransparency=1
	row.BorderSizePixel=0; row.LayoutOrder=rowOrder; row.ZIndex=15; row.Parent=card
	local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.55,0,1,0); lbl.Position=UDim2.fromOffset(16,0)
	lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=14
	lbl.TextColor3=T.textPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=16; lbl.Parent=row
	local btn=Instance.new("TextButton"); btn.Size=UDim2.fromOffset(100,28)
	btn.AnchorPoint=Vector2.new(0.5,0.5); btn.Position=UDim2.new(1,-66,0.5,0)
	btn.BackgroundColor3=T.blue; btn.BackgroundTransparency=0.1; btn.BorderSizePixel=0
	btn.AutoButtonColor=false; btn.Text=btnText; btn.Font=Enum.Font.GothamSemibold
	btn.TextSize=13; btn.TextColor3=T.textPrimary; btn.ZIndex=16; btn.Parent=row
	liquidGlass(btn,{radius=8,sheen=true,strokeT=0.55})
	btn.MouseEnter:Connect(function() tween(btn,0.08,{BackgroundTransparency=0}) end)
	btn.MouseLeave:Connect(function() tween(btn,0.08,{BackgroundTransparency=0.1}) end)
	btn.MouseButton1Click:Connect(function()
		-- Subtle press-down then spring back from anchor point
		tween(btn,0.07,{Size=UDim2.fromOffset(96,25)},Enum.EasingStyle.Quad)
		task.delay(0.07,function()
			tween(btn,0.3,{Size=UDim2.fromOffset(100,28)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		end)
		tween(btn,0.08,{BackgroundColor3=T.blue:Lerp(Color3.new(1,1,1),0.2)})
		task.delay(0.15,function() tween(btn,0.2,{BackgroundColor3=T.blue}) end)
		if callback then callback() end
	end)
	if divOrder then addDivider(card,divOrder) end
	return {}
end

-- ============================================================
-- SIDEBAR ROW BUILDER (internal)
-- ============================================================
local selectPage  -- forward decl

local function buildSidebarRow(tabName, iconName, subText)
	local H = 38  -- always 38 — subtitle fits inside without extra height
	local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,H); row.BackgroundTransparency=1
	row.LayoutOrder=LG_sbOrder; LG_sbOrder+=1; row.ZIndex=15; row.Parent=SBList

	local bg=Instance.new("Frame"); bg.Size=UDim2.fromScale(1,1); bg.BackgroundColor3=T.activeItem
	bg.BackgroundTransparency=1; bg.BorderSizePixel=0; bg.ZIndex=15; bg.Parent=row
	Instance.new("UICorner",bg).CornerRadius=UDim.new(0,8)

	local iconSize=26
	local iconBg=Instance.new("Frame"); iconBg.Size=UDim2.fromOffset(iconSize,iconSize)
	iconBg.AnchorPoint=Vector2.new(0,0.5); iconBg.Position=UDim2.new(0,4,0.5,0)
	iconBg.BackgroundColor3=resolveIconColor(iconName)
	iconBg.BorderSizePixel=0; iconBg.ZIndex=16; iconBg.Parent=row
	Instance.new("UICorner",iconBg).CornerRadius=UDim.new(0,6)
	local base=resolveIconColor(iconName)
	local ig=Instance.new("UIGradient"); ig.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,base:Lerp(Color3.new(1,1,1),0.3)),ColorSequenceKeypoint.new(1,base)}); ig.Rotation=135; ig.Parent=iconBg
	local is=Instance.new("UIStroke"); is.Color=Color3.fromRGB(255,255,255); is.Transparency=0.7; is.Thickness=1; is.Parent=iconBg

	local ico=Instance.new("Frame"); ico.Size=UDim2.fromOffset(iconSize-6,iconSize-6)
	ico.Position=UDim2.fromOffset(3,3); ico.BackgroundTransparency=1; ico.ZIndex=17; ico.Parent=iconBg
	buildIcon(ico,iconName,iconSize-6)

	local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamMedium
	lbl.TextSize=13; lbl.TextColor3=T.textPrimary; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=16
	if subText then
		-- Stack name + subtitle tightly, centred vertically in the row
		lbl.Size=UDim2.new(1,-(iconSize+14),0,16); lbl.Position=UDim2.new(0,iconSize+10,0.5,-16)
		lbl.Text=tabName; lbl.Font=Enum.Font.GothamSemibold; lbl.TextSize=13; lbl.Parent=row
		local sub=Instance.new("TextLabel"); sub.Size=UDim2.new(1,-(iconSize+14),0,12)
		sub.Position=UDim2.new(0,iconSize+10,0.5,1)
		sub.BackgroundTransparency=1; sub.Text=subText
		sub.Font=Enum.Font.Gotham; sub.TextSize=10; sub.TextColor3=T.textTertiary
		sub.TextXAlignment=Enum.TextXAlignment.Left; sub.ZIndex=16; sub.Parent=row
	else
		lbl.Size=UDim2.new(1,-(iconSize+14),1,0); lbl.Position=UDim2.fromOffset(iconSize+10,0)
		lbl.Text=tabName; lbl.Parent=row
	end

	local hit=Instance.new("TextButton"); hit.Size=UDim2.fromScale(1,1)
	hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=18; hit.Parent=row
	LG_sidebarBtns[tabName]={bg=bg,lbl=lbl}
	hit.MouseEnter:Connect(function() if LG_selected~=tabName then tween(bg,0.12,{BackgroundColor3=T.hoverItem,BackgroundTransparency=0.4}) end end)
	hit.MouseLeave:Connect(function() if LG_selected~=tabName then tween(bg,0.12,{BackgroundTransparency=1}) end end)
	hit.MouseButton1Click:Connect(function() selectPage(tabName) end)
end

-- ============================================================
-- PAGE RENDERER
-- ============================================================
function selectPage(name)
	for n,btn in pairs(LG_sidebarBtns) do
		if n==name then tween(btn.bg,0.18,{BackgroundColor3=T.activeItem,BackgroundTransparency=0})
		else tween(btn.bg,0.18,{BackgroundTransparency=1}) end
	end
	LG_selected=name
	for _,c in ipairs(ContentList:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
	ContentScroll.CanvasPosition=Vector2.zero

	local tabDat=LG_tabData[name]
	if not tabDat then return end

	local titleLbl=Instance.new("TextLabel"); titleLbl.Size=UDim2.new(1,0,0,40)
	titleLbl.BackgroundTransparency=1; titleLbl.Text=tabDat.title or name
	titleLbl.Font=Enum.Font.GothamBold; titleLbl.TextSize=26; titleLbl.TextColor3=T.textPrimary
	titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.LayoutOrder=0; titleLbl.ZIndex=14; titleLbl.Parent=ContentList

	local order=10
	for gi,sec in ipairs(tabDat.sections) do
		if sec.header then
			spacer(ContentList,8,order); order+=1
			local hl=Instance.new("TextLabel"); hl.Size=UDim2.new(1,0,0,18); hl.BackgroundTransparency=1
			hl.Text=sec.header:upper(); hl.Font=Enum.Font.GothamBold; hl.TextSize=11
			hl.TextColor3=T.textTertiary; hl.TextXAlignment=Enum.TextXAlignment.Left
			hl.LayoutOrder=order; hl.ZIndex=14; hl.Parent=ContentList; order+=1
		else
			spacer(ContentList,gi==1 and 4 or 10,order); order+=1
		end

		local card=makeCard(ContentList,order); order+=1
		local n=#sec.controls
		for ii,ctrl in ipairs(sec.controls) do
			local ro=ii*10; local dv=(ii<n) and (ro+5) or nil
			if ctrl.type=="toggle" then
				ctrl._handle=buildToggle(card,ctrl.label,ctrl.default,ctrl.callback,ro,dv)
			elseif ctrl.type=="slider" then
				ctrl._handle=buildSlider(card,ctrl.label,ctrl.default,ctrl.callback,ro,dv)
			elseif ctrl.type=="info" then
				ctrl._handle=buildInfo(card,ctrl.label,ctrl.value,ro,dv)
			elseif ctrl.type=="dropdown" then
				ctrl._handle=buildDropdown(card,ctrl.label,ctrl.options,ctrl.default,ctrl.callback,ro,dv)
			elseif ctrl.type=="button" then
				ctrl._handle=buildButton(card,ctrl.label,ctrl.btnText,ctrl.callback,ro,dv)
			end
		end
	end
	spacer(ContentList,20,order+999)
	ContentList.GroupTransparency=1
	tween(ContentList,0.25,{GroupTransparency=0},Enum.EasingStyle.Quad)
end

-- ── Search ──────────────────────────────────────────────────

local function dismissSearch()
	SearchBox.Text = ""
	-- restore sidebar rows
	for _,c in ipairs(SBList:GetChildren()) do
		if c:IsA("Frame") then c.Visible = true end
	end
end

-- Results panel — parented to ScreenGui so Sidebar clipping doesn't affect it
SRF = Instance.new("ScrollingFrame")
SRF.Name = "SearchResults"
SRF.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
SRF.BackgroundTransparency = 0
SRF.BorderSizePixel = 0
SRF.ScrollBarThickness = 0
SRF.CanvasSize = UDim2.fromScale(1, 0)
SRF.AutomaticCanvasSize = Enum.AutomaticSize.Y
SRF.ClipsDescendants = true
SRF.Visible = false
SRF.ZIndex = 60
SRF.Parent = ScreenGui
-- Rounded corners + stroke only — no liquidGlass gradient (causes glitch on dark bg)
local srfCorner = Instance.new("UICorner"); srfCorner.CornerRadius = UDim.new(0,10); srfCorner.Parent = SRF
local srfStroke = Instance.new("UIStroke"); srfStroke.Color = Color3.fromRGB(255,255,255)
srfStroke.Transparency = 0.78; srfStroke.Thickness = 1
srfStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; srfStroke.Parent = SRF
local srfList = Instance.new("UIListLayout"); srfList.Padding = UDim.new(0,0)
srfList.SortOrder = Enum.SortOrder.LayoutOrder; srfList.Parent = SRF
local srfPad = Instance.new("UIPadding"); srfPad.PaddingTop = UDim.new(0,4)
srfPad.PaddingBottom = UDim.new(0,4); srfPad.Parent = SRF

local function clearSRF()
	for _,c in ipairs(SRF:GetChildren()) do
		if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
	end
end

-- Position and size the panel to sit just below the search bar in screen space.
-- Uses RunService to wait one frame so AbsolutePosition is valid.
local RunService = game:GetService("RunService")
local function showSRF(resultCount)
	-- Wait two frames so all AbsolutePositions are settled
	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()
	-- SearchWrap.AbsolutePosition is in true screen pixels from top-left.
	-- Our ScreenGui uses IgnoreGuiInset=true so its Y=0 is also the true top.
	-- Therefore we can use AbsolutePosition directly — no inset adjustment.
	-- Sidebar starts at Y=50 inside Window (below titlebar).
	-- Search bar is at Y=10 inside Sidebar, height=32.
	-- So the panel should sit at: Sidebar.AbsoluteY + 50 + 32 + 8
	local sideX  = Sidebar.AbsolutePosition.X
	local sideY  = Sidebar.AbsolutePosition.Y
	local panelX = sideX + 8
	local panelY = sideY + 10 + 32 + 6 + GuiService:GetGuiInset().Y
	local panelW = Sidebar.AbsoluteSize.X - 16
	local rowH   = 44
	local panelH = math.min(resultCount * rowH + 8, 320)
	SRF.Position = UDim2.fromOffset(panelX, panelY)
	SRF.Size     = UDim2.fromOffset(panelW, panelH)
	SRF.Visible  = true
end

local function addSRFResult(tabName, controlLabel, sectionHeader, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 44)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.LayoutOrder = order
	btn.ZIndex = 61
	btn.Parent = SRF

	-- Breadcrumb
	local crumb = Instance.new("TextLabel")
	crumb.Size = UDim2.new(1, -16, 0, 13)
	crumb.Position = UDim2.fromOffset(12, 5)
	crumb.BackgroundTransparency = 1
	local bc = sectionHeader and (tabName .. " › " .. sectionHeader) or tabName
	crumb.Text = bc:upper()
	crumb.Font = Enum.Font.Gotham
	crumb.TextSize = 9
	crumb.TextColor3 = T.textTertiary
	crumb.TextXAlignment = Enum.TextXAlignment.Left
	crumb.TextTruncate = Enum.TextTruncate.AtEnd
	crumb.ZIndex = 62
	crumb.Parent = btn

	-- Main label
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 0, 18)
	lbl.Position = UDim2.fromOffset(12, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = controlLabel
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 13
	lbl.TextColor3 = T.textPrimary
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.ZIndex = 62
	lbl.Parent = btn

	-- Divider
	local div = Instance.new("Frame")
	div.Size = UDim2.new(1, -24, 0, 1)
	div.Position = UDim2.fromOffset(12, 43)
	div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	div.BackgroundTransparency = 0.88
	div.BorderSizePixel = 0
	div.ZIndex = 62
	div.Parent = btn

	btn.MouseEnter:Connect(function()
		tween(btn, 0.08, {BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0.92})
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, 0.08, {BackgroundTransparency=1})
	end)
	btn.MouseButton1Click:Connect(function()
		dismissSearch()
		SRF.Visible = false
		clearSRF()
		selectPage(tabName)
	end)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local q = SearchBox.Text:lower()
	clearSRF()

	if q == "" then
		SRF.Visible = false
		for _,c in ipairs(SBList:GetChildren()) do
			if c:IsA("Frame") then c.Visible = true end
		end
		return
	end

	-- Hide sidebar rows while searching
	for _,c in ipairs(SBList:GetChildren()) do
		if c:IsA("Frame") then c.Visible = false end
	end

	local results = {}
	for _,tabName in ipairs(LG_tabs) do
		if tabName:lower():find(q, 1, true) then
			table.insert(results, {tab=tabName, label=tabName, section=nil})
		end
	end
	for _,tabName in ipairs(LG_tabs) do
		local td = LG_tabData[tabName]
		if td then
			for _,sec in ipairs(td.sections) do
				for _,ctrl in ipairs(sec.controls) do
					local ltext = (ctrl.label or ""):lower()
					local vtext = (ctrl.value or ctrl.btnText or ""):lower()
					if ltext:find(q,1,true) or vtext:find(q,1,true) then
						-- avoid duplicating a pure tab-name match
						local dupe = false
						for _,r in ipairs(results) do
							if r.tab==tabName and r.label==ctrl.label and r.section==sec.header then
								dupe=true; break
							end
						end
						if not dupe then
							table.insert(results, {tab=tabName, label=ctrl.label, section=sec.header})
						end
					end
				end
			end
		end
	end

	if #results == 0 then
		local nr = Instance.new("TextButton")
		nr.Size = UDim2.new(1, 0, 0, 40)
		nr.BackgroundTransparency = 1; nr.AutoButtonColor = false
		nr.Text = "No results"
		nr.Font = Enum.Font.Gotham; nr.TextSize = 13
		nr.TextColor3 = T.textTertiary
		nr.LayoutOrder = 1; nr.ZIndex = 61
		nr.Parent = SRF
	else
		for i, r in ipairs(results) do
			addSRFResult(r.tab, r.label, r.section, i)
		end
	end

	task.spawn(function() showSRF(math.max(1, #results)) end)
end)

-- Dismiss when clicking outside
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		task.defer(function()
			if not SearchBox:IsFocused() and SRF.Visible then
				dismissSearch()
				SRF.Visible = false
				clearSRF()
			end
		end)
	end
end)

-- ============================================================
-- PUBLIC API
-- ============================================================
local LiquidGlass = {}
LiquidGlass.__index = LiquidGlass

-- Section handle
local Section = {}
Section.__index = Section

function Section:AddToggle(label, defaultVal, callback)
	local ctrl={type="toggle",label=label,default=defaultVal~=false,callback=callback,_handle=nil}
	table.insert(self._controls,ctrl)
	-- return a proxy that forwards to _handle once built
	local proxy=setmetatable({},{
		__index=function(_,k) return ctrl._handle and ctrl._handle[k] end,
		__newindex=function() end
	})
	return proxy
end

function Section:AddSlider(label, defaultVal, callback)
	local ctrl={type="slider",label=label,default=defaultVal or 0.5,callback=callback,_handle=nil}
	table.insert(self._controls,ctrl)
	local proxy=setmetatable({},{
		__index=function(_,k) return ctrl._handle and ctrl._handle[k] end,
		__newindex=function() end
	})
	return proxy
end

function Section:AddInfo(label, value)
	local ctrl={type="info",label=label,value=tostring(value),_handle=nil}
	table.insert(self._controls,ctrl)
	local proxy=setmetatable({},{
		__index=function(_,k) return ctrl._handle and ctrl._handle[k] end,
		__newindex=function() end
	})
	return proxy
end

function Section:AddDropdown(label, options, defaultIndex, callback)
	local ctrl={type="dropdown",label=label,options=options,default=defaultIndex or 1,callback=callback,_handle=nil}
	table.insert(self._controls,ctrl)
	local proxy=setmetatable({},{
		__index=function(_,k) return ctrl._handle and ctrl._handle[k] end,
		__newindex=function() end
	})
	return proxy
end

function Section:AddButton(label, btnText, callback)
	local ctrl={type="button",label=label,btnText=btnText or "Action",callback=callback,_handle=nil}
	table.insert(self._controls,ctrl)
	return {}
end

-- Tab handle
local Tab = {}
Tab.__index = Tab

function Tab:AddSection(header)
	local sec={header=header,controls={},_controls=nil}
	sec._controls=sec.controls
	local handle=setmetatable({_controls=sec.controls},Section)
	table.insert(self._sections,sec)
	return handle
end

-- Library
function LiquidGlass:SetConfig(opts)
	LG_config=opts or {}
	if opts.title then TitleLbl.Text=opts.title end
	if opts.profileName then
		ProfName.Text=opts.profileName
		-- Update fallback initial only (image takes over once loaded)
		AvatarLbl.Text=(opts.profileInitial or opts.profileName:sub(1,1)):upper()
	end
	if opts.profileInitial then AvatarLbl.Text=opts.profileInitial:upper() end
	if opts.profileSub then ProfSub.Text=opts.profileSub end
	if opts.accentColor then
		T.activeItem=opts.accentColor; T.sliderFill=opts.accentColor; T.blue=opts.accentColor
	end
	if opts.windowAlpha then Window.BackgroundTransparency=opts.windowAlpha end
end

function LiquidGlass:AddTab(tabName, iconName, subText)
	table.insert(LG_tabs, tabName)
	LG_tabData[tabName]={
		title=tabName,
		iconName=iconName or "General",
		subText=subText,
		sections={}
	}
	-- Build sidebar row immediately
	if #LG_tabs>1 then
		-- small spacer before groups of items; handled by layout order
	end
	buildSidebarRow(tabName, iconName or "General", subText)

	local handle=setmetatable({
		_name=tabName,
		_sections=LG_tabData[tabName].sections
	},Tab)
	return handle
end

function LiquidGlass:SelectTab(name)
	if LG_tabData[name] then selectPage(name) end
end

function LiquidGlass:Open()
	local w,h=getWinSize()
	Overlay.Visible=true; Window.Visible=true; Shadow.Visible=true
	tween(Overlay,0.4,{BackgroundTransparency=0.15})
	tween(Shadow,0.45,{ImageTransparency=0.45})
	tween(Window,0.45,{BackgroundTransparency=0.18})
	tween(Blur,0.45,{Size=24})
	local info=TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	TweenService:Create(Window,info,{Size=UDim2.fromOffset(w,h)}):Play()
end

function LiquidGlass:Close()
	tween(Window,0.3,{Size=UDim2.fromOffset(0,0),BackgroundTransparency=1})
	tween(Shadow,0.3,{ImageTransparency=1})
	tween(Overlay,0.3,{BackgroundTransparency=1})
	tween(Blur,0.3,{Size=0})
end

function LiquidGlass:Notify(label, value, notifType)
	notify(notifType or "custom", label, value)
end

function LiquidGlass:NotifyError(label, value)
	notify("error", label, value)
end

function LiquidGlass:NotifyWarning(label, value)
	notify("warning", label, value)
end

function LiquidGlass:AutoNotif(ctrlType, label, value)
	-- Pass this as (or call inside) a control callback to opt in to Dynamic Island.
	-- ctrlType is auto-filled when used via the helper below, or pass manually.
	notify(ctrlType or "custom", label, value)
end

-- Convenience helpers — pass directly as the callback argument
-- e.g. toggleSec:AddToggle("Shadows", true, LiquidGlass.Notif.Toggle("Shadows"))
LiquidGlass.Notif = {}

function LiquidGlass.Notif.Toggle(label)
	return function(val)
		notify("toggle", label, val and "On" or "Off")
	end
end

function LiquidGlass.Notif.Slider(label)
	return function(val)
		notify("slider", label, math.round(val*100).."%")
	end
end

function LiquidGlass.Notif.Dropdown(label)
	return function(idx, opt)
		notify("dropdown", label, opt)
	end
end

function LiquidGlass.Notif.Button(label)
	return function()
		notify("button", label)
	end
end

-- ============================================================
-- SIRI GLOW INTRO ANIMATION
-- ============================================================
-- Four thin gradient frames hug each screen edge and cycle
-- through vivid colours, mimicking the Apple Intelligence /
-- new Siri border glow. After the glow plays the main window
-- springs open as normal.

local GLOW_COLORS = {
	Color3.fromRGB(10,  132, 255),  -- blue
	Color3.fromRGB(48,  209,  88),  -- green
	Color3.fromRGB(191,  90, 242),  -- purple
	Color3.fromRGB(255, 159,  10),  -- amber
	Color3.fromRGB(255,  55,  95),  -- pink-red
	Color3.fromRGB(100, 210, 255),  -- sky
}

local GlowCanvas = Instance.new("CanvasGroup")
GlowCanvas.Size                   = UDim2.fromScale(1,1)
GlowCanvas.BackgroundTransparency = 1
GlowCanvas.GroupTransparency      = 1
GlowCanvas.ZIndex                 = 200
GlowCanvas.Parent                 = ScreenGui

-- Simple approach: one frame per edge, thick, with a single UIGradient
-- that fades from opaque AT the screen edge to transparent toward the centre.
-- No child frames, no masking — just a clean feather.
local function makeEdge(axis, anchor)
	local f = Instance.new("Frame")
	f.BackgroundColor3       = Color3.new(1,1,1)
	f.BackgroundTransparency = 0
	f.BorderSizePixel        = 0
	f.ZIndex                 = 201
	f.Parent                 = GlowCanvas

	local g = Instance.new("UIGradient")
	g.Parent = f

	if axis == "H" then
		-- Full width, tall strip
		f.AnchorPoint = Vector2.new(0, anchor)
		f.Position    = UDim2.new(0, 0, anchor, 0)
		f.Size        = UDim2.new(1, 0, 0, 160)
		-- Top: fade down (90°), Bottom: fade up (270°)
		g.Rotation = anchor == 0 and 90 or 270
	else
		-- Full height, wide strip
		f.AnchorPoint = Vector2.new(anchor, 0)
		f.Position    = UDim2.new(anchor, 0, 0, 0)
		f.Size        = UDim2.new(0, 160, 1, 0)
		-- Left: fade right (0°), Right: fade left (180°)
		g.Rotation = anchor == 0 and 0 or 180
	end

	-- Opaque at edge (0), feathers to transparent at centre (1)
	g.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,   0),
		NumberSequenceKeypoint.new(0.5, 0.7),
		NumberSequenceKeypoint.new(1,   1),
	})

	return f
end

local edgeTop    = makeEdge("H", 0)
local edgeBottom = makeEdge("H", 1)
local edgeLeft   = makeEdge("V", 0)
local edgeRight  = makeEdge("V", 1)
local glowEdges  = {edgeTop, edgeBottom, edgeLeft, edgeRight}

-- Subtle ambient bloom
local GlowBloom = Instance.new("Frame")
GlowBloom.Size                   = UDim2.fromScale(1,1)
GlowBloom.BackgroundColor3       = Color3.new(1,1,1)
GlowBloom.BackgroundTransparency = 0.97
GlowBloom.BorderSizePixel        = 0
GlowBloom.ZIndex                 = 200
GlowBloom.Parent                 = GlowCanvas

local function setGlowColor(col)
	for _, e in ipairs(glowEdges) do e.BackgroundColor3 = col end
	GlowBloom.BackgroundColor3 = col
end

local function doIntro()
	local w,h = getWinSize()
	Window.Size               = UDim2.fromOffset(0,0)
	Window.BackgroundTransparency = 1
	Shadow.ImageTransparency  = 1
	Overlay.BackgroundTransparency = 1
	if #LG_tabs > 0 then selectPage(LG_tabs[1]) end

	-- Phase 1: fade glow IN
	setGlowColor(GLOW_COLORS[1])
	tween(GlowCanvas, 0.35, {GroupTransparency=0}, Enum.EasingStyle.Quad)
	task.wait(0.35)

	-- Phase 2: cycle through colours with smooth crossfade
	local cycleTime = 0.55
	for i = 2, #GLOW_COLORS do
		local col = GLOW_COLORS[i]
		-- Tween each edge colour
		for _, e in ipairs(glowEdges) do
			TweenService:Create(e,
				TweenInfo.new(cycleTime, Enum.EasingStyle.Sine),
				{BackgroundColor3=col}):Play()
		end
		TweenService:Create(GlowBloom,
			TweenInfo.new(cycleTime, Enum.EasingStyle.Sine),
			{BackgroundColor3=col}):Play()
		task.wait(cycleTime * 0.75)
	end
	-- One final cycle back to blue
	for _, e in ipairs(glowEdges) do
		TweenService:Create(e,
			TweenInfo.new(cycleTime, Enum.EasingStyle.Sine),
			{BackgroundColor3=GLOW_COLORS[1]}):Play()
	end
	TweenService:Create(GlowBloom,
		TweenInfo.new(cycleTime, Enum.EasingStyle.Sine),
		{BackgroundColor3=GLOW_COLORS[1]}):Play()
	task.wait(cycleTime * 0.5)

	-- Phase 3: window springs open while glow fades out simultaneously
	tween(Overlay, 0.5, {BackgroundTransparency=0.15})
	tween(Shadow,  0.5, {ImageTransparency=0.45})
	tween(Window,  0.5, {BackgroundTransparency=0.18})
	tween(Blur,    0.5, {Size=24})
	TweenService:Create(Window,
		TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size=UDim2.fromOffset(w,h)}):Play()
	tween(GlowCanvas, 0.55, {GroupTransparency=1}, Enum.EasingStyle.Quad)

	-- Clean up glow after fade
	task.delay(0.6, function()
		GlowCanvas:Destroy()
	end)
end

-- ============================================================
-- ██╗   ██╗███████╗███████╗██████╗      ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
-- ██║   ██║██╔════╝██╔════╝██╔══██╗    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
-- ██║   ██║███████╗█████╗  ██████╔╝    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
-- ██║   ██║╚════██║██╔══╝  ██╔══██╗    ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
-- ╚██████╔╝███████║███████╗██║  ██║    ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
-- ============================================================
-- Edit ONLY below this line. The library code above does not need to be changed.
-- ============================================================

-- ── Window & profile config ──────────────────────────────────
-- Profile name/avatar are auto-set from LocalPlayer.
-- Use SetConfig to override anything.
LiquidGlass:SetConfig({
	title      = "System Settings",
	-- profileName = "Custom Name",
	-- profileSub  = "Custom subtitle",
	-- accentColor = Color3.fromRGB(255, 80, 120),
})

-- ══════════════════════════════════════════════════════════════
-- SINGLE DEMO TAB — shows every control type + all notifications
-- ══════════════════════════════════════════════════════════════
local demo = LiquidGlass:AddTab("Demo", "General", "All features")

-- ── Toggles ───────────────────────────────────────────────────
local toggleSec = demo:AddSection("Toggles")

-- No notification — just a plain toggle
toggleSec:AddToggle("Simple toggle", true)

-- Opt in with LiquidGlass.Notif.Toggle — auto-formats "On"/"Off" badge
toggleSec:AddToggle("Notify on change", off, LiquidGlass.Notif.Toggle("Notify on change"))

-- Or write a custom callback and call Notify yourself
local trackedToggle = toggleSec:AddToggle("Custom callback", false, function(on)
	if on then
		LiquidGlass:Notify("Feature enabled", "On")
	else
		LiquidGlass:NotifyWarning("Feature disabled", "Off")
	end
end)

-- ── Sliders ───────────────────────────────────────────────────
local sliderSec = demo:AddSection("Sliders")

-- No notification
sliderSec:AddSlider("Simple slider", 0.5)

-- Same as the one below just without an additonal notification
sliderSec:AddSlider("is test (testing?)", 0.05, function(v)
	if v > 1 then -- just keep this always at 1 for the dynamic islands bar to function
		LiquidGlass:Notify("Working test", math.round(v*100).."%")
	end
end)

-- Custom callback — fire warning only above a threshold
sliderSec:AddSlider("Threshold (warning above 80%)", 0.3, function(v)
	if v > 0.8 then
		LiquidGlass:NotifyWarning("High threshold", math.round(v*100).."%")
	end
end)

sliderSec:AddSlider("your cortisol", 0, function(v)
	if v > 1 then
		LiquidGlass:Notify("cortisol level is alright", math.round(v*100).."%")
  elseif v > 0.9 then
    LiquidGlass:NotifyWarning("corrisol level too high", math.round(v*100).."%") 
	end
end)

-- ── Dropdowns ─────────────────────────────────────────────────
local dropSec = demo:AddSection("Dropdowns")

-- No notification
dropSec:AddDropdown("Simple dropdown", {"Option A","Option B","Option C"}, 1)

-- Opt in with LiquidGlass.Notif.Dropdown — shows selected option in badge - preferably use this its easier
dropSec:AddDropdown("Quality (notif)", {"Low","Medium","High","Ultra"}, 4,
	LiquidGlass.Notif.Dropdown("Quality"))

-- Custom callback
dropSec:AddDropdown("Region", {"US East","US West","EU","Asia"}, 1, function(idx, label)
	LiquidGlass:Notify("Region set", label)
end)

-- ── Info rows ─────────────────────────────────────────────────
local infoSec = demo:AddSection("Info")

local versionInfo = infoSec:AddInfo("Version", "1.0.0")
infoSec:AddInfo("Status", "Connected")
infoSec:AddInfo("Player", Players.LocalPlayer.Name)

-- ── Buttons ───────────────────────────────────────────────────
local btnSec = demo:AddSection("Buttons")

-- No notification — plain button
btnSec:AddButton("Silent button", "Click me")

-- Opt in with LiquidGlass.Notif.Button
btnSec:AddButton("Button with notif", "Click", LiquidGlass.Notif.Button("Button pressed"))

-- Manual Notify / NotifyError / NotifyWarning
btnSec:AddButton("Fire Notify", "Fire", function()
	LiquidGlass:Notify("Hello!", "Custom")
end)

btnSec:AddButton("Fire NotifyError", "Fire", function()
	LiquidGlass:NotifyError("Something went wrong", "Code 404")
end)

btnSec:AddButton("Fire NotifyWarning", "Fire", function()
	LiquidGlass:NotifyWarning("Heads up", "Check settings")
end)

-- Demonstrate SetValue / GetValue on handles
btnSec:AddButton("Update info row", "Update", function()
	versionInfo:SetValue("2.0.0")
	LiquidGlass:Notify("Version updated", "2.0.0")
end)

btnSec:AddButton("Flip toggle via code", "Flip", function()
	trackedToggle:SetValue(not trackedToggle:GetValue())
	LiquidGlass:Notify("Toggled", trackedToggle:GetValue() and "On" or "Off")
end)

btnSec:AddButton("Set slider to 80%", "Set", function()
	volSlider:SetValue(0.8)
	LiquidGlass:Notify("Volume set", "80%", "slider")
end)



-- ============================================================
-- BOOT — do not remove
-- ============================================================
task.defer(doIntro)
print("[LiquidGlass UI Library] Loaded ✓")



local Test = LiquidGlass:AddTab("Test")
local buttonSec = Test:AddSection("Testing")
buttonSec:AddButton("Hihhh", "tuttt", function()
LiquidGlass:Notify("Test slider", "loading", "sliding")
LiquidGlass:NotifyWarning("Warning", "29%", "heyyy")
end)


buttonSec:AddSlider("low cortisol", 0, function(v)
	if v > 1 then
		LiquidGlass:Notify("cortisol level", math.round(v*100).."%")
  elseif v > 0.9 then
    LiquidGlass:NotifyWarning("corrisol level too high", math.round(v*100).."%") 
	end
end)


