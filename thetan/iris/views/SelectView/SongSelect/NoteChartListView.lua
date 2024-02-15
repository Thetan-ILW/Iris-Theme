local ListView = require("thetan.iris.views.ListView")
local just = require("just")
local TextCellImView = require("thetan.iris.imviews.TextCellImView")
local Format = require("sphere.views.Format")

local Theme = require("thetan.iris.views.Theme")
local Color = Theme.colors
local Text = Theme.textSongSelect

local NoteChartListView = ListView + {}

NoteChartListView.rows = 7
NoteChartListView.centerItems = true
NoteChartListView.noItemsText = Text.noCharts
NoteChartListView.scrollSound = Theme.sounds.scrollSoundSmallList

function NoteChartListView:new(game)
	self.game = game
	self.font = Theme:getFonts("noteChartListView")
end

function NoteChartListView:reloadItems()
	self.stateCounter = self.game.selectModel.noteChartStateCounter
	self.items = self.game.selectModel.noteChartLibrary.items
end

---@return number
function NoteChartListView:getItemIndex()
	return self.game.selectModel.noteChartItemIndex
end

---@param count number
function NoteChartListView:scroll(count)
	self.game.selectModel:scrollNoteChart(count)

	if math.abs(count) ~= 1 then
		return
	end

	self:playSound()
end

function NoteChartListView:input()
	if just.keypressed("up") then
		self:scroll(-1)
	elseif just.keypressed("down") then
		self:scroll(1)
	end
end

---@param i number
---@param w number
---@param h number
function NoteChartListView:drawItem(i, w, h)
	local items = self.items
	local item = items[i]

	local baseTimeRate = self.game.playContext.rate

	local difficulty = Format.difficulty((item.difficulty or 0) * baseTimeRate)
	local inputMode = Format.inputMode(item.inputMode)
	inputMode = inputMode == "2K" and "TAIKO" or inputMode
	local name = item.name
	local creator = item.creator

	self:drawItemBody(w, h, i, i == self:getItemIndex())

	love.graphics.setColor(Color.text)
	love.graphics.translate(0, 4)

	just.indent(15)
	TextCellImView(
		50,
		h,
		"left",
		string.format("[%s]", inputMode),
		difficulty,
		self.font.inputMode,
		self.font.difficulty
	)

	just.sameline()
	just.indent(20)
	TextCellImView(math.huge, h, "left", creator, name, self.font.creator, self.font.name)
end

return NoteChartListView
