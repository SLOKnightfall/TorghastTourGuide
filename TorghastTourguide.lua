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
local cellCounts = {0,0,0,0}
addon.ravCount = 0
local Profile
local isEnabled = false

addon.Stats = {}

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
					hidden = true,
				},

				ResetStats = {
					order = 2,
					name = L["Reset Stats"],
					type = "execute",
					width = 1.3,
					func = function() addon.Stats:ResetAll() end,
				},
				spacer1 = {
					order = 2.1,
					name = " ",
					type = "description",
					width = 1.3,
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

local function ResetCounts()
	local defaults = {
			Phantasma = 0,
			AnimaPowers = 0,
			JarsBroken = 0,
			FloorsCompleted = 0,
			Deaths = 0,
			Grue = 0,
			MobsKilled = 0,
			Mawrats = 0,
			Rares = 0,
			Bosses = 0,
			Time = 0,
			CurrentTime = 0,
			TrapSprung = 0,
			Bosses = 0,
			Rares = 0,
			SoulsSaved = 0,
			Chests = 0,
			QuestsCompleted = 0,
			RunsCompleted = 0,
		}

	return defaults
end
addon.Stats.ResetCounts = ResetCounts


local statsDefaults = {
	profile = {}
}
statsDefaults.profile.current = ResetCounts()
statsDefaults.profile.total = ResetCounts()


local function Enable()
	if isEnabled then return end

	isEnabled = true

	if frames.f then
		frames.f:Show()
		frames.b:Show()
	else
		addon.InitFrames()
	end

	addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "EventHandler")
	addon:RegisterEvent("CURSOR_UPDATE", "EventHandler")
	addon:RegisterEvent("BAG_UPDATE", "EventHandler")

	addon:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "EventHandler")
	addon:RegisterEvent("PLAYER_DEAD", "EventHandler")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED", "EventHandler")
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "EventHandler")
	addon:RegisterEvent("NAME_PLATE_UNIT_ADDED", "EventHandler")
	addon:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED", "EventHandler")
	addon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
	addon:RegisterEvent("QUEST_TURNED_IN", "EventHandler")

	if not addon.Statsdb.profile.current.CurentTime then 
		addon.Statsdb.profile.current.CurentTime = GetTime()
	end

	frames.f:RegisterUnitEvent("UNIT_AURA", "player");
	frames.f:RegisterUnitEvent("UNIT_TARGET", "target");
	frames.f:SetScript("OnEvent", function(...) addon.EventHandler(...) end)

	if PlayerChoiceFrame and not addon:IsHooked(PlayerChoiceFrame, "OnShow") then
		addon:HookScript(PlayerChoiceFrame, "OnShow", function() C_Timer.After(0.2, addon.PowerShow) end)
	end
end


local function Disable()
	addon:UnregisterEvent("UPDATE_MOUSEOVER_UNIT", "EventHandler")
	addon:UnregisterEvent("CURSOR_UPDATE", "EventHandler")
	addon:UnregisterEvent("BAG_UPDATE", "EventHandler")
	addon:UnregisterEvent("CURRENCY_DISPLAY_UPDATE", "EventHandler")

	addon:UnregisterEvent("PLAYER_DEAD", "EventHandler")
	addon:UnregisterEvent("PLAYER_REGEN_ENABLED", "EventHandler")
	addon:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "EventHandler")

	addon:UnregisterEvent("NAME_PLATE_UNIT_ADDED", "EventHandler")
	addon:UnregisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED", "EventHandler")
	addon:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED", "EventHandler")
	addon:UnregisterEvent("QUEST_TURNED_IN", "EventHandler")

	addon.Statsdb.profile.total.Time = addon.Statsdb.profile.total.CurrentTime
	if frames.f then
		frames.f:Hide()
		frames.b:Hide()
	end
	isEnabled = false

	if PlayerChoiceFrame and addon:IsHooked(PlayerChoiceFrame, "OnShow") then
		addon:Unhook(PlayerChoiceFrame, "OnShow")
	end
end
	

function addon:GetCIDFromGUID(guid)
	local guidType, _, playerdbID, _, _, cid, _ = strsplit("-", guid or "")
	if guidType and (guidType == "Creature" or guidType == "Vehicle" or guidType == "Pet") then
		return tonumber(cid)
	elseif type and (guidType == "Player" or guidType == "Item") then
		return tonumber(playerdbID)
	end
	return 0
