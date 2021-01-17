--  ///////////////////////////////////////////////////////////////////////////////////////////
--
--   
--  Author: SLOKnightfall

--  

--

--  ///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local frames = {} 
local cellCounts = {0,0,0}

---Ace based addon initilization
function addon:OnInitialize()
	addon:RegisterEvent("PLAYER_ENTERING_WORLD", "EventHandler" )
end


local function Enable()
	addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "EventHandler")
	addon:RegisterEvent("CURSOR_UPDATE", "EventHandler")
	addon:RegisterEvent("BAG_UPDATE", "EventHandler")
	if frames.f then
		frames.f:Show()
		frames.b:Show()
	else
		addon.InitFrames()
	end
end


local function Disable()
	addon:UnregisterEvent("UPDATE_MOUSEOVER_UNIT", "EventHandler")
	addon:UnregisterEvent("CURSOR_UPDATE", "EventHandler")
	addon:UnregisterEvent("BAG_UPDATE", "EventHandler")
	if frames.f then
		frames.f:Hide()
		frames.b:Hide()
	end
end


local function InTorghast()
	local id = C_Map.GetBestMapForUnit("player");
	if id then
		local name = C_Map.GetMapInfo(id).name
		if name and name == "Torghast" then
			return Enable()
		end
	end

	return Disable()
end


function addon:EventHandler(event, arg1 )
	if event == "PLAYER_ENTERING_WORLD" then
		InTorghast()
	elseif event == "UPDATE_MOUSEOVER_UNIT" or event == "CURSOR_UPDATE"  then
		C_Timer.After(0.1, addon.PowerTooltips)
	elseif event == "BAG_UPDATE" then
		addon.UpdateCellCount()
	end		
end


function addon:OnEnable()
	addon.initTourGuide()
end

do
	local function GetUnitId()
		local _, unit = GameTooltip:GetUnit();
		if unit then
			local guid = UnitGUID(unit);
			local id = tonumber(strmatch(guid, '%-(%d-)%-%x-$'), 10)
			return id
		end
	end

	local function CheckModified()
		for i=1,GameTooltip:NumLines() do
			local tooltip = _G["GameTooltipTextRight"..i]
			local text = tooltip:GetText()
			if text and string.find(text, L["Anima Cell"]) then
				return true
			end
		end

		return false
	end


	function addon.PowerTooltips()
		local unitID = GetUnitId()
		if not unitID then return end
			--if (isRSoulPresent or alwaysDisplayTraits) and addon.values[unitID] ~= nil and addon.values[unitID]["effect"] ~= nil and addon.values[unitID]["effect"]["id"] ~= nil then
		if cellCounts[1] > 0 then 
			local mobPowerInfo = addon.mobs[unitID]
			--if not mobPowerInfo then return end

			local powerName = GetSpellInfo(mobPowerInfo) 
			local powerDescription = GetSpellDescription(mobPowerInfo)
				powerDescription = GetSpellDescription(mobPowerInfo) or "" -- Sometimes return nil at first
			--end
			if powerName and not CheckModified() then
				GameTooltip:AddDoubleLine(powerName, L["Ravenous Anima Cell"], 0.9, 0.8, 0.5, 1, 0)
				GameTooltip:AddLine(powerDescription, 0.9, 0.8, 0.5, 1, 0)
				GameTooltip:Show()
			end
		end

		local powers = addon.RareIDs[unitID]
		if powers and not CheckModified() then
			for i, data in ipairs(powers) do
				local powerName = GetSpellInfo(data) 
				local powerDescription = GetSpellDescription(data)
				powerDescription = GetSpellDescription(data) or "" -- Sometimes return nil at first

				if powerName  then
					GameTooltip:AddDoubleLine(powerName, L["Dropped Anima Cell"], 0.9, 0.8, 0.5, 1, 0)
					GameTooltip:AddLine(powerDescription, 0.9, 0.8, 0.5, 1, 0)
					GameTooltip:Show()

				end
			end
		end
	end
end

local function AnimaCountTooltip(self, type)
	local name = L["Anima Cell"]
	if type == "rav" then 
		name = L["Ravenous Anima Cell"]
	end
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine((L["%s Count"]):format(name))
	GameTooltip:Show()
end


