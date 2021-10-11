--///////////////////////////////////////////////////////////////////////////////////////////
--
-- 
--Author: SLOKnightfall

--

--

--///////////////////////////////////////////////////////////////////////////////////////////

local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local tempTable = {}

function addon:AutoSelect()
	if not PlayerChoiceFrame then return end

	if not PlayerChoiceFrame:IsShown() then
		return false

	else
		local data = C_PlayerChoice.GetCurrentPlayerChoiceInfo()
		local message_text = ""
		if data then
			tempTable = tempTable and wipe(tempTable) or {}
			for i, choice in pairs(data.options) do
				local button = choice.buttons[1].id
				local colour = choice.rarityColor:GenerateHexColor()
				local t = {button = button, rarity = colour, spellID = choice.spellID, description = choice.description, index = i}
				tempTable[choice.spellID] = t
				tempTable[choice.header] = t
			end
			
			for i, spell in ipairs(addon.FavoritePowerdb.profile.favorites) do
				if tempTable[spell] then
					local spellDetails = tempTable[spell]
					local spellID = spellDetails.spellID

					-- if in combat then flash the button, if not, select it. 
					if addon.db.profile.AutoSelect and not InCombatLockdown()then
						if addon.db.profile.ShowSelectMessage then
							message_text = (L["|c%s[%s] auto-selected"]):format(spellDetails.rarity or "ffffffff", (GetSpellInfo(spellID)))
							UIErrorsFrame:AddMessage(message_text, 1, 1, 1, 41, 5);
						end

						C_PlayerChoice.SendPlayerChoiceResponse(spellDetails.button)
						HideUIPanel(PlayerChoiceFrame)
						return true
					else
						
						if addon.db.profile.ShowSelectMessage then
							message_text = (L["Click |c%s[%s]"]):format(spellDetails.rarity or "ffffffff", (GetSpellInfo(spellID)))
							UIErrorsFrame:AddMessage(message_text, 1, 1, 1, 41, 5);
						end
						--flash
						local optionFrames = PlayerChoiceFrame:GetLayoutChildren()
						local flashFrame = optionFrames[spellDetails.index]
						if flashFrame then
							UIFrameFlash(flashFrame, 0.2,0.2,1,true,0,0,nil)
						end

						return true
					end
				end
			end

			if addon.db.profile.ShowSelectMessage then

				-- nothing matched, flag for manual
				message_text = L["No priority Powers Available"],
				UIErrorsFrame:AddMessage(message_text, 1, 1, 1, 41, 5);
			end
			return true
		end
	end
end

