 #!/bin/bash  

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

 if [ -z "$1" ]; then 
     echo "Please provide an element as an argument."
     exit 0
else 
    re='^[0-9]+$'
     if ! [[ $1 =~ $re ]] ; then  # WORD
        declare A arr 
        name_symbol=$($PSQL "select name, symbol from elements")
        if ! [[ "$name_symbol" == *"$1"* ]]; then
           echo "I could not find that element in the database."
           exit 0
        fi
        arr[0]+=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'") #atomic number
        arr[1]=$($PSQL "select name from elements where symbol='$1' or name='$1'") #name
        arr[2]=$($PSQL "select symbol from elements where symbol='$1' or name='$1'") #symbol
        arr[3]=$($PSQL "select type from types, properties where properties.atomic_number='${arr[0]}' and types.type_id=properties.type_id") #type
        arr[4]=$($PSQL "select atomic_mass from properties where atomic_number='${arr[0]}'") #atomic_mass
        arr[5]=$($PSQL "select melting_point_celsius from properties where atomic_number='${arr[0]}'") #melting point
        arr[6]=$($PSQL "select boiling_point_celsius from properties where atomic_number='${arr[0]}'") #boiling point
        echo "The element with atomic number ${arr[0]} is ${arr[1]} (${arr[2]}). It's a ${arr[3]}, with a mass of ${arr[4]} amu. ${arr[1]} has a melting point of ${arr[5]} celsius and a boiling point of ${arr[6]} celsius."
  
    else # NUMBER
        #declare A arr 
        atomic_numbers=$($PSQL "select atomic_number from elements")
        if ! [[ "$atomic_numbers" == *"$1"* ]]; then
           echo "I could not find that element in the database."
           exit 0
        fi

        arr[0]=$1 #atomic number
        arr[1]=$($PSQL "select name from elements where elements.atomic_number='$1'") #name
        arr[2]=$($PSQL "select symbol from elements where elements.atomic_number='$1'") #symbol
        arr[3]=$($PSQL "select type from types, properties where properties.atomic_number='${arr[0]}' and types.type_id=properties.type_id") #type
        arr[4]=$($PSQL "select atomic_mass from properties where atomic_number='${arr[0]}'") #atomic_mass
        arr[5]=$($PSQL "select melting_point_celsius from properties where atomic_number='${arr[0]}'") #melting point
        arr[6]=$($PSQL "select boiling_point_celsius from properties where atomic_number='${arr[0]}'") #boiling point
        echo "The element with atomic number ${arr[0]} is ${arr[1]} (${arr[2]}). It's a ${arr[3]}, with a mass of ${arr[4]} amu. ${arr[1]} has a melting point of ${arr[5]} celsius and a boiling point of ${arr[6]} celsius."
    fi

fi
