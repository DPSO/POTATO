#define LINE_BREAK toString[13,10]
#define INDENT "    "
#define CFG_FOOTER "};" + LINE_BREAK + LINE_BREAK
#define CFG_CLASS_DATA(dataName, data) INDENT + INDENT + dataName + " = " + data + ";" + LINE_BREAK

#define AI_AUDIBLE_FIRE_0 100   // regular ammo
#define AI_AUDIBLE_FIRE_1 10    // subsonic ammo
#define AI_AUDIBLE_FIRE_2 200   // vehicle ammo (30mm autocannon, hellfire, etc)
#define AI_AUDIBLE_FIRE_3 50    // Grenade Launchers (40mm UGL, VOG25, etc)

/*
audibleFire = AI_AUDIBLE_FIRE_0;
        GVAR(macroUsed) = "AI_AUDIBLE_FIRE_0";
*/

