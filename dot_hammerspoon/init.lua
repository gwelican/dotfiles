-- Hammerspoon Window Management Script
-- Window movement and resizing with keyboard shortcuts

-- Store previous window sizes for undo functionality
local previousSizes = {}

-- Helper function to get window key
local function getWindowKey(window)
	return window:id()
end

-- Helper function to save current window size
local function savePreviousSize(window)
	local key = getWindowKey(window)
	previousSizes[key] = {
		x = window:topLeft().x,
		y = window:topLeft().y,
		w = window:size().w,
		h = window:size().h,
	}
end

-- Helper function to restore previous size
local function restorePreviousSize(window)
	local key = getWindowKey(window)
	if previousSizes[key] then
		local prev = previousSizes[key]
		window:setTopLeft(hs.geometry.point(prev.x, prev.y))
		window:setSize(hs.geometry.size(prev.w, prev.h))
	end
end

-- Maximize window (not fullscreen)
local function maximizeWindow()
	local window = hs.window.focusedWindow()
	if not window then
		return
	end

	savePreviousSize(window)

	local screen = window:screen()
	local max = screen:frame()

	window:setFrame(max)
end

-- Resize to previous size
local function resizeToPrevious()
	local window = hs.window.focusedWindow()
	if not window then
		return
	end

	restorePreviousSize(window)
end

-- Move window to left 50% of screen
local function moveToLeftHalf()
	local window = hs.window.focusedWindow()
	if not window then
		return
	end

	savePreviousSize(window)

	local screen = window:screen()
	local frame = screen:frame()

	local leftHalf = hs.geometry.rect(frame.x, frame.y, frame.w / 2, frame.h)

	window:setFrame(leftHalf)
end

-- Move window to right 50% of screen
local function moveToRightHalf()
	local window = hs.window.focusedWindow()
	if not window then
		return
	end

	savePreviousSize(window)

	local screen = window:screen()
	local frame = screen:frame()

	local rightHalf = hs.geometry.rect(frame.x + frame.w / 2, frame.y, frame.w / 2, frame.h)

	window:setFrame(rightHalf)
end

-- Move window to screen on the left
local function moveToLeftScreen()
	local window = hs.window.focusedWindow()
	if not window then
		return
	end

	local currentScreen = window:screen()
	local allScreens = hs.screen.allScreens()

	-- Find the screen to the left
	local targetScreen = nil
	for _, screen in ipairs(allScreens) do
		if screen:frame().x + screen:frame().w <= currentScreen:frame().x then
			if not targetScreen or screen:frame().x > targetScreen:frame().x then
				targetScreen = screen
			end
		end
	end

	if targetScreen then
		savePreviousSize(window)
		local frame = targetScreen:frame()
		window:setFrame(frame)
	end
end

-- Move window to screen on the right
local function moveToRightScreen()
	local window = hs.window.focusedWindow()
	if not window then
		return
	end

	local currentScreen = window:screen()
	local allScreens = hs.screen.allScreens()

	-- Find the screen to the right
	local targetScreen = nil
	for _, screen in ipairs(allScreens) do
		if screen:frame().x >= currentScreen:frame().x + currentScreen:frame().w then
			if not targetScreen or screen:frame().x < targetScreen:frame().x then
				targetScreen = screen
			end
		end
	end

	if targetScreen then
		savePreviousSize(window)
		local frame = targetScreen:frame()
		window:setFrame(frame)
	end
end

-- Lock the screen using macOS Security framework
local function lockScreen()
	print("Locking the screen...")
	hs.caffeinate.lockScreen()
	os.execute("/System/Library/CoreServices/Menu\\ Extras/User\\ Accounts.menu/Contents/Resources/CGSession -suspend")
end

-- Bind keyboard shortcuts
hs.hotkey.bind({ "cmd", "shift" }, "up", maximizeWindow)
hs.hotkey.bind({ "cmd", "shift" }, "down", resizeToPrevious)
hs.hotkey.bind({ "cmd", "shift" }, "left", moveToLeftHalf)
hs.hotkey.bind({ "cmd", "shift" }, "right", moveToRightHalf)
hs.hotkey.bind({ "cmd", "shift", "ctrl" }, "left", moveToLeftScreen)
hs.hotkey.bind({ "cmd", "shift", "ctrl" }, "right", moveToRightScreen)
hs.hotkey.bind({ "cmd" }, "l", lockScreen)

-- Auto-reload config on file changes
local configWatcher = nil

local function setupConfigWatcher()
	if configWatcher then
		configWatcher:stop()
	end

	configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
		for _, file in ipairs(files) do
			if file:sub(-4) == ".lua" then
				print("Config file changed, reloading...")
				hs.reload()
				return
			end
		end
	end)
	configWatcher:start()
end

setupConfigWatcher()

-- Print confirmation to console
print("Window management hotkeys loaded successfully!")
print("Cmd+Shift+Up: Maximize")
print("Cmd+Shift+Down: Restore previous size")
print("Cmd+Shift+Left: Move to left 50%")
print("Cmd+Shift+Right: Move to right 50%")
print("Cmd+Shift+Ctrl+Left: Move to left screen")
print("Cmd+Shift+Ctrl+Right: Move to right screen")
print("Cmd+L: Lock screen")

