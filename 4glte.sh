#!/bin/bash

# Constants
connected_info_msg="[INFO] The 4glte modem is connected to internet, now."
connect_fail_error_msg="[ERROR] The 4glte modem is unable connecting to internet."
already_connected_info_msg="[INFO] The 4glte modem is already connected to internet."
is_not_connected_info_msg="[INFO] The 4glte modem is not connected to internet."

wait_until_connected=3
usb_modeswitch_wait=5

# define the path of `mswitch.sh` script file
# Adjust it if necessary
mswitch_path=/home/pi/usb-modeswitch-data

# A helper method to connect 4glte USB Modem to internet.
function connect() {
   echo "[INFO] Try switching the USB 4glte Modem to be in Modem mode."
   $mswitch_path/mswitch.sh
   sleep $usb_modeswitch_wait
   echo "[INFO] Connecting to internet through the 4glte Modem now ..."
   sudo wvdial &	
}

# A helper method to determine whether 'wvdial' process is running or not
function check_wvdial_running_status() {
   pgrep -x "wvdial" > /dev/null
   wvdial_running_status=$?
}

# A helper method to disconnect the connected modem
function disconnect() {
   sudo killall wvdial
   sleep 2
   trap exit INT
}

# The main entry
arg=$1

check_wvdial_running_status
# echo "[DEBUG] \$wvdial_running_status = $wvdial_running_status"
# echo "[DEBUG] arg(s) = $arg"

# Do we have 'disconnect` arg ?
if [ "$arg" = "disconnect" ];
then  
   check_wvdial_running_status
   if [ $wvdial_running_status -eq 0 ];
   then 
      # Disconnect current active connection
      disconnect
   else
      echo $is_not_connected_info_msg
   fi
   exit 0
fi

# No 'disconnect' arg. So, we will connect the modem
if [ $wvdial_running_status -eq 1 ];
then
   connect
   sleep $wait_until_connected
   check_wvdial_running_status
   if [ $wvdial_running_status -eq 0 ] ; 
   then
	  echo $connected_info_msg
	  trap exit INT
   else
      echo $connect_fail_error_msg
   fi
else
   echo $already_connected_info_msg
fi
