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
addon.cellCounts = cellCounts
local Profile
local isEnabled = false

--ACE3 Option Handlers
local optionHandler = {}
function optionHandler:Setter(info, value)
	Profile[info[#info]] = value
end


function optionHandler:Getter(info)
	return Profile[info[#info]]
end


--ACE3 Options Constuctor
local options = {
	name = addonName,
	handler = optionHandler,
	get = "Getter",
	set = "Setter",
	type = 'group',
	childGroups = "tab",
	inline = true,
	args = {
		general_settings={
			name = " ",
			type = "group",
			inline = true,
			order = 1,
			hidden = true,
			args={
				Options_Header = {
					order = 1,
					name = L["General Options"],
					type = "header",
					width = "full",
				},
				
				IgnoreClassRestrictions = {
					order = 1.2,
					name = "ff",--L["Ignore Class Restriction Filter"],
					type = "toggle",
					width = 1.3,
					arg = "IgnoreClassRestrictions",
				},
			},
		},
		tooltip_settings={
			name = " ",
			type = "group",
			inline = true,
			order = 3,
			args={
				Tooltip_Header = {
					order = 1,
					name = L["Tooltip Options"],
					type = "header",
					width = "full",
				},
				ShowRavenousTooltips = {
					order = 2,
					name = L["Show Ravenous Anima Cell Tooltips"],
					type = "toggle",
					width = 1.5,
				},
				ShowRavenousTooltips_Always = {
					order = 3,
					name = L["Always"],
					type = "toggle",
					width = 1,
					disabled = function() return not addon.db.profile.ShowRavenousTooltips end
				},
				ShowRareTooltips = {
					order = 4,
					name = L["Show Rare Ability Drop Tooltips"],
					type = "toggle",
					width = "full",
				},
			},
		},				
	},
}


--ACE Profile Saved Variables Defaults
local defaults = {
	profile = {
		['*'] = true,
	}
}

local noteDefaults = {
	profile = {
	}
}


local function Enable()
	addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "EventHandler")
	addon:RegisterEvent("CURSOR_UPDATE", "EventHandler")
	addon:RegisterEvent("BAG_UPDATE", "EventHandler")
	addon:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "EventHandler")


	if frames.f then
		frames.f:Show()
		frames.b:Show()
	else
		addon.InitFrames()
	end
	isEnabled = true
	addon.InitPowers()

	--if not IsAddOnLoaded("Blizzard_PlayerChoiceUI") then 
		-- LoadAddOn("Blizzard_PlayerChoiceUI")
		--end

	if PlayerChoiceFrame and not addon:IsHooked(PlayerChoiceFrame, "OnShow") then
		addon:HookScript(PlayerChoiceFrame, "OnShow", function() C_Timer.After(0.2, addon.PowerShow) end)
	end
end


local function Disable()
	addon:UnregisterEvent("UPDATE_MOUSEOVER_UNIT", "EventHandler")
	addon:UnregisterEvent("CURSOR_UPDATE", "EventHandler")
	addon:UnregisterEvent("BAG_UPDATE", "EventHandler")
	addon:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED", "EventHandler")
	if frames.f then
		frames.f:Hide()
		frames.b:Hide()
	end
	isEnabled = false

	if PlayerChoiceFrame and addon:IsHooked(PlayerChoiceFrame, "OnShow") then
		addon:Unhook(PlayerChoiceFrame, "OnShow")
	end
end
	

local function InTorghast()
	local id = C_Map.GetBestMapForUnit("player")
	if id then
		local name = C_Map.GetMapInfo(id).name
		if name and name == "Torghast" then
			return Enable()
		end
	end

	return Disable()
end


function addon:EventHandler(event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		InTorghast()
	elseif event == "ADDON_LOADED" and arg1 == "Blizzard_PlayerChoiceUI" and isEnabled then 
		C_Timer.After(0, function() addon:HookScript(PlayerChoiceFrame, "OnShow", function() C_Timer.After(0.2, addon.PowerShow) end) end)
	elseif event == "UPDATE_MOUSEOVER_UNIT" or event == "CURSOR_UPDATE"  then
		C_Timer.After(0.1, addon.PowerTooltips)
	elseif event == "BAG_UPDATE" then
		addon.UpdateCellCount()
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		addon.InitPowers()
	end		
end


---Ace based addon initilization
function addon:OnInitialize()
	TorghastTourgiudeDB = TorghastTourgiudeDB or {}
	TorghastTourgiudeDB.Options = TorghastTourgiudeDB.Options or {}
	TorghastTourgiudeDB.Notes = TorghastTourgiudeDB.Notes or {}
	TorghastTourgiudeDB.Weights = TorghastTourgiudeDB.Weights or {}
	self.db = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Options, defaults, true)
	self.Weightsdb = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Weights, noteDefaults, false)
	self.Notesdb = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Notes, noteDefaults, false)
	--options.args.settings.args.options = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	Profile = self.db.profile
	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)
	
	addon:RegisterEvent("PLAYER_ENTERING_WORLD", "EventHandler" )
	addon:RegisterEvent("ADDON_LOADED", "EventHandler" )
