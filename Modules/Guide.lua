--  ///////////////////////////////////////////////////////////////////////////////////////////
--
--   
--  Author: SLOKnightfall

--  

--

--  ///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local frames = {} 

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


TorghastTourGuideScrollBarMixin = {};
function TorghastTourGuideScrollBarMixin:OnLoad()
	self.trackBG:SetVertexColor(ENCOUNTER_JOURNAL_SCROLL_BAR_BACKGROUND_COLOR:GetRGBA());
end

function addon.initTourGuide()
	local f = CreateFrame("Frame", "TorghastTourGuide", UIParent, "TorghastTourGuideTemplate")
	frames.tg = f
	tinsert(UISpecialFrames,"TorghastTourGuide")

	CreateUpgradeListFrame(f)
	addon.CreateBossButtons()
	addon.DisplayCreature()

	f.info.LinkButton:SetScript("OnEnter", function(self) addon.ShowTooltip(self, L["WoWHead Links"]) end)
	f.info.LinkButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.info.LinkButton:SetScript("OnClick", function(self) addon.ToggleLinkWindow() end)
end
	

--PlayerChoiceFrame.Option1
--CONFIRM_PURCHASE_NONREFUNDABLE_ITEM

local TTG_Tabs = {}
TTG_Tabs[1] = {frame = "upgrades", button="overviewTab"}
TTG_Tabs[2] = {frame = "bossesScroll", button="bossTab"}
TTG_Tabs[3] = {frame="detailsScroll", button="bossDetailsTab"}
--TTG_Tabs[4] = {frame="model", button="modelTab"}

function TorghastTourGuide_TabClicked(self, button)
	local tabType = self:GetID()
	addon.SetTab(tabType)
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
end


local creatureDisplayID
local function SetDefaultModel(tabType)
	if tabType == 1 then 
		addon.DisplayCreature()
	else
		addon.DisplayCreature(creatureDisplayID.encounterID)
	end
end


function addon.SetTab(tabType)
	local info = frames.tg.info
	for key, data in pairs(TTG_Tabs) do
		if key == tabType then
			info[data.frame]:Show()
			info[data.button].selected:Show()
			info[data.button].unselected:Hide()
			info[data.button]:LockHighlight()
		else
			info[data.frame]:Hide()
			info[data.button].selected:Hide()
			info[data.button].unselected:Show()
			info[data.button]:UnlockHighlight()
		end
	end
	if tabType == 1 then
		info[TTG_Tabs[3].button]:Hide()
	else
		info[TTG_Tabs[3].button]:Show()
	end
	if tabType == 3 then
		info.LinkButton:Show()
	else
		info.LinkButton:Hide()
	end


	SetDefaultModel(tabType)
end


function addon.DisplayCreature(UnitID)
	local data = addon.Bosses[UnitID]
	if not data then 
		data =  {"venari", 95004, {}, 65} 
		UnitID = 95004
	end

	local modelScene = frames.tg.info.model
	if data then -- and (EncounterJournal.creatureDisplayID ~= self.displayInfo or forceUpdate) then
		local scene = addon.BossCamera[UnitID] or 9
		modelScene:SetFromModelSceneID(scene, true)

		local creature = modelScene:GetActorByTag("creature")
		if creature then
			creature:SetModelByCreatureDisplayID(data[2], true)
		end
	end

	modelScene.imageTitle:SetText(data[1])
end


