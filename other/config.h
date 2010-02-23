/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>     // for multimedia keys

/* appearance */
#define BARPOS                  BarTop 
#define BORDERPX                1
#define FONT                    "Consolas:size=8:weight=bold:autohinting=true"
#define NORMBORDERCOLOR         "#313b3d"
#define NORMBGCOLOR             "#000000"
#define NORMFGCOLOR             "#cccccc"
#define SELBORDERCOLOR          "#0080bc"
#define SELBGCOLOR              "#000000"
#define SELFGCOLOR              "#0080bc"
#define URGFGCOLOR              "#ffff00"
#define URGBGCOLOR              "#ff0000"

#define BOTTOM_BAR_HEIGHT       15 // make room for conky!

/* tagging */
const char tags[][MAXTAGLEN] = { "web","cli","gui","null" };
Bool seltags[LENGTH(tags)] = {[1] = True};
Rule rules[] = {
  /* class:instance:title regex   tags regex                    isfloating */
  { "urxvt*",                     "cli",                        False },
  { "skype",                      "gui",                        True  },
  { "Acroread",                   "gui",                        False },
  { "feh",                        "gui",                        True  },
  { "Gran Paradiso:.*",           "web",                        False },
  { "Gran Paradiso:.*(Bookmarks|Downloads|Add-ons)","web|gui",  True  },
  { "Conky",                      NULL,                         True  },
  { "MPlayer",                    NULL,                         True  },
  { "vlc*",                       NULL,                         True  },
};


/* layout(s) */
#define MWFACT             0.6  /* master width factor [0.1 .. 0.9] */
#define RESIZEHINTS    False    /* False - respect size hints in tiled resizals */
#define SNAP           4        /* snap pixel */
#define NMASTER        1        /* number of windows in "master" area */

#include "ntile.c"
Layout layouts[] = {
  /* symbol   function */
  { "[H]",    nbtile },
  { "[V]",    ntile},
  { "[F]",    floating },
};

/* key definitions */
#define MODKEY      Mod4Mask
Key keys[] = {
  /* modifier                      key                        function         argument */
  { NULL,                          XF86XK_AudioMute,          spawn,           "exec dvol -t" }, 
  { NULL,                          XF86XK_AudioRaiseVolume,   spawn,           "exec dvol -i 5" }, 
  { NULL,                          XF86XK_AudioLowerVolume,   spawn,           "exec dvol -d 5" }, 
  { MODKEY,                        XK_b,                      togglebar,       NULL }, 
  { MODKEY,                        XK_j,                      focusnext,       NULL }, 
  { MODKEY,                        XK_k,                      focusprev,       NULL }, 
  { MODKEY,                        XK_h,                      setmwfact,       "-0.05" },
  { MODKEY,                        XK_l,                      setmwfact,       "+0.05" },
  { MODKEY,                        XK_m,                      togglemax,       NULL }, 
  { MODKEY,                        XK_p,                      spawn,           "exe=`dmenu_path | dmenu -fn '"FONT"' -nb '"NORMBGCOLOR"' -nf '"NORMFGCOLOR"' -sb '"SELBGCOLOR"' -sf '"SELFGCOLOR"'` && exec $exe" }, 
  { MODKEY,                        XK_0,                      view,            NULL },
  { MODKEY,                        XK_1,                      view,            tags[0] },
  { MODKEY,                        XK_2,                      view,            tags[1] },
  { MODKEY,                        XK_3,                      view,            tags[2] },
  { MODKEY,                        XK_4,                      view,            tags[3] },
  { MODKEY,                        XK_bracketleft,            spawn,           "exec sudo gov-tool --set powersave" },
  { MODKEY,                        XK_bracketright,           spawn,           "exec sudo gov-tool --set performance" },
  { MODKEY,                        XK_equal,                  spawn,           "exec sudo gov-tool --increase" },
  { MODKEY,                        XK_minus,                  spawn,           "exec sudo gov-tool --decrease" },
  { MODKEY,                        XK_Return,                 zoom,            NULL }, 
  { MODKEY,                        XK_space,                  setlayout,       NULL }, 
  { MODKEY,                        XK_Tab,                    focusnext,       NULL }, 
  { MODKEY|ShiftMask,              XK_c,                      killclient,      NULL },
  { MODKEY|ShiftMask,              XK_Tab,                    focusprev,       NULL }, 
  { MODKEY|ShiftMask,              XK_space,                  togglefloating,  NULL },
  { MODKEY|ShiftMask,              XK_equal,                  setnmaster,      "+1" },
  { MODKEY|ShiftMask,              XK_minus,                  setnmaster,      "-1" },
  { MODKEY|ShiftMask,              XK_0,                      tag,             NULL },
  { MODKEY|ShiftMask,              XK_1,                      tag,             tags[0] },
  { MODKEY|ShiftMask,              XK_2,                      tag,             tags[1] },
  { MODKEY|ShiftMask,              XK_3,                      tag,             tags[2] },
  { MODKEY|ShiftMask,              XK_4,                      tag,             tags[3] },
  { MODKEY|ControlMask,            XK_1,                      toggleview,      tags[0] },
  { MODKEY|ControlMask,            XK_2,                      toggleview,      tags[1] },
  { MODKEY|ControlMask,            XK_3,                      toggleview,      tags[2] },
  { MODKEY|ControlMask,            XK_4,                      toggleview,      tags[3] },
  { MODKEY|ControlMask|ShiftMask,  XK_q,                      quit,            NULL },
  { MODKEY|ControlMask|ShiftMask,  XK_1,                      toggletag,       tags[0] },
  { MODKEY|ControlMask|ShiftMask,  XK_2,                      toggletag,       tags[1] },
  { MODKEY|ControlMask|ShiftMask,  XK_3,                      toggletag,       tags[2] },
  { MODKEY|ControlMask|ShiftMask,  XK_4,                      toggletag,       tags[3] },
};
