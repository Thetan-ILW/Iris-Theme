local class = require("class")
local just = require("just")
local imgui = require("thetan.iris.imgui")
local gfx_util = require("gfx_util")

local Layout = require("thetan.iris.views.SelectView.Collections.CollectionsLayout")

local Theme = require("thetan.iris.views.Theme")
local Color = Theme.colors
local Text = Theme.textCollections
local Font

local CollectionListView = require("thetan.iris.views.SelectView.Collections.CollectionListView")
local OsuDirectListView = require("thetan.iris.views.SelectView.Collections.OsuDirectListView")
local OsuDirectChartsListView = require("thetan.iris.views.SelectView.Collections.OsuDirectChartsListView")
local OsuDirectQueueListView = require("thetan.iris.views.SelectView.Collections.OsuDirectQueueListView")

local ViewConfig = class()

local canUpdate = false
local collectionsMode = "Collections"

function ViewConfig:new(game)
	self.collectionListView = CollectionListView(game)
	self.osuDirectListView = OsuDirectListView(game)
	self.osuDirectChartsListView = OsuDirectChartsListView(game)
	self.osuDirectQueueListView = OsuDirectQueueListView(game)
	Font = Theme:getFonts("collectionsViewConfig")
end

local function frame(w, h)
	love.graphics.setColor(Color.panel)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

local function border(w, h)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(4)
	love.graphics.setColor(Color.border)
	love.graphics.rectangle("line", -2, -2, w + 3, h + 3)
end

function ViewConfig:cacheStatus(view)
	local cacheModel = view.game.cacheModel
	local shared = cacheModel.shared
	local state = shared.state

	local text = ""
	if state == 1 then
		text = (Text.searching):format(shared.noteChartCount)
	elseif state == 2 then
		text = (Text.creatingCache):format(shared.cachePercent)
	elseif state == 3 then
		text = Text.complete
	else
		text = Text.idle
	end

	local w, h = Layout:move("status")
	love.graphics.setFont(Font.status)
	love.graphics.setColor(Color.text)
	gfx_util.printBaseline(text, 0, h / 2, w, 1, "center")
end

function ViewConfig:osuDirectDownloadQueue(view)
	local w, h = Layout:move("queue")
	frame(w, h)
	self.osuDirectQueueListView:draw(w, h, canUpdate)
	border(w, h)
end

function ViewConfig:osuDirectCharts(view)
	local w, h = Layout:move("charts")
	frame(w, h)
	self.osuDirectChartsListView:draw(w, h, canUpdate)
	border(w, h)
end

function ViewConfig:collectionsButtons(view)
	local w, h = Layout:move("buttons")
	frame(w, h)

	love.graphics.setColor(Color.text)
	love.graphics.setFont(Font.buttons)

	w, h = Layout:move("button1")

	if imgui.TextOnlyButton("cache", Text.cache, w, h) then
		view.game.selectController:updateCacheCollection(
			view.game.selectModel.collectionItem.path,
			love.keyboard.isDown("lshift")
		)
	end

	if imgui.TextOnlyButton("osuDirect", Text.osuDirect, w, h) then
		collectionsMode = "osu!direct"
		view.game.osudirectModel:searchNoDebounce()
		self.osuDirectChartsListView.noItemsText = Text.notInOsuDirect
	end

	w, h = Layout:move("button3")
	if imgui.TextOnlyButton("mounts", Text.mounts, w, h) then
		view:openModal("thetan.iris.views.modals.MountsModal")
	end

	w, h = Layout:move("buttons")
	border(w, h)
end

function ViewConfig:osuDirectButtons(view)
	local w, h = Layout:move("buttons")
	frame(w, h)

	love.graphics.setColor(Color.text)
	love.graphics.setFont(Font.buttons)

	w, h = Layout:move("button1")

	local set = view.game.osudirectModel.beatmap
	if set then
		local buttonText = set.downloaded and Text.redownload or Text.download

		if imgui.TextOnlyButton("download", buttonText, w, h) then
			view.game.osudirectModel:downloadBeatmapSet(set)
		end
	else
		imgui.TextOnlyButton("wait", Text.wait, w, h)
	end

	if imgui.TextOnlyButton("collections", Text.collections, w, h) then
		collectionsMode = "Collections"
		view.game.selectModel:debouncePullNoteChartSet()
		self.osuDirectChartsListView.items = {}
		self.osuDirectChartsListView.noItemsText = Text.noCharts
	end

	if imgui.TextOnlyButton("mounts", Text.mounts, w, h) then
		view.gameView:setModal(require("sphere.views.MountsView"))
	end

	w, h = Layout:move("buttons")
	border(w, h)
end

function ViewConfig:collectionsList(view)
	if collectionsMode ~= "Collections" then
		return
	end

	local w, h = Layout:move("list")
	frame(w, h)
	self.collectionListView:draw(w, h, canUpdate)
	border(w, h)
end

function ViewConfig:osuDirectList(view)
	if collectionsMode ~= "osu!direct" then
		return
	end

	local w, h = Layout:move("list")
	frame(w, h)
	self.osuDirectListView:draw(w, h, canUpdate)
	border(w, h)
end

function ViewConfig:footer(view)
	local w, h = Layout:move("name")
	love.graphics.setFont(Font.titleAndMode)
	love.graphics.setColor(Color.text)

	if collectionsMode == "Collections" and #self.collectionListView.items > 0 then
		local name = self.collectionListView:getItem().name
		just.text(name, w)
	end

	w, h = Layout:move("mode")
	just.text(collectionsMode, w, true)
end

function ViewConfig:draw(view, position)
	if math.abs(position) >= 1 then
		return
	end

	canUpdate = position == 0

	just.origin()
	Layout:draw(position)

	self:cacheStatus(view)
	self:osuDirectDownloadQueue(view)
	self:collectionsList(view)
	self:osuDirectList(view)

	if collectionsMode == "Collections" then
		self:collectionsButtons(view)
	else
		self:osuDirectButtons(view)
	end

	self:osuDirectCharts(view)
	self:footer(view)
end

return ViewConfig
