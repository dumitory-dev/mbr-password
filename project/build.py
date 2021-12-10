from os import sys
import subprocess
from pathlib import Path

Path("./out").mkdir(parents=True, exist_ok=True)

subprocess.run(["./compiler/fasm.exe", "mbr.asm", "out/mbr.bin"])
subprocess.run(["./compiler/fasm.exe", "password_checker.asm", "out/password_checker.bin"])

def get_file_data(file_name):
    with open(file_name, mode='rb') as file:
        fileContent  = file.read()
        return fileContent

path_custom_mbr = "out/mbr.bin"
path_password_checker = "out/password_checker.bin"
path_os_img = "winos.img" 

ORIGINAL_MBR_OFFSET = 0x3200
PASSWORD_CHECKER_OFFSET = 0x3400                         
SECTOR_SIZE = 0x200

arg = ""

if len(sys.argv) > 1:
    arg = sys.argv[1]

if arg == "repair":
    print("Restoring an image...")
    os_file = open(path_os_img,'r+b')
    os_file.seek(ORIGINAL_MBR_OFFSET)
    original_mbr = os_file.read(SECTOR_SIZE)
    os_file.seek(0)
    os_file.write(original_mbr)
    exit(0)

custom_mbr_data = get_file_data(path_custom_mbr)
password_checker_data = get_file_data(path_password_checker)

os_file = open(path_os_img,'r+b')

original_mbr = os_file.read(SECTOR_SIZE)
os_file.seek(0)
os_file.write(custom_mbr_data)
os_file.seek(ORIGINAL_MBR_OFFSET)
os_file.write(original_mbr)
os_file.seek(PASSWORD_CHECKER_OFFSET)
os_file.write(password_checker_data)