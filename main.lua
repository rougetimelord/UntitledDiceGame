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
    Button = require("button")
    Hands = require("hands")

    Dice = {}
    Score = {}
    Started = false
    Round = nil
    RoundIntro = false
    RoundIntroWait = 0

    RollSound = love.audio.newSource("assets/roll.mp3", "static")
    FailSound = love.audio.newSource("assets/fail.mp3", "static")

    PauseMenu = PauseMenu(Fonts.IAS36)
    Background = require("background")
    PlayButton = Button(love.graphics.getWidth() / 2 - 50, 0.75 * love.graphics.getHeight(), 100, 50, "Play", Fonts.IAS24, PlayHand)
    MainBg = Background("assets/img/bg.png")
end

function NewRound()
    -- Round complete
    Score.score = 0
    Score.tries = 3
    Score.required = Score.required + 50 * Round
    Score.unusedRolls = 0
    Score.rolls = 5

    Score.money = Score.money + Score.tries * 3 + Score.unusedRolls + math.floor(Score.money / 10)
    Round = Round + 1
    RoundIntro = true
end

function PlayHand()
    Hands.ScoreHand()
    Score.unusedRolls = Score.unusedRolls + Score.rolls
    Score.rolls = 5
    Score.tries = Score.tries - 1

    if Score.score > Score.required then
        NewRound()
    elseif Score.tries <= 0 then
        -- Game over
        Score.money = 0
        NewGame()
    end

    for index, value in ipairs(Dice) do
        value:roll()
    end
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
    Score.tries = 3
    Score.required = 100
    Score.unusedRolls = 0
    Started = true
    Round = 1
    RoundIntro = true
end

LastMenu = love.timer.getTime()
function love.update(dt)
    if RoundIntro then
        RoundIntroWait = RoundIntroWait + dt
        if RoundIntroWait >= 2 then
            RoundIntro = false
            RoundIntroWait = 0
        end
    end
    MainBg:update(dt)
    if love.keyboard.isDown("escape") and math.abs(LastMenu - love.timer.getTime()) > 0.5 then
        LastMenu = love.timer.getTime()
        PauseMenu:setDisabled(not PauseMenu.disabled)
    end
    if PauseMenu.disabled then
        if not Started then
            NewGame()
        end
        local found = false
        PlayButton:update(dt)
        for index, value in ipairs(Dice) do
            value:update(dt)
            if not found and love.mouse.isDown(1) then
                local x, y = love.mouse.getPosition()
                if value:clicked(x, y) then
                    if Score.rolls > 0 then
                        Score.rolls = Score.rolls - 1
                    end
                    value:roll()
                    found = true
                end
            end
        end
    end
    PauseMenu:update()
end

local function drawMainScreen()
    MainBg:draw()
    for index, value in ipairs(Dice) do
        value:draw()
    end
    PlayButton:draw()
end

local function drawRoundIntro()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Fonts.Y29I64)
    love.graphics.print("Round " .. Round, love.graphics.getWidth() / 2 - Fonts.Y29I64:getWidth("Round " .. Round) / 2, love.graphics.getHeight() / 2 - Fonts.Y29I64:getHeight() / 2)
end

local function drawScore()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Fonts.IAS24)
    love.graphics.print("Score: " .. Score.score .. " / " .. Score.required, 10, 10)
    love.graphics.print("Money: " .. Score.money, 10, 40)
    love.graphics.print("Rerolls: " .. Score.rolls, 10, 70)
    love.graphics.print("Plays: " .. Score.tries, 10, 100)
end

function love.draw()
    drawMainScreen()
    drawScore()
    if RoundIntro then
        drawRoundIntro()
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