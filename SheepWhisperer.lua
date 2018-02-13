SheepWhispererEvents = { }

SheepWhisperer_Spells = {
	-- Mage: English
	["Polymorph"] = true,
	["Polymorph: Pig"] = true,
	["Polymorph: Turtle"] = true,

	-- Mage: Russian
	["Превращение"] = true,
	["Превращение: свинья"] = true,
	["Превращение: черепаха"] = true,

	-- Mage: German
	["Verwandlung"] = true,

	-- Mage: French
	["Métamorphose"] = true,
	["Métamorphose: cochon"] = true,
	["Métamorphose: Tortue"] = true,

	-- Mage: Chinese (S)
	["变形术"] = true,
	["变形术：猪"] = true,
	["变形术：龟"] = true,

	-- Mage: Chinese (T)
	["變形術"] = true,
	["變豬術"] = true,
	["變龜術"] = true,

	-- Mage: Korean
	["변이"] = true,
	["변이: 돼지"] = true,
	["변이: 거북이"] = true,

	-- Priest
	["Shackle Undead"] = true,

	-- Priest: Russian
	["Сковывание нежити"] = true,

	-- Priest: German
	["Untote fesseln"] = true,

	-- Priest: French
	["Entraves des morts-vivants"] = true,

	-- Priest: Chinese (S)
	["束缚亡灵"] = true,

	-- Priest: Chinese (T)
	["束縛不死生物"] = true,

	-- Priest: Korean
	["언데드 속박"] = true,
}

function SheepWhispererEvents.UNIT_SPELLCAST_START(unitID, spell, rank, lineID, spellID)
	if (not SheepWhisperer_Spells[spell]) then
		return
	end

	SheepWhisperer_DebugPrint("Detected matching spell, " .. spell)

	if (unitID == "player") then
		SheepWhisperer_CheckOwnSheep(spell)
		return
	end

	if (unitID == "party1" or unitID == "party2" or unitID == "party3" or unitID == "party4") then
		SheepWhisperer_CheckOthersSheep(spell, unitID)
	end
end

function SheepWhisperer_CheckOthersSheep(spell, unitID)
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
	UIErrorsFrame:AddMessage("Switch target, " .. spell .. " is being cast by " .. unitName, 1.0, 0.5, 0.0, 3)
end

function SheepWhisperer_CheckOwnSheep(spell)
	if (not UnitExists("target")) then
		return
	end

	local target = UnitGUID("target")
	local targetName = UnitName("target")
	
	-- SheepWhisperer_CheckUnitTarget(spell, "player")

	if (IsInGroup()) then
		SheepWhisperer_DebugPrint("in group, checking each group member")
		for i=1, 4, 1 do
			local partyID = "party" .. tostring(i)
			if (UnitExists(partyID)) then
				SheepWhisperer_DebugPrint("checking" .. raidID)
				SheepWhisperer_CheckUnitTarget(spell, partyID)
			else
				SheepWhisperer_DebugPrint("no unit " .. raidID .. ", stopping scan")
				break
			end
		end
	end

	if (IsInRaid()) then
		SheepWhisperer_DebugPrint("in raid, checking each raid member")
		for i=1, 40, 1 do
			local raidID = "raid" .. tostring(i)
			if (UnitExists(raidID)) then
				SheepWhisperer_DebugPrint("checking" .. raidID)
				SheepWhisperer_CheckUnitTarget(spell, raidID)
			else
				SheepWhisperer_DebugPrint("no unit " .. raidID .. ", stopping scan")
				break
			end
		end
	end
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

	SheepWhisperer_DebugPrint("I am targetting " .. myTarget .. ", " .. unit .. " is targetting " .. theirTarget)

	local targetName = UnitName(unit .. "target")
	local unitName = UnitName(unit)
	SendChatMessage("I am casting " .. spell .. " on your target, " .. targetName .. ", please change to a different target if possible", "WHISPER", nil, unitName)
end

function SheepWhisperer_ChatPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[SheepWhisperer] "..str, 0.25, 1.0, 0.25)
end

function SheepWhisperer_ErrorPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[SheepWhisperer] "..str, 1.0, 0.5, 0.5)
end

function SheepWhisperer_DebugPrint(str)
	-- DEFAULT_CHAT_FRAME:AddMessage("[SheepWhisperer] "..str, 0.75, 1.0, 0.25)
end

SheepWhisperer_ChatPrint("Loaded")
SheepWhispererFrame = CreateFrame("Frame", nil, UIParent)
SheepWhispererFrame:RegisterEvent("UNIT_SPELLCAST_START")
SheepWhispererFrame:SetScript("OnEvent", function (_, e, ...) SheepWhispererEvents[e](...) end)