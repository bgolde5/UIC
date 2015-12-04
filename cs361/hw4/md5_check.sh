#!/bin/bash  

# run using sh md5_check <directory to check> <ip> <port> <md5-type>
# example:
# OSX: $ bash md5_check.sh WWW localhost 8888 md5
# LINUX: $ bash md5_check.sh WWW localhost 8888 md5sum
 

# DO NOT USE SLASHES, ONLY USE THE DIRECTORY NAME

root="$(pwd)"
local_dir=$1
temp_dir=temp_dir
ip=$2
port=$3

# store all files in your local_dir directory
# in an array
cd $local_dir
shopt -s nullglob
array=(*.*)
shopt -u nullglob

cd $root # at ROOT

#############
# REMOTE WORK
#############
# create a temp directory to store files in
# and go into that directory
mkdir $temp_dir
cd $temp_dir

# download each file in that array 
# from your server
# also perform md5 and store the result
for i in "${array[@]}"
do
  if [ $4 = md5 ]; then
    #curl -O -s $ip:$port/$local_dir/$i
    curl -O -s $ip:$port/$i
  else
    #wget $ip:$port/$local_dir/$i
    wget $ip:$port/$i
  fi

  $4 $i >> remote_files.txt
done

cd $root # at ROOT

touch md5_output.txt
echo "----------------------" >> md5_output.txt
echo "MD5 FOR DOWNLOADED FILES" >> md5_output.txt
echo "----------------------" >> md5_output.txt
cat $temp_dir/remote_files.txt >> $root/md5_output.txt


############
# LOCAL WORK
############
# go into local directory and 
# md5 each file
cd $local_dir

# md5 each local file in that array
for i in "${array[@]}"
do
  $4 $i >> $root/$temp_dir/local_files.txt # remove local_dir from front
done

cd $root # at ROOT

echo "----------------------" >> md5_output.txt
echo "MD5 FOR LOCAL FILES" >> md5_output.txt
echo "----------------------" >> md5_output.txt
cat ./$temp_dir/local_files.txt >> $root/md5_output.txt

###############
# DO COMPARISON
###############
cd $temp_dir
# comapre all local files with 
# downloaded files
diff remote_files.txt local_files.txt >> diff_output.txt

if [ -s diff_output.txt ] ; then
  echo "Your md5 sums don't match up."
  cat diff_output.txt
else
  echo "Your server served files perfectly from $local_dir!"
  echo "View the results in md5_output.txt"
fi

cd $root # at ROOT

# clean up
rm -rf $temp_dir
