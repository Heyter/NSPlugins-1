PLUGIN.name = "Civil Clearance Level"
PLUGIN.author = "Blank"
PLUGIN.desc = "Edits CID cards to contain a CCL (Civil Clearance Level). Also adds a scanner entity that will open doors if your CCL is high enough."

function PLUGIN:SchemaInitialized()
	local item = nut.item.Get("cid")

	if (!item) then return end

	item.functions = item.functions or {}
	item.functions.Apply = {
		text = "Apply",
		icon = "icon16/user_comment.png",
		run = function(itemTable, client, data, entity, index)
			client:ConCommand("say "..(data.Name or "no one")..", "..(data.Digits or "00000"))

			return false
		end
	}
end
