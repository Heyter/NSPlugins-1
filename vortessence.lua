PLUGIN.name = "Vortessence"
PLUGIN.author = "Blank"
PLUGIN.desc = "Vortessence"

local words = {"ahglah", "ahhhr", "alla", "allu", "baah", "beh", "bim", "buu", "chaa", "chackt", "churr", "dan", "darr", "dee", "eeya", "ge", "ga", "gaharra",
"gaka", "galih", "gallalam", "gerr", "gog", "gram", "gu", "gunn", "gurrah", "ha", "hallam", "harra", "hen", "hi", "jah", "jurr", "kallah", "keh", "kih",
"kurr", "lalli", "llam", "lih", "ley", "lillmah", "lurh", "mah", "min", "nach", "nahh", "neh", "nohaa", "nuy", "raa", "ruhh", "rum", "saa", "seh", "sennah",
"shaa", "shuu", "surr", "taa", "tan", "tsah", "turr", "uhn", "ula", "vahh", "vech", "veh", "vin", "voo", "vouch", "vurr", "xkah", "xih", "zurr"}

nut.chat.Register("vortessence", {
	canHear = nut.config.chatRange,
	onChat = function(speaker, text)
		local vort = {}
		local split = string.Split(text, " ")

		for k, v in pairs(split) do 
			local string = table.Random(words)
			table.insert(vort, string)
		end

		local text = (LocalPlayer():Team() == FACTION_VORT) and text or table.concat(vort, " ")

		chat.AddText(Color(114, 175, 237), hook.Run("GetPlayerName", speaker, "ic", text)..": "..text)
	end,
	canSay = function(speaker)
		if (speaker:Team() != FACTION_VORT) then
			nut.util.Notify("You don't know Vortessence!", speaker)

			return false
		end

		return true
	end,
	prefix = {"/v", "/vortessence"}
})