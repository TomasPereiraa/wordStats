#!/usr/bin/env bash

MODE=$1
FILE=$2
LANGUAGE=$3


echo "./wordStats.sh $1 $2 $3"

#Validation
# If <MODE> and <INPUT> are empty

if [[ -z "$1" ]] || [[ -z "$2" ]]; then

	echo "[ERROR] insufficient parameters";
	echo "./word_stats.sh Cc|Pp|Tt INPUT [iso3166]"

	exit
fi

# Checks if the environment variable is empty, if it is = 10 (default) 

if [[ $1 == t || $1 == T || $1 == p || $1 == P ]]; then
if [[ -z "$WORD_STATS_TOP" ]]; then

	WORD_STATS_TOP=10
	echo "Environment variable WORD_STATS_TOP is empty (using default 10)"

# Checks if the environment variable is a digit, if it is = 10 (default) 

elif [[ ! $WORD_STATS_TOP =~ ^[[:digit:]]+$ ]]; then
	
	echo "'$WORD_STATS_TOP' is not a valid number (using default 10)"
	
	WORD_STATS_TOP=10

else

# if the environment variable is a number

	echo "export WORD_STATS_TOP=$WORD_STATS_TOP"
	echo "WORD_STATS_TOP=$WORD_STATS_TOP"
fi
fi

#check if that file exists 

if [[ ! -f $2 ]]; then

echo "[ERROR] can't find file '$2'"

exit 
fi

# Check the last 4 symbols to see if the file is .txt or .pdf.
# if it is .pdf, convert it to .txt
# if it is .txt, it does not change
# if it is not .pdf or .txt, it says the file is invalid 

if [ ${FILE: -4} == ".pdf" ]; then
	
	echo "'$FILE': PDF file"
	pdftotext -layout $FILE $FILE.txt
	FILE=$FILE.txt
	
elif [ ${FILE: -4} == ".txt" ]; then
	
	echo "'$FILE': TXT file"
	
else 
	
	echo "[ERROR] Invalid File "
	
	exit
fi

if [[ ! -z $4 ]]; then

echo "You can only enter 3 parameters  <MODE> <INPUT> <ISO3166>"

exit
fi

# End validation 


# Creation of a "switch case" to compare the letter entered with the existing <MODE> Cc | Pp | Tt 
case $1 in
"c")
	
	echo "[INFO] Processing '$FILE'"
	echo "STOP WORDS will be filtered out"
	    
# If <ISO3166> is "pt
if [[ $LANGUAGE == "pt" || $LANGUAGE == "Pt" || $LANGUAGE == "PT" || $LANGUAGE == "pT" ]]; then
	
# Counting the words in a .txt file, sorting in numerical order in descending order
# Filtering the words that are in the file pt.stop_words.txt 	
	
	echo "StopWords file '$LANGUAGE': 'StopWords/pt.stop_words.txt' (`tr ' ' '\n' < StopWords/pt.stop_words.txt | wc -w` words)"
	echo "COUNT MODE"
		
	cat $FILE| egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/pt.stop_words.txt | cat -n > result---$FILE
	cat result---$FILE 
	
	echo "RESULTS: 'result---$FILE'"
	
	ls -la result---$FILE
			
	echo "`cat $FILE |  egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/pt.stop_words.txt | wc -l` distinct words"

# If <ISO3166> is not introduced or in any other language 
else

# Counting the words in a .txt file, ordering in numerical order in descending order
# Filtering the words that are in the file en.stop_words.txt 

	echo "StopWords file '$LANGUAGE' / default language (English/en) 'StopWords/en.stop_words.txt' (`tr ' ' '\n' < StopWords/en.stop_words.txt | wc -w` words)"
	echo "COUNT MODE"
		
	cat $FILE| egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/en.stop_words.txt |cat -n > result---$FILE
	cat result---$FILE
	
	echo "RESULTS: 'result---$FILE"
	
	ls -la result---$FILE			
		
	echo "`cat $FILE | egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/en.stop_words.txt | wc -l` distinct words"		
		
fi
		
;;	

"C")

# Counting the words in a .txt file, sorting in numerical order in descending order 

	echo "[INFO] Processing '$FILE'" 
	echo "STOP WORDS will be counted"
	echo "COUNT MODE"
		
	cat $FILE| egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r |cat -n > result---$FILE
	cat result---$FILE 
	
	echo "RESULTS: 'result---$FILE'"

	ls -la result---$FILE
	
	echo "`cat $FILE| egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | wc -l` distinct words"
		
;;



