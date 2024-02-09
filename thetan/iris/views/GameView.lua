local class = require("class")
local FadeTransition = require("sphere.views.FadeTransition")
local FrameTimeView = require("sphere.views.FrameTimeView")
local AsyncTasksView = require("sphere.views.AsyncTasksView")
local TextTooltipImView = require("sphere.imviews.TextTooltipImView")
local ContextMenuImView = require("sphere.imviews.ContextMenuImView")

---@class sphere.GameView
---@operator call: sphere.GameView
local GameView = class()

---@param game sphere.GameController
function GameView:new(game)
	self.game = game
	self.fadeTransition = FadeTransition()
	self.frameTimeView = FrameTimeView()
end

function GameView:load()
	self.frameTimeView.game = self.game

	self.frameTimeView:load()

	self:setView(self.game.selectView)
end

---@param view sphere.ScreenView
function GameView:_setView(view)
	if self.view then
		self.view:unload()
	end
	view.prevView = self.view
	self.view = view
	self.view:load()
end

---@param view sphere.ScreenView
function GameView:setView(view)
	view.gameView = self
	self.fadeTransition:transit(function()
		self.fadeTransition:transitAsync(1, 0)
		self:_setView(view)
		self.fadeTransition:transitAsync(0, 1)
	end)
end

function GameView:unload()
	if not self.view then
		return
	end
	self.view:unload()
end

---@param dt number
function GameView:update(dt)
	self.fadeTransition:update()
	if not self.view then
		return
	end
	self.view:update(dt)
end

function GameView:draw()
	if not self.view then
		return
	end
	self.fadeTransition:drawBefore()
	self.view:draw()

	if self.modal then
		self.modal:draw()

        if self.modal.alpha < 0 then
            self.modal = nil
			self.view.modalActive = false
        end
	end

	if self.contextMenu and ContextMenuImView(self.contextMenuWidth) then
		if ContextMenuImView(self.contextMenu()) then
			self.contextMenu = nil
		end
	end
	if self.tooltip then
		TextTooltipImView(self.tooltip)
		self.tooltip = nil
	end

	self.fadeTransition:drawAfter()
	self.frameTimeView:draw()

	local settings = self.game.configModel.configs.settings
	local showTasks = settings.miscellaneous.showTasks

	if showTasks then
		AsyncTasksView()
	end
end

---@param event table
function GameView:receive(event)
	self.frameTimeView:receive(event)
	if not self.view then
		return
	end
	self.view:receive(event)
end

---@param f function?
---@param width number?
function GameView:setContextMenu(f, width)
	self.contextMenu = f
	self.contextMenuWidth = width
end

---@param modal table?
function GameView:setModal(modal)
	local opennedModal = self.modal
	if not opennedModal then
		self.modal = modal
		self.modal.alpha = 0
        self.modal:show()
		self.view.modalActive = true
		return
	end

	self.modal = modal
	if opennedModal == modal then
		self.modal:hide()
	end
end

return GameView