function addon.CreateBossButtons()
	local bossIndex = 1
	--local name, description, bossID, rootSectionID, link = EJ_GetEncounterInfoByIndex(bossIndex)
	for bossID, data in pairs(addon.Bosses) do
		local name = data[1]
		local bossButton = _G["TorgastTourGuideBossButton"..bossIndex]
		local hasBossAbilities = false

		if not bossButton then
			bossButton = CreateFrame("BUTTON", "TorgastTourGuideBossButton"..bossIndex, frames.tg.info.bossesScroll.child, "TorghastTourGuideBossButtonTemplate")
			if bossIndex > 1 then
				bossButton:SetPoint("TOPLEFT", _G["TorgastTourGuideBossButton"..(bossIndex - 1)], "BOTTOMLEFT", 0, -15)
				bossButton:UnlockHighlight()
			else
				
				bossButton:SetPoint("TOPLEFT", frames.tg.info.bossesScroll.child, "TOPLEFT", 0, -10)
				bossButton:LockHighlight()

			end
		end

		bossButton:SetText(name)
		bossButton:Show()
		bossButton.encounterID = bossID
		if bossIndex == 1 then 
			creatureDisplayID = bossButton
			addon.BossClick(bossButton)
		end
		bossButton:SetScript("OnClick", function() addon.BossClick(bossButton) end)
		--Use the boss' first creature as the button ico
		local bossImage = data[2] or "Interface\\EncounterJournal\\UI-EJ-BOSS-Default"
		SetPortraitTextureFromCreatureDisplayID(bossButton.creature, bossImage)

		bossIndex = bossIndex + 1
	end
end


function addon.ToggleTourGuide()
	if TorghastTourGuide:IsShown() then
		TorghastTourGuide:Hide()
	else
		TorghastTourGuide:Show()
	end
end


function TorghastTourGuide_Toggle()
	addon.ToggleTourGuide()
end


