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

	if not TorghastTourgiudeDB.Notes or (TorghastTourgiudeDB.Notes and TorghastTourgiudeDB.Notes.profiles and not TorghastTourgiudeDB.Notes.profiles[name.. " - "..realmName]) then return end

	local currentSpec = GetSpecialization()
	local NotesDB = TorghastTourgiudeDB.Notes.profiles[name.." - "..realmName]
	local WeightsDB = TorghastTourgiudeDB.Weights.profiles[name.." - "..realmName]
	local dualspec = addon.Weights_Notesdb:GetNamespace("LibDualSpec-1.0")

	local currentProfile
	for spec = 1, 4 do
		local currentSpecID, currentSpecName = GetSpecializationInfo(spec)
		if NotesDB and currentSpecID then
			local profileName = currentSpecName.." - "..name.." - "..realmName
			profileList = addon.Weights_Notesdb:GetProfiles()
			--TorghastTourgiudeDB.Weights_Notesdb = TorghastTourgiudeDB.Weights_Notesdb or {}
			--TorghastTourgiudeDB.Weights_Notesdb.profiles = TorghastTourgiudeDB.Weights_Notesdb.profiles or {}
			--TorghastTourgiudeDB.Weights_Notesdb.profiles[profileName] = {}
			addon.Weights_Notesdb:SetProfile(profileName)
			dualspec.char[spec] = profileName
	
			local newProfile = addon.Weights_Notesdb.profile
			--newProfile.note = {}
			--newProfile.weight = {}

			if NotesDB[currentSpecID] then 
				for i, data in pairs(NotesDB[currentSpecID]) do
					newProfile[i] = newProfile[i] or {}
					newProfile[i].note = data
				end
			end
			if WeightsDB[currentSpecID] then 
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
	TorghastTourgiudeDB.Notes.profiles[name.. " - "..realmName] = nil
	TorghastTourgiudeDB.Weights.profiles[name.. " - "..realmName] = nil
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

	local spellID = frame.spellID
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
		frame.weight.Text:SetText(Weights_Notesdb[spellID].weight)
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
	MultiLineEditBox:SetText(Weights_Notesdb[spellID].weight or "")
	f:AddChild(MultiLineEditBox)
	
	local Button = AceGUI:Create("Button")
	Button:SetText(CLOSE)
	Button:SetCallback("OnClick", function() f:Hide() end)
	f:AddChild(Button)
end


function addon.PowerShow()
	local Weights_Notesdb = addon.Weights_Notesdb.profile
	for i, frame in ipairs(PlayerChoiceFrame.Options) do
		local weight, notes
		if not frame.weight then 
			local notes = CreateFrame("Frame", nil, frame, "TorghastTourGuideNoteTemplate")
			--notes:SetScript("OnMouseDown", function(self) addon.EditWeight(self, frame) end)

			local weight = CreateFrame("Frame", nil, frame, "TorghastTourGuidePowerTemplate")
			--	weight:SetScript("OnEnter", function(self) self:GetParent().MouseOverOverride:EnableMouse(false);  addon.ShowTooltip(self, "This Is a Note")  end)
			--	weight:SetScript("OnLeave", function(self) GameTooltip:Hide(); self:GetParent().MouseOverOverride:EnableMouse(true); end)
			weight:SetScript("OnMouseDown", function(self) addon.EditWeight(self, frame) end)
			weight:SetFrameLevel(15)
			frame.weight = weight
			frame.notes = notes
			--addon:Hook(frame, "UpdateMouseOverStateOnOption", function(self) C_Timer.After(0.2, mouseover(self)) end, true)
		end

		local spellID = frame.spellID
		if spellID  then 
			frame.weight.Text:SetText(Weights_Notesdb[spellID] and Weights_Notesdb[spellID].weight or "")
			frame.notes.Text:SetText(Weights_Notesdb[spellID] and Weights_Notesdb[spellID].note or "")
		end
	end
end