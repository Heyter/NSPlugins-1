PLUGIN.name = "Miscellaneous Commands"
PLUGIN.author = "Blank"
PLUGIN.desc = "Adds commands."

nut.command.Register({
    superAdminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = nut.command.FindPlayer(client, arguments[1])

        if (IsValid(target)) then
            if (SERVER) then
                local data = {
                    Name = target.character.publicVars.charname,
                    Digits = target.character.privateVars.chardata.digits
                }

                if (target:Team() == FACTION_CITIZEN) then
                    nut.util.Notify("You can only give CID cards to citizen characters.", client)

                    return
                end

                target:UpdateInv("cid", 1, data, true)

                nut.util.Notify("You have given "..target:Name().." a new CID card.", client)
                nut.util.Notify("You have been granted a new CID card by"..client:Name()..".", target)
            end
        end
    end
}, "chargivecid")
    
nut.command.Register({
    superAdminOnly = true,
    allowDead = true,
    syntax = "<string name> <string faction>",
        onRun = function(client, arguments)
        local target = nut.command.FindPlayer(client, arguments[1])

        if (IsValid(target)) then
            if (!arguments[2]) then
                nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

                return
            end

            local faction

            for k, v in pairs(nut.faction.GetAll()) do
                if (nut.util.StringMatches(arguments[2], v.name)) then
                    faction = v

                    break
                end
            end

            if (faction) then
                if (!nut.faction.CanBe(target, faction.index)) then
                    nut.util.Notify(nut.lang.Get("not_whitelisted"), target)

                    return
                end

                target:SetTeam(faction.index)
                target.character:SetVar("faction", faction.index)

                nut.util.Notify(nut.lang.Get("whitelisted", client:Name(), target:Name(), faction.name))
            else
                nut.util.Notify(nut.lang.Get("invalid_faction"), client)
            end
        end
    end
}, "charsetfaction")

nut.command.Register({
    superAdminOnly = true,
    allowDead = true,
    syntax = "<string name>",
        onRun = function(client, arguments)
        local target = nut.command.FindPlayer(client, arguments[1])

        if (IsValid(target)) then  
            if (!arguments[2]) then
                nut.util.Notify(nut.lang.Get("missing_arg", 2), client)

                return
            end

            local arg = tonumber(arguments[2])
            local index

            for k, v in pairs(target.characters) do
                if (k == arg) then
                    index = v
                end
            end

            if (!index) then
                nut.util.Notify("That is not a valid character", client)

                return
            end

            local prevchar
            
            if (target.character and target.character.index == index) then
                nut.util.Notify("That player is already playing as that character.", client)
                
                return
            else
                prevchar = target.character
                nut.char.Save(target)
                nut.schema.Call("OnCharChanged", target)
            end

            nut.char.LoadID(target, index, function(sameChar)
                if (!sameChar) then
                    nut.schema.Call("PlayerLoadedChar", target)
                        target:Spawn()
                    nut.schema.Call("PostPlayerSpawn", target)

                    nut.util.Notify("You forced "..prevchar.publicVars.charname.." to play as "..target.character.publicVars.charname, client)
                end
            end)        
        end
    end
}, "plyforcechar")
