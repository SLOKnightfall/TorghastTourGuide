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


do
	local function GetUnitId()
		local _, unit = GameTooltip:GetUnit()
		if unit then
			local guid = UnitGUID(unit)
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
		local profile = addon.db.profile
		local unitID = GetUnitId()
		if not unitID then return end

		if (cellCounts[1] > 0  and profile.ShowRavenousTooltips) or (profile.ShowRavenousTooltips and profile.ShowRavenousTooltips_Always) then 
			local mobPowerInfo = addon.mobs[unitID]

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

		if profile.ShowRareTooltips then 
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
end