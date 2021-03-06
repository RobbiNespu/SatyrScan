#!/bin/bash
if [ ! -d "sourcefiles" ]
then
mkdir sourcefiles
chmod 755 sourcefiles
fi

cd /home/sscan/sourcefiles

if [ -e "virloc.source" ]
then
        rm virloc.source
fi

ls -ld /home/*/public_html/ | awk '{print $9}' > dirs.source

echo -e "\033[35mFinding Scripts... \033[0m"

#Numbers for loading bar
percent=$(wc -l ../inc/virs.source | awk '{print $1}')
percent2=$(wc -l dirs.source | awk '{print $1}')
percent3=$(( $percent * $percent2 ))
process=$(bc -l <<< "scale = 3;  100 / $percent3")
proc2=$process

while read dirs
do

#Get script locations
while read line
do
        echo -ne "$process \r"
        grep -lE -R --exclude="../inc/virs.source" "$line" $dirs  >> virloc.source
        process=$(bc -l <<< "scale = 2; $process + $proc2")


done < ../inc/virs.source

done < dirs.source

#Sort out duplicates
echo -e "\033[35mSorting... \033[0m"
sort virloc.source | uniq -u > virus.sort
sort virloc.source | uniq -d >> virus.sort
sed -e 's/ /\\\ /g' virus.sort >> virus.local

echo " "
read -p "Do you wish to REMOVE the infected files? " remove

        if [ $remove = "y" ] || [ $remove = "Y" ] || [ $remove = "yes" ] || [ $remove = "Yes" ]
        then
        echo -e "\033[31m"
        read -p "ARE YOU SURE YOU WISH REMOVE THE INFECTED FILES? " remove
        echo -e "\033[0m"

                if [ $remove = "y" ] || [ $remove = "Y" ] || [ $remove = "yes" ] || [ $remove = "Yes" ]
                then

                cat virus.local | xargs rm -f

                echo "Removed files"
                fi
        else
        echo " "
        echo -e "\033[32mPlease check virus.local for file locations\033[0m"
        fi

../coffeewi