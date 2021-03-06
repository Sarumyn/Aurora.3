/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["lastchangelog"]    >> pref.lastchangelog
	S["default_slot"]     >> pref.default_slot
	S["toggles"]          >> pref.toggles
	S["asfx_togs"]        >> pref.asfx_togs
	S["motd_hash"]        >> pref.motd_hash
	S["memo_hash"]        >> pref.memo_hash
	S["parallax_speed"]   >> pref.parallax_speed
	S["parallax_toggles"] >> pref.parallax_togs

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["lastchangelog"]    << pref.lastchangelog
	S["default_slot"]     << pref.default_slot
	S["toggles"]          << pref.toggles
	S["asfx_togs"]        << pref.asfx_togs
	S["motd_hash"]        << pref.motd_hash
	S["memo_hash"]        << pref.memo_hash
	S["parallax_speed"]   << pref.parallax_speed
	S["parallax_toggles"] << pref.parallax_togs

/datum/category_item/player_setup_item/player_global/settings/gather_load_query()
	return list(
		"ss13_player_preferences" = list(
			"vars" = list(
				"lastchangelog",
				"current_character",
				"toggles",
				"asfx_togs",
				"lastmotd" = "motd_hash",
				"lastmemo" = "memo_hash"
			), 
			"args" = list("ckey")
		)
	)

/datum/category_item/player_setup_item/player_global/settings/gather_load_parameters()
	return list("ckey" = pref.client.ckey)

/datum/category_item/player_setup_item/player_global/settings/gather_save_query()
	return list(
		"ss13_player_preferences" = list(
			"lastchangelog",
			"current_character",
			"toggles",
			"asfx_togs",
			"lastmotd",
			"lastmemo",
			"ckey" = 1,
			"parallax_toggles",
			"parallax_speed"
		)
	)

/datum/category_item/player_setup_item/player_global/settings/gather_save_parameters()
	return list(
		"ckey" = pref.client.ckey,
		"lastchangelog" = pref.lastchangelog,
		"current_character" = pref.current_character,
		"toggles" = pref.toggles,
		"asfx_togs" = pref.asfx_togs,
		"lastmotd" = pref.motd_hash,
		"lastmemo" = pref.memo_hash,
		"parallax_toggles" = pref.parallax_togs,
		"parallax_speed" = pref.parallax_speed
	)

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences(var/sql_load = 0)
	if (sql_load)
		pref.current_character = text2num(pref.current_character)

	pref.lastchangelog  = sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.default_slot   = sanitize_integer(text2num(pref.default_slot), 1, config.character_slots, initial(pref.default_slot))
	pref.toggles        = sanitize_integer(text2num(pref.toggles), 0, 65535, initial(pref.toggles))
	pref.asfx_togs      = sanitize_integer(text2num(pref.asfx_togs), 0, 65535, initial(pref.toggles))
	pref.motd_hash      = sanitize_text(pref.motd_hash, initial(pref.motd_hash))
	pref.memo_hash      = sanitize_text(pref.memo_hash, initial(pref.memo_hash))
	pref.parallax_speed = sanitize_integer(text2num(pref.parallax_speed), 1, 10, initial(pref.parallax_speed))
	pref.parallax_togs  = sanitize_integer(text2num(pref.parallax_togs), 0, 65535, initial(pref.parallax_togs))

/datum/category_item/player_setup_item/player_global/settings/content(mob/user)
	var/list/dat = list(
		"<b>Play admin midis:</b> <a href='?src=\ref[src];toggle=[SOUND_MIDI]'><b>[(pref.toggles & SOUND_MIDI) ? "Yes" : "No"]</b></a><br>",
		"<b>Play lobby music:</b> <a href='?src=\ref[src];toggle=[SOUND_LOBBY]'><b>[(pref.toggles & SOUND_LOBBY) ? "Yes" : "No"]</b></a><br>",
		"<b>Ghost ears:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTEARS]'><b>[(pref.toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a><br>",
		"<b>Ghost sight:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTSIGHT]'><b>[(pref.toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a><br>",
		"<b>Ghost radio:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTRADIO]'><b>[(pref.toggles & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a><br>",
		"<b>Space Parallax:</b> <a href='?src=\ref[src];paratoggle=[PARALLAX_SPACE]'><b>[(pref.parallax_togs & PARALLAX_SPACE) ? "Yes" : "No"]</b></a><br>",
		"<b>Space Dust:</b> <a href='?src=\ref[src];paratoggle=[PARALLAX_DUST]'><b>[(pref.parallax_togs & PARALLAX_DUST) ? "Yes" : "No"]</b></a><br>",
		"<b>Progress Bars:</b> <a href='?src=\ref[src];paratoggle=[PROGRESS_BARS]'><b>[(pref.parallax_togs & PROGRESS_BARS) ? "Yes" : "No"]</b></a><br>",
		"<b>Static Space:</b> <a href='?src=\ref[src];paratoggle=[PARALLAX_IS_STATIC]'><b>[(pref.parallax_togs & PARALLAX_IS_STATIC) ? "Yes" : "No"]</b></a><br>"
	)

	. = dat.Join()

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["toggle"])
		var/toggle_flag = text2num(href_list["toggle"])
		pref.toggles ^= toggle_flag
		if(toggle_flag == SOUND_LOBBY && isnewplayer(user))
			if(pref.toggles & SOUND_LOBBY)
				user << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
			else
				user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)
		return TOPIC_REFRESH

	if(href_list["paratoggle"])
		var/flag = text2num(href_list["paratoggle"])
		pref.parallax_togs ^= flag
		return TOPIC_REFRESH

	return ..()
