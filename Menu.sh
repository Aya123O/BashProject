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
display_table_menu(){
while true ;do 

    clear  

    echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"
    echo -e "${BOLD}${CYAN}           Welcome to the Table Menu${NC}"
    echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"
    echo ""

    echo -e "${BOLD}${YELLOW}➤ 1. Create Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 2. List Tables${NC}"
    echo -e "${BOLD}${YELLOW}➤ 3. Insert into Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 4. Drop table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 5. Update Table${NC}"  # New option for updating table
    echo -e "${BOLD}${CYAN}➤ 6. Return to Main Menu${NC}"  # New option to return to main menu
    echo -e "${BOLD}${RED}➤ 0. Exit${NC}" 
    echo ""
    read -p "Please choose an option: " choice

        case $choice in
            1)
                # Create Table code here
                #echo "Creating table..."
    		echo -e "${CYAN}--- Creating Table ---${NC}"

    		read -p "Enter the name of the new file: " file_name
    		if [[ -z "$db_name/$file_name.txt" ]]
    		then
			echo -e "${RED}Error: Input cannot be empty or contain only spaces. Please provide a valid value.${NC}"
    			#read -p "Press [Enter] to return to the menu..."
    		elif [ -f $db_name/$file_name.txt ]
		then
			echo -e "${RED}File '$file_name' already exists in '$db_name'.${NC}"
    			#read -p "Press [Enter] to return to the menu..."
    		else
			touch "$db_name/$file_name.txt"
      		echo -e "${GREEN}File '$file_name' has been created successfully in '$db_name'! You can now proceed with the next steps.${NC}"
			read -p "Please enter the value for the column that will serve as the primary key: " pkcolumn
			echo -n "$pkcolumn(PK):">> "$db_name/$file_name.txt"
			for ((i=0; i<5; i++))
			do
				read -p "Please enter the value for the column $((i+1)): " column
				while [[ -z "${column}" ]]
				do
					echo -e "${RED}Error: Input cannot be empty or contain only spaces.${NC}"
					read -p "Please provide a valid column name: " column
	      		done
			echo -n $column: >> "$db_name/$file_name.txt"
      		done
    		echo -e "${GREEN}Columns have been added successfully!${NC}"
    		#read -p "Press [Enter] to return to the menu..."
    		fi
                ;;
            2)
                # List Tables code here
                echo "Listing tables..."
                ;;
            3)
                # Insert into Table code here
                echo "Inserting into table..."
                ;;
            4)
                
                echo "Dropping table..."
                ;;
            5)
               
                echo "Updating table..."
                ;;
            6)   return  
                ;;
            0)
                
                echo "Exiting the program..."
                exit 0
                ;;
            *)
                echo "Invalid option, please try again."
                ;;
        esac

        
        read -p "Press any key to continue..." -n1 -s
    done

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

   
    if [[ ! "$db_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo -e "${RED}Invalid database name. Only alphanumeric characters, hyphens, and underscores are allowed.${NC}"
        read -p "Press [Enter] to return to the menu..."
        return
    fi

   
    read -p "Enter the directory to store the database (or press Enter to use current): " db_directory
    db_directory="${db_directory:-.}"  

    if [ ! -d "$db_directory" ]; then
        echo -e "${RED}Directory '$db_directory' does not exist. Please provide a valid directory.${NC}"
        read -p "Press [Enter] to return to the menu..."
        return
    fi

    if [ -d "$db_directory/$db_name" ]; then
        echo -e "${RED}Database '$db_name' already exists in the specified directory.${NC}"
        read -p "Would you like to overwrite it? (y/n): " overwrite_choice
        if [ "$overwrite_choice" != "y" ]; then
            echo -e "${YELLOW}Database creation cancelled.${NC}"
            read -p "Press [Enter] to return to the menu..."
            return
        fi
        rm -rf "$db_directory/$db_name"
        echo -e "${YELLOW}Existing database '$db_name' has been removed.${NC}"
    fi

   
    mkdir "$db_directory/$db_name"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Database '$db_name' created successfully in '$db_directory'.${NC}"
        
     
        echo "Database created on $(date)" > "$db_directory/$db_name/db_metadata.txt"
        echo -e "${GREEN}Metadata file created: $db_directory/$db_name/db_metadata.txt${NC}"
        
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

connect_database() {
    echo -e "${CYAN}--- Connecting to Database ---${NC}"
    read -p "Enter the name of the database to connect to: " db_name
    if [ -d "$db_name" ]; then
        echo -e "${GREEN}Successfully connected to database '$db_name'.${NC}"
        if [ -f "$db_name/db_metadata.txt" ]; then
            cat "$db_name/db_metadata.txt"
        else
            echo -e "${YELLOW}No metadata file found for this database.${NC}"
        fi
      display_table_menu
    else
        echo -e "${RED}Database '$db_name' does not exist.${NC}"
    fi
    read -p "Press [Enter] to return to the menu..."
}

drop_database(){
    #for loop 3 times to input a correct name!!
    read -p "Enter the name of the database you want to drop: " name
    if [ -d $name ]
    then
	read -p "Are you sure you want to permanently delete the database '$name'? (yes/no):" check
	if [[ "yes" =~ $check ]]
	then
		flag=0
		rm -r $name
		echo -e "${GREEN}Database '$db_name' dropped successfully!${NC}"
	elif [[ "no" =~ $check ]]
	then
	        read -p "Press [Enter] to return to the menu..."
		flag=1
	else
	  	echo -e "${RED}Error: Please enter yes/no.${NC}"
	fi
    else
	flag=0
	echo -e "${RED}Error: No database found with the specified name. Please enter a valid database name.${NC}"
    fi
    if [[ $flag == 0 ]]
    then
    	read -p "Press [Enter] to return to the menu..."
    fi
    #echo "Dropping database..." 
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

