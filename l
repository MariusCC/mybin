#!/bin/sh

# An enhanced ls -l

# <!--Exclude from bashfeed-->

# Author:
#    http://www.pixelbeat.org/
# Notes:
#    A symlink target may loose info as there are no mode bits to highlight
# Changes:
#    V0.1, 18 Sep 2009, Initial release
#    V0.2, 30 Sep 2009, Correctly strip "total" line for all locales
#                       Modify colors even when dircolors doesn't support $TERM
#                       Don't error for ls without --group-dir or --no-group

# apply thousands separator to file sizes
export BLOCK_SIZE=\'1

# traditional unix time format with abbreviated month translated from locale
# en_* locales default to ISO format without this for reasons discussed here:
# http://lists.gnu.org/archive/html/bug-coreutils/2009-09/msg00433.html
export TIME_STYLE='+%b %e  %Y
%b %e %H:%M'

# Add a fancy symlink arrow
if echo "$LANG" | grep -Ei "utf-?8$" >/dev/null; then
  SYM_ARROW="▪▶"
else
  SYM_ARROW="->"
fi

# Don't enable highlighting if not outputting to terminal
if test -t 1 || echo "$*" | grep -E -- "--color( |=always|$)" >/dev/null; then
  # Note if the user specifies --color=auto then that will override this
  # and hence the output will not be colored :(
  color_when=always
  BLD=$(tput bold)
  RST=$(tput sgr0)
  HLI=$(tput smso)
  LS_HLI=$(echo "$HLI" | sed 's/\x1b\[\(.*\)m/\1/')
else
  color_when=auto
fi

# modify the coreutils default colors if distro or user colors not set
[ "$LS_COLORS" ] || eval $(dircolors)
# xterm-256color not supported by older dircolors for example
[ "$LS_COLORS" ] || eval $(TERM=xterm dircolors)

# Turn off the confusing entries with different backgrounds
# as we'll highlight the mode bits and hardlink count instead.
#
# Also turn off capability colouring even though we don't
# highlight anything in lieu of it, as this will short circuit
# the slow capability checks within ls
#
# Also we reset the dangling symlink color to "highlight"
# as it defaults to blinking.  We could do all this in ~/.dir_colors
# but so this script is more general, we do it here.
eval $(
  echo "export LS_COLORS='$LS_COLORS'" |

  sed "
    s/hl[^:]*:/hl=:/
    s/mh[^:]*:/mh=:/
    s/su[^:]*:/su=:/
    s/sg[^:]*:/sg=:/
    s/ow[^:]*:/ow=:/
    s/st[^:]*:/st=:/
    s/tw[^:]*:/tw=:/

    s/ca[^:]*:/ca=:/

    s/mi=[^:]\{1,\}:/mi=$LS_HLI:/
  "
)

# Get locale total string to match on
total=$(ls -s --color=never / | sed 's/\([^ ]*\).*/\1/;q')

# Use these options if available
ls --group-directories-first -d . >/dev/null 2>&1 && gdf=--group-directories
ls --no-group -d . >/dev/null 2>&1 && ng=--no-group

# Start with the standard long format listing
# with colours, and latest files at bottom
ls -lrt --color=$color_when $ng $gdf "$@" |

# process with sed to...
sed "
  # Remove total line I never use
  /$total [0-9,. ]\{1,\}$/d

  # prettify symlink arrows
  s/ -> / $BLD$SYM_ARROW$RST /

  # highlight ug+s indicators
  s/^\(.\{3\}\)\([sS]\)/\1$HLI\2$RST/
  s/^\(.\{6\}\)\([sS]\)/\1$HLI\2$RST/

  # highlight +t o+w indicators for directories
  /^d/!b not_dir_bit;
  s/^\(.\{9\}\)\([tT]\)/\1$HLI\2$RST/
  s/^\(.\{8\}\)w/\1${HLI}w$RST/
  s/^\(.\{3\}\)\([sS]\)/\1$HLI\2$RST/
  s/^\(.\{6\}\)\([sS]\)/\1$HLI\2$RST/
  :not_dir_bit

  # highlight multiply linked files
  /^d/b not_hl; /^[^d][^ ]* *1 /b not_hl;
  s/^\([^ ]*\)\( *\)\([0-9]\{1,\}\)/\1\2$HLI\3$RST/
  :not_hl
"
