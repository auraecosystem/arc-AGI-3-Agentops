// Define global world settings
world
    fps = 30
    view = 6
    turf = /turf/floor

// Define basic environment turfs
turf
    floor
        icon = 'icons.dmi'
        icon_state = "floor"
    wall
        icon = 'icons.dmi'
        icon_state = "wall"
        density = 1 

// Define inventory items
obj
    item
        keycard
            name = "Security Keycard"
            icon = 'icons.dmi'
            icon_state = "keycard"
            verb/get()
                set category = "Interaction"
                set src in oview(1)
                src.loc = usr.contents
                usr << "You pick up the **[src]**."

    door
        name = "Security Door"
        icon = 'icons.dmi'
        icon_state = "door_locked"
        density = 1
        opacity = 1
        var/solved = 0

        verb/interact()
            set category = "Interaction"
            set src in oview(1)

            if(solved)
                src << "The door is already unlocked."
                return

            // Check if player has the keycard or solves the riddle
            var/obj/item/keycard/K = locate(/obj/item/keycard) in usr.contents
            if(K)
                solved = 1
                density = 0
                opacity = 0
                icon_state = "door_open"
                usr << "Access Granted! Your Security Keycard overrides the lock."
                view() << "[usr] swipes the keycard and opens the security door."
                return

            src << "A security screen flashes: 'Answer the riddle or present a keycard: What has keys but no locks?'"
            var/answer = input(src, "Enter the solution:", "Security Terminal", "") as text

            if(lowertext(answer) == "keyboard")
                solved = 1
                density = 0
                opacity = 0
                icon_state = "door_open"
                src << "Access Granted! The security lock disengages."
                view() << "[src] successfully solves the puzzle and opens the security door."
            else
                src << "Access Denied! Incorrect answer."

// Define entities (Player and Autonomous Enemy)
mob
    icon = 'icons.dmi'
    
    player
        icon_state = "player"
        var/hp = 100
        var/max_hp = 100
        var/attack_power = 15

        verb/check_status()
            set category = "Commands"
            src << "Your current HP is [hp]/[max_hp]."

        verb/attack(mob/M as mob in oview(1))
            set category = "Combat"
            if(M.hp <= 0)
                src << "[M] is already defeated!"
                return
            
            M.hp -= src.attack_power
            src << "You strike **[M]** for **[src.attack_power]** damage!"
            M << "**[src]** attacks you for **[src.attack_power]** damage! (Current HP: [M.hp]/[M.max_hp])"
            
            if(M.hp <= 0)
                M.hp = 0
                src << "You have defeated **[M]**!"
                M << "You have been knocked out!"

        Login()
            ..()
            src << "Welcome! Locate the keycard or solve the terminal puzzle to open the security door."

    enemy
        name = "Security Drone"
        icon_state = "drone"
        var/hp = 50
        var/max_hp = 50
        var/attack_power = 10

        New()
            ..()
            spawn() src.AI_Loop()

        proc/AI_Loop()
            while(src && src.hp > 0)
                sleep(30) // Wait 3 seconds per cycle
                var/mob/player/P = locate(/mob/player) in oview(src, 3)
                if(P)
                    step_towards(src, P)
                    if(get_dist(src, P) <= 1)
                        P.hp -= src.attack_power
                        view() << "**[src]** zaps **[P]** for **[src.attack_power]** damage! (HP: [P.hp])"
                        if(P.hp <= 0)
                            P.hp = 0
                            P << "You have been destroyed by the security drone!"
