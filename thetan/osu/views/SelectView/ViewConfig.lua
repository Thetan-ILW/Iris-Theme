local class = require("class")

local Layout = require("thetan.osu.views.SelectView.Layout")

local ViewConfig = class()

local gyatt = require("thetan.gyatt")
local time_util = require("time_util")
local math_util = require("math_util")
local table_util = require("table_util")
local Format = require("sphere.views.Format")

local NoteChartSetListView = require("thetan.osu.views.SelectView.NoteChartSetListView")
local ScoreListView = require("thetan.osu.views.SelectView.ScoreListView")

local Theme = require("thetan.irizz.views.Theme")
local font

---@type osu.OsuSelectAssets
local assets
---@type table<string, love.Image>
local img

local gfx = love.graphics

local window_height

local avatar
local top_panel_quad
local brighten_shader

local has_focus = true

local prev_chart_id = 0
local chart_name = ""
local charter = ""
local length_str = ""
local bpm_str = ""
local objects_str = ""
local ln_count_str = ""
local note_count_str = ""
local columns_str = ""
local difficulty_str = ""
local username = ""
local is_logged_in = false
local scroll_speed_str = ""
local mods_str = ""
local current_time = 0
local update_time = 0
local chart_list_update_time = 0
local has_scores = false

local white = { 1, 1, 1, 1 }

local dropdowns = {
	scoreSource = {
		focus = false,
		updateTime = 0,
		selectedIndex = 1,
		format = "%s",
		mouseOver = false,
		items = {
			"Local ranking",
			"Online ranking",
			"osu! API ranking",
		},
	},
	group = {
		focus = false,
		updateTime = 0,
		selectedIndex = 1,
		format = "By %s",
		mouseOver = false,
		items = {
			"charts",
			"collections",
		},
	},
	sort = {
		focus = false,
		updateTime = 0,
		selectedIndex = 1,
		format = "By %s",
		mouseOver = false,
		items = {},
	},
}

local buttons = {
	back = {
		updateTime = 0,
		mouseOver = false,
		rect = { 0, -90, 200, 90 },
	},
	mode = {
		updateTime = 0,
		mouseOver = false,
		rect = { 0, -90, 88, 90 },
	},
	mods = {
		updateTime = 0,
		mouseOver = false,
		rect = { 0, -90, 74, 90 },
	},
	random = {
		updateTime = 0,
		mouseOver = false,
		rect = { 0, -90, 74, 90 },
	},
	chartOptions = {
		updateTime = 0,
		mouseOver = false,
		rect = { 0, -90, 74, 90 },
	},
}

---@param game sphere.GameController
---@param _assets osu.OsuSelectAssets
function ViewConfig:new(game, _assets)
	avatar = Theme.avatarImage

	assets = _assets
	img = assets.images

	font = Theme:getFonts("osuSongSelect")

	self.noteChartSetListView = NoteChartSetListView(game)
	self.noteChartSetListView:setAssets(assets)

	self.scoreListView = ScoreListView(game)
	self.scoreListView:setAssets(assets)

	local sort_model = game.selectModel.sortModel
	dropdowns.sort.items = sort_model.names

	local sort_function = game.configModel.configs.select.sortFunction
	dropdowns.sort.selectedIndex = table_util.indexof(sort_model.names, sort_function)

	local shaders = require("irizz.shaders")
	brighten_shader = shaders.brighten

	Layout:draw()

	chart_list_update_time = love.timer.getTime() + 0.4
	self:resolutionUpdated()
end

