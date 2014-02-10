echo -e "\033[36m                                                   \033[0m"
echo -e "\033[36m  _________          __                     _________                         \033[0m"
echo -e "\033[36m /   _____/_____   _/  |_  ___.__._______  /   _____/  ____  _____     ____   \033[0m"
echo -e "\033[36m \_____  \ \__  \  \   __\<   |  |\_  __ \ \_____  \ _/ ___\ \__  \   /    \  \033[0m"
echo -e "\033[36m /        \ / __ \_ |  |   \___  | |  | \/ /        |\  \___  / __ \_|   |  \ \033[0m"
echo -e "\033[36m/_______  /(____  / |__|   / ____| |__|   /_______  / \___  >(____  /|___|  / \033[0m"
echo -e "\033[36m        \/      \/         \/                     \/      \/      \/      \/  \033[0m"
echo -e "\033[36m                                                   \033[0m"

if [ ! -d "sourcefiles" ]
then
mkdir sourcefiles
chmod 755 sourcefiles
fi

if [ -e "sourcefiles/virloc.source" ]
then
        rm sourcefiles/virloc.source
fi

echo -e "\033[35mFinding Scripts... \033[0m"

percent=$(wc -l virs.source | awk '{print $1}')

echo $percent

process=$(bc -l <<< "scale = 2;  100 / $percent")
proc2=$process

#Get script locations
while read line
do
        echo $process
        grep -lE -R --exclude="virs.source" "$line" /var/games/* >> sourcefiles/virloc.source
        process=$(bc -l <<< "scale = 2; $process + $proc2")


done < virs.source

#Sort out duplicates
echo -e "\033[35mSorting... \033[0m"
sort sourcefiles/virloc.source | uniq -u > virus.local
sort sourcefiles/virloc.source | uniq -d >> virus.local
sed -e 's/ /\\\ /g' virus.local >> virus.local

echo " "
read -p "Do you wish to REMOVE the infected files? " remove

        if [ $remove = "y" ] || [ $remove = "Y" ] || [ $remove = "yes" ] || [ $remove = "Yes" ]
        then
        echo -e "\033[31m"
        read -p "ARE YOU SURE YOU WISH REMOVE THE INFECTED FILES? "
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
