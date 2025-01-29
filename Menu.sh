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
    echo -e "${BOLD}${YELLOW}➤ 2. Insert into Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 3. List All Table${NC}"
     echo -e "${BOLD}${YELLOW}➤ 4. select Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 5. Drop table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 6. Update Table${NC}"  # New option for updating table
    echo -e "${BOLD}${CYAN}➤ 6. Return to Main Menu${NC}"  # New option to return to main menu
    echo -e "${BOLD}${RED}➤ 0. Exit${NC}" 
    echo ""
    read -p "Please choose an option: " choice

       
        case $choice in
    1)
        echo -e "${CYAN}--- Creating Table ---${NC}"
        read -p "Enter the name of the new table: " table_name

        if [[ -z "$table_name" ]]; then
            echo -e "${RED}Error: Table name cannot be empty.${NC}"
        elif [ -f "$db_name/$table_name.txt" ]; then
            echo -e "${RED}Table '$table_name' already exists.${NC}"
        else
            touch "$db_name/$table_name.txt"
            touch "$db_name/$table_name.metaData.txt"
            echo -e "${GREEN}Table '$table_name' created successfully!${NC}"

            read -p "Enter number of columns (including primary key): " num_columns
            while ! [[ "$num_columns" =~ ^[0-9]+$ ]] || [ "$num_columns" -lt 1 ]; do
                echo -e "${RED}Error: Please enter a valid number of columns.${NC}"
                read -p "Enter number of columns: " num_columns
            done

            read -p "Enter primary key column name: " pk_name
            while [[ -z "$pk_name" ]]; do
                echo -e "${RED}Error: Primary key name cannot be empty.${NC}"
                read -p "Enter primary key column name: " pk_name
            done

            read -p "Enter primary key column data type: " pk_type
            while [[ -z "$pk_type" ]]; do
                echo -e "${RED}Error: Primary key data type cannot be empty.${NC}"
                read -p "Enter primary key column data type: " pk_type
            done

            echo -e "$pk_name:$pk_type:PK" >> "$db_name/$table_name.metaData.txt"
            echo -n "$pk_name:" >> "$db_name/$table_name.txt"

            for ((i=0; i<num_columns-1; i++)); do
                read -p "Enter column $((i+1)) name: " col_name
                while [[ -z "$col_name" ]]; do
                    echo -e "${RED}Error: Column name cannot be empty.${NC}"
                    read -p "Enter column $((i+1)) name: " col_name
                done

                read -p "Enter column $((i+1)) data type: " col_type
                while [[ -z "$col_type" ]]; do
                    echo -e "${RED}Error: Column data type cannot be empty.${NC}"
                    read -p "Enter column $((i+1)) data type: " col_type
                done

                echo -e "$col_name:$col_type" >> "$db_name/$table_name.metaData.txt"
                echo -n "$col_name:" >> "$db_name/$table_name.txt"
            done
            echo -e "${GREEN}Columns added successfully!${NC}"
        fi
        ;;
    2)
        echo -e "${CYAN}--- Insert Data into Table ---${NC}"
        echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"

        read -p "Enter the name of the table to insert data into: " insert_table

        if [ -f "$db_name/$insert_table.txt" ]; then
            columns=$(cat "$db_name/$insert_table.metaData.txt" | cut -d: -f1)

            for column in $columns; do
                read -p "Enter value for $column: " value
                while [[ -z "$value:1" ]]; do
                    echo -e "${RED}Error: Value for $column cannot be empty.${NC}"
                    read -p "Enter value for $column: " value
                done
                echo -n "$value:" >> "$db_name/$insert_table.txt"
            done

            echo "" >> "$db_name/$insert_table.txt"
            echo -e "${GREEN}Data inserted successfully!${NC}"
        else
            echo -e "${RED}Table '$insert_table' does not exist.${NC}"
        fi
        ;;
    3)
        echo -e "${CYAN}--- Listing Tables ---${NC}"
        echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"
        table_files=$(ls $db_name/*.txt 2>/dev/null)

        if [[ -z "$table_files" ]]; then
            echo -e "${RED}No Tables Found.${NC}"
        else
            echo -e "${CYAN}Available Tables:${NC}"
            for table in $table_files; do
                table_name=$(basename "$table" .txt)
                echo " - $table_name"
            done
        fi
        read -p "Press [Enter] to return to the menu..."
        ;;
    4)
        echo -e "${CYAN}--- Select Table ---${NC}"
        echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"

        read -p "Enter the name of the table to display data: " selected_table

        if [[ ! -f "$db_name/$selected_table.txt" ]]; then
            echo -e "${RED}Table '$selected_table' does not exist.${NC}"
        else
            echo -e "${CYAN}Displaying Data for Table '$selected_table':${NC}"

            header=$(head -n 1 "$db_name/$selected_table.metaData.txt" | cut -d: -f1 | tr '\n' ' ')
            while IFS= read -r row; do
                echo "$row" | tr ':' ' '
            done < "$db_name/$selected_table.txt"
        fi
        ;;
    5)
        echo -e "${CYAN}--- Drop Table ---${NC}"
        echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"

        read -p "Enter the name of the table to drop: " drop_table

        if [ -f "$db_name/$drop_table.txt" ]; then
            rm "$db_name/$drop_table.txt" "$db_name/$drop_table.metaData.txt"
            echo -e "${GREEN}Table '$drop_table' has been dropped successfully!${NC}"
        else
            echo -e "${RED}Table '$drop_table' does not exist.${NC}"
        fi
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

