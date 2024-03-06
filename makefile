# Name of the Bash script
SCRIPT_NAME = outer.sh

# Destination directory where the script will be installed
DEST_DIR = /usr/local/bin

# Install command
INSTALL = install

install:
    $(INSTALL) -m 755 $(SCRIPT_NAME) $(DEST_DIR)/$(SCRIPT_NAME)

uninstall:
    rm -f $(DEST_DIR)/$(SCRIPT_NAME)