function ViewConfig:updateInfo(view)
	local chartview = view.game.selectModel.chartview
	local rate = view.game.playContext.rate

	if not chartview then
		return
	end

	chart_name = string.format("%s - %s [%s]", chartview.artist, chartview.title, chartview.name)
	charter = chartview.creator

	local note_count = chartview.notes_count or 0
	local ln_count = chartview.long_notes_count or 0

	length_str = time_util.format((chartview.duration or 0) / rate)
	bpm_str = ("%i"):format((chartview.tempo or 0) * rate)
	objects_str = tostring(note_count + ln_count)
	note_count_str = tostring(note_count or 0)
	ln_count_str = tostring(ln_count or 0)

	columns_str = Format.inputMode(chartview.chartdiff_inputmode)
	difficulty_str = ("%0.02f"):format(chartview.osu_diff or 0)

	username = view.game.configModel.configs.online.user.name or "xXx_FortnitePro_xXx"
	is_logged_in = view.game.configModel.configs.online.user.name == nil

	local speedModel = view.game.speedModel
	local gameplay = view.game.configModel.configs.settings.gameplay
	scroll_speed_str = ("%i (fixed)"):format(speedModel.format[gameplay.speedType]:format(speedModel:get()))

	self.noteChartSetListView:reloadItems()
	self.scoreListView:reloadItems()

	has_scores = #view.game.selectModel.scoreLibrary.items ~= 0

	if prev_chart_id ~= chartview.id then
		update_time = current_time
	end

	prev_chart_id = chartview.id
end

local function animate(time, interval)
	local t = math.min(current_time - time, interval)
	local progress = t / interval
	return math_util.clamp(progress * progress, 0, 1)
end

local function easeOutCubic(time, interval)
	local t = math.min(current_time - time, interval)
	local progress = t / interval
	return math_util.clamp(1 - math.pow(1 - progress, 3), 0, 1)
end

local function dropdown(id, w)
	local instance = dropdowns[id]
	instance.mouseOver = false

	local r, g, b, a = gfx.getColor()
	gfx.push()
	gfx.setColor({ 0, 0, 0, 0.5 })
	gfx.rectangle("fill", 0, 0, w, 22, 4, 4)

	gfx.setColor({ r, g, b, a })
	gfx.setLineWidth(1)
	gfx.rectangle("line", 0, 0, w, 22, 4, 4)

	gfx.translate(3, -1)
	gfx.setColor(white)
	gfx.setFont(font.dropdown)
	gyatt.text(instance.format:format(instance.items[instance.selectedIndex]), w, "left")

	gyatt.sameline()
	gfx.translate(w - 25, 4)
	gfx.draw(img.dropdownArrow)
	gfx.pop()

	local just_opened = false

	local time = current_time

	if gyatt.mousePressed(1) then
		local open = gyatt.isOver(w, 22)

		if not instance.focus and open then
			instance.focus = true
			instance.updateTime = time
			just_opened = true
		elseif instance.focus and open then
			instance.focus = false
			instance.updateTime = time
		end
	end

	local changed = false
	local selected = 0

	a = easeOutCubic(instance.updateTime, 0.35)

	if not instance.focus then
		a = 1 - a
	end

	if a == 0 then
		return
	end

	local prev_canvas = gfx.getCanvas()
	local canvas = gyatt.getCanvas(id .. "_dropdown")

	gfx.setCanvas({ canvas, stencil = true })
	gfx.clear()

	gfx.translate(0, 22)

	for i, v in ipairs(instance.items) do
		local mouse_over = gyatt.isOver(w, 27)

		if instance.focus then
			instance.mouseOver = instance.mouseOver or mouse_over
		end

		if mouse_over and gyatt.mousePressed(1) and instance.focus then
			selected = i
			changed = true
			instance.selectedIndex = i
			instance.focus = false
			instance.updateTime = time
		end

		gfx.push()

		gfx.setColor(mouse_over and { r, g, b, 1 } or { 0, 0, 0, 1 })
		gfx.rectangle("fill", 0, 0, w, 27, 4, 4)

		gfx.setColor(white)
		gfx.translate(10, 2)
		gyatt.text(instance.format:format(v))

		gfx.pop()

		gfx.translate(0, 27 * a)
	end

	gfx.setCanvas({ prev_canvas, stencil = true })

	gfx.origin()

	gfx.setColor({ a, a, a, a })
	gfx.draw(canvas)

	if not changed and gyatt.mousePressed(1) and not just_opened and instance.focus then
		instance.focus = false
		instance.updateTime = time
	end

	return changed, selected
end