end

local ashen = {
	[164698] = true,
	[167986] = true,
	[165523] = true,
	[165533] = true,
	[170525] = true,
	[167987] = true,
}


local traps = {
	[307023] = true, --soul-burst
	[331321] = true,-- spike trap
	[306772] = true,--scythe
}

local ashenCache = {}
local function ClearAshenCache()
	ashenCache = {}
end


local grueFound = {}
local PHANTASMA_ID_NUMBER = 1728
local FREEING_SPELLID = 342127
local OPEN_CHEST_SPELLID = 320060
local mobList = {}
local currentFloor = 1
local runType
function addon:EventHandler(event, arg1, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if IsInJailersTower() then 
			Enable()
		else
			Disable()
		end

	elseif event == "JAILERS_TOWER_LEVEL_UPDATE" then
		local level = arg1
		currentFloor = arg1
		runType = ...
		--Enum.JailersTowerType
		if level == 1 then 
			addon.Stats:InitRun()
		else
			addon.Stats.IncreaseCounter("FloorsCompleted")
		end

	elseif event == "ADDON_LOADED" and arg1 == "Blizzard_PlayerChoiceUI" and isEnabled then 
		C_Timer.After(0, function() addon:HookScript(PlayerChoiceFrame, "OnShow", function() C_Timer.After(0.2, addon.PowerShow) end) end)

	elseif event == "UPDATE_MOUSEOVER_UNIT" or event == "CURSOR_UPDATE"  then
		C_Timer.After(0.1, addon.PowerTooltips)
	elseif event == "BAG_UPDATE" then

		addon.UpdateItemCount()

	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		--addon.InitPowers()
		--addon.initTourGuide()

		addon.RefreshConfig()
	elseif event == "PLAYER_DEAD" then
			addon.Stats.IncreaseCounter("Deaths")

	elseif event == "CURRENCY_DISPLAY_UPDATE" and arg1 == PHANTASMA_ID_NUMBER then 
			local  quantity, quantityChange, quantityGainSource, quantityLostSource = ...
			addon.Stats:SetPhantasma(quantityChange)

	elseif event == "PLAYER_CHOICE_UPDATE" then
			addon.Stats:AnimaGain()

	elseif event == "NAME_PLATE_UNIT_ADDED" or event == "FORBIDDEN_NAME_PLATE_UNIT_ADDED"  then
		if arg1 then
			local guid = UnitGUID(arg1)
			if not guid then return end
			local cid = self:GetCIDFromGUID(guid)
			if cid == 152253 and not grueFound[guid] then
				grueFound[guid] = true
				
				--PlaySoundFile("Interface\\AddOns\\DBM-CHallenges\\Shadowlands\\Stars.mp3", "Master")
			addon.Stats.IncreaseCounter("Grue")
			end
		end

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
		--print(CombatLogGetCurrentEventInfo())	
		--if not destGUID then return end
		local cid = self:GetCIDFromGUID(destGUID)
		local playerGUID = UnitGUID("player")
		local petGUID = UnitGUID("pet")

			--Revisit to count only player & pet kills?
		if (subevent == "UNIT_DIED") and destGUID ~= playerGUID then
			addon.Stats.IncreaseCounter("MobsKilled")
			if (cid == 151353) then 
				addon.Stats.IncreaseCounter("Mawrats")
			elseif 	mobList[destGUID]  and mobList[destGUID] == "rare" then
				mobList[destGUID] = nil
				addon.Stats.IncreaseCounter("Rares")
			elseif 	mobList[destGUID]  and mobList[destGUID] == "boss" then
				mobList[destGUID] = nil
				addon.Stats.IncreaseCounter("Bosses")
				if (currentFloor == 6 and runType ~= 0) or
				  (currentFloor == 18 and runType == 0) then 
					addon.Stats.IncreaseCounter("Bosses")
				end
			end
		
		elseif (subevent == "SPELL_DAMAGE")  and destGUID == playerGUID and traps[spellID] then 
			addon.Stats.IncreaseCounter("TrapSprung")
			
		elseif (cid and ashen[cid])  and (sourceGUID == playerGUID or sourceGUID == petGUID) and not ashenCache[destGUID] then
			ashenCache[destGUID] = true
			addon.Stats.IncreaseCounter("JarsBroken")
		end

	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then 
		local arg2, arg3 = ...
		if arg1 == "player" and arg3 == FREEING_SPELLID then 
			addon.Stats.IncreaseCounter("SoulsSaved")
		elseif arg3 == OPEN_CHEST_SPELLID then 
			addon.Stats.IncreaseCounter("Chests")
		end

	elseif event == "UNIT_AURA" then
		addon.Stats:AnimaGain()

	elseif event ==  "UNIT_TARGET" then
		local unitClass = UnitClassification("target")
		local level = UnitLevel("target")
		if unitClass == "rare" or unitClass == "rareelite" then 
			local guid = UnitGUID("target")
			mobList[guid] = "rare"
		elseif unitClass == "elite" and level >=62 then 
			local guid = UnitGUID("target")
			mobList[guid] = "boss"
		end

	elseif event ==  "QUEST_TURNED_IN" then
		addon.Stats.IncreaseCounter("QuestsCompleted")

	elseif(event == "SCENARIO_COMPLETED") then 
			--print("Done")
	end		
end


function addon.RefreshConfig()
	C_Timer.After(1,function()
		addon.CreateRavinousPowerListFrame()
		addon.CreateAnimaPowerListFrame()
	end)

end

---Ace based addon initilization
function addon:OnInitialize()
	TorghastTourgiudeDB = TorghastTourgiudeDB or {}
	TorghastTourgiudeDB.Options = TorghastTourgiudeDB.Options or {}
	--TorghastTourgiudeDB.Notes = TorghastTourgiudeDB.Notes or {}
	--TorghastTourgiudeDB.Weights = TorghastTourgiudeDB.Weights or {}
	TorghastTourgiudeDB.Stats = TorghastTourgiudeDB.Stats or {}
	TorghastTourgiudeDB.Weights_Notes = TorghastTourgiudeDB.Weights_Notes or {}
	self.db = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Options, defaults, true)
	--self.Weightsdb = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Weights, noteDefaults, false)
	--self.Notesdb = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Notes, noteDefaults, false)
	self.Statsdb = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Stats, statsDefaults, false)
	self.Weights_Notesdb = LibStub("AceDB-3.0"):New(TorghastTourgiudeDB.Weights_Notes, noteDefaults, false)

	self.Weights_Notesdb.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.Weights_Notesdb.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.Weights_Notesdb.RegisterCallback(self, "OnProfileReset", "RefreshConfig")


	Profile = self.db.profile
	LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
	--options.args.profiles  = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.Weightsdb)

	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)

	options.args.profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.Weights_Notesdb)
	options.args.profiles.name = "Weights & Notes"
	  -- Add dual-spec support
  	local LibDualSpec = LibStub('LibDualSpec-1.0')
  	LibDualSpec:EnhanceDatabase(self.Weights_Notesdb, addonName)
  	LibDualSpec:EnhanceOptions(options.args.profiles, self.Weights_Notesdb)
	
	addon:RegisterEvent("PLAYER_ENTERING_WORLD", "EventHandler" )
	addon:RegisterEvent("ADDON_LOADED", "EventHandler" )
	addon:RegisterEvent("JAILERS_TOWER_LEVEL_UPDATE", "EventHandler" )
	addon:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "EventHandler")
