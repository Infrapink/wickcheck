#!/bin/bash

# This file is copyright Chris McCrohan and is distributed under the MIT license.

options=()
for i in $@; do
    flags+=($i);
done

trope=""
fun=0
included=()
excluded=()
outfile="checklist.txt"
namespace="Main/"
t=0
u=1
dot=0
all=0
h=0

#for z in ${flags[@]}; do
#    echo $z;
#done


for j in ${flags[@]}; do
    option=$j;
    h=$((h+1))
    case $option in
	-w) trope=${flags[$h]} ;;
	-f|--fun) fun=1 ;;
	-n|--namespace) namespace=${flags[$h]} ;;
	-i|--include)
	    k=$h
            z=0
            while [[ ${flags[$k]} =~ ^[A-Za-z] ]]; do
                included[$z]=${flags[$k]}
                k=$((k+1))
                z=$((z+1))
            done
	    ;;
	-x|--exclude)
	    # have to do something.
	    k=$h
	    z=0
	    while [[ ${flags[$k]} =~ ^[A-Za-z] ]]; do
		excluded[$z]=${flags[$k]}
		k=$((k+1))
		z=$((z+1))
	    done
	    ;;
	-o|--output) outfile=${flags[h]} ;;
	-u|--url)
	    u=1;
	    t=0;
	    ;;
	-t|--trope)
	    u=0;
	    t=1
	    ;;
	-d|--dot) dot=1 ;;
	-a|--all) all=1 ;;
	*) h=$h ;;
    esac
done

