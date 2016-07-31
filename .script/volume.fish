amixer sget Master | gawk '/%/ {gsub(/[\[\]%]/, "", $5); volume = $5} END { if ($6 == "[off]") print "  Muted"
									   else if ($6 == "[on]") if (volume > 35) print " " volume "%"
												  else print "  " volume "%"}'