function addon.InitFrames()
	local b = CreateFrame("Button", nil, ScenarioStageBlock)
	frames.b = b
	b:SetSize(20, 20)
	b:SetPoint("TOPLEFT", 0, 0)
	b:SetFrameLevel(100)
	b:Show()
	b.Icon = b:CreateTexture(nil, "OVERLAY")
	b.Icon:SetSize(20, 20)

	b.Icon:SetAtlas("Campaign-QuestLog-LoreBook")
	b.Icon:SetPoint("TOPLEFT", 5, -5)
	b:SetScript("OnClick", addon.ToggleTourGuide)

	local f = CreateFrame("Frame", nil, ScenarioStageBlock)
	frames.f = f
	f:SetSize(50, 20)
	f:SetPoint("TOPRIGHT", -20, -20)
	f:SetFrameLevel(100)
	f:Show()

	f.ravFrame = CreateFrame("Frame", nil, f)
	f.ravFrame:SetSize(30, 15)
	f.ravFrame:SetPoint("TOPLEFT")
	f.ravButton = CreateFrame("Button", nil, f.ravFrame, "SecureActionButtonTemplate")
	f.ravButton:SetAttribute("type", "item")
	f.ravButton:SetAllPoints()
	f.ravButton:SetScript("OnEnter", function(self)  AnimaCountTooltip(self, "rav") end)
	f.ravButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.ravIcon = f.ravFrame:CreateTexture(nil, "OVERLAY")
	f.ravIcon:SetSize(15,15)
	f.ravIcon:SetTexture("Interface\\Icons\\inv_misc_orb_05")
	f.ravIcon:SetPoint("TOPLEFT")
	f.ravCount = f.ravFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.ravCount:SetText("0")
	f.ravCount:SetPoint("LEFT",f.ravIcon, "RIGHT", 5, 0)

	f.cellFrame = CreateFrame("Frame", nil, f)
	f.cellFrame:SetSize(30, 15)
	f.cellFrame:SetPoint("LEFT",f.ravFrame, "RIGHT", 15, 0 )
	f.cellButton = CreateFrame("Button", nil, f.cellFrame, "SecureActionButtonTemplate")
	f.cellButton:SetAttribute("type", "item")
	f.cellButton:SetAllPoints()
	f.cellButton:SetScript("OnEnter", function(self) AnimaCountTooltip(self, "cell") end)
	f.cellButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.cellIcon = f.cellFrame:CreateTexture(nil, "OVERLAY")
	f.cellIcon:SetSize(15,15)
	f.cellIcon:SetTexture("Interface\\Icons\\inv_misc_orb_04")
	f.cellIcon:SetPoint("TOPLEFT")
	f.cellCount = f.cellFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.cellCount:SetText("0")
	f.cellCount:SetPoint("LEFT",f.cellIcon, "RIGHT", 5, 0)

	addon.UpdateCellCount()
end


local function CreateUpgradeFrame(parent, id)
	local upgradeInfo = addon.Upgrades[id]
	local item = Item:CreateFromItemID(id)
	local known = C_QuestLog.IsQuestFlaggedCompleted(upgradeInfo[2])
	local description = GetSpellDescription(upgradeInfo[1])
	local color = RED_FONT_COLOR_CODE
	if known then
		color = GREEN_FONT_COLOR_CODE
	end

	local f = CreateFrame("Frame", nil, parent) 
	f:SetSize(20, 100)
	f:Show()

	f.icon = f:CreateTexture(nil, "OVERLAY")
	f.icon:SetSize(25,25)
	f.icon:SetTexture(itemTexture)
	f.icon:SetPoint("TOPLEFT")
	f.name = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	f.name:SetPoint("LEFT",f.icon, "RIGHT", 5, 0)
	item:ContinueOnItemLoad(function()
		local name = item:GetItemName() 
		local icon = item:GetItemIcon()
		f.name:SetText(color..name)
		f.icon:SetTexture(icon)
	end)
	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	f.desc:SetText(description)
	f.desc:SetPoint("TOPLEFT",f.icon, "BOTTOMLEFT",0, 0)
	f.desc:SetWidth(370)
	f.desc:SetJustifyH("LEFT")
	local height = f.desc:GetStringHeight()
	f:SetHeight(height + 35)
	return f
