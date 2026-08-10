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
        density = 1 // Prevents entities from walking through

// Define an interactive puzzle object (Locked Security Door)
obj
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

            // Prompt the player with a puzzle riddle
            src << "A security screen flashes: 'Answer the riddle to unlock the path: What has keys but no locks?'"
            var/answer = input(src, "Enter the solution:", "Security Terminal", "") as text

            // Check the player's input
            if(lowertext(answer) == "keyboard")
                solved = 1
                density = 0
                opacity = 0
                icon_state = "door_open"
                src << "Access Granted! The security lock disengages."
                view() << "[src] successfully solves the puzzle and opens the security door."
            else
                src << "Access Denied! Incorrect answer."

// Define the player mob and attributes
mob
    icon = 'icons.dmi'
    icon_state = "player"
    
    var/hp = 100
    var/max_hp = 100
    var/attack_power = 15

    // Custom status check command
    verb/check_status()
        set category = "Commands"
        set desc = "Displays your current health status."
        src << "Your current HP is [hp]/[max_hp]."

    // Combat verb to attack adjacent targets
    verb/attack(mob/M as mob in oview(1))
        set category = "Combat"
        set desc = "Attack an adjacent target."
        
        if(M.hp <= 0)
            src << "[M] is already defeated!"
            return
        
        // Apply damage
        M.hp -= src.attack_power
        src << "You strike **[M]** for **[src.attack_power]** damage!"
        M << "**[src]** attacks you for **[src.attack_power]** damage! (Current HP: [M.hp]/[M.max_hp])"
        
        // Check for defeat
        if(M.hp <= 0)
            M.hp = 0
            src << "You have defeated **[M]**!"
            M << "You have been knocked out!"

    // Automatically called when a player logs in
    Login()
        ..()
        src << "Welcome to the world! Find the security door, interact with it, and solve the puzzle to proceed."
