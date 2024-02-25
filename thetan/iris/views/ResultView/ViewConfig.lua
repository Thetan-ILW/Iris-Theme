local class = require("class")
local just = require("just")
local gfx_util = require("gfx_util")
local Format = require("sphere.views.Format")
local erfunc = require("libchart.erfunc")

local Theme = require("thetan.iris.views.Theme")
local Color = Theme.colors
local Text = Theme.textResult
local font

local Layout = require("thetan.iris.views.ResultView.Layout")

local ScoreListView = require("thetan.iris.views.ScoreListView")
local PointGraphView = require("sphere.views.GameplayView.PointGraphView")

local ViewConfig = class()

function ViewConfig:new(game)
	self.scoreListView = ScoreListView(game, true)
	self.scoreListView.rows = 4
	font = Theme:getFonts("resultView")
end

---@param view table
---@return boolean
local function showLoadedScore(view)
	local scoreEntry = view.game.playContext.scoreEntry
	local scoreItem = view.game.selectModel.scoreItem
	if not scoreEntry or not scoreItem then
		return false
	end
	return scoreItem.id == scoreEntry.id
end

local lines = {
	"line1",
	"line2",
	"line3",
	"line4",
	"line5"
}

local function panel()
	local w, h = Layout:move("panel")
	Theme:panel(w, h)
	Theme:border(w, h)

	love.graphics.setColor(Color.border)
	for _, name in ipairs(lines) do
		w, h = Layout:move(name)
		love.graphics.rectangle("fill", 0, 0, w, h)
	end
end

function ViewConfig:scores(view)
	local w, h = Layout:move("scores")
	local list = self.scoreListView
	list:draw(w, h, true)
	if list.openResult then
		list.openResult = false
		view:loadScore(list.selectedScoreIndex)
	end
end

local pointR = 3
local padding = 5
---@param self table
local function drawGraph(self)
	local w, h = Layout:move("hitGraph")
	love.graphics.translate(pointR + padding, pointR)
	self.__index.draw(self, w - pointR - (padding * 2), h - pointR)
	love.graphics.translate(-pointR - padding, -pointR)
end

local function getPointY(y)
	return (y.misc.deltaTime / 0.27) + 0.5
end

local perfectColor = Color.hitPerfect
local notPerfectColor = Color.hitBad
local noobColor = Color.hitVeryBad
local _HitGraph = PointGraphView({
	draw = drawGraph,
	radius = pointR,
	backgroundColor = { 0, 0, 0, 0.2 },
	backgroundRadius = 6,
	point = function(self, point)
		if point.base.isMiss then
			return
		end
		local color = noobColor
		if math.abs(point.misc.deltaTime) <= 0.032 then
			color = notPerfectColor
		end
		if math.abs(point.misc.deltaTime) <= 0.016 then
			color = perfectColor
		end
		local y = getPointY(point)
		return y, unpack(color)
	end,
	show = showLoadedScore
})

local _EarlyHitGraph = PointGraphView({
	draw = drawGraph,
	radius = pointR,
	backgroundColor = { 0, 0, 0, 1 },
	backgroundRadius = pointR + 4,
	point = function(self, point)
		if not point.base.isEarlyHit then
			return
		end
		local y = getPointY(point)
		return y, unpack(Color.hitMiss)
	end,
	show = showLoadedScore
})

local _MissGraph = PointGraphView({
	draw = drawGraph,
	radius = pointR,
	backgroundColor = { 0, 0, 0, 1 },
	backgroundRadius = pointR + 4,
	point = function(self, point)
		if not point.base.isMiss then
			return
		end
		local y = getPointY(point)
		return y, unpack(Color.hitMiss)
	end,
	show = showLoadedScore
})