end

local RAVENOUS_CELL_ID = 170540
local PLUNDERED_CELL_ID = 168207
local REQUISITIONED_CELL_ID = 184662
local OBSCURING_ESSENCE_POTION_ID = 176331
local PHANTASMIC_INFUSER_ID = 184652
local ravName, cellName, reqName, obscuringName, infuserName

function addon:OnEnable()
	addon:GeneratePowerList()
	addon.InitPowers()

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

	local item4 = Item:CreateFromItemID(OBSCURING_ESSENCE_POTION_ID)
	item4:ContinueOnItemLoad(function()
		obscuringName = item4:GetItemName() 
	end)

	local item5 = Item:CreateFromItemID(PHANTASMIC_INFUSER_ID)
	item5:ContinueOnItemLoad(function()
	infuserName = item5:GetItemName() 
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

	--f:SetSize(50, 20)
	--f:SetPoint("TOPRIGHT", -20, -20)
	f:SetPoint("TOPRIGHT")
	f:SetPoint("BOTTOMLEFT")
	f:SetFrameLevel(100)
	f:Show()

	local function AnimaCountTooltip(self, type)
		local name = L["Anima Cell"]
		if type == "rav" then 
			name = ravName
		elseif type == "potion" then
			name = obscuringName

		elseif type == "infuser" then
			name = infuserName
		end

		local text = (L["Click to use %s"]):format(name)
		addon.ShowTooltip(self, text)
	end

	f.ravFrame = CreateFrame("Frame", nil, f)
	f.ravFrame:SetSize(30, 15)
	f.ravFrame:SetPoint("TOP", 45, -20)
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

	f.potionFrame = CreateFrame("Frame", nil, f)
	f.potionFrame:SetFrameStrata("HIGH")
	f.potionFrame:SetFrameLevel(50)
	f.potionFrame:SetSize(30, 15)
	f.potionFrame:SetPoint("BOTTOM",-10, 22)
	f.potionButton = CreateFrame("Button", nil, f.potionFrame, "SecureActionButtonTemplate")
	f.potionButton:SetAttribute("type", "item")
	f.potionButton:SetAllPoints()
	f.potionButton:SetScript("OnEnter", function(self) AnimaCountTooltip(self, "potion") end)
	f.potionButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	f.potionIcon = f.potionFrame:CreateTexture(nil, "OVERLAY")
	f.potionIcon:SetSize(15,15)
	f.potionIcon:SetTexture("Interface\\Icons\\Inv_alchemy_70_potion2_nightborne")
	f.potionIcon:SetPoint("TOPLEFT")
	f.potionCount = f.potionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.potionCount:SetText("0")
	f.potionCount:SetPoint("LEFT",f.potionIcon, "RIGHT", 5, 0)


	f.infuserFrame = CreateFrame("Frame", nil, f)
	f.infuserFrame:SetFrameStrata("HIGH")
	f.infuserFrame:SetSize(30, 15)
	f.infuserFrame:SetPoint("BOTTOMRIGHT", 40, 22)
	f.infuserButton = CreateFrame("Button", nil, f.infuserFrame, "SecureActionButtonTemplate")
	f.infuserButton:SetAttribute("type", "item")
	f.infuserButton:SetAllPoints()
	f.infuserButton:SetScript("OnEnter", function(self)  AnimaCountTooltip(self, "infuser") end)
	f.infuserButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.infuserIcon = f.infuserFrame:CreateTexture(nil, "OVERLAY")
	f.infuserIcon:SetSize(15,15)
	f.infuserIcon:SetTexture("Interface\\Icons\\spell_burningsoul")
	f.infuserIcon:SetPoint("TOPLEFT")

	addon.UpdateItemCount()
end

local blessing = 324717

local runecarver = 164937
local hasInfuser = false
local function GetItemCounts()
	cellCounts = {0,0,0,0}
	hasInfuser = false
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
				elseif itemID == OBSCURING_ESSENCE_POTION_ID then
					cellCounts[4] = cellCounts[4] + 1
				elseif itemID == PHANTASMIC_INFUSER_ID then
					hasInfuser = true
				end
			end
		end
	end

	return cellCounts
end

function addon.UpdateItemCount()
	if not frames.f then return end
	local f = frames.f

	local ravCount, cellCount, reqCount, potionCount = unpack(GetItemCounts())
	addon.ravCount = ravCount
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

	if potionCount > 0 then
		f.potionButton:SetAttribute("item", obscuringName)
	else
		f.potionButton:SetAttribute("item", nil)
	end

	if hasInfuser then
		f.infuserButton:SetAttribute("item", infuserName)
		f.infuserFrame:Show()
	else
		f.infuserButton:SetAttribute("item", nil)
		f.infuserFrame:Hide()
	end
	--f.infuserIcon:SetDesaturated(true)

	f.ravCount:SetText(ravCount)
	f.cellCount:SetText(cellCount + reqCount)
	f.potionCount:SetText(potionCount)
end