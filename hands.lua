function IdentifyHand()
    local occurs = {}
    for index, value in ipairs(Dice) do
        if not occurs[value.up.name] then
            occurs[value.up.name] = 0
        end
        occurs[value.up.name] = occurs[value.up.name] + 1
    end
    local list = {}
    for key, value in pairs(occurs) do
        table.insert(list, value)
    end
    table.sort(list, function(a, b) return a > b end)
    if list[1] == 6 then
        return {name= "Six of a Kind", mult=12, score=75}
    end
    if list[1] == 5 then
        return {name= "Five of a Kind", mult=10, score=50}
    elseif list[1] == 4 then
        return {name= "Four of a Kind", mult=8, score=20}
    elseif list[1] == 3 and list [2] == 2 then
        return {name= "Full House", mult=5, score=15}
    elseif list[1] == 3 then
        return {name= "Three of a Kind", mult=3, score=10}
    elseif list[1] == 2 and list[2] == 2 then
        return {name= "Two Pair", mult=2, score=5}
    elseif list[1] == 2 then
        return {name= "One Pair", mult=2, score=0}
    else
        return {name= "High Dice", mult=1, score=0}
    end
end

function ScoreHand()
    local hand = IdentifyHand()
    local score = 0
    for index, value in ipairs(Dice) do
        score = value.up.scoring(score)
    end
    Score.score = Score.score + ((score + hand.score) * hand.mult)
end

return {
    IdentifyHand = IdentifyHand,
    ScoreHand = ScoreHand
}