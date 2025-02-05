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

# Table name validation
if [[ -z "$table_name" ]]; then
    echo -e "${RED}Error: Table name cannot be empty.${NC}"
elif [[ -f "$db_name/$table_name.txt" ]]; then
    echo -e "${RED}Error: Table '$table_name' already exists.${NC}"
else
    # Create table and metadata files
    touch "$db_name/$table_name.txt"
    touch "$db_name/$table_name.metaData.txt"
    echo -e "${GREEN}Table '$table_name' created successfully!${NC}"

    read -p "Enter number of columns (including primary key): " num_columns
    while ! [[ "$num_columns" =~ ^[0-9]+$ ]] || [ "$num_columns" -lt 1 ]; do
        echo -e "${RED}Error: Please enter a valid number of columns (positive integer).${NC}"
        read -p "Enter a valid number of columns: " num_columns
    done

    # Primary key column name validation
    read -p "Enter primary key column name: " pk_name
    while [[ -z "$pk_name" || "$pk_name" =~ ^[0-9+_!@#%*():.\/$%]+$ ]]; do
        if [[ -z "$pk_name" ]]; then
            echo -e "${RED}Error: Primary key name cannot be empty.${NC}"
        elif [[ "$pk_name" =~ ^[0-9+_!@#%*():.\/$%]+$ ]]; then
            echo -e "${RED}Error: Primary key name cannot contain special characters or numbers only.${NC}"
        fi
        read -p "Enter a valid primary key column name: " pk_name
    done

    # Primary key column data type validation
    read -p "Enter primary key column data type (int/string): " pk_type
    while [[ -z "$pk_type" || ! "$pk_type" =~ ^(int|string)$ ]]; do
        echo -e "${RED}Error: Primary key data type must be 'int' or 'string'.${NC}"
        read -p "Enter a valid primary key column data type: " pk_type
    done

    echo -e "$pk_name:$pk_type:PK" >> "$db_name/$table_name.metaData.txt"
    echo -n "$pk_name" >> "$db_name/$table_name.txt"

    # Column definitions
    for ((i=0; i<num_columns-1; i++)); do
        read -p "Enter column $((i+1)) name: " col_name

        # Column name validation
        while [[ -z "$col_name" || "$col_name" =~ ^[0-9+_!@#%*():.\/$%]+$ ]]; do
            if [[ -z "$col_name" ]]; then
                echo -e "${RED}Error: Column name cannot be empty.${NC}"
            elif [[ "$col_name" =~ ^[0-9+_!@#%*():.\/$%]+$ ]]; then
                echo -e "${RED}Error: Column name cannot contain special characters or numbers only.${NC}"
            fi
            read -p "Enter a valid column name: " col_name
        done

        read -p "Enter column $((i+1)) data type (int/string/boolean): " col_type

        # Column data type validation
        while [[ -z "$col_type" || ! "$col_type" =~ ^(int|string|boolean)$ ]]; do
            echo -e "${RED}Error: Column data type must be 'int', 'string', or 'boolean'.${NC}"
            read -p "Enter a valid data type for column $((i+1)): " col_type
        done

        echo -e "$col_name:$col_type" >> "$db_name/$table_name.metaData.txt"
        if [[ $i -ne $((num_columns-1)) ]]; then
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

# Check for available tables in the database
available_tables=()
for table in "$db_name"/*.txt; do
    if [[ ! "$table" =~ metaData\.txt$ && ! "$table" =~ db_metadata\.txt$ ]]; then
        table_name=$(basename "$table" .txt)
        available_tables+=("$table_name")
    fi
done

# If no tables exist, inform the user and exit
if [ ${#available_tables[@]} -eq 0 ]; then
    echo -e "${RED}No tables available in the database.${NC}"
    return
fi

# Display available tables
echo -e "${CYAN}Available Tables:${NC}"
for table in "${available_tables[@]}"; do
    echo "$table"
done

# Prompt the user to select a table
read -p "Enter the name of the table to display data: " selected_table

# Validate that the user did not enter an empty string
while [[ -z "$selected_table" ]]; do
    echo -e "${RED}Error: Table name cannot be empty.${NC}"
    read -p "Please enter a valid table name: " selected_table
done

# Validate if the selected table exists in the available tables list
while [[ ! " ${available_tables[@]} " =~ " $selected_table " ]]; do
    echo -e "${RED}Error: Table '$selected_table' does not exist.${NC}"
    read -p "Please enter a valid table name from the available tables: " selected_table
done

# If the table exists, proceed with displaying its data
echo -e "${CYAN}Displaying Data for Table '$selected_table':${NC}"

# Display the header (column names) from the metadata file
header=$(head -n 1 "$db_name/$selected_table.metaData.txt" | cut -d: -f1 | tr '\n' ' ')
echo -e "${CYAN}Columns: $header${NC}"

# Read and display the data from the table file
if [[ -f "$db_name/$selected_table.txt" ]]; then
    while IFS= read -r row; do
        # Display the row data with proper formatting
        echo "$row" | tr ':' ' '
    done < "$db_name/$selected_table.txt"
else
    echo -e "${RED}Error: Could not find data for table '$selected_table'.${NC}"
fi
;;


	3)
	   echo -e "${CYAN}--- Drop Table ---${NC}"
echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"

# Prompt the user for the table name to drop
read -p "Enter the name of the table to drop: " drop_table

# Validate the input to ensure it is not empty
while [[ -z "$drop_table" ]]; do
    echo -e "${RED}Error: Table name cannot be empty.${NC}"
    read -p "Please enter a valid table name to drop: " drop_table
done

# Check if the table exists
if [ -f "$db_name/$drop_table.txt" ]; then
    # Ask for user confirmation before dropping the table
    read -p "Are you sure you want to drop the table '$drop_table'? (y/n): " confirm_drop
    while [[ ! "$confirm_drop" =~ ^[YyNn]$ ]]; do
        echo -e "${RED}Error: Invalid input. Please enter 'y' or 'n' to confirm.${NC}"
        read -p "Are you sure you want to drop the table '$drop_table'? (y/n): " confirm_drop
    done

    # If the user confirms, delete the table and its metadata
    if [[ "$confirm_drop" =~ ^[Yy]$ ]]; then
        rm "$db_name/$drop_table.txt" "$db_name/$drop_table.metaData.txt"
        echo -e "${GREEN}Table '$drop_table' has been dropped successfully!${NC}"
    else
        echo -e "${CYAN}Table '$drop_table' has not been dropped.${NC}"
    fi
else
    echo -e "${RED}Error: Table '$drop_table' does not exist.${NC}"
fi
;;

	4) 
                echo -e "${CYAN}--- Insert Data into Table ---${NC}"
echo -e "${BG_GREEN}${WHITE}==========================================================${NC}"

# Prompt for table to insert data
read -p "Enter the name of the table to insert data into: " insert_table

# Validate if table exists
if [ -f "$db_name/$insert_table.txt" ]; then
    # Get column names and their data types
    columns=$(cut -d: -f1 "$db_name/$insert_table.metaData.txt")
    columns_dt=$(cut -d: -f2 "$db_name/$insert_table.metaData.txt")
    pk_column=$(awk -F: '$3 == "PK" {print $1}' "$db_name/$insert_table.metaData.txt")

    echo -e "${CYAN}Insert Data for Table '$insert_table'${NC}"
    echo -e "${BG_BLUE}${WHITE}----------------------------------------------------------${NC}"

    insert_line=""

    # Loop through columns to collect data
    for column in $columns; do
        column_dt=$(awk -F: -v col="$column" '$1 == col {print $2}' "$db_name/$insert_table.metaData.txt")

        echo -e "${YELLOW}Data type for $column: ${WHITE}$column_dt${NC}"

        # Read value for each column
        read -p "Enter value for $column: " value

        # Validation: Ensure value is not empty
        while [[ -z "$value" ]]; do
            echo -e "${RED}Error: Value for $column cannot be empty.${NC}"
            read -p "Enter value for $column: " value
        done

        # Handle case where we need to split values like "salary5" into "salary 5"
        if [[ "$value" =~ ^([a-zA-Z]+)([0-9]+)$ ]]; then
            # If the value matches "letters followed by numbers", add a space between them
            value="${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
        fi

        # Validate the value based on column's data type
        case $column_dt in
            int)
                while ! [[ "$value" =~ ^[0-9]+$ ]]; do
                    echo -e "${RED}Error: $column must be an integer.${NC}"
                    read -p "Enter value for $column: " value
                done
                ;;
            string)
                while [[ "$value" =~ [^a-zA-Z0-9[:space:]] ]]; do
                    echo -e "${RED}Error: $column must be a valid string (letters, numbers, spaces only).${NC}"
                    read -p "Enter value for $column: " value
                done
                ;;
            boolean)
                while [[ "$value" != "true" && "$value" != "false" ]]; do
                    echo -e "${RED}Error: $column must be 'true' or 'false'.${NC}"
                    read -p "Enter value for $column: " value
                done
                ;;
            *)
                echo -e "${RED}Error: Unknown data type '$column_dt' for column '$column'.${NC}"
                exit 1
                ;;
        esac

        # Primary Key Uniqueness Check
        if [[ "$column" == "$pk_column" ]]; then
            if grep -q "^$value:" "$db_name/$insert_table.txt"; then
                echo -e "${RED}Error: Primary Key value '$value' already exists in the table.${NC}"
                exit 1
            fi
        fi

        # Build the line to insert into the table
        if [[ -z "$insert_line" ]]; then
            insert_line="$value"
        else
            insert_line="$insert_line:$value"
        fi
    done

    echo -e "${BG_BLUE}${WHITE}----------------------------------------------------------${NC}"
    echo -e "${GREEN}Data inserted successfully into '$insert_table' table!${NC}"

    # Insert the data into the table file with a new line
    echo "$insert_line" >> "$db_name/$insert_table.txt"
    echo "" >> "$db_name/$insert_table.txt"  # Adding a new line to separate entries

    # Optional: Display inserted data for confirmation
    echo -e "${CYAN}Inserted Data:${NC}"
    echo "$insert_line" | tr ':' ' '  # Display the data in a more readable format
else
    echo -e "${RED}Error: Table '$insert_table' does not exist.${NC}"
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
            if [[ ! "$search_value" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}Error: ID must be a valid number.${NC}"
            else
                found_row=$(grep -P "^$search_value:" "$db_name/$selected_table.txt")
                if [[ -z "$found_row" ]]; then
                    echo -e "${RED}No row found with ID '$search_value'.${NC}"
                else
                    echo "$found_row" | tr ':' ' '
                fi
            fi
        elif [[ "$search_criteria" == "name" ]]; then
            read -p "Enter the Name to search for: " search_value
            if [[ ! "$search_value" =~ ^[a-zA-Z0-9[:space:]]+$ ]]; then
                echo -e "${RED}Error: Name must only contain letters, numbers, and spaces.${NC}"
            else
                found_row=$(grep ":$search_value" "$db_name/$selected_table.txt")
                if [[ -z "$found_row" ]]; then
                    echo -e "${RED}No row found with Name '$search_value'.${NC}"
                else
                    echo "$found_row" | tr ':' ' '
                fi
            fi
        else
            echo -e "${RED}Invalid search criteria. Please use 'id' or 'name'.${NC}"
        fi
    fi
    ;;

6)
    echo -e "${CYAN}--- Delete From Table ---${NC}"
    echo -e "${BG_GREEN}${WHITE}===================${NC}"

    read -p "Enter the name of the table to display its data: " display_table

    if [[ ! -f "$db_name/$display_table.txt" ]]; then
        echo -e "${RED}Table '$display_table' does not exist.${NC}"
    else
        echo -e "${CYAN}Displaying data for '$display_table':${NC}"
        cat "$db_name/$display_table.txt"
        echo -e "\n"

        read -p "Enter the primary key of the record you want to delete: " deleted_rowPK

        # VALIDATION: Primary key can't be empty
        while [[ -z "$deleted_rowPK" ]]; do
            echo -e "${RED}Error: Primary key cannot be empty.${NC}"
            read -p "Enter a valid primary key: " deleted_rowPK
        done

        # VALIDATION: Ensure the primary key is numeric (if that's the required type)
        while [[ ! "$deleted_rowPK" =~ ^[0-9]+$ ]]; do
            echo -e "${RED}Error: Primary key must be a valid number.${NC}"
            read -p "Enter a valid primary key: " deleted_rowPK
        done

        read -p "Are you sure you want to permanently delete this row? (yes/no): " checking

        if [[ "$checking" =~ ^[Yy]es$ ]]; then
            # Extract primary keys from the data, skipping the header (first line)
            existing_pk=$(tail -n +2 "$db_name/$display_table.txt" | cut -d: -f1)  # Skip the first line (header)

            # Initialize flag and line counter
            flagid=0
            lineNumberr=2  # Start from 2 since we skip the first line (header)

            # Check for the existence of the primary key in the data
            for pk in $existing_pk; do
                if [[ $pk == "$deleted_rowPK" ]]; then
                    # Perform the deletion (skip the first line which is the header)
                    sed -i "${lineNumberr}d" "$db_name/$display_table.txt"
                    echo -e "${GREEN}Record with primary key '$deleted_rowPK' deleted successfully.${NC}"
                    return
                fi
                lineNumberr=$((lineNumberr + 1))
            done

            # If the primary key was not found
            echo -e "${RED}Error: No record found with primary key '$deleted_rowPK'.${NC}"

        elif [[ "$checking" =~ ^[Nn]o$ ]]; then
            echo -e "${CYAN}Deletion aborted.${NC}"
        else
            echo -e "${RED}Error: Invalid input. Please enter 'yes' or 'no'.${NC}"
        fi
    fi
    ;;

7)
    echo -e "${CYAN}--- Update Table ---${NC}"
    echo -e "${BG_GREEN}${WHITE}===================${NC}"

    read -p "Enter the name of the table to display its data: " updated_table

    if [[ ! -f "$db_name/$updated_table.txt" ]]; then
        echo -e "${RED}Table '$updated_table' does not exist.${NC}"
    else
        cat "$db_name/$updated_table.txt"
        echo -e "\n"
        read -p "Enter the primary key of the record you want to update: " inserted_pk

        while [[ -z $inserted_pk ]]; do
            echo -e "${RED}Error: Primary key cannot be empty.${NC}"
            read -p "Enter a valid primary key: " inserted_pk
        done

        # LOOP ON VALUES (in .txt) TO GET ID, CHECK IF id = $inserted_pk (if NOT --> does NOT exist)
        existing_pk=$(tail -n +2 "$db_name/$updated_table.txt" | cut -d: -f1)
        flag=0
        lineNum=1
        for id in $existing_pk; do
            if [[ $flag -eq 0 ]]; then
                lineNum=$((lineNum + 1))
            fi
            if [[ $id == "$inserted_pk" ]]; then
                flag=1
                read -p "Enter the column name you want to update: " inserted_column

                while [[ -z $inserted_column ]]; do
                    echo -e "${RED}Error: Column name cannot be empty.${NC}"
                    read -p "Enter a valid column name: " inserted_column
                done

                col_Titles=$(head -n 1 "$db_name/$updated_table.txt" | tr ':' ' ')
                i=0
                for title in $col_Titles; do
                    i=$((i + 1))
                    if [[ $title == "$inserted_column" ]]; then
                        break
                    fi
                done

                fieldNum=$i
                old_data=$(cut -d ":" -f$fieldNum "$db_name/$updated_table.txt" | sed -n "${lineNum}p")
                echo -e "${GREEN}Data to be updated: '$old_data'${NC}"

                read -p "Enter new data for '$inserted_column': " new_data

                while [[ -z $new_data ]]; do
                    echo -e "${RED}Error: The new data cannot be empty.${NC}"
                    read -p "Enter a valid value for the new data: " new_data
                done

                # Validate new data type
                # Add additional validation for the data type if necessary
                new_fileData=$(awk -v old_data="$old_data" -v new_data="$new_data" -v fieldNum="$fieldNum" 'BEGIN{FS=OFS=":"} {if ($fieldNum == old_data) $fieldNum = new_data; print}' "$db_name/$updated_table.txt")

                # replace old_data with new_data
                echo -n "$new_fileData:" > "$db_name/$updated_table.txt"
                echo -e "${GREEN}Data updated successfully.${NC}"
            fi
        done

        if [[ $flag -eq 0 ]]; then
            echo -e "${RED}Error: Record with primary key '$inserted_pk' does not exist.${NC}"
        fi
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


# Function to display the main menu
display_main_menu() {
    clear
    echo -e "${CYAN}===============================${NC}"
    echo -e "${CYAN}        Main Menu               ${NC}"
    echo -e "${CYAN}===============================${NC}"
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect to Database"
    echo "4) Drop Database"
    echo "0) Exit"
    echo -e "${CYAN}===============================${NC}"
}

# Function to show footer or closing message
show_footer() {
    echo -e "${CYAN}==========================================================${NC}"
    echo -e "${WHITE}Database Management Script - Version 1.0${NC}"
    echo -e "${CYAN}==========================================================${NC}"
}

# Create Database Function
create_database(){
    echo -e "${CYAN}===============================${NC}"
    echo -e "${CYAN}    Creating Database           ${NC}"
    echo -e "${CYAN}===============================${NC}"

    # Validate username and password
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

    # Validate database name
    read -p "Enter the name of the new database: " db_name

    if [[ ! "$db_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo -e "${RED}Invalid database name. Only alphanumeric characters, hyphens, and underscores are allowed.${NC}"
        read -p "Press [Enter] to return to the menu..."
        return
    fi

    # Directory input and validation
    read -p "Enter the directory to store the database (or press Enter to use current): " db_directory
    db_directory="${db_directory:-.}"

    if [ ! -d "$db_directory" ]; then
        echo -e "${RED}Directory '$db_directory' does not exist. Please provide a valid directory.${NC}"
        read -p "Press [Enter] to return to the menu..."
        return
    fi

    # Check if the database already exists
    if [ -d "$db_directory/$db_name" ]; then
        echo -e "${RED}Database '$db_name' already exists in the specified directory.${NC}"
        read -p "Would you like to overwrite it? (y/n): " overwrite_choice
        if [[ "$overwrite_choice" != "y" ]]; then
            echo -e "${YELLOW}Database creation cancelled.${NC}"
            read -p "Press [Enter] to return to the menu..."
            return
        fi
        rm -rf "$db_directory/$db_name"
        echo -e "${YELLOW}Existing database '$db_name' has been removed.${NC}"
    fi

    # Create new database
    mkdir "$db_directory/$db_name"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Database '$db_name' created successfully in '$db_directory'.${NC}"
        
        # Create metadata file
        echo "Database created on $(date)" > "$db_directory/$db_name/db_metadata.txt"
        echo -e "${GREEN}Metadata file created: $db_directory/$db_name/db_metadata.txt${NC}"
        
        read -p "Press [Enter] to return to the menu..."
    else
        echo -e "${RED}Failed to create the database. Please try again.${NC}"
        read -p "Press [Enter] to return to the menu..."
    fi

    echo ""
}

# List Databases Function
list_database() {
    echo -e "${CYAN}===============================${NC}"
    echo -e "${CYAN}     Listing Databases          ${NC}"
    echo -e "${CYAN}===============================${NC}"

    # Check if the script has permission to read the current directory
    if [ ! -r . ]; then
        echo -e "${RED}Error: No read permission in the current directory.${NC}"
        return 1  # Exit function if no read permissions
    fi

    # Check if any directories exist (Databases) in the current working directory
    dbs=$(ls -A -d */ 2>/dev/null)
    
    if [ -z "$dbs" ]; then
        echo -e "${RED}No Databases Found.${NC}"
    else
        echo -e "${GREEN}Databases found:${NC}"
        echo -e "$dbs"
    fi

    # Check for any unexpected errors during the directory listing
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error occurred while listing directories. Please check permissions.${NC}"
        return 1  # Exit function on error
    fi
    
    # Prompt to return to the menu
    read -p "Press [Enter] to return to the menu..."
}

# Connect to Database Function
connect_database() {
    echo -e "${CYAN}===============================${NC}"
    echo -e "${CYAN}    Connecting to Database     ${NC}"
    echo -e "${CYAN}===============================${NC}"

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

# Drop Database Function
drop_database(){
    echo -e "${CYAN}===============================${NC}"
    echo -e "${CYAN}     Dropping Database          ${NC}"
    echo -e "${CYAN}===============================${NC}"

    read -p "Enter the name of the database you want to drop: " name
    if [ -d "$name" ]; then
        read -p "Are you sure you want to permanently delete the database '$name'? (yes/no): " check
        if [[ "yes" =~ $check ]]; then
            rm -r "$name"
            echo -e "${GREEN}Database '$name' dropped successfully!${NC}"
        elif [[ "no" =~ $check ]]; then
            echo -e "${YELLOW}Database deletion cancelled.${NC}"
        else
            echo -e "${RED}Error: Please enter yes/no.${NC}"
        fi
    else
        echo -e "${RED}Error: No database found with the specified name. Please enter a valid database name.${NC}"
    fi
    read -p "Press [Enter] to return to the menu..."
}

# Main Loop to display menu and take actions
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
            read -p "Press [Enter] to continue..."
            ;;
    esac
done
