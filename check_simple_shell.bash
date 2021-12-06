#!/bin/bash
#
# Performing checks on the Holberton School "simple shell" project


#######################################
# Formating variables
# dont forget to use echo with -e to enable escape chars
# always end this variables with m, or use ";" to sepecify more then one before m
#######################################
# fonts
font_blue="\033[34m"
font_yellow="\033[33m"
font_red="\033[31m"
font_green="\033[32m"
font_cyan="\033[36m"

# background
back_blue="\033[44m"
back_yellow="\033[43m"
back_red="\033[41m"
back_green="\033[42m"
back_cyan="\033[46m"

# styles
st_none="\033[0m"
st_bold="\033[1m"
st_lowIntens="\033[2m"
st_underline="\033[4m"
st_blink="\033[5m"
st_reverse="\033[7m"
st_invisible="\033[8m"

# none
f_none="\033[0m"

#######################################
# Predifined formated structures for test outputs

# Top output title
pre_t="$font_cyan$st_bold---$font_yellow$st_bold"
post_t="$f_none$font_cyan$st_bold------------------------------------------------------------------------$f_none"


#######################################
# Print KO, in red, followed by a new line
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
function print_ko()
{
    ko="KO"
    echo -e "[$font_red$st_bold$ko$f_none]"
}

#######################################
# Print OK in green, followed by a new line
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
function print_ok()
{
    ok="OK"
    echo -e "[$font_green$st_bold$ok$f_none]"
}

#######################################
# Kill the shell in a clean way and remove temporary files
# Globals:
#   SHELL
#   OUTPUTFILE
#   ERROROUTPUTFILE
#   LTRACEOUTPUTFILE
# Arguments:
#   None
# Returns:
#   None
#######################################
function stop_shell()
{
    if [ `pidof $SHELL | wc -l` -ne 0 ]; then
	   killall -9 $SHELL 2>&1 > /dev/null
    fi
    rm -f $OUTPUTFILE $ERROROUTPUTFILE $LTRACEOUTPUTFILE
}

########################################
# Log Results if variable SHOWRESULTS is equal to 1
# Globals:
#   SHOWRESULTS
#
#
########################################
function log_results()
{
    tmp_file=$1
    OUTPUTFILE=$2
    LOGFILE=$3
    command=$4
    result=$5
    if [[ $SHOWRESULTS -eq 1 ]]; then
    	exp=`cat $tmp_file`
    	rec=`cat $OUTPUTFILE`
    	echo "Logging Results" >> $LOGFILE
    	if [[ $result -eq 0 ]]; then
            echo "<--PASSED-->" >> $LOGFILE
        else
            echo "<--FAILED-->" >> $LOGFILE
        fi
        echo "Date ------- $(date)" >> $LOGFILE
    	echo >> $LOGFILE
    	echo "Command executed: " >> $LOGFILE
    	echo "$command" >> $LOGFILE
    	echo >> $LOGFILE
    	echo "--- Expected Output -----------------" >> $LOGFILE
    	echo $exp >> $LOGFILE
    	echo >> $LOGFILE
    	echo >> $LOGFILE
    	echo "--- Received Output -----------------" >> $LOGFILE
    	echo $rec >> $LOGFILE
    	echo >> $LOGFILE
    fi
}


# Load configuration
source config

# counters

# reset errog log file
echo "RESULTS FROM LAST CHECK-RUN - EXPECTED VS RECEIVED OUTPUT" > $LOGFILE
echo >> $LOGFILE
echo >> $LOGFILE

# Cleanup
echo -ne "\033[37m"
rm -f $OUTPUTFILE $LTRACEOUTPUTFILE

# Locates all tests and launch them
for dir in `ls -d "$TESTDIR"/tests/*/`
do
    echo -e " $pre_t $font_yello $dir $post_t "
    if [[ $SHOWRESULTS -eq 1 ]]; then
        echo " === Test Directory >>> $dir ==================================" >> $LOGFILE
        echo >> $LOGFILE
    fi
    for testname in `ls "$dir" | grep -v "~$"`
    do
       if [[  $SHOWRESULTS -eq 1 ]]; then
        echo " === Test >> $testname ===================================== " >> $LOGFILE
        echo >> $LOGFILE
	   fi
       echo -n "   # $testname: "
	   source "$dir$testname"
    done
done

# Cleanup
rm -f $OUTPUTFILE $LTRACEOUTPUTFILE $ERROROUTPUTFILE
rm -f checker_output_*
rm -f checker_tmp_file_*
rm -f /tmp/.checker_tmp_file_*
echo -ne "\033[37m"
