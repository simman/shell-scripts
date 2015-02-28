#!/bin/sh


convert_bw() {
	>$1-c.log
	while read line
        do
            if [ -z "$line" ]; then
                continue
            fi
            echo $line |grep "KB/s" >/dev/null
        	if [ $? -eq 0 ]; then
                        tmp=`echo $line |sed 's/KB\/s//g'`
                else
			echo $line |grep "MB/s" >/dev/null
			if [ $? -eq 0 ]; then
				tmp=`echo $line |sed 's/MB\/s//g'`
                                tmp=`echo "scale=1;$tmp*1024" |bc`
			else
                        	tmp=`echo $line |sed 's/B\/s//g'`
                       		tmp=`echo "scale=1;$tmp/1024" |bc`
			fi
                fi
                echo $tmp >>$1-c.log
        done <$1.log
}

convert_lat() {
	>$1-c.log
	while read line
	do
 	if [ -z "$line" ]; then
        	continue
  	fi
  	echo $line |grep usec >/dev/null
  		if [ $? -eq 0 ]; then
        		tmp=`echo $line |sed 's/usec//g'`
        		tmp=`echo "scale=4;$tmp/1000" |bc`
  		else
        		tmp=`echo $line |sed 's/msec//g'`
  		fi
  		echo $tmp >>$1-c.log
	done <$1.log
}

file_to_array() {
  for f in $*
  do
	case $f in
	r1)
	    r1_array=
	    while read LINE
            do
                if [ -z "$LINE" ]; then
                        continue
                fi
                if [ -z "${r1_array}" ]; then
                        r1_array="$LINE"
                else
                        r1_array="$r1_array $LINE"
		fi
            done <r1-c.log
	    r1_array=($r1_array)
	;;
	r2)
	    r2_array=
            while read LINE
            do
                if [ -z "$LINE" ]; then
                        continue
                fi
                if [ -z "${r2_array}" ]; then
                        r2_array="$LINE"
                else
                        r2_array="$r2_array $LINE"
                fi
            done <r2.log
            r2_array=($r2_array)	
	;;
	r3)
	    r3_array=
            while read LINE
            do
                if [ -z "$LINE" ]; then
                        continue
                fi
                if [ -z "${r3_array}" ]; then
                        r3_array="$LINE"
                else
                        r3_array="$r3_array $LINE"
                fi
            done <r3-c.log
            r3_array=($r3_array)
	;;
	w1)
	    w1_array=
            while read LINE
            do
                if [ -z "$LINE" ]; then
                        continue
                fi
                if [ -z "${w1_array}" ]; then
                        w1_array="$LINE"
                else
                        w1_array="$w1_array $LINE"
                fi
            done <w1-c.log
            w1_array=($w1_array)
	;;
	w2)
	    w2_array=
            while read LINE
            do
                if [ -z "$LINE" ]; then
                        continue
                fi
                if [ -z "${w2_array}" ]; then
                        w2_array="$LINE"
                else
                        w2_array="$w2_array $LINE"
                fi
            done <w2.log
            w2_array=($w2_array)
	;;
	w3)
	    w3_array=
            while read LINE
            do
                if [ -z "$LINE" ]; then
                        continue
                fi
                if [ -z "${w3_array}" ]; then
                        w3_array="$LINE"
                else
                        w3_array="$w3_array $LINE"
                fi
            done <w3-c.log
            w3_array=($w3_array)
	;;
	esac
  done
 # for((x=0;x<${#r1_array[@]};x++)) 
 # do
 #       echo ${r1_array[$x]}
 # done
 # echo done
}

ioDepth=(1 4 16 64 128 256 512 1024)
randRW=(512b 4k 64k)
seqRW=(64k 1m)


