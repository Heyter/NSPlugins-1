PLUGIN.name = "Roll Gain"
PLUGIN.author = "Blank"
PLUGIN.desc = "Boosts your rolls depending on your faction, class and equiped weapon."

local GAINS_CP = {
	{"05",5},
	{"04",5},
	{"03",10},
	{"02",20},
	{"01",10},
	{"OfC",15},
	{"EpU",20},
	{"DvL",25},
	{"CmD",25},
	{"SeC",25}
}

local GAINS_OW = {
	{"OWS",25},
	{"SGS",30},
	{"EOW",35}
}

local GAINS_WEP = {
	{"nut_stunstick",5},
	{"weapon_crowbar",10},
	{"weapon_pistol",15},
	{"weapon_357",20},
	{"weapon_smg1",25},
	{"weapon_shotgun",30},
	{"weapon_crossbow",30},
	{"weapon_ar2",35}
}

nut.command.Register({
	onRun = function(client, arguments)
		local weapon = client:GetActiveWeapon():GetClass()
		local faction = client:Team()
		local roll_max = 100
		local gain = 0

		-- Checks to see if the client faction is MPF, if it is then move onto the next line.
		if (faction == FACTION_CP) then
			for k,v in pairs(GAINS_CP) do
				if (client:IsCombineRank(v[1])) then
					roll_max = roll_max + v[2]
					break
		  		end	
			end
		end

		-- If clients faction is OTA then give him one of these gains.
		if (faction == FACTION_OW) then
			for k,v in pairs(GAINS_OW) do
				if (client:IsCombineRank(v[1])) then
					roll_max = roll_max + v[2]
					break
		  		end	
			end
		end

		-- If clients faction is CWU then give him gain of 5.
		if (faction == FACTION_UNCE) then
			roll_max = roll_max + 5	
		end

		-- This should be pretty self explanatory if you followed the rest. This adds a gain based on the weapon EQUIPPED.
		for k,v in pairs(GAINS_WEP) do
			if (weapon == v[1]) then
				gain = gain + v[2]
				break
	  		end	
		end

		-- Again hopefully pretty self explanatory. Based on your attributes what gain you would get.
		if client:GetAttrib(ATTRIB_STR, 0) >= 20 then
			gain = gain + 10
		end
		
		if client:GetAttrib(ATTRIB_ACR, 0) >= 20 then
			gain = gain + 5
		end

		if client:GetAttrib(ATTRIB_SPD, 0) >= 20 then
			gain = gain + 5
		end

		if client:GetAttrib(ATTRIB_END, 0) >= 20 then
			gain = gain + 5
		end

		math.randomseed(CurTime())

		local base = math.random(0, roll_max)
		local roll = base + gain

		-- Makes sure the roll doesn't go over 100
		if roll > roll_max then
			roll = roll_max
		end

		-- Notifys the client of the roll and their gain.
		nut.chat.Send(client, "roll", client:Name().." has rolled "..roll.." out of "..roll_max.." with a gain of "..gain.." for a total of "..(roll + gain <= roll_max and roll + gain or roll_max)..".")
	end
}, "roll")


