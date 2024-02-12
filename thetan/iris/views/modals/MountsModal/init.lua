local Modal = require("thetan.iris.views.modals.Modal")

local ViewConfig = require("thetan.iris.views.modals.MountsModal.ViewConfig")

local MountsModal = Modal + {}

MountsModal.viewConfig = ViewConfig

function MountsModal:new(game)
    self.game = game
end

return MountsModal