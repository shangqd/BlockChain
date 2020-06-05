cd ./logs-collector
for dir in $(ls)
do
	echo $dir 
	cat $dir | grep -E "Error|err"
done
