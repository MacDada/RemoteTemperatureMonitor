RemoteTemperatureMonitor
===

General notes
---

* One esp8266 to handle multiple thermometers

ESP8266 device options
---

### "Simple"

* chip
	* [16,99 + 7 = 23,99 zł](http://allegro.pl/modul-sieciowy-wifi-esp8266-sterowanie-rs232-at-i5506834559.html)

### Devkit

* devkit
	* [29,99 + 7 = 36,99](http://allegro.pl/modul-wifi-esp8266-nodemcu-v3-arduino-cp2102-i6646289495.html)
* usb charger
	* [2,49 + 4,5 = 6,99](http://allegro.pl/ladowarka-zasilacz-usb-do-mp3-mp4-iphone-telefonu-i6571311314.html)

### Common

* green led beam: everything is working fine
* green led flash: "working" (transmitting data)
* red led flash: a problem (with getting temperature, transmitting data, or whatever)
* ~~on/off button~~ not needed (?), just unplug and plug the power supply
* a few thermometers (ds18b20)
* some way to plug the thermometers (it should be easy to do that)
* buzzer for error sound
* button to turn off sound error


Todo
---

* inputting wifi credentials
	* by usb connection and code upload
	* by some built–in interface
	* by some connectable interface
* replace `net` module with `http` (make new flash with it):
  https://nodemcu.readthedocs.io/en/master/en/modules/http/
* audio? https://nodemcu.readthedocs.io/en/master/en/modules/pcm/
* `SSL support, TLS 1.1 with 4 cipher suites`?
  https://nodemcu-build.com/
* switch to integer flash version?
* `nodemcu-uploader` to upload files? 
  https://github.com/kmpm/nodemcu-uploader/blob/master/doc/USAGE.md
* `luatool` to upload files?
  https://github.com/4refr0nt/luatool
* use `master` version of flash, when new version is published (~ december 2016)
* multiple thermometers
    * solder a third thermometer to nodemcu
    * update `thermometer.lua` to handle multiple thermometers
    * update Fritzing project
* ~~decide if to use parasite mode for ds18b20~~ yep, parasite
* plan how many thermometers would be with how many esp8266 chips
* make a decision on final esp8266 chip
* make plan for monitoring system
	* one to put on place and one to use remotely
    * lcd
    * green led – everything is fine
    * red blinking led – something is wrong
    * sound alaram when something is wrong
    * any button disables sound alarm
    * button to switch between thermometers
    * lcd shows thermometer name, its temperature and alarm temperature


Flash
---

* https://nodemcu.readthedocs.io/en/latest/en/flash/
* Built using https://nodemcu-build.com/
* Built against the ~~master~~ `dev` branch and includes the following modules: 
  `file, gpio, net, node, ow, tmr, uart, wifi`.
* How to flash: https://nodemcu.readthedocs.io/en/master/en/flash/
* Currently using `float` version
* `4 MB` module, so `dio` flash mode (see `Flash size` section below)
* `master` version doesn't work for some reason, `dev` must be / have been used

```
$ esptool.py --port=/dev/tty.SLAB_USBtoUART erase_flash
esptool.py v1.2.1
Connecting...
Running Cesanta flasher stub...
Erasing flash (this may take a while)...
Erase took 9.6 seconds

$ esptool.py --port=/dev/tty.SLAB_USBtoUART write_flash -fm=dio -fs=32m 0x00000 src/nodemcu-lua/flash/nodemcu-dev-8-modules-2016-11-22-01-12-06-float.bin 
esptool.py v1.2.1
Connecting...
Running Cesanta flasher stub...
Flash params set to 0x0240
Writing 409600 @ 0x0... 409600 (100 %)
Wrote 409600 bytes at 0x0 in 35.5 seconds (92.2 kbit/s)...
Leaving...
```


Flash size
---

https://nodemcu.readthedocs.io/en/latest/en/flash/#determine-flash-size

```
$ esptool.py --port=/dev/tty.SLAB_USBtoUART flash_id
esptool.py v1.2.1
Connecting...
Manufacturer: ef
Device: 4016
```

Chip id can be found here:
https://code.coreboot.org/p/flashrom/source/tree/HEAD/trunk/flashchips.h

This leads to a manufacturer name and a chip model name/number.
In our case it is `AMIC_A25LQ032`.

Last two or three digits in the module name denote the capacity in megabits.

`A25LQ032` is a `32 Mb` (`4 MB`) module.