end


local function CreateUpgradeListFrame(parent)
	local f = CreateFrame("Frame", nil, parent)
	--frames.upgrades = f
	frames.tg.info.upgrades = f
	f:SetPoint("TOPLEFT", 400, -40 )
	f:SetPoint("BOTTOMRIGHT")
	f:Show()

	f.desc = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.desc:SetText(L["Torghast Upgrades"])
	f.desc:SetPoint("TOP", 0, -5)
	f.desc:SetJustifyH("CENTER")

	local index = 1
	for id in pairs(addon.Upgrades) do
		f[index] = CreateUpgradeFrame(f, id)
		if index == 1 then 
			f[index]:SetPoint("TOPLEFT", 20, -20)
			f[index]:SetPoint("TOPRIGHT", 0, 0)
		else
			f[index]:SetPoint("TOPLEFT", f[index - 1], "BOTTOMLEFT" )
		end
		index = index + 1
	end

end

EncounterJournalScrollBarMixin = {}
local venari = {"venari", 95004, 65}
function addon.initTourGuide()
	local f = CreateFrame("Frame", "TorghastTourGuide", UIParent, "TourGuideTemplate2")
	frames.tg = f
	--f:SetSize(50, 100)
	f:SetPoint("TOP")
	--f:SetFrameLevel(100)
	f:Show()
--f:Hide()
	CreateUpgradeListFrame(f)
		local f2 = CreateFrame("Frame", nil, f)
	frames.text = f2

	addon.DisplayCreature(venari)
	addon.CreateBossButtons()
end
	
local blessing = 324717
local ravID = 170540
local cellID = 184662
local reqID = 168207
local runecarver = 164937
local function GetCellCounts()
	cellCounts = {0,0,0}
	for t=0,4 do
		local slots = GetContainerNumSlots(t);
		if (slots > 0) then
			for c=1,slots do
				local _,_,_,_,_,_,itemLink,_,_,itemID = GetContainerItemInfo(t,c)

				if (itemID == ravID) then
					cellCounts[1] = cellCounts[1] + 1
				elseif itemID == cellID then 
					cellCounts[2] = cellCounts[2] + 1
				elseif itemID == reqID then
					cellCounts[3] = cellCounts[3] + 1
				end
			end
		end
	end

	return cellCounts
end

function addon.UpdateCellCount()
	if not frames.f then return end
	local f = frames.f

	local ravCount, cellCount, reqCount = unpack(GetCellCounts())
	if ravCount > 0 then 
		local item = Item:CreateFromItemID(ravID)
		item:ContinueOnItemLoad(function()
			local name = item:GetItemName() 
			f.cellButton:SetAttribute("item", name)
		end)
	else 
		f.ravButton:SetAttribute("item", nil)
	end
	if cellCount > 0 then
		local item = Item:CreateFromItemID(cellID)
		item:ContinueOnItemLoad(function()
			local name = item:GetItemName() 
			f.cellButton:SetAttribute("item", name)
		end)
	elseif reqCount > 0 then 
		local item = Item:CreateFromItemID(168207)
		item:ContinueOnItemLoad(function()
			local name = item:GetItemName() 
			f.cellButton:SetAttribute("item", name)
		end)
	else
		f.cellButton:SetAttribute("item", nil)
	end

	f.ravCount:SetText(ravCount)
	f.cellCount:SetText(cellCount + reqCount)
end


--PlayerChoiceFrame.Option1
--CONFIRM_PURCHASE_NONREFUNDABLE_ITEM


local TTG_Tabs = {}

--frames.tg.info.bossesScroll.child
TTG_Tabs[1] = {frame = "upgrades", button="overviewTab"};
TTG_Tabs[2] = {frame = "bossesScroll", button="bossTab"};
--TTG_Tabs[3] = {frame="detailsScroll", button="bossTab"};
--TTG_Tabs[4] = {frame="model", button="modelTab"};

function TorghastTourGuide_TabClicked(self, button)
	local tabType = self:GetID();
	addon.SetTab(tabType);
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN);
end

local creatureDisplayID = 156239

local function SetDefaultModel(tabType)
	if tabType == 1 then 
		addon.DisplayCreature(venari)
	else
		addon.DisplayCreature(addon.Bosses[creatureDisplayID])
	end
