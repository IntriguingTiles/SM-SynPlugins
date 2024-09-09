# SM-SynPlugins

A collection of SourceMod plugins for Synergy focused on making server administration much easier. Some of them are generic enough to be used with other games.

These are intended for use with the `development` beta branch of Synergy but most of them should work for older versions too.

Currently, upstream SourceMod and Metamod:Source do not properly support the Synergy's slightly strange `development` binaries, so you will need to patch both projects in order for them to fully load Synergy's binaries.

You will also need to change SourceMod's hardcoded maxplayer define to `129` if you intend to run a server with >100 maxplayers.

## Plugins

| Plugin              | Description                                                                                                                               |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `antinoclip`        | An attempt to mitigate strange issues relating to players gaining noclip under certain conditions. Obsolete but kept around just in case. |
| `antitroll`         | Aims to prevent players from disrupting the game. Currently restricts usage of `impulse 50` (squad control) and the EP2 jalopy to admins. |
| `npc_utils`         | Teleporting and spawning NPCs. Can teleport the jalopy too.                                                                               |
| `pmute`             | Automatically mutes previously muted players on level change and rejoin.                                                                  |
| `sm_crane_driver`   | Tells you the name of the crane driver. Useful if the crane driver doesn't want to do their job.                                          |
| `sm_ent_create`     | Reimplementation of Source's `ent_create`.                                                                                                |
| `sm_ent_fire`       | Partial reimplementation of Source's `ent_fire`. Does not support passing arguments to inputs.                                            |
| `sm_ent_remove_all` | Partial reimplementation of Source's `ent_remove_all`. Does not support removing by targetname.                                           |
| `sm_equip`          | An attempt to work around a bug with certain maps spawning players with no weapons. Should be obsolete.                                   |
| `sm_givecamera`     | Switches the player controlling a shared camera to you.                                                                                   |
| `sm_goto`           | Teleports you to the specified player.                                                                                                    |
| `sm_respawn`        | Respawns either yourself or the specified player(s).                                                                                      |
| `sm_tele`           | Teleports the specified player(s) to you.                                                                                                 |
| `sm_telecoords`     | Teleports the specified player(s) to the specified coordinates.                                                                           |