#!/bin/bash

# Color variables for styling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
WHITE='\033[0;37m'
BG_GREEN='\033[42m'  # Background Green for highlighting
BG_CYAN='\033[46m'   # Background Cyan for sections
NC='\033[0m'         # No Color "

display_main_menu() {
    clear  

    echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"
    echo -e "${BOLD}${CYAN}           Welcome to the Database Management Menu${NC}"
    echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"
    echo ""

    echo -e "${BOLD}${YELLOW}➤ 1. Create Database${NC}"
    echo -e "${BOLD}${YELLOW}➤ 2. List Databases${NC}"
    echo -e "${BOLD}${YELLOW}➤ 3. Connect To Database${NC}"
    echo -e "${BOLD}${YELLOW}➤ 4. Drop Database${NC}"
    echo -e "${BOLD}${RED}➤ 0. Exit${NC}" 
    echo ""
}

create_database(){
    echo -e "${CYAN}--- Creating Database ---${NC}"
    read -p "Enter username: " username
    read -s -p "Enter password: " password
    echo ""

    VALID_USERNAME="admin"
    VALID_PASSWORD="secret"
    
    if [ "$username" != "$VALID_USERNAME" ] || [ "$password" != "$VALID_PASSWORD" ]; then
        echo -e "${RED}Invalid username or password. Access denied.${NC}"
         read -p "Press [Enter] to return to the menu..."
       return 
    fi

    read -p "Enter the name of the new database: " db_name

    if [ -d "$db_name" ]; then
        echo -e "${RED}Database '$db_name' already exists.${NC}"
        read -p "Press [Enter] to return to the menu..."
        return
    fi

    mkdir "$db_name"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Database '$db_name' created successfully!${NC}"
        read -p "Press [Enter] to return to the menu..."
    else
        echo -e "${RED}Failed to create the database. Please try again.${NC}"
        read -p "Press [Enter] to return to the menu..."
    fi

    echo ""
}

list_database(){
	echo -e "${CYAN}--- Listing Databases ---${NC}"
	[ "$(ls -A -d)" ] && ls -d */ 2>/dev/null || echo -e "${RED}No Databases Found.${NC}"
	read -p "Press [Enter] to return to the menu..."
}

connect_database(){ 
    echo "Connecting to database..." 
    # Add your connection logic here
}

drop_database(){ 
    echo "Dropping database..." 
    # Add your drop logic here
}

show_footer() {
    echo -e "${CYAN}==========================================================${NC}"
    echo -e "${WHITE}Database Management Script - Version 1.0${NC}"
    echo -e "${CYAN}==========================================================${NC}"
}

while true; do
    display_main_menu
    read -p "Choose an option: " choice
    case $choice in 
        1)
            create_database
            ;;
        2)
            list_database
            ;;
        3)
            connect_database
            ;;
        4)
            drop_database
            ;;
        0)
            echo -e "${CYAN}Exiting...${NC}"
            show_footer
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice, please try again.${NC}"
            ;;
    esac
done

