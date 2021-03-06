SheepWhispererEvents = { }

SheepWhisperer_Spells = {
    -- Mage
    [118] = "Polymorph: Sheep",
    [161353] = "Polymorph: Polar Bear Cub",
    [28271] = "Polymorph: Turtle",
    [161354] = "Polymorph: Monkey",
    [161355] = "Polymorph: Penguin",
    [61305] = "Polymorph: Black Cat",
    [126819] = "Polymorph: Porcupine",
    [161372] = "Polymorph: Peacock",
    [28272] = "Polymorph: Pig",
    [61780] = "Polymorph: Turkey",
    [277792] = "Polymorph: Bumblebee",

    -- Priest
    [9484] = "Shackle Undead",
    [11444] = "Shackle Undead",
    [40135] = "Shackle Undead"
}

function SheepWhispererEvents.UNIT_SPELLCAST_START(unitID, castGUID, spellID)
    local spellName = SheepWhisperer_Spells[spellID]
    if not spellName then
        return
    end

    LVK:Debug("Detected matching spellName, " .. spellName)

	if (unitID == "player") then
		SheepWhisperer_CheckOwnSheep(spellName)
		return
	end

	if (unitID == "party1" or unitID == "party2" or unitID == "party3" or unitID == "party4") then
		SheepWhisperer_CheckOthersSheep(spellName, unitID)
    end
end

function SheepWhisperer_CheckOthersSheep(spellName, unitID)
	if (not UnitExists("target")) then
		return
	end

	if (not UnitExists(unitID .. "target")) then
		return
	end

	local myTarget = UnitGUID("target")
	local theirTarget = UnitGUID(unitID .. "target")

	if (myTarget ~= theirTarget) then
		return
	end

	local target = UnitGUID("target")
	local targetName = UnitName("target")

	local unitName = UnitName(unitID)
	UIErrorsFrame:AddMessage("Switch target, " .. spellName .. " is being cast by " .. unitName, 1.0, 0.5, 0.0, 3)
end

function SheepWhisperer_CheckOwnSheep(spellName)
	if (not UnitExists("target")) then
		return
	end

	local target = UnitGUID("target")
	local targetName = UnitName("target")
	
	-- SheepWhisperer_CheckUnitTarget(spellName, "player")

	if (IsInGroup()) then
		LVK:Debug("in group, checking each group member")
		for i=1, 4, 1 do
            local partyID = "party" .. tostring(i)
			if (UnitExists(partyID)) then
				LVK:Debug("checking " .. partyID)
				SheepWhisperer_CheckUnitTarget(spellName, partyID)
			else
				LVK:Debug("no unit " .. partyID .. ", stopping scan")
				break
			end
		end
	end

	if (IsInRaid()) then
		LVK:Debug("in raid, checking each raid member")
		for i=1, 40, 1 do
			local raidID = "raid" .. tostring(i)
			if (UnitExists(raidID)) then
				LVK:Debug("checking" .. raidID)
				SheepWhisperer_CheckUnitTarget(spellName, raidID)
			else
				LVK:Debug("no unit " .. raidID .. ", stopping scan")
				break
			end
		end
    end
    
    -- SheepWhisperer_CheckUnitTarget(spellName, "player")
end

function SheepWhisperer_CheckUnitTarget(spell, unit)
	if (not UnitExists(unit) or not UnitExists(unit .. "target")) then
		return
	end
	if (not UnitExists("target")) then
		return
	end

	local myTarget = UnitGUID("target")
	local theirTarget = UnitGUID(unit .. "target")

	if (myTarget ~= theirTarget) then
		return
	end

	LVK:Debug("I am targetting " .. myTarget .. ", " .. unit .. " is targetting " .. theirTarget)

	local targetName = UnitName(unit .. "target")
	local unitName = UnitName(unit)
	SendChatMessage("I am casting " .. spell .. " on your target, " .. targetName .. ", please change to a different target if possible", "WHISPER", nil, unitName)
end

SheepWhispererFrame = CreateFrame("Frame", nil, UIParent)
SheepWhispererFrame:RegisterEvent("UNIT_SPELLCAST_START")
SheepWhispererFrame:SetScript("OnEvent", function (_, e, ...) SheepWhispererEvents[e](...) end)

LVK:AnnounceAddon("SheepWhisperer");