for op in ${randRW[*]}
do
    for i_depth in ${ioDepth[*]}
    do
       grep " fio_randrw_${op}_${i_depth} " * -A4 |grep read -A1 |awk -F, '{print $2}' |sed '/^$/d' |sed 's/bw=//g' |sed 's/ //g' >r1.log
       grep " fio_randrw_${op}_${i_depth} " * -A4 |grep read -A1 |awk -F, '{print $3}' |sed '/^$/d' |sed 's/iops=//g' |sed 's/ //g' >r2.log
       grep " fio_randrw_${op}_${i_depth} " * -A4  |grep read -A1 |grep 'lat' |awk -F'avg=' '{print $2}' |sed '/^$/d' |sed 's/avg=//g' |sed 's/ //g' >r3.log
       
       grep " fio_randrw_${op}_${i_depth} " *.log.* -A4 |grep write -A1 |awk -F, '{print $2}' |sed '/^$/d' |sed 's/bw=//g' |sed 's/ //g' >w1.log
       grep " fio_randrw_${op}_${i_depth} " *.log.* -A4 |grep write -A1 |awk -F, '{print $3}' |sed '/^$/d' |sed 's/iops=//g'|sed 's/ //g' >w2.log
       grep " fio_randrw_${op}_${i_depth} " *.log.* -A4  |grep write -A1 |grep 'lat' |awk -F'avg=' '{print $2}' |sed '/^$/d' |sed 's/ //g' >w3.log
       convert_bw r1
       convert_bw w1
       convert_lat r3
       convert_lat w3
       file_to_array r1 r2 r3 w1 w2 w3
       for((i=0;i<${#r1_array[@]};i++))
       do
	  if [ $i -eq 0 ]; then
		>fio_randrw_${op}_${i_depth}.xx
		#echo -e "read\tread\tread\twrite\twrite\twrite">fio_randrw_${op}_${i_depth}.xx
		#echo -e "bw(KB/s)\tiops\tlatency(msec)\tbw(KB/s)\tiops\tlatency(msec)" >>fio_randrw_${op}_${i_depth}.xx
		echo -e "${r1_array[$i]}\t${r2_array[$i]}\t${r3_array[$i]}\t${w1_array[$i]}\t${w2_array[$i]}\t${w3_array[$i]}" >>fio_randrw_${op}_${i_depth}.xx
	  else
		echo -e "${r1_array[$i]}\t${r2_array[$i]}\t${r3_array[$i]}\t${w1_array[$i]}\t${w2_array[$i]}\t${w3_array[$i]}" >>fio_randrw_${op}_${i_depth}.xx
	  fi

       done
    done
done

for op in ${seqRW[*]}
do
    for i_depth in ${ioDepth[*]}
    do
       grep " fio_seqrw_${op}_${i_depth} " * -A4 |grep read -A1 |awk -F, '{print $2}' |sed '/^$/d' |sed 's/bw=//g' |sed 's/ //g' >r1.log
       grep " fio_seqrw_${op}_${i_depth} " * -A4 |grep read -A1 |awk -F, '{print $3}' |sed '/^$/d' |sed 's/iops=//g' |sed 's/ //g' >r2.log
       grep " fio_seqrw_${op}_${i_depth} " * -A4  |grep read -A1 |grep 'lat' |awk -F'avg=' '{print $2}' |sed '/^$/d' |sed 's/avg=//g' |sed 's/ //g' >r3.log

       grep " fio_seqrw_${op}_${i_depth} " *.log.* -A4 |grep write -A1 |awk -F, '{print $2}' |sed '/^$/d' |sed 's/bw=//g' |sed 's/ //g' >w1.log
       grep " fio_seqrw_${op}_${i_depth} " *.log.* -A4 |grep write -A1 |awk -F, '{print $3}' |sed '/^$/d' |sed 's/iops=//g'|sed 's/ //g' >w2.log
       grep " fio_seqrw_${op}_${i_depth} " *.log.* -A4  |grep write -A1 |grep 'lat' |awk -F'avg=' '{print $2}' |sed '/^$/d' |sed 's/ //g' >w3.log
       convert_bw r1
       convert_bw w1
       convert_lat r3
       convert_lat w3
       file_to_array r1 r2 r3 w1 w2 w3
       for((i=0;i<${#r1_array[@]};i++))
       do
          if [ $i -eq 0 ]; then
		>fio_seqrw_${op}_${i_depth}.xx
                #echo -e "read\tread\tread\twrite\twrite\twrite">fio_seqrw_${op}_${i_depth}.xx
                #echo -e "bw(KB/s)\tiops\tlatency(msec)\tbw(KB/s)\tiops\tlatency(msec)" >>fio_seqrw_${op}_${i_depth}.xx
                echo -e "${r1_array[$i]}\t${r2_array[$i]}\t${r3_array[$i]}\t${w1_array[$i]}\t${w2_array[$i]}\t${w3_array[$i]}" >>fio_seqrw_${op}_${i_depth}.xx
          else
                echo -e "${r1_array[$i]}\t${r2_array[$i]}\t${r3_array[$i]}\t${w1_array[$i]}\t${w2_array[$i]}\t${w3_array[$i]}" >>fio_seqrw_${op}_${i_depth}.xx
          fi

       done
    done
done

