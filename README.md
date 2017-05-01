Small tutorials & scripts that can be used as references for connecting usb 3g/4g modem, in OS linux such as Raspbian, Ubuntu and other Debian's variants.

## Pre-requisites:
* Ensure that `wvdial`, `ppp` & `usb-modeswitch` have been installed. Run `sudo apt-get install` command for installing them, if you have not done it before.

## How to connect to internet using the USB Modem
* Plug-in your USB Modem, wait for few seconds then run `lsusb` command. Notice the manufacturer of your modem is displayed within the list. Make note the vendor id : default product id code that appear before the manufacturer's name. E.g. `05c6:f000`
* Download & untar `usb-modeswitch-data` from this following url: http://www.draisberghof.de/usb_modeswitch/. Make note the path of folder where contains the extracted files.
* Clone this repository into your home folder.
* Copy the `mswitch.sh` & `4glte.sh` script files into the folder of untar-ed `usb-modeswitch-data` and ensure that the copied files can be executed (run `chmod 755` command against them, if they are not executable. ). To make it easier executing these scripts later, create links against them using `ln` command, e.g. `ln -s mswitch.sh mswitch`, `ln -s 4glte.sh 4glte`.
* Open the `mswitch.sh` file, changed the `USB_MODEM_VENDOR_ID` & `USB_MODEM_DEFAULT_PRODUCT_ID` entries with vendor ID & default product ID that you have noted in prior step. Save the changed file. Changed the `mswitch_path` variable with the location of untared `usb-modeswitch-data` directory.
* To ensure `4glte.sh` can be executed from anywhere in the machine, concatenate the location of copied script files with the current `$PATH` variable. You could do it by modifying `.profile` file inside your $HOME folder. Here is the example of the modified `.profile` file:

```bash
export USBMODEM=$HOME/usb_modeswitch_data
export PATH=$PATH:$USBMODEM
```

Save the `.profile` file and run this command to apply the changes `source .profile`
* Run `4glte` command to begin connecting to internet using the plugged in USB Modem.
* To disconnect the modem, run this command `4glte disconnect`.

## How to connect the modem when system boot
* Copy the `4glte` script inside cloned repository's `etc/init.d` folder, into your machine's `/etc/init.d` directory. 
* Ensure the copied `4glte` script is executable. Run `sudo chmod 755 /etc/init.d/4glte` command to ensure this.
* Open the copied `4glte` script as superuser & edit the entry which point to the directory location of where you put the `4glte.sh` file at. Save the changes.
* Run `sudo update-rc.d 4glte defaults` to register the script as a startup script.
* Run `sudo update-rc.d -f 4glte remove` if you want to de-register the script from being executed when the system boot.