end

function addon.SetTab(tabType)
	local info = frames.tg.info
	--info.tab = tabType;
	for key, data in pairs(TTG_Tabs) do
		if key == tabType then
			info[data.frame]:Show();
			info[data.button].selected:Show();
			info[data.button].unselected:Hide();
			info[data.button]:LockHighlight();
		else
			info[data.frame]:Hide();
			info[data.button].selected:Hide();
			info[data.button].unselected:Show();
			info[data.button]:UnlockHighlight();
		end
	end
	SetDefaultModel(tabType)

end

local creature = {
["name"]= "Dark Ascended Corrus",
["id"] = 156239,

}

function addon.DisplayCreature(data)
--156239
	local modelScene = frames.tg.info.model;
	--cal data = addon.Bosses[mobID]

	if data then -- and (EncounterJournal.creatureDisplayID ~= self.displayInfo or forceUpdate) then
		local scene = data[3] or 9
		modelScene:SetFromModelSceneID(9, true);
		--local x,y,z = modelScene:GetCameraPosition()
		----print(x)
		--modelScene:SetCameraPosition(x, y, z+500)
		--modelScene:SetFogColor(0, 0, 1)
		--modelScene:SetFogNear(100)
--65

		local creature = modelScene:GetActorByTag("creature");
		if creature then
			creature:SetModelByCreatureDisplayID(data[2], true);
		end



		--EncounterJournal.creatureDisplayID = self.displayInfo;
	end

	modelScene.imageTitle:SetText(data[1]);

	--self:Disable();
	--frames.tg.info.shownCreatureButton = self;

	-- Ensure that the models tab properly updates the selected button (it's possible to display creatures here
	-- that only have a portrait/creature button on the abilities tab).
	--local creatureButton = EncounterJournal_FindCreatureButtonForDisplayInfo(self.displayInfo);
	--if creatureButton and creatureButton:IsShown() then
		--creatureButton:Click();
	--end
end

function addon.CreateBossButtons()
	local bossIndex = 1;
	--local name, description, bossID, rootSectionID, link = EJ_GetEncounterInfoByIndex(bossIndex);
	 for bossID, data in pairs(addon.Bosses) do
	local name = "test"
	local bossButton;
--frames.tg.info.bossesScroll.child;
	local hasBossAbilities = false;
	--while bossID do
		bossButton = _G["TorgastTourGuideBossButton"..bossIndex];
		if not bossButton then -- create a new header;
			bossButton = CreateFrame("BUTTON", "TorgastTourGuideBossButton"..bossIndex, frames.tg.info.bossesScroll.child, "TorghastTourGuideBossButtonTemplate");
			if bossIndex > 1 then
				bossButton:SetPoint("TOPLEFT", _G["TorgastTourGuideBossButton"..(bossIndex-1)], "BOTTOMLEFT", 0, -15);
			else
				creatureDisplayID = bossID
				bossButton:SetPoint("TOPLEFT", frames.tg.info.bossesScroll.child, "TOPLEFT", 0, -10);
			end
		end

		--bossButton.link = link;
		bossButton:SetText(data[1]);
		bossButton:Show();
		bossButton.encounterID = bossID;
		--Use the boss' first creature as the button icon
		--local _, _, _, _, bossImage = EJ_GetCreatureInfo(1, bossID);
		local bossImage --= data[2]
		bossImage = bossImage or "Interface\\EncounterJournal\\UI-EJ-BOSS-Default";
		--bossButton.creature:SetTexture(bossImage);
		SetPortraitTextureFromCreatureDisplayID(bossButton.creature, data[2])
		--bossButton:UnlockHighlight();

		--EncounterJournalBossButton_UpdateDifficultyOverlay(bossButton);

		---if ( not hasBossAbilities ) then
			--hasBossAbilities = rootSectionID > 0;
		--end

		bossIndex = bossIndex + 1;
		--name, description, bossID, rootSectionID, link = EJ_GetEncounterInfoByIndex(bossIndex);
	end
end

function addon.ToggleTourGuide()
	if TorghastTourGuide:IsShown() then
		TorghastTourGuide:Hide()
	else
		TorghastTourGuide:Show()
	end
end