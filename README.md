# SM-SynPlugins

A collection of SourceMod plugins for Synergy focused on making server administration much easier. Some of them are generic enough to be used with other games.

These are intended for use with the `development` beta branch of Synergy but most of them should work for older versions too.

Currently, upstream SourceMod and Metamod:Source do not properly support Synergy's slightly strange `development` binaries, so you will need to patch both projects in order for them to interact with Synergy's binaries without crashing.

You will also need to change SourceMod's hardcoded maxplayer define to `129` if you intend to run a server with >100 maxplayers.

## Plugins

| Plugin                      | Description                                                                                                                               |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `antinoclip`                | [OBSOLETE] An attempt to mitigate strange issues relating to players gaining noclip under certain conditions.                             |
| `antitroll`                 | Aims to prevent players from disrupting the game. Currently restricts usage of `impulse 50` (squad control) and the EP2 jalopy to admins. |
| `disable_d3_c17_10b_lasers` | Automatically disables the laser puzzle in d3_17_10b.                                                                                     |
| `early_reservedslots`       | Runs the reserve type 0 logic as soon as possible in the connection process. Requires `reservedslots.smx`.                                |
| `invincible_striders`       | Makes striders invincible on d3_c17_13 and ep1_c17_06 until an admin runs `sm_enable_strider_dmg`.                                        |
| `npc_utils`                 | Teleporting and spawning NPCs (plus the jalopy).                                                                                          |
| `outland_02`                | Provides a way to force ep2_outland_02 to act as if you have returned from ep2_outland_04.                                                |
| `pmute`                     | Automatically mutes previously muted players on level change and rejoin.                                                                  |
| `sm_crane_driver`           | Tells you the name of the crane driver. Useful if the crane driver doesn't want to do their job.                                          |
| `sm_ent_create`             | Reimplementation of Source's `ent_create`.                                                                                                |
| `sm_ent_fire`               | Reimplementation of Source's `ent_fire`.                                                                                                  |
| `sm_ent_remove_all`         | Partial reimplementation of Source's `ent_remove_all`. Does not support removing by targetname.                                           |
| `sm_equip`                  | [OBSOLETE] An attempt to work around a bug with certain maps spawning players with no weapons.                                            |
| `sm_givecamera`             | Switches the player controlling a shared camera to you.                                                                                   |
| `sm_goto`                   | Teleports you to the specified player.                                                                                                    |
| `sm_respawn`                | Respawns either yourself or the specified player(s).                                                                                      |
| `sm_tele`                   | Teleports the specified player(s) to you.                                                                                                 |
| `sm_telecoords`             | Teleports the specified player(s) to the specified coordinates.                                                                           |
| `sm_wholook`                | Tells you the name of the player you're looking at.                                                                                       |