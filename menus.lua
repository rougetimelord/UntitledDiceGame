local menuengine = require("menuengine")


function PauseMenu(font)
    PauseMenu = menuengine.new(love.graphics.getWidth() / 4, love.graphics.getHeight() / 4, font)
    PauseMenu:setDisabled(true)
    PauseMenu:addEntry("Resume", function()
        PauseMenu:setDisabled(true)
    end)
    PauseMenu:addEntry("Restart", function()
        NewGame()
        PauseMenu:setDisabled(true)
    end)
    PauseMenu:addEntry("Quit", function()
        love.event.quit()
    end)
    return PauseMenu
end

return {PauseMenu}