function addon.BossClick(bossButton)
	creatureDisplayID:UnlockHighlight()
	creatureDisplayID = bossButton
	addon.DisplayCreature(creatureDisplayID.encounterID)
	bossButton:LockHighlight()
	addon.ClearOverview()
	for i, spellID in ipairs(addon.Bosses[creatureDisplayID.encounterID][3]) do
		addon.SetUpOverview(spellID, i)
	end

	addon.SetUpTips(addon.BossTips[creatureDisplayID.encounterID], frames.tg.info.detailsScroll.child.overviews[#(addon.Bosses[creatureDisplayID.encounterID][3])])
end


function addon.SetUpTips(tipdata, anchor)
	local parent = frames.tg.info.detailsScroll.child
	if not parent.tips then 
		local infoHeader = CreateFrame("FRAME", nil, parent, "TorghastTourGuideInfoTemplate")
		infoHeader.descriptionBG:ClearAllPoints()
		infoHeader.descriptionBG:SetPoint("TOPLEFT", infoHeader, "BOTTOMLEFT")
		infoHeader.descriptionBG:SetPoint("TOPRIGHT", infoHeader, "BOTTOMRIGHT")

		infoHeader.button.abilityIcon:Hide()
		infoHeader.button.icon1:Hide()
		infoHeader.button.icon2:Hide()
		infoHeader.button.icon3:Hide()
		infoHeader.button.icon4:Hide()
		infoHeader.button.title:SetText(L["Tips & Tricks"])
		local textRightAnchor = infoHeader.button.icon1
		--infoHeader.button.title:SetPoint("LEFT", 5, 0)
		infoHeader.button.title:SetPoint("RIGHT", -5, 0)
		parent.tips = infoHeader
	end

	parent.tips:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT" , 0, -15 )
	parent.tips:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -15)
	parent.tips:Show()
	parent.bullets = parent.bullets or {}

	for index, data in ipairs(parent.bullets) do
		data:Hide()
	end

	for index, data in ipairs(tipdata) do
		local infoBullet
		if not parent.bullets[index] then
			infoBullet = CreateFrame("Frame", nil, parent, "TorghastTourGuideOverviewBulletTemplate")
			parent.bullets[index] = infoBullet
		else
			infoBullet = parent.bullets[index]
			infoBullet:Show()
		end

		if (index == 1) then
			infoBullet:SetPoint("TOPLEFT", parent.tips, "BOTTOMLEFT" , 4, -10 )
			infoBullet:SetPoint("TOPRIGHT", parent.tips, "BOTTOMRIGHT", -4, -10)

		else
			infoBullet:SetPoint("TOPLEFT", parent.bullets[index - 1], "BOTTOMLEFT", 0, -9)
			infoBullet:SetPoint("TOPRIGHT", parent.bullets[index - 1], "BOTTOMRIGHT", 0, -9)
		end

		infoBullet.Text:SetWordWrap(true)
		infoBullet.Text:SetText(data)
		infoBullet.Text:SetHeight(200)
	--	infoBullet:SetWidth(parent:GetWidth() - 13)
		infoBullet.Text:SetWidth(parent.tips:GetWidth() - 26)
		infoBullet:SetHeight(infoBullet.Text:GetStringHeight() + 5)
		parent.tips.descriptionBG:SetPoint("BOTTOMRIGHT", infoBullet, "BOTTOMRIGHT", 0, -3)
	end
end


function addon.ClearOverview()
	if not frames.tg.info.detailsScroll.child.overviews then return end
	for index, data in ipairs(frames.tg.info.detailsScroll.child.overviews) do
		data:Hide()
	end

end


function addon.SetUpOverview(spellID, index)
	local infoHeader
	local parent = frames.tg.info.detailsScroll.child
	parent.overviews = parent.overviews or {}
	if not parent.overviews[index] then -- create a new header
		infoHeader = CreateFrame("FRAME", "TTTG_InfoHeader"..index, parent, "TorghastTourGuideInfoTemplate")
		infoHeader.button.icon1:Hide()
		infoHeader.button.icon2:Hide()
		infoHeader.button.icon3:Hide()
		infoHeader.button.icon4:Hide()
		infoHeader.overviewIndex = index
		
		local textRightAnchor = infoHeader.button.icon1
		--infoHeader.button.title:SetPoint("LEFT", 5, 0)
		infoHeader.button.title:SetPoint("RIGHT", textRightAnchor, "LEFT", -5, 0)
		parent.overviews[index] = infoHeader
	else
		infoHeader = parent.overviews[index]
	end
	infoHeader:Show()

	infoHeader:ClearAllPoints()
	if (index == 1) then
		infoHeader:SetPoint("TOPLEFT",  0, -15 )
		infoHeader:SetPoint("TOPRIGHT", 0, -15 )
	else
		infoHeader:SetPoint("TOPLEFT", parent.overviews[index-1], "BOTTOMLEFT", 0, -9)
		infoHeader:SetPoint("TOPRIGHT", parent.overviews[index-1], "BOTTOMRIGHT", 0, -9)
	end
	--infoHeader.spellID = sectionInfo.spellID

	infoHeader.button.title:Show()

	--Workarround for undefined abilities
	if spellID == 999999999 then 
		local spell = Spell:CreateFromSpellID(300824)
		spell:ContinueOnSpellLoad(function()
			local name = spell:GetSpellName()
			local texture = spell:GetSpellTexture()
			infoHeader.button.abilityIcon:SetTexture(texture)
			infoHeader.button.abilityIcon:Show()
			infoHeader.button.title:SetText(name)
			infoHeader.description:SetText(L["Split_Desc"])
			infoHeader:SetHeight(infoHeader.description:GetHeight() + 40)
		end)
	else
		local spell = Spell:CreateFromSpellID(spellID)
		spell:ContinueOnSpellLoad(function()
			local name = spell:GetSpellName()
			local desc = spell:GetSpellDescription()
			local texture = spell:GetSpellTexture()
			infoHeader.button.abilityIcon:SetTexture(texture)
			infoHeader.button.abilityIcon:Show()
			infoHeader.button.title:SetText(name)
			infoHeader.description:SetText(desc)
			infoHeader:SetHeight(infoHeader.description:GetHeight() + 40)
		end)
	end

	infoHeader:Show()
end


local LISTWINDOW
function addon.ToggleLinkWindow()
	if LISTWINDOW then LISTWINDOW:Hide() end

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	--f:SetTitle("Wardrobe Export")
	f:SetLayout("Fill")
	f:EnableResize(false)
	f:SetHeight(150)
	f:SetWidth(350)
	LISTWINDOW = f

	_G["TTG_LinkWindow"] = f.frame
	tinsert(UISpecialFrames, "TTG_LinkWindow")

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullHeight(true)
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel("")
	MultiLineEditBox:DisableButton(button)
	MultiLineEditBox.button:Hide()
	MultiLineEditBox:SetText((L["BOSSLINK"]):format(creatureDisplayID.encounterID).."\n"..L["GUIDELINK"])
	f:AddChild(MultiLineEditBox)
end