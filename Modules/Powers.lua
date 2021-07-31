local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local Weights_Notesdb


local function GetSpec()
	local currentSpec = GetSpecialization()
	local currentSpecID = currentSpec and select(1, GetSpecializationInfo(currentSpec))
	return currentSpecID
end


function addon.InitDB()
	local name = UnitName("player")
	local realmName = GetRealmName()
	--local spec = GetSpec()
	--addon.Notesdb.profile[spec] = addon.Notesdb.profile[spec] or {}
	--NotesDB = addon.Notesdb.profile[spec]
	--addon.Weightsdb.profile[spec] = addon.Weightsdb.profile[spec] or {}
	--WeightsDB = addon.Weightsdb.profile[spec]

	if (not TorghastTourgiudeDB.Notes or (TorghastTourgiudeDB.Notes and TorghastTourgiudeDB.Notes.profiles and not TorghastTourgiudeDB.Notes.profiles[name.. " - "..realmName]))  or
	(not TorghastTourgiudeDB.Wieghts or (TorghastTourgiudeDB.Wieghts and TorghastTourgiudeDB.Wieghts.profiles and not TorghastTourgiudeDB.Wieghts.profiles[name.. " - "..realmName])) then return end


	local currentSpec = GetSpecialization()
	local NotesDB = TorghastTourgiudeDB.Notes.profiles[name.." - "..realmName]
	local WeightsDB = TorghastTourgiudeDB.Weights.profiles[name.." - "..realmName]
	local dualspec = addon.Weights_Notesdb:GetNamespace("LibDualSpec-1.0")

	local currentProfile
	for spec = 1, 4 do
		local currentSpecID, currentSpecName = GetSpecializationInfo(spec)
		if (NotesDB or WeightsDB)  and currentSpecID then
			local profileName = currentSpecName.." - "..name.." - "..realmName
			profileList = addon.Weights_Notesdb:GetProfiles()
			addon.Weights_Notesdb:SetProfile(profileName)
			dualspec.char[spec] = profileName
	
			local newProfile = addon.Weights_Notesdb.profile
			if NotesDB and NotesDB[currentSpecID] then 
				for i, data in pairs(NotesDB[currentSpecID]) do
					newProfile[i] = newProfile[i] or {}
					newProfile[i].note = data
				end
			end

			if WeightsDB and WeightsDB[currentSpecID] then 
				for i, data in pairs(WeightsDB[currentSpecID]) do
					newProfile[i] = newProfile[i] or {}
					newProfile[i].weight = data
				end
			end
			--NotesDB = LibStub("AceDB-3.0"):New(name.."-"..relm.."-"..currentSpecName, NotesDB[spec])
			--WeightsDB = LibStub("AceDB-3.0"):New(name.."-"..relm.."-"..currentSpecName, WeightsDB[spec])
			if spec == currentSpec then
				currentProfile = profileName
			end
		end
	end
	
	addon.Weights_Notesdb:SetProfile(currentProfile)
	dualspec.char.enabled = true
	if 	TorghastTourgiudeDB and TorghastTourgiudeDB.Notes then
	 	TorghastTourgiudeDB.Notes.profiles[name.. " - "..realmName] = nil
	end
	if	TorghastTourgiudeDB and TorghastTourgiudeDB.Weights then
		 TorghastTourgiudeDB.Weights.profiles[name.. " - "..realmName] = nil
	end
end


function addon.GetNotes(spellID)
	--print(addon.Weights_Notesdb:GetCurrentProfile())
	local Weights_Notesdb = addon.Weights_Notesdb.profile
	local notes = (Weights_Notesdb[spellID] and Weights_Notesdb[spellID].note) or ""
	local weight = (Weights_Notesdb[spellID] and Weights_Notesdb[spellID].weight) or ""
	return weight, notes
end


local LISTWINDOW
function addon.EditWeight(self, frame)
	if LISTWINDOW then LISTWINDOW:Hide() end
	local Weights_Notesdb = addon.Weights_Notesdb.profile

	local f = AceGUI:Create("Window")
	f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle(L["Set Power Weight & Note"])
	f:SetLayout("Flow")
	f:EnableResize(false)
	f:SetHeight(235)
	f:SetWidth(350)
	LISTWINDOW = f

