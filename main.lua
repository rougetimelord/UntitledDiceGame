if arg[2] == "debug" then
    require("lldebugger").start()
end

local MenuEngine = require("menuengine")
require("menus")

function love.load()
    Fonts = require("fonts")
    
    local splash = love.graphics.newText(Fonts.IAS48, "Dice Game")
    love.graphics.draw(splash, love.graphics.getWidth() / 2 - splash:getWidth() / 2, love.graphics.getHeight() / 2 - splash:getHeight() / 2)
    love.graphics.present()

    love.window.setMode(900, 900, {fullscreen = true, resizable = true})
    Object = require("classic")
    Die = require("die")
    Dice = {}
    Score = {}
    Started = false
    Round = nil
    RoundIntro = false
    RoundIntroWait = 0

    PauseMenu = PauseMenu(Fonts.IAS36)
    Background = require("background")
    MainBg = Background("assets/img/bg.png")
end

function NewGame()
    Dice = {}
    for i = 1, 5, 1 do
        local die = Die(nil, love.graphics.getWidth() / 2 + (i - 3) * 150, love.graphics.getHeight() / 2, 128, 128)
        table.insert(Dice, die)
    end
    Score.score = 0
    Score.money = 0
    Score.rolls = 5
    Started = true
    Round = 1
    RoundIntro = true
end

LastMenu = love.timer.getTime()
function love.update(dt)
    MainBg:update(dt)
    if love.keyboard.isDown("escape") and math.abs(LastMenu - love.timer.getTime()) > 0.5 then
        LastMenu = love.timer.getTime()
        PauseMenu:setDisabled(not PauseMenu.disabled)
    end
    if PauseMenu.disabled then
        if not Started then
            NewGame()
        end
        -- Only run game if not paused
        if love.mouse.isDown(1) then
            local x, y = love.mouse.getPosition()
            for index, value in ipairs(Dice) do
                if value:clicked(x, y) then
                    value:roll()
                    break
                end
            end
        end
    end
    PauseMenu:update()
end

function love.draw()
    if RoundIntro then
        RoundIntroWait = RoundIntroWait + love.timer.getDelta()
        if RoundIntroWait >= 2 then
            RoundIntro = false
            RoundIntroWait = 0
        end
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(Fonts.Y29I64)
        love.graphics.print("Round " .. Round, love.graphics.getWidth() / 2 - Fonts.Y29I64:getWidth("Round " .. Round) / 2, love.graphics.getHeight() / 2 - Fonts.Y29I64:getHeight() / 2)
    else
        MainBg:draw()
        for index, value in ipairs(Dice) do
            value:draw()
        end
    end
    PauseMenu:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    MenuEngine.mousemoved(x, y)
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end