end

local RAVENOUS_CELL_ID = 170540
local PLUNDERED_CELL_ID = 168207
local REQUISITIONED_CELL_ID = 184662

local ravName, cellName, reqName
function addon:OnEnable()
	addon.initTourGuide()

	local item = Item:CreateFromItemID(RAVENOUS_CELL_ID)
	item:ContinueOnItemLoad(function()
		ravName = item:GetItemName() 
	end)

	local item2 = Item:CreateFromItemID(PLUNDERED_CELL_ID)
	item2:ContinueOnItemLoad(function()
		cellName = item2:GetItemName() 
	end)

	local item3 = Item:CreateFromItemID(REQUISITIONED_CELL_ID)
	item3:ContinueOnItemLoad(function()
		reqName = item3:GetItemName() 
	end)
end


function addon.ShowTooltip(self, text)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine(text)
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
	b:SetScript("OnEnter", function(self) addon.ShowTooltip(self, L["Toggle Guide"]) end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)

	local f = CreateFrame("Frame", nil, ScenarioStageBlock)
	frames.f = f
	f:SetSize(50, 20)
	f:SetPoint("TOPRIGHT", -20, -20)
	f:SetFrameLevel(100)
	f:Show()

	local function AnimaCountTooltip(self, type)
		local name = L["Anima Cell"]
		if type == "rav" then 
			name = L["Ravenous Anima Cell"]
		end

		local text = (L["%s Count"]):format(name)
		addon.ShowTooltip(self, text)
	end

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
	f.cellButton:SetScript("OnEnter", function(self) AnimaCountTooltip (self, "cell") end)
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

local blessing = 324717

local runecarver = 164937
local function GetCellCounts()
	cellCounts = {0,0,0}
	for t=0,4 do
		local slots = GetContainerNumSlots(t)
		if (slots > 0) then
			for c=1,slots do
				local _,_,_,_,_,_,itemLink,_,_,itemID = GetContainerItemInfo(t,c)

				if itemID == RAVENOUS_CELL_ID then
					cellCounts[1] = cellCounts[1] + 1
				elseif itemID == PLUNDERED_CELL_ID then
					cellCounts[2] = cellCounts[2] + 1
				elseif itemID == REQUISITIONED_CELL_ID then
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
		f.ravButton:SetAttribute("item", ravName)
	else 
		f.ravButton:SetAttribute("item", nil)
	end

	if cellCount > 0 then
		f.cellButton:SetAttribute("item", cellName)
	elseif reqCount > 0 then 
		f.cellButton:SetAttribute("item", reqName)
	else
		f.cellButton:SetAttribute("item", nil)
	end

	f.ravCount:SetText(ravCount)
	f.cellCount:SetText(cellCount + reqCount)
end