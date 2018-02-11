SheepWhispererEvents = { }

function SheepWhispererEvents.UNIT_SPELLCAST_START(unitID, spell, rank, lineID, spellID)
	if (unitID == "player") then
		SheepWhisperer_CheckOwnSheep(spell);
		return
	end

	if (unitID == "party1" or unitID == "party2" or unitID == "party3" or unitID == "party4") then
		SheepWhisperer_CheckOthersSheep(spell, unitID);
	end
end

function SheepWhisperer_CheckOthersSheep(spell, unitID)
	if (not SheepWhisperer_IsSheepSpell(spell)) then
		return
	end

	if (not UnitExists("target")) then
		return
	end

	if (not UnitExists(unitID .. "target")) then
		return
	end

	local myTarget = UnitGUID("target");
	local theirTarget = UnitGUID(unitID .. "target");

	if (myTarget ~= theirTarget) then
		return
	end

	local target = UnitGUID("target");
	local targetName = UnitName("target");

	local unitName = UnitName(unitID);
	UIErrorsFrame:AddMessage("Switch target, " .. spell .. " is being cast by " .. unitName, 1.0, 0.5, 0.0, 3);
end

function SheepWhisperer_CheckOwnSheep(spell)
	if (not UnitExists("target")) then
		return
	end

	if (not SheepWhisperer_IsSheepSpell(spell)) then
		return
	end

	local target = UnitGUID("target");
	local targetName = UnitName("target");
	
	-- SheepWhisperer_CheckUnitTarget(spell, "player");
	SheepWhisperer_CheckUnitTarget(spell, "party1");
	SheepWhisperer_CheckUnitTarget(spell, "party2");
	SheepWhisperer_CheckUnitTarget(spell, "party3");
	SheepWhisperer_CheckUnitTarget(spell, "party4");
end

function SheepWhisperer_CheckUnitTarget(spell, unit)
	if (not UnitExists(unit) or not UnitExists(unit .. "target")) then
		return
	end
	if (not UnitExists("target")) then
		return
	end

	local myTarget = UnitGUID("target");
	local theirTarget = UnitGUID(unit .. "target");

	if (myTarget ~= theirTarget) then
		return
	end

	local targetName = UnitName(unit .. "target");
	local unitName = UnitName(unit);
	SendChatMessage("I am casting " .. spell .. " on your target, " .. targetName .. ", please change to a different target if possible", "WHISPER", nil, unitName);
end

function SheepWhisperer_IsSheepSpell(spell)
	if spell == "Polymorph" then
		return true
	end
	if spell == "Shackle Undead" then
		return true
	end

	return false
end

function SheepWhisperer_ChatPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[SheepWhisperer] "..str, 0.25, 1.0, 0.25);
end

function SheepWhisperer_ErrorPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[GTSheepWhispererFO] "..str, 1.0, 0.5, 0.5);
end

function SheepWhisperer_DebugPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[SheepWhisperer] "..str, 0.75, 1.0, 0.25);
end

SheepWhisperer_ChatPrint("Loaded");
SheepWhispererFrame = CreateFrame("Frame", nil, UIParent)
SheepWhispererFrame:RegisterEvent("UNIT_SPELLCAST_START");
SheepWhispererFrame:SetScript("OnEvent", function (_, e, ...) SheepWhispererEvents[e](...) end)