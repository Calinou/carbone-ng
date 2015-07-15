
Extended Ban Mod for Minetest
-----------------------------

This mod registers all the IPs used by individual players, and can ban the
player when using any of them, even if he is not online at the moment.

License
-------

See file 'LICENSE.txt'.

Chat Commands
-------------

/xban <player> [<reason>]
  Ban given player and all his IPs. If reason not given, it defaults to
  "because random". If player is online at the moment, he/she is shown it. If
  user is not online, it saves it in a list, and next time he connects from any
  IP, or connects from a banned IP with different name, it gets banned again,
  and new IP/username recorded.

/xtempban <player> <time> [<reason>]
  Same as /xban, except it specifies a temporary ban.
  <time> must be prefixed by a colon (':'), and can be in any of the
  following formats:
    123m       - Ban for 123 minutes.
    12h        - Ban for 12 hours.
    1d         - Ban for 1 day.
    1W         - Ban for 1 week.
    1M         - Ban for 1 month (30 days).
  If not specified, the ban is permanent and must be manually removed.

/xunban <player>
  Unban given player and all his IPs.

Configuration
-------------

The following options can be used to change the behavior of `xban'. They
must be set in your server's `minetest.conf'.

xban.kick_guests = <bool>
  Whether to kick "Guest" users (automatically generated player names).
  Default is false.

xban.ban_message = <string>
  The default ban message when not specified.
  Default is "Because random.".

xban.guest_kick_message = <string>
  Message sent before kicking guests. Not applicable if the option
  `xban.kick_guests' is false.
  Default is "Guest accounts are not allowed. Please choose a proper name.".

API
---

Other mods can make use of xban functionality if desired. You just need
to (opt)depend on xban.

xban.ban_player(name, time, reason)

  Bans a given player <name> for <time> seconds with specified <reason>.
  If <time> is nil, it acts as a permanent ban.
  If <reason> is nil, the default reason "because random" is used.

xban.unban_player(name)
  --> (true) or (nil, error)

  Removes a player from the ban list.
  Returns true on success, or nil plus error message on error.

xban.find_entry(name_or_ip)
  --> (entry, index) or (nil)

  Returns the database entry for the given player or IP. Please note that a
  single entry is shared by several IPs and several user names at the same
  time. See below for the format of entries. Also note that the table is not
  copied, so modifications will be saved to disk.

xban.entries

  This is the list of entries in the database. See below for format.

Files
-----

This mod only modifies a single file named 'players.iplist.v2' in the world
directory (and indirectly, 'ipban.txt'). The format is a serialized Lua table.

Each item in the table is in the following format:

{
  names = {
    ["foo"] = true,             -- To ban by name.
    ["123.45.67.89"] = true,    -- To ban by IP.
    ...
  },
  banned = "Because random.",   -- If nil, user is not banned.
  expires = 123456,             -- In time_t. If nil, user is permabanned.
  privs = { ... },              -- Player privileges before the ban.
  record = {                    -- Record of previous bans.
    {
      date = 123456,            -- Date when the ban was issued.
      time = 4123,              -- Ban time. This is nil if permabanned.
      reason = "asdf",          -- Duh.
    },
    ...
  },
}

The old `players.iplist' DB format is still read at startup, and converted
to the new format. In this case, `banned' is set to the default ban reason,
and `expires' is unset.