--:GetLayoutChildren()[1].optionInfo.spellID
	local spellID = frame.optionInfo.spellID
	Weights_Notesdb[spellID] = Weights_Notesdb[spellID] or {}

	_G["TTG_NoteWindow"] = f.frame
	tinsert(UISpecialFrames, "TTG_NoteWindow")
	local EditBox = AceGUI:Create("EditBox")
	EditBox.frame:SetWidth(200)
	EditBox.editbox:ClearAllPoints()
	EditBox.editbox:SetPoint("BOTTOMLEFT", 6, 0)
	EditBox.editbox:SetWidth(80)
	EditBox.button:ClearAllPoints()
	EditBox.button:SetPoint("LEFT",EditBox.editbox, "RIGHT")
	EditBox:SetLabel(L["Power Weight"])
	EditBox:SetText(Weights_Notesdb[spellID].weight or "")
	EditBox:SetCallback("OnEnterPressed" , function() 
		Weights_Notesdb[spellID] = Weights_Notesdb[spellID] or {}
		Weights_Notesdb[spellID].weight = EditBox:GetText()
		self.Text:SetText(Weights_Notesdb[spellID].weight)
	end)
	f:AddChild(EditBox)

	local MultiLineEditBox = AceGUI:Create("MultiLineEditBox")
	MultiLineEditBox:SetFullWidth(true)
	MultiLineEditBox:SetLabel(L["Power Notes"])

	MultiLineEditBox:SetCallback("OnEnterPressed" , function() 
		Weights_Notesdb[spellID] = Weights_Notesdb[spellID] or {}
		Weights_Notesdb[spellID].note = MultiLineEditBox:GetText(); 
		if frame.notes then 
			frame.notes.Text:SetText(Weights_Notesdb[spellID].note)
		elseif frame.description then 
			addon.CreateAnimaPowerListFrame()
		end  
	end)
	MultiLineEditBox:SetText(Weights_Notesdb[spellID].note or "")
	f:AddChild(MultiLineEditBox)
	
	local Button = AceGUI:Create("Button")
	Button:SetText(CLOSE)
	Button:SetCallback("OnClick", function() f:Hide() end)
	f:AddChild(Button)
end


local framePool = {}
function addon.PowerShow()
	print("show")
	local Weights_Notesdb = addon.Weights_Notesdb.profile

	local frames = PlayerChoiceFrame:GetChildren()[1]
	for i, frame in ipairs(PlayerChoiceFrame:GetLayoutChildren()) do
		local weight, notes, f
		if not framePool[i] then 
			f = CreateFrame("Frame", nil, UIParent)
			f.notes = CreateFrame("Frame", nil, f, "TorghastTourGuideNoteTemplate")
			--notes:SetScript("OnMouseDown", function(self) addon.EditWeight(self, frame) end)

			f.weight = CreateFrame("Frame", nil, f, "TorghastTourGuidePowerTemplate")
			--	weight:SetScript("OnEnter", function(self) self:GetParent().MouseOverOverride:EnableMouse(false);  addon.ShowTooltip(self, "This Is a Note")  end)
			--	weight:SetScript("OnLeave", function(self) GameTooltip:Hide(); self:GetParent().MouseOverOverride:EnableMouse(true); end)

			f.helper = CreateFrame("Frame", nil, f, "TorghastTourAnimaSelectionTemplate")
			f.helper.icon:SetVertexColor(1,0,0);

			f.weight:SetScript("OnMouseDown", function(self) addon.EditWeight(self, frame) end)
			f.weight:SetFrameLevel(15)
			framePool[i] = f
			f:SetFrameStrata("DIALOG")
			f:SetFrameLevel(frame.WidgetContainer:GetFrameLevel()+500)

			f.count = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")

			f.count:SetPoint("CENTER", f, 45, 35)
			f.count:SetJustifyH("CENTER")
		else
			f = framePool[i]
			f:Show()
		end

		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", frame, "TOPLEFT")
		f:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")

		local spellID = frame.optionInfo.spellID
		local spellRarity = frame.optionInfo.rarity
		if spellID  then 
			local count = addon.GetAnimaPowerCount(spellID)
			if count < 0 then
				f.count:SetText(count)
			else
				f.count:SetText("")

			end

			f.weight.Text:SetText(Weights_Notesdb[spellID] and Weights_Notesdb[spellID].weight or "")
			f.notes.Text:SetText(Weights_Notesdb[spellID] and Weights_Notesdb[spellID].note or "")

			local isEpic = addon.CheckAnimaRarity(spellRarity)
			local isDupe = addon.CheckAnimaPowers(spellID)
			if (addon.checkBonusStatus("Pauper") and isEpic) or (addon.checkBonusStatus("Highlander") and  isDupe) then

				f.helper.icon:Show()
				f.helper.tooltipTitle = "Selecting Voids:"
				f.helper.tooltipText = ("%s%s"):format((isEpic and "Pauper  +10pts\n") or "", (isDupe and "Highlander + 15pts") or"")
			else
				f.helper.icon:Hide()
				f.helper.tooltipText = nil
			end
		end
	end
end

function addon.PowerHide()
	for i, frame in ipairs(framePool) do
		frame:Hide()
	end
end

local function LogEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT" then
		self:LogEvent_Original(event, CombatLogGetCurrentEventInfo())
	elseif event == "COMBAT_TEXT_UPDATE" then
		self:LogEvent_Original(event, (...), GetCurrentCombatTextEventInfo())
	else
		self:LogEvent_Original(event, ...)
	end
end

local function OnEventTraceLoaded()
	EventTrace.LogEvent_Original = EventTrace.LogEvent
	EventTrace.LogEvent = LogEvent
end

if EventTrace then
	OnEventTraceLoaded()
else
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and (...) == "Blizzard_EventTrace" then
			OnEventTraceLoaded()
			self:UnregisterAllEvents()
		end
	end)
end