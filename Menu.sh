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
    echo -e "${BOLD}${YELLOW}➤ 2. List All Tables${NC}"
    echo -e "${BOLD}${YELLOW}➤ 3. Drop Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 4. Insert into Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 5. Select From Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 6. Delete From Table${NC}"
    echo -e "${BOLD}${YELLOW}➤ 7. Update Table${NC}"  # New option for updating table
    echo -e "${BOLD}${CYAN}➤ 8. Return to Main Menu${NC}"  # New option to return to main menu
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

		 # VALIDATION --> COL. NAME CAN NOT BE A NUMBER
		 # VALIDATION --> PK CAN NOT BE REPEATED
            while [[ -z "$pk_name" || "$pk_name" =~ ^[0-9]+$ ]]; do
                echo -e "${RED}Error: Primary key name cannot be empty & cannot be a number.${NC}"
                read -p "Enter primary key column name: " pk_name
            done

            read -p "Enter primary key column data type: " pk_type

		 # VALIDATION --> INSERT DATATYPES ONLY
            while [[ -z "$pk_type" ]]; do
                echo -e "${RED}Error: Primary key data type cannot be empty.${NC}"
                read -p "Enter primary key column data type: " pk_type
            done

            echo -e "$pk_name:$pk_type:PK" >> "$db_name/$table_name.metaData.txt"
            echo -n "$pk_name" >> "$db_name/$table_name.txt"

            for ((i=0; i<num_columns-1; i++)); do
                read -p "Enter column $((i+1)) name: " col_name

		 # VALIDATION --> COL. NAME CAN'T BE A NUMBER
                while [[ -z "$col_name" ]]; do
                    echo -e "${RED}Error: Column name cannot be empty.${NC}"
                    read -p "Enter column $((i+1)) name: " col_name
                done

                read -p "Enter column $((i+1)) data type: " col_type

		 # VALIDATION --> INSERT DATATYPES ONLY
                while [[ -z "$col_type" ]]; do
                    echo -e "${RED}Error: Column data type cannot be empty.${NC}"
                    read -p "Enter column $((i+1)) data type: " col_type
                done

                echo -e "$col_name:$col_type" >> "$db_name/$table_name.metaData.txt"
                if [[ $i -ne $((num_columns-1)) ]]
                then
                    echo -n ":$col_name" >> "$db_name/$table_name.txt"
                else                
                    echo -n "$col_name" >> "$db_name/$table_name.txt"
                fi
            done
            echo -e "${GREEN}Columns added successfully!${NC}"
        fi
        ;;
        
    2)
            echo -e "${CYAN}--- Listing Tables ---${NC}"
        echo -e "${BG_GREEN}${WHITE}=======================${NC}"

       
        echo -e "${CYAN}Available Tables:${NC}"
        for table in "$db_name"/*.txt; do

    if [[ ! "$table" =~ metaData\.txt$ && ! "$table" =~ db_metadata\.txt$ ]]; then
                table_name=$(basename "$table" .txt)
                echo "$table_name"
            fi
        done

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


	3)
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

	4) 
	   echo -e "${CYAN}--- Insert Data into Table ---${NC}"
        echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"

        read -p "Enter the name of the table to insert data into: " insert_table

        if [ -f "$db_name/$insert_table.txt" ]; then
            columns=$(cat "$db_name/$insert_table.metaData.txt" | cut -d: -f1)
		 echo -e >> "$db_name/$insert_table.txt"

            for column in $columns; do
			# VALIDATION --> PK CAN NOT BE REPEATED
                read -p "Enter value for $column: " value
                while [[ -z "$value" ]]; do
                    echo -e "${RED}Error: Value for $column cannot be empty.${NC}"
                    read -p "Enter value for $column: " value
                done
                echo -n "$value:" >> "$db_name/$insert_table.txt"

            done
            # removing the last : in the file --> :$ (: char. to remove, $ end of line), // (replace by nothing)
            # /dev/null 2>&1 --> redirecting the error to the /dev/null filee
            sed -i '' 's/:$//' "$db_name/$insert_table.txt" > /dev/null 2>&1
            echo -e "${GREEN}Data inserted successfully!${NC}"
        else
            echo -e "${RED}Table '$insert_table' does not exist.${NC}"
        fi
        ;;

    5)

    echo -e "${CYAN}--- Select Table ---${NC}"
    echo -e "${BG_GREEN}${WHITE}===================${NC}"

    read -p "Enter the name of the table to display data: " selected_table

    if [[ ! -f "$db_name/$selected_table.txt" ]]; then
        echo -e "${RED}Table '$selected_table' does not exist.${NC}"
    else
        echo -e "${CYAN}Displaying Data for Table '$selected_table':${NC}"
        header=$(head -n 1 "$db_name/$selected_table.metaData.txt" | cut -d: -f1 | tr '\n' ' ')
        echo -e "Header: $header"

        read -p "Do you want to search by 'id' or 'name'? " search_criteria

        if [[ "$search_criteria" == "id" ]]; then
            read -p "Enter the ID to search for: " search_value
            found_row=$(grep -P "^$search_value:" "$db_name/$selected_table.txt")
            
            if [[ -z "$found_row" ]]; then
                echo -e "${RED}No row found with ID '$search_value'.${NC}"
            else
                echo "$found_row" | tr ':' ' '
            fi
        elif [[ "$search_criteria" == "name" ]]; then
            read -p "Enter the Name to search for: " search_value
            found_row=$(grep -i ":$search_value:" "$db_name/$selected_table.txt")
            
            if [[ -z "$found_row" ]]; then
                echo -e "${RED}No row found with Name '$search_value'.${NC}"
            else
                echo "$found_row" | tr ':' ' '
            fi
        else
            echo -e "${RED}Invalid search criteria.${NC}"
        fi
    fi
    ;;

    6)
        	echo -e "${CYAN}--- Delete From Table ---${NC}"
    		echo -e "${BG_GREEN}${WHITE}===================${NC}"

    		read -p "Enter the name of the table to display its data: " display_table
		
		if  [[ ! -f "$db_name/$display_table.txt" ]]
		then
			echo -e "${RED}Table '$display_table' does not exist.${NC}"
		else
            cat "$db_name/$display_table.txt"
			echo -e "\n"
			read -p "Enter the primary key of the record you want to delete: " delete_rowPK
			# VALIDATION --> inserted_pk CAN'T BE A STRING
			while [[ -z ${delete_rowPK} ]]
			do
                    echo -e "${RED}Error: primary key cannot be empty.${NC}"
                    read -p "Enter a valid primary key: " inserted_pk
            done
            read -p "Are you sure you want to permanently delete this row? (yes/no):" checking
	        if [[ "yes" =~ $checking ]]
            then
                flagdel=0
                existing_pk=$(tail -n +2 "$db_name/$display_table.txt" | cut -d: -f1)
			flagid=0;
			lineNumberr=1;
			for pk in $existing_pk
			do
				if [[ $flagid -eq 0 ]]
				then
					lineNumberr=$((lineNumberr+1))
				fi
				if [[ $pk =~ "$delete_rowPK" ]]
                # VALIDATION --> PK IF IT DOESN'T EXIST
                # VALIDATION --> WE CAN'T DELETE THE 1ST LINE (HEADERS --> id:name:age)
				then
					flagid=1
                    echo $lineNumberr
                    # -i --> to modify the original file (without it, output will be in terminal w/o modifying it)
                    sed -i '' "${lineNumberr}d" "$db_name/$display_table.txt"
                    echo -e "${GREEN}ID 'deleted_rowPK' deleted successfully.${NC}"
                    return;
                fi
            done
            elif [[ "no" =~ $checking ]]
            then
                    read -p "Press [Enter] to return to the menu..."
                    flagdel=1
            else
                # ASK FOR USER INPUT AGAIN
                echo -e "${RED}Error: Please enter yes/no.${NC}"
                #read -p "Are you sure you want to permanently delete this row? (yes/no):" checking
            fi
        fi
                ;;

	7)
		# list the rows inside the specific table - DONE
		# ask 'which ID do you want to update data in ?' - DONE

    		echo -e "${CYAN}--- Update Table ---${NC}"
    		echo -e "${BG_GREEN}${WHITE}===================${NC}"

    		read -p "Enter the name of the table to display its data: " updated_table
		
		if  [[ ! -f "$db_name/$updated_table.txt" ]]
		then
			echo -e "${RED}Table '$updated_table' does not exist.${NC}"
		else
			cat "$db_name/$insert_table.txt"
			echo -e "\n"
			read -p "Enter the primary key of the record you want to update: " inserted_pk
			# VALIDATION --> $inserted_pk CAN'T BE A STRING
			while [[ -z ${inserted_pk} ]]
			do
                    echo -e "${RED}Error: primary key cannot be empty.${NC}"
                    read -p "Enter a valid primary key: " inserted_pk
            done
		    # LOOP ON VALUES(in .txt) TO GET ID, CHECK IF id = $inserted_pk (if NOT --> does NOT exist)
			# SKIP 1ST ROW TO PREVENT TAKING THE TITLES (start from 2nd row)
			existing_pk=$(tail -n +2 "$db_name/$insert_table.txt" | cut -d: -f1)
			flag=0;
			lineNum=1;
			for id in $existing_pk
			do
                idflag=0;
				if [[ $flag -eq 0 ]]
				then
					lineNum=$((lineNum+1))
				fi
				if [[ $id =~ "$inserted_pk" ]]
				then
					flag=1
                    idflag=1;
					echo -e "${GREEN}ID exists.${NC}"
					read -p "Enter the column name you want to update: " inserted_column

				# VALIDATION --> CHECK IF THE $inserted_column EXISTS
				while [[ -z $inserted_column ]]
				do
                    		echo -e "${RED}Error: column name cannot be empty.${NC}"
                    		read -p "Enter a valid column name: " inserted_column
                done
	
				#loop on titles (1st line only),add a counter increment it
				#check on $inserted_column when found
				#cut using the counter
				col_Titles=$(head -n 1 "$db_name/$insert_table.txt" | tr ':' ' ')
				#echo $col_Titles
				i=0
				for title in $col_Titles
				do
					#echo $title
					#echo $inserted_column
					i=$((i+1));
					if [[  $title =~ "$inserted_column" ]]
					then	
						#echo $i
                        idflag=1;
						break
					fi
				done

# get lineNumber by ID
# loop over the line
# & change $fieldNum to $updated_data
				fieldNum=$i
				old_data=$(cut -d ":" -f$fieldNum "$db_name/$insert_table.txt" | sed -n "${lineNum}p")
				echo -e "${GREEN}data to be updated: '$old_data'${NC}"

				read -p "Enter new data for '$inserted_column': " new_data
				while [[ -z $new_data ]]
				do
					echo -e "${RED}Error: the new data cannot be empty.${NC}"
                    read -p "Enter a valid value for the new data: " new_data
				done

                # if $fieldNum (value inside fn 1 for ex.) == old_data --> replace w/ new
                new_fileData=$(awk -v old_data="$old_data" -v new_data="$new_data" -v fieldNum="$fieldNum" 'BEGIN{FS=OFS=":"} {if ($fieldNum == old_data) $fieldNum = new_data; print}' "$db_name/$insert_table.txt")
				
				# replace old_data with new_data (in the .txt file) (> overrides, >> adds new data after already exisiting ones)
				echo -n "$new_fileData:" > "$db_name/$insert_table.txt"
				echo -e "${GREEN}Data updated successfully.${NC}"
# ID:Name:Age:
# 10:jana:23:
# 20:malak:50:
# 30:khaled:70::::::
# WHEN I UPDATE, EXTRA : IS ADDED AT THE END EACH TIME 
				fi
            idflag=1
			done
            if [[ $idflag -eq 0 ]]
                then
                    echo -e "${RED}id '$inserted_pk' does not exist.${NC}"
            fi		
		fi

		# error for $inserted_pk --> if it doesn't exist - DONE
		# validation for $inserted_column --> must be one of the columns available + has to be the EXACT SAME col_name
		# validation for $updated_data --> must be the old value
		# validation for $new_data --> must be of the SAME datatype + (show datatype for the user)

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

