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
    Player = {
        tries = 3,
        rolls = 5,
    }
    Started = false
    Round = nil
    RoundIntro = false
    RoundIntroWait = 0
    GameOver = false
    GameOverWait = 0

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
    Score.tries = Player.tries
    Score.required = Score.required + 50 * Round
    Score.unusedRolls = 0
    Score.rolls = Player.rolls

    Score.money = Score.money + Score.tries * 3 + Score.unusedRolls + math.floor(Score.money / 10)
    Round = Round + 1
    RoundIntro = true
end

function PlayHand()
    Hands.ScoreHand()
    Score.unusedRolls = Score.unusedRolls + Score.rolls
    Score.rolls = Player.rolls
    Score.tries = Score.tries - 1

    if Score.score > Score.required then
        NewRound()
    elseif Score.tries <= 0 then
        -- Game over
        
        GameOver = true
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
    -- Reset player stats
    Player.tries = 3
    Player.rolls = 5
    -- Reset score object
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
        if RoundIntroWait >= 1.5 then
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
        for index, value in ipairs(Dice) do
            value:update(dt)
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
    love.graphics.setFont(Fonts.IAS64)
    love.graphics.print("Round " .. Round, love.graphics.getWidth() / 2 - Fonts.IAS64:getWidth("Round " .. Round) / 2, love.graphics.getHeight() / 2 - Fonts.IAS64:getHeight() / 2)
end

local function drawScore()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Fonts.IAS24)
    love.graphics.print("Score: " .. Score.score .. " / " .. Score.required, 10, 10)
    love.graphics.print("Money: " .. Score.money, 10, 40)
    love.graphics.print("Rerolls: " .. Score.rolls, 10, 70)
    love.graphics.print("Plays: " .. Score.tries, 10, 100)
end

local function drawHandPreview()
    local hand = Hands.IdentifyHand()
    local handText = hand.name .. ": " .. hand.score .. " x " .. hand.mult
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Fonts.IAS24)
    love.graphics.print(handText, love.graphics.getWidth() / 2 - Fonts.IAS24:getWidth(handText) / 2, love.graphics.getHeight() * 0.75 - 50)
end

function love.draw()
    if GameOver then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(Fonts.IAS64)
        love.graphics.print("Game Over", love.graphics.getWidth() / 2 - Fonts.IAS64:getWidth("Game Over") / 2, love.graphics.getHeight() / 2 - Fonts.IAS64:getHeight() / 2)
        love.graphics.print("Click to restart", love.graphics.getWidth() / 2 - Fonts.IAS64:getWidth("Click to restart") / 2, love.graphics.getHeight() / 2 + Fonts.IAS64:getHeight() / 2)
    else
        drawMainScreen()
        drawHandPreview()
        drawScore()
        if RoundIntro then
            drawRoundIntro()
        end
    end
    PauseMenu:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    MenuEngine.mousemoved(x, y)
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        if GameOver then
            NewGame()
            GameOver = false
        else
            if RoundIntro then
                RoundIntro = false
                RoundIntroWait = 0
            end
            if PlayButton:check(x, y) then
                return
            end
            for index, value in ipairs(Dice) do
                if value:clicked(x, y) then
                    value:roll()
                    if Score.rolls > 0 then
                        Score.rolls = Score.rolls - 1
                    end
                end
            end
        end
    end
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end