local function tab(label)
	gfx.setColor({ 0.86, 0.08, 0.23, 1 })
	gfx.draw(img.tab)

	gfx.setColor(white)
	gyatt.frame(label, 0, 2, 137, 21, "center", "center")
end

function ViewConfig:chartInfo()
	local w, h = Layout:move("base")

	local a = animate(update_time, 0.2)
	gfx.setColor({ 1, 1, 1, a })

	gfx.translate(5, 5)
	gfx.draw(img.rankedIcon)
	gfx.translate(-5, -5)

	gfx.setFont(font.chartName)
	gfx.translate(39, -5)
	gyatt.text(chart_name, w, "left")

	gfx.setFont(font.chartedBy)
	gfx.translate(0, -5)
	gyatt.text(("Mapped by %s"):format(charter), w, "left")

	w, h = Layout:move("base")
	gfx.setFont(font.infoTop)

	gfx.translate(5, 38)
	a = animate(update_time, 0.3)
	gfx.setColor({ 1, 1, 1, a })
	gyatt.text(("Length: %s BPM: %s Objects %s"):format(length_str, bpm_str, objects_str), w, "left")

	a = animate(update_time, 0.4)
	gfx.setColor({ 1, 1, 1, a })
	gfx.setFont(font.infoCenter)
	gyatt.text(("Circles: %s Sliders: %s Spinners: 0"):format(note_count_str, ln_count_str))

	a = animate(update_time, 0.5)
	gfx.setColor({ 1, 1, 1, a })
	gfx.setFont(font.infoBottom)
	gyatt.text(("Keys: %s OD: 8 HP: 8 Star rating: %s"):format(columns_str, difficulty_str))
end

function ViewConfig:top()
	local w, h = Layout:move("base")

	local prev_shader = gfx.getShader()

	gfx.setShader(brighten_shader)
	gfx.setColor(white)
	gfx.draw(img.panelTop, top_panel_quad)
	gfx.setShader(prev_shader)

	w, h = Layout:move("base")
	gfx.translate(w - 570, 23)
	gfx.setFont(font.groupSort)
	gfx.setColor({ 0.57, 0.76, 0.9, 1 })
	gyatt.text("Group")
	gyatt.sameline()

	w, h = Layout:move("base")
	gfx.translate(w - 270, 23)
	gfx.setFont(font.groupSort)
	gfx.setColor({ 0.68, 0.82, 0.54, 1 })
	gyatt.text("Sort")

	w, h = Layout:move("base")
	gfx.setFont(font.tabs)
	gfx.translate(w - 632, 54)
	tab("Collections")
	gfx.translate(118, 0)
	tab("Recently played")
	gfx.translate(118, 0)
	tab("By Artist")
	gfx.translate(118, 0)
	tab("By Difficulty")
	gfx.translate(118, 0)
	tab("No grouping")
end

function ViewConfig:topUI(view)
	local w, h = Layout:move("base")
	gfx.translate(10, 120)
	gfx.setColor({ 0.08, 0.51, 0.7, 1 })
	dropdown("scoreSource", 305)

	w, h = Layout:move("base")
	gfx.setColor(white)
	gfx.translate(331, 118)
	gfx.draw(img.forum)

	if gyatt.isOver(23, 23) and gyatt.mousePressed(1) then
		love.system.openURL("https://soundsphere.xyz/notecharts")
		view.gameView.showMessage("Opening the link. Check your browser.", nil, { show_time = 3 })
	end

	w, h = Layout:move("base")
	gfx.setColor({ 1, 1, 1, 0.5 })
	gfx.setFont(font.scrollSpeed)
	gyatt.frame(scroll_speed_str, -15, 0, w, h, "right", "top")

	w, h = Layout:move("base")
	gfx.translate(w - 479, 29)
	gfx.setColor({ 0.57, 0.76, 0.9, 1 })
	dropdown("group", 192)

	w, h = Layout:move("base")
	gfx.translate(w - 210, 29)
	gfx.setColor({ 0.68, 0.82, 0.54, 1 })
	local changed, index = dropdown("sort", 192)

	if changed then
		local sort_model = view.game.selectModel.sortModel
		local name = sort_model.names[index]

		if name then
			view.game.selectModel:setSortFunction(name)
		end
	end
end

local function bottomButtonImage(id, image, mouse_over_image)
	local instance = buttons[id]
	local rect = instance.rect
	local mouse_over = gyatt.isOver(rect[3], rect[4], rect[1], rect[2])
	instance.mouseOver = mouse_over

	local _, ih = image:getDimensions()
	gfx.translate(0, -ih)
	gfx.setColor(white)
	gfx.draw(image)
	gfx.translate(0, ih)

	local pressed = false

	if mouse_over then
		instance.updateTime = current_time

		if gyatt.mousePressed(1) then
			pressed = true
		end
	end

	local a = 1 - animate(instance.updateTime, 0.4)

	_, ih = mouse_over_image:getDimensions()
	gfx.translate(0, -ih)
	gfx.setColor({ a, a, a, a })
	gfx.setBlendMode("add")
	gfx.draw(mouse_over_image)
	gfx.setBlendMode("alpha")
	gfx.translate(0, ih)

	return pressed
end

function ViewConfig:bottom(view)
	local w, h = Layout:move("base")

	gfx.setColor(white)

	local iw, ih = img.panelBottom:getDimensions()

	local prev_shader = gfx.getShader()

	gfx.setShader(brighten_shader)
	gfx.translate(0, h - ih)
	gfx.draw(img.panelBottom, 0, 0, 0, w / iw, 1)
	gfx.setShader(prev_shader)

	w, h = Layout:move("base")
	gfx.translate(630, 693)

	gfx.setFont(font.rank)
	gfx.setColor({ 1, 1, 1, 0.17 })
	gyatt.frame("#69", -1, 10, 322, 78, "right", "top")

	iw, ih = avatar:getDimensions()
	gfx.setColor(white)
	gfx.draw(avatar, 0, 0, 0, 74 / iw, 74 / ih)

	gfx.translate(82, -4)

	gfx.setFont(font.username)
	gyatt.text(username)
	gfx.setFont(font.belowUsername)

	gyatt.text("Performance: 1337pp\nAccuracy: 200.00%\nLv3")

	gfx.translate(40, 22)

	gfx.setColor({ 0.15, 0.15, 0.15, 1 })
	gfx.rectangle("fill", 0, 0, 199, 12, 8, 8)

	gfx.setLineWidth(1)
	gfx.setColor({ 0.4, 0.4, 0.4, 1 })
	gfx.rectangle("line", 0, 0, 199, 12, 6, 6)

	w, h = Layout:move("base")
	iw, ih = img.osuLogo:getDimensions()

	gfx.setColor(white)
	gfx.translate(w - (iw * 0.45) + 60, h - (ih * 0.45) + 60)
	gfx.scale(0.45)
	gfx.draw(img.osuLogo)
	gfx.scale(1)

	w, h = Layout:move("base")
	gfx.translate(0, h)
	if bottomButtonImage("back", img.menuBack, img.menuBack) then
		view.mainMenuView:toggle()
	end

	w, h = Layout:move("bottomButtons")
	bottomButtonImage("mode", img.modeButton, img.modeButtonOver)

	iw, ih = img.maniaSmallIcon:getDimensions()
	gfx.translate(-iw / 2 + 45, -ih / 2 - 55)
	gfx.setColor(white)
	gfx.draw(img.maniaSmallIcon)
	gfx.translate(iw / 2 - 45, ih / 2 + 55)

	gfx.translate(92, 0)

	if bottomButtonImage("mods", img.modsButton, img.modsButtonOver) then
		view:openModal("thetan.irizz.views.modals.ModifierModal")
	end

	gfx.translate(77, 0)

	if bottomButtonImage("random", img.randomButton, img.randomButtonOver) then
		view.selectModel:scrollRandom()
	end

	gfx.translate(77, 0)

	if bottomButtonImage("chartOptions", img.optionsButton, img.optionsButtonOver) then
		view:openModal("thetan.irizz.views.modals.MountsModal")
	end
end

