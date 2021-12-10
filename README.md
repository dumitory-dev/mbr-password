# MBR PASSWORD

This is a tutorial project that shows how to set the BIOS boot password.

## Build
You need to download [Bochs 2.6.8](https://sourceforge.net/projects/bochs/files/bochs/2.6.8/Bochs-2.6.8.exe/download) and a WinXp [image](https://1drv.ms/u/s!Ajww2emPJhWY6Qt_eLx1gjD6HpJn?e=ymZaCb) for a quick start of this project. 

Bochs Drive Settings:

![Alt text](/images/settings.png)

Rename the image to winos.img and put it in the project package.

Next, simply type `python build.py` to flash the image. 

Сonfigure Bochs and set the path to the disk image

To return the original mbr, type `python build.py repair`

## Work Example
![Alt text](/images/winxp-mbr.gif)


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)