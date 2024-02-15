local ListView = require("thetan.iris.views.ListView")
local TextCellImView = require("thetan.iris.imviews.TextCellImView")
local just = require("just")

local Theme = require("thetan.iris.views.Theme")
local Color = Theme.colors
local Text = Theme.textCollections

local OsudirectListView = ListView + {}

OsudirectListView.rows = 11
OsudirectListView.centerItems = true
OsudirectListView.scrollSound = Theme.sounds.scrollSoundLargeList

function OsudirectListView:new(game)
	self.game = game
	self.font = Theme:getFonts("osuDirectListView")
end

function OsudirectListView:reloadItems()
	self.items = self.game.osudirectModel.items
	if self.itemIndex > #self.items then
		self.targetItemIndex = 1
		self.stateCounter = (self.stateCounter or 0) + 1
	end
end

---@param count number
function OsudirectListView:scroll(count)
	ListView.scroll(self, count)
	self.game.osudirectModel:setBeatmap(self.items[self.targetItemIndex])
	self:playSound()
end

---@param ... any?
function OsudirectListView:draw(...)
	ListView.draw(self, ...)
end

function OsudirectListView:input()
	if not just.key_over() then
		return
	end

	local kp = just.keypressed
	if kp("up") or kp("left") then
		self:scroll(-1)
	elseif kp("down") or kp("right") then
		self:scroll(1)
	elseif kp("pageup") then
		self:scroll(-10)
	elseif kp("pagedown") then
		self:scroll(10)
	elseif kp("home") then
		self:scroll(-math.huge)
	elseif kp("end") then
		self:scroll(math.huge)
	end
end

---@param i number
---@param w number
---@param h number
function OsudirectListView:drawItem(i, w, h)
	local item = self.items[i]
	local color = item.downloaded and Color.itemDownloaded or Color.text

	self:drawItemBody(w, h, i, i == self:getItemIndex())

	love.graphics.setColor(color)
	love.graphics.translate(0, 4)
	just.indent(15)
	TextCellImView(math.huge, h, "left", item.artist, item.title, self.font.artist, self.font.title)
end

return OsudirectListView
