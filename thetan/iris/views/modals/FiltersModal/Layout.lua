local gfx_util = require("gfx_util")

local Layout = require("sphere.views.Layout")

local _Layout = Layout()

function _Layout:draw()
	local width, height = love.graphics.getDimensions()

	love.graphics.replaceTransform(gfx_util.transform(self.transform))

	local _x, _y = love.graphics.inverseTransformPoint(0, 0)
	local _xw, _yh = love.graphics.inverseTransformPoint(width, height)

	local _w, _h = _xw - _x, _yh - _y

	self:pack("base", _x, _y, _w, _h)

	local gx, gw = gfx_util.layout(_x, _xw, { 20, "*", 20 })
	local gy, gh = gfx_util.layout(_y, _yh, { 20, "*", 20 })

	local x1, w1 = gfx_util.layout(gx[2], gw[2], { -0.5, 1000,  -0.5 })
	local y1, h1 = gfx_util.layout(gy[2], gh[2], { 200, -1, 200 })
	local y2, h2 = gfx_util.layout(y1[2], h1[2], { -0.3, -0.4, -0.3 })

	self:pack("modalName", gx[2], y1[1], gw[2], h1[1])
	self:pack("filters", x1[2], y1[2], w1[2], h1[2])
	self:pack("filterLine", gx[2], y1[3], gw[2], h1[3])
end

return _Layout