if [[ ${#trope} -eq 0 ]]; then
    for i in ${flags[@]}; do
	a=0
	if [[ $i =~ ^http ]]; then
	    trope=$i
	    a=3
	elif [[ $i =~ [A-Za-z] ]]; then
	    if [[ $i =~ /$ ]]; then
		a=$a
	    elif [[ $a -lt 3 ]]; then
		if [[ $(echo $i| grep -c '/') -eq 1 ]]; then
		    trope=$i
		    a=2
		elif [[ $a -lt 2 ]]; then
		    trope=$i
		    a=1
		fi
	    fi
	fi
    done
fi

if [[ $trope =~ ^https ]]; then
    trope=$trope # full URL; no need to do anything
elif [[ $trope =~ ^pmwiki.php ]]; then
    trope="https://tvtropes.org/pmwiki/"$trope;
elif [[ $trope =~ ^pmwiki ]]; then
    trope="https://tvtropes.org/"$trope;
elif [[ $trope =~ ^tvtropes.org ]]; then
    trope = "https://"
elif [[ $trope =~ *'/'* ]]; then
    trope="https://tvtropes.org/pmwiki/pmwiki.php/"$trope;
else
    trope="https://tvtropes.org/pmwiki/pmwiki.php/Main/"$trope
fi

# account for namespaces
ns=$(echo $trope|cut -d '/' -f 6)
trope=$(echo $trope|sed s_ns_namespace_)

trope=$(echo $trope|sed 's_pmwiki.php/_relatedsearch.php?term=_')
wget --quiet  --output-document=/tmp/wicklist $trope

# next, we need to massage the HTML to extract a list of URLs
sed 's_href_\n_g' /tmp/wicklist | egrep ^=  | cut -d '"' -f 2 > /tmp/wicklist2
egrep ^/pmwiki/pmwiki.php /tmp/wicklist2 > /tmp/wicklist
head -n -64 /tmp/wicklist |tail +9 > /tmp/wicklist2
sed -i 's_^_https://tvtropes.org_g' /tmp/wicklist2
mv /tmp/wicklist2 /tmp/wicklist

# now we have a list of wicks to look at. time to figure out the target number.
len=$(wc -l /tmp/wicklist|cut -f 1 -d ' ');
dec=$(echo "scale=10;sqrt($len)"| bc);
root=$(( `echo $dec|cut -f 1 -d '.'` + 1 ));
if [[ $root -le 50 ]]; then
    target=50;
else
    target=$root;
fi

# now to remove the omitted namespaces
jff=("Headscratchers" "WMG" "AATAFOVS" "JustForFun" "DarthWiki" "SugarWiki" "SoYouWantTo" "Horrible" "Pantheon" "SelfDemonstrating" "Haiku" "ImageLinks" "Timeline" "UsefulNotes" "GrandUnifiedTimeline" "VideoExamples" "Sandbox")
if [[ ${#included[@]} -gt 0 ]]; then
    for n in ${included[@]}; do
	m=$(echo $n|sed s_/__)
	grep -i "/$m/" /tmp/wicklist >> /tmp/wicklist2;
    done
    cp /tmp/wicklist2 /tmp/wicklist;
else
    for n in ${excluded[@]}; do
	#echo $n
	m=$(echo $n|sed s_/__)
	grep -iv "/$m/" /tmp/wicklist > /tmp/wicklist2;
	mv /tmp/wicklist2 /tmp/wicklist;
    done
    # remove the fun namespaces
    if [[ $fun -eq 0 ]]; then
	for f in ${jff[@]}; do
	    grep -iv "/$f/" /tmp/wicklist > /tmp/wicklist2;
	    mv /tmp/wicklist2 /tmp/wicklist
	done
    fi
fi

len=$(wc -l /tmp/wicklist|cut -f 1 -d ' '); # do this again to account for removed namespaces
checklines=();
rm -f $outfile

echo "Checking $target of $len valid pages..."

if [[ $all -eq 1 ]]; then
    echo $outfile
    mv /tmp/wicklist $outfile;
elif [[ $len -le 50 ]]; then
    mv /tmp/wicklist $outfile;
elif [[ $len -le $target ]]; then
    mv /tmp/eicklist $outfile
elif [[ $target -lt 100 ]]; then
    # in this case, the number to include will be greater than the number to exclude
    # as such, it's easier and more efficient to get the number of wicks that will be omitted and remove them
    # than to get $target wicks
    omit=$(( 100 - target ));
    z=0
    while [[ $z -lt $omit ]]; do
	a=0;
	i=0
	r=$(( 1 + $RANDOM % $len));
	while [[ $i -lt ${#checklines[@]} ]]; do
	    #echo ${#checklines[@]}
	    if [[ $r -eq ${checklines[$i]} ]]; then
		a=1
	    else
		a=$a
	    fi
	    i=$((i+1))
	done
	if [[ $a -eq 0 ]]; then
	    checklines[$i]=$r
	    j=$i
	    # sort checklines[] into reverse numerical order
	    while [[ $j -gt 0 ]]; do
		if [[ ${checklines[$j]} -lt ${checklines[$((j-1))]} ]]; then
		    j=0
		else
		    checklines[$j]=${checklines[$((j-1))]}
		    checklines[$((j-1))]=$r
		    j=$((j-1))
		fi
	    done
	fi
	z=$((z+1))
    done

    for l in ${checklines[@]}; do
	sed -i ${l}d /tmp/wicklist;
    done
    mv /tmp/wicklist $outfile;
else
    z=0
    while [[ $z -lt $target ]]; do
	a=0
	r=$((1 + $RANDOM % $len ))
	c=0
	while [[ $c -lt ${#checklines[@]} ]]; do
	    if [[ $r -eq ${checklines[$c]} ]]; then
		a=1
	    else
		a=$a
	    fi
	    c=$((c+1))
	done
	if [[ $a -eq 0 ]]; then
	    checklines[$z]=$r
	    z=$((z+1))
	fi
    done
    for l in ${checklines[@]}; do
	sed -n ${l}p /tmp/wicklist >> $outfile
    done
fi

if [[ $dot -eq 1 ]]; then
    for i in $(cut -d '/' -f 6 $outfile|uniq); do
	sed -i "s_$i/_$i._g" $outfile;
    done
fi

if [[ $t -eq 1 ]]; then
    sed -i s_https://tvtropes.org/pmwiki/pmwiki.php/__g $outfile
fi

echo "Done!"
echo "See $outfile for the full list"