"p")
	stop_words="Stop words included"

	echo "[INFO] Processing '$2'" 
	echo "STOP WORDS will be counted"

	cat $FILE| egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/pt.stop_words.txt | head -$WORD_STATS_TOP | cat -n > result---$FILE.dat
	plot_required=true
	
	ls -la result---$FILE.dat

;;

"P")
	stop_words="Stop words removed"

	echo "[INFO] Processing '$2'" 
	echo "STOP WORDS will be counted"

	cat $FILE | egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r |  head -$WORD_STATS_TOP | cat -n > result---$FILE.dat
	plot_required=true
	
	ls -la result---$FILE.dat

;;
 		
"t")
	
	echo "[INFO] Processing '$2'"
	echo "STOP WORDS will be filtered out"
	
	ls -la result---$FILE
 
# Counting the words of a .txt file, sorting in numerical order in descending order
# Filters the words that are in the file pt.stop_words.txt
# Show the "n" number of most frequent words in <INPUT> through the variable environment $ WORD_STATS_TOP 
 
if [[ $LANGUAGE == "pt" || $LANGUAGE == "Pt" || $LANGUAGE == "PT" || $LANGUAGE == "pT" ]]; then

	echo "StopWords file '$LANGUAGE': 'StopWords/pt.stop_words.txt' (`tr ' ' '\n' < StopWords/pt.stop_words.txt | wc -w` words)"
	
	echo "-------------------------------------"
	echo "# TOP $WORD_STATS_TOP elements"

	cat $FILE | egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/pt.stop_words.txt |cat -n > result---$FILE
	cat result---$FILE | head -$WORD_STATS_TOP
	
else

# Counting the words of a .txt file, sorting in numerical order in descending order
# Filters the words that are in the file en.stop_words.txt
# Show the "n" number of most frequent words in <INPUT> through the variable environment $ WORD_STATS_TOP  
	
	echo "StopWords file '$LANGUAGE': 'StopWords/en.stop_words.txt' (`tr ' ' '\n' < StopWords/en.stop_words.txt | wc -w` words)"

	echo "-------------------------------------"
	echo "# TOP $WORD_STATS_TOP elements"

	cat $FILE| egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r | grep -vwFf StopWords/en.stop_words.txt |cat -n > result---$FILE
	cat result---$FILE | head -$WORD_STATS_TOP

fi				

	echo "-------------------------------------"

;;
		
"T")

# Counting the words of a .txt file, sorting in numerical order in descending order
# Show the "n" number of most frequent words in <INPUT> through the variable environment $ WORD_STATS_TOP 

	echo "[INFO] Processing '$2'"
	echo "STOP WORDS will be counted" 

	ls -la result---$FILE
	
	echo "-------------------------------------"
	echo "# TOP $WORD_STATS_TOP elements"
	
	cat $FILE | egrep -o '\b\w+\b' | sort | uniq -c -i | sort -n -r |cat -n > result---$FILE
	cat result---$FILE | head -$WORD_STATS_TOP

	echo "-------------------------------------"
;;

*) 

	echo "[ERROR] unknown command $1"

esac 

if [[ "$plot_required" == true ]] ; then

	cat <<EOF > bar.gnuplot

#!/bin/bash
set terminal png
set output "result---$FILE.png"
set title "
set boxwidth 0.5
set style fill solid
set grid
set xtic rotate by 90
set bmargin 8
set xtics offset 0.5,-3.5
set xtics font ", 10"
set border 15
set xlabel 'Words' offset 0,-4
set ylabel 'Number of occurances'
set ytics 25
set yrange [0:]
plot "result---$FILE.dat" using 1:2:xtic(3) with boxes title "#of occurrences" lt rgb "#005fff"
EOF
	
	gnuplot < bar.gnuplot

    cat <<EOF > result---$FILE.html

<!DOCTYPE html>
    <head>
        <title> $2 Chart</title>
        <meta charset="UTF-8">
    </head>
    <body>
	    <header style= "text-align:center">
        
		    <h2><b> Top $WORD_STATS_TOP words - '$2'</b></h2>
            <p>Top words for '$2'</p>
            <p>Data: $(date '+%Y.%m.%d-%Hh%M:%S') </p>
			<p>( '$3' - $stop_words )</p>
                    
        </header>

        <img src="result---$FILE.png" alt="plot" style="display:block; margin-left:auto; margin-right:auto; margin-top:200px">

    <footer style= "text-align:center">
        <p><b>Authors:</b> Tomás Pereira - 2201785 / João Ferreira - 2201795</p>
		<p><b>Created:</b> $(date '+%Y.%m.%d-%Hh%M:%S') </p>
    </footer>

    </body>
	
</html>
EOF

	ls -la result---$FILE.png
	ls -la result---$FILE.html

firefox "result---$FILE.html"

fi
