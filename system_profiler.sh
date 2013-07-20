#!/bin/bash

_HOST=host.list

function run_system_profiler()
{
	local _user="$(echo $1 | cut -d@ -f1 | cut -d: -f1)"
	local _pass="$(echo $1 | cut -d: -f2 | cut -d@ -f1)"
	local _host="$(echo $1 | cut -d@ -f2)"
	local _outf="$_host.profile"
	
	echo ssh -q "$_user@$_host" -t system_profiler \> $_outf
}

case $1 in
	--help|-h|?|help|'')
		echo Help instructions here:
		echo ${0##/*/} [file...]
		echo ${0##/*/} [user:pass@host...]
		echo
		;;
	*)
		for i do
			case $i in
				*:*@*|*@*)
					run_system_profiler $i
					;;
				*)
					if test -f $i
					then
						cat $i | while read line
						do
							echo $line
							run_system_profiler $line
						done
					else
						_error $i is not valid file type
					fi
					;;
			esac
		done
		;;
esac