---@param view table
local function HitGraph(view)
	local w, h = Layout:move("hitGraph")
	Theme:panel(w, h)
	_HitGraph.game = view.game
	_HitGraph:draw()
	_EarlyHitGraph.game = view.game
	_EarlyHitGraph:draw()
	_MissGraph.game = view.game
	_MissGraph:draw()

	local show = showLoadedScore(view)

	local rhythmModel = view.game.rhythmModel
	local scoreEngine = rhythmModel.scoreEngine
	local scoreItem = view.game.selectModel.scoreItem
	local normalscore = rhythmModel.scoreEngine.scoreSystem.normalscore
	local mean = show and normalscore.normalscore.mean or scoreItem.mean

	local meanText = string.format("Mean: %i ms", mean * 1000)
	local maxErrorText = string.format("Max error: %i ms", scoreEngine.scoreSystem.misc.maxDeltaTime * 1000)

	local fontHeight = font.hitError:getBaseline()
	Theme:panel(font.hitError:getWidth(meanText) + 10, fontHeight + 10)

	local fontWidth = font.hitError:getWidth(maxErrorText)
	love.graphics.rectangle("fill", 0, h - fontHeight - 10, fontWidth + 10, fontHeight + 10)

	just.indent(5)
	love.graphics.setColor(Color.text)
	love.graphics.setFont(font.hitError)
	just.text(meanText, w)
	Layout:move("hitGraph")
	gfx_util.printFrame(maxErrorText, 5, -5, w, h, "left", "bottom")
	Theme:border(w, h)
end

---@param view table
function ViewConfig:judgements(view)
	local show = showLoadedScore(view)
	local scoreEngine = view.game.rhythmModel.scoreEngine
	local scoreItem = view.game.selectModel.scoreItem
	local judgement = scoreEngine.scoreSystem.judgement

	if not judgement or not scoreItem then
		return
	end

	local counterName = view.game.configModel.configs.select.judgements
	local counters = judgement.counters
	local judgementLists = judgement.judgementLists
	local counter = counters[counterName]
	local judgements = judgement.judgements[counterName]
	local base = scoreEngine.scoreSystem.base

	local count = counters.all.count

	local perfect = show and counter.perfect or scoreItem.perfect or 0
	local notPerfect = show and counter["not perfect"] or scoreItem.not_perfect or 0
	local miss = show and base.missCount or scoreItem.miss or 0

	local w, h = Layout:move("judgements")
	love.graphics.setFont(font.judgements)
	love.graphics.setColor(Color.text)

	local textInterval = 10

	if show then
		local judgeCount = #judgementLists[counterName] + 1
		local frameSize = (h - textInterval) / judgeCount

		for i, name in ipairs(judgementLists[counterName]) do
			local value = counters[counterName][name]
			gfx_util.printFrame(("%s: %i"):format(name, value), 0, (i - 1) * frameSize + (textInterval / 2), w, frameSize,
				"center", "center")
		end

		gfx_util.printFrame(("%s: %i"):format("MISS", miss), 0, (judgeCount - 1) * frameSize + (textInterval / 2), w, frameSize,
			"center", "center")
	end

	w, h = Layout:move("judgementsAccuracy")
	gfx_util.printFrame(("%3.2f%%"):format(judgements.accuracy(counter) * 100), 0, 0, w, h, "center", "center")
end

local function Footer(view)
	local noteChartItem = view.game.selectModel.noteChartItem

	if not noteChartItem then
		return
	end

	love.graphics.setColor(Color.text)
	love.graphics.setFont(font.titleAndDifficulty)

	local w, h = Layout:move("footerTitle")
	just.text(string.format("%s - %s", noteChartItem.artist, noteChartItem.title), w)

	w, h = Layout:move("footerChartName")
	just.text(
		string.format(
			"[%s] [%s] %s",
			Format.inputMode(noteChartItem.inputMode),
			noteChartItem.creator,
			noteChartItem.name
		),
		w,
		true
	)
end

function ViewConfig:scoreInfo(view)
	local ratingHitTimingWindow = view.game.configModel.configs.settings.gameplay.ratingHitTimingWindow

	local rhythmModel = view.game.rhythmModel
	local normalscore = rhythmModel.scoreEngine.scoreSystem.normalscore

	local noteChartItem = view.game.selectModel.noteChartItem
	local scoreItem = view.game.selectModel.scoreItem
	local scoreEngine = rhythmModel.scoreEngine
	local playContext = view.game.playContext

	if not scoreItem then
		return
	end

	local topScoreItem = view.game.scoreLibraryModel.items[1]
	if topScoreItem == scoreItem then
		topScoreItem = view.game.scoreLibraryModel.items[2]
	end
	if not topScoreItem then
		topScoreItem = scoreItem
	end

	local scoreEntry = playContext.scoreEntry
	if not scoreEntry then
		return
	end

	local show = showLoadedScore(view)

	local baseTimeRate = show and playContext.rate or scoreItem.rate
	local baseInputMode = noteChartItem.inputMode

	local inputMode = show and tostring(rhythmModel.noteChart.inputMode) or scoreItem.inputmode
	inputMode = Format.inputMode(inputMode)
	local score = not show and scoreItem.score or
		erfunc.erf(ratingHitTimingWindow / (normalscore.accuracyAdjusted * math.sqrt(2))) * 10000
	if score ~= score then
		score = 0
	end
	
	local accuracyValue = show and normalscore.accuracyAdjusted or scoreItem.accuracy
	local accuracy = Format.accuracy(accuracyValue)
	
	local w, h = Layout:move("normalscore")
	love.graphics.setFont(font.scoreInfo)
	gfx_util.printFrame(
		("%s: %i\n%s: %s\n%s: %s\n%s: %0.02fx"):format(
			Text.score, score,
			Text.accuracy, accuracy,
			Text.inputMode, inputMode,
			Text.timeRate, baseTimeRate),
		0, 0, w, h, "center", "center"
	)
