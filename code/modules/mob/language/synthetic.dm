/datum/language/binary
	name = LANGUAGE_ROBOT
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = list("states")
	ask_verb = list("queries")
	exclaim_verb = list("declares")
	key = "b"
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	message = formalize_text(message)

	log_say("[key_name(speaker)] : ([name]) [message]",ckey=key_name(speaker))

	var/message_start = "<span style='font-size: [speaker.get_binary_font_size()];'><i><span class='game say'>[name], <span class='name'>[speaker.real_name]</span>"
	var/message_body = "<span class='message'>[speaker.say_quote(message)], \"[message]\"</span></span></i></span>"

	for (var/mob/M in dead_mob_list)
		if(!istype(M,/mob/abstract/new_player) && !istype(M,/mob/living/carbon/brain)) //No meta-evesdropping
			M.show_message("[ghost_follow_link(speaker, M)] [message_start] [message_body]", 2)

	for (var/mob/living/S in living_mob_list)

		if(drone_only && !istype(S,/mob/living/silicon/robot/drone))
			continue
		else if(istype(S , /mob/living/silicon/ai))
			message_start = "<i><span class='game say'>[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'><span class='name'>[speaker.real_name]</span></a></span></i>"
		else if (!S.binarycheck())
			continue

		S.show_message("[message_start] [message_body]", 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(istype(M, /mob/living/silicon) || M.binarycheck())
			continue
		M.show_message("<i><span class='game say'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>",2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = LANGUAGE_DRONE
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = list("transmits")
	ask_verb = list("transmits")
	exclaim_verb = list("transmits")
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = 1

/mob/living/proc/get_binary_font_size()
	return "1em"

/mob/living/silicon/robot/drone/construction/matriarch/get_binary_font_size()
	return "1.2em"