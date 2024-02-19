local gfx_util = require("gfx_util")

local Layout = require("sphere.views.Layout")

local _Layout = Layout()

local Theme = require("thetan.iris.views.Theme")
local outerPanelsSize = Theme.layout.outerPanelsSize
local innerPanelSize = Theme.layout.innerPanelSize
local gap = Theme.layout.gap
local verticalPanelGap = Theme.layout.verticalPanelGap
local horizontalPanelGap = Theme.layout.horizontalPanelGap

function _Layout:_footer(x, y, w, h)
	local x1, w1 = gfx_util.layout(x, w, { -0.65, -0.35 })
	self:pack("footerTitle", x1[1], y, w1[1], h)
	self:pack("footerChartName", x1[2], y, w1[2], h)
end

function _Layout:draw()
	local width, height = love.graphics.getDimensions()

	love.graphics.replaceTransform(gfx_util.transform(self.transform))

	local _x, _y = love.graphics.inverseTransformPoint(0, 0)
	local _xw, _yh = love.graphics.inverseTransformPoint(width, height)

	local _w, _h = _xw - _x, _yh - _y

	local gx, gw = gfx_util.layout(_x, _xw, { gap, "*", gap })
	local gy, gh = gfx_util.layout(_y, _yh, { 64, -1, gap })

	self:pack("background", _x, _y, _xw, _yh)

	local x1, w1 = gfx_util.layout(gx[2], gw[2], {-0.5, outerPanelsSize, horizontalPanelGap, innerPanelSize, horizontalPanelGap, outerPanelsSize, -0.5})
	local y1, h1 = gfx_util.layout(gy[2], gh[2], { gap, -0.1, gap, -0.9, gap, 20, gap })

	self:_footer(gx[2], y1[6], gw[2], h1[6])

	local y2, h2 = gfx_util.layout(y1[4], h1[4], {-0.15, -0.55, verticalPanelGap, -0.3})
	local hitGraphWidth = w1[2]+w1[3]+w1[4]+w1[5]+w1[6]
	self:pack("hitGraph", x1[2], y2[4], hitGraphWidth, h2[4]) 

end

return _Layout