function ViewConfig:chartSetList()
	local w, h = Layout:move("base")
	local list = self.noteChartSetListView

	local no_focus = false

	for _, v in pairs(dropdowns) do
		no_focus = no_focus or v.mouseOver
	end

	list.focus = not no_focus and has_focus

	local a = easeOutCubic(chart_list_update_time, 0.7)

	gfx.translate(w - (610 * a), 82)
	list:updateAnimations()
	list:draw(610, 595, true)

	w, h = Layout:move("base")
	gfx.translate(w - 610, 82)
	gyatt.scrollBar(list, 610, 595)
end

function ViewConfig:scores(view)
	local list = self.scoreListView

	local no_focus = false

	for _, v in pairs(dropdowns) do
		no_focus = no_focus or v.mouseOver
	end

	list.focus = not no_focus and has_focus

	local prev_canvas = gfx.getCanvas()
	local canvas = gyatt.getCanvas("osuScoreList")
	gfx.setCanvas({ canvas, stencil = true })
	gfx.clear()

	local w, h = Layout:move("base")

	gfx.setBlendMode("alpha", "alphamultiply")

	if not has_scores then
		gfx.translate(20, 298)
		gfx.setColor({ 1, 1, 1, 1 })
		gfx.draw(img.noScores)
	else
		gfx.translate(8, 154)
		list:updateAnimations()
		list:draw(378, 420, true)
	end

	gfx.setCanvas({ prev_canvas, stencil = true })

	gfx.origin()
	gfx.setBlendMode("alpha", "premultiplied")
	local a = animate(update_time, 0.3)
	gfx.setColor(a, a, a, a)
	gfx.draw(canvas)
	gfx.setBlendMode("alpha")

	if list.openResult then
		list.openResult = false
		view:result()
	end
end

function ViewConfig:mods(view)
	local w, h = Layout:move("base")

	gfx.translate(104, 633)
	gfx.setColor({ 1, 1, 1, 0.75 })
	gfx.setFont(font.mods)
	gyatt.text(mods_str)
end

function ViewConfig:updateOtherInfo(view)
	local modifiers = view.game.playContext.modifiers
	mods_str = Theme:getModifierString(modifiers)

	local rate = view.game.playContext.rate
	local rate_type = view.game.configModel.configs.settings.gameplay.rate_type
	local time_rate_model = view.game.timeRateModel

	if rate ~= 1 then
		local rate_str

		if rate_type == "linear" then
			rate_str = ("%0.02fx"):format(time_rate_model:get())
		else
			rate_str = ("%iQ"):format(time_rate_model:get())
		end

		mods_str = rate_str .. " " .. mods_str
	end
end

function ViewConfig:modeLogo()
	local w, h = Layout:move("base")
	local image = img.maniaIcon
	local iw, ih = image:getDimensions()

	gfx.translate(w / 2 - iw / 2, h / 2 - ih / 2)
	gfx.setColor({ 1, 1, 1, 0.2 })
	gfx.draw(image)
end

function ViewConfig:resolutionUpdated()
	local w, h = Layout:move("base")
	top_panel_quad = gfx.newQuad(0, 0, w, img.panelTop:getHeight(), img.panelTop)

	local wh = love.graphics.getHeight()
	window_height = wh

	font = Theme:getFonts("osuSongSelect", wh / 768)

	self.noteChartSetListView:loadFonts()
	self.scoreListView:loadFonts()
end

function ViewConfig:setFocus(value)
	has_focus = value
end

function ViewConfig:draw(view)
	Layout:draw()

	current_time = love.timer.getTime()
	gyatt.setTextScale(768 / window_height)

	local a = math_util.clamp((1 - easeOutCubic(update_time, 1)) * 0.15, 0, 0.10)
	brighten_shader:send("amount", a)

	self:updateOtherInfo(view)

	self:modeLogo()
	self:chartSetList()
	self:scores(view)
	self:top()
	self:bottom(view)
	self:chartInfo()
	self:topUI(view)
	self:mods(view)

	gyatt.setTextScale(1)
end

return ViewConfig