end

---@param view table
---@param noteChartItem table
local function EnpsDifficulty(view, noteChartItem)
	if not noteChartItem.difficulty then
		return
	end

	local baseTimeRate = view.game.playContext.rate

	local w, h = Layout:move("difficulty")

	love.graphics.setColor(Theme:getDifficultyColor(noteChartItem.difficulty * baseTimeRate, "enps"))
	love.graphics.setFont(font.difficulty)
	gfx_util.printBaseline(string.format("%0.02f", noteChartItem.difficulty * baseTimeRate), 0, h / 2, w, 1, "center")

	love.graphics.setFont(font.calculator)
	gfx_util.printBaseline("ENPS", 0, h / 1.2, w, 1, "center")
end

---@param view table
---@param noteChartItem table
local function MsdDifficulty(view, noteChartItem)
	if not noteChartItem.difficulty then
		return
	end

	local baseTimeRate = view.game.playContext.rate

	--if baseTimeRate ~= 1 then
	--	baseTimeRate = baseTimeRate / 1.04
	--end

	local difficultyData = noteChartItem.difficulty_data or "None"
	difficultyData = difficultyData:gsub(";", "\n")

	local w, h = Layout:move("difficulty")

	love.graphics.setColor(Theme:getDifficultyColor(noteChartItem.difficulty * baseTimeRate, "msd"))
	love.graphics.setFont(font.difficulty)
	gfx_util.printBaseline(string.format("%0.02f", noteChartItem.difficulty * baseTimeRate), 0, h / 2, w, 1, "center")

	love.graphics.setFont(font.calculator)
	gfx_util.printBaseline("DUPS", 0, h / 1.2, w, 1, "center")

	love.graphics.setColor(Color.text)
	love.graphics.setFont(font.patterns)
	w, h = Layout:move("patterns")
	gfx_util.printFrame(difficultyData, 0, 15, w, h, "center", "center")

end

function ViewConfig:difficulty(view)
	local w, h = Layout:move("difficulty")

	love.graphics.setColor(Color.transparentPanel)
	love.graphics.rectangle("fill", 0, 0, w, h)

	local noteChartItem = view.game.selectModel.noteChartItem

	if not noteChartItem then
		return
	end

	if noteChartItem.difficulty_data then
		MsdDifficulty(view, noteChartItem)
	else
		EnpsDifficulty(view, noteChartItem)
	end
end

function ViewConfig:pauses(view)
	local scoreItem = view.game.selectModel.scoreItem
	local rhythmModel = view.game.rhythmModel
	local scoreEngine = rhythmModel.scoreEngine
	local playContext = view.game.playContext

	local show = showLoadedScore(view)
	local const = show and playContext.const or scoreItem.const
	local scrollSpeed = "X"
	if const then
		scrollSpeed = "Constant"
	end

	local w, h = Layout:move("pauses")
	love.graphics.setFont(font.pauses)
	gfx_util.printFrame(("%s: %i\n%s: %s"):format(Text.pauses, scoreItem.pauses, Text.scrollSpeed, scrollSpeed), 0, 0, w, h, "center", "center")
end

function ViewConfig:draw(view)
	just.origin()
	panel()
	self:judgements(view)
	self:scores(view)
	self:difficulty(view)
	self:scoreInfo(view)
	self:pauses(view)
	HitGraph(view)
	Footer(view)
end

return ViewConfig
