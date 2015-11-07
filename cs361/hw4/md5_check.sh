#!/bin/bash  

# run using sh md5_check <directory to check> <ip> <port>
# example:
# $ sh md5_check WWW localhost 8888

# DO NOT USE SLASHES, ONLY USE THE DIRECTORY NAME

root="$(pwd)"
local_dir=$1
temp_dir="$(date|md5)" # creates a unique temp directory

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
  curl -O -s localhost:8888/$local_dir/$i
  md5 $i >> remote.txt # remove local_dir from front
done

cd $root # at ROOT

############
# LOCAL WORK
############
# go into local directory and 
# md5 each file
cd $local_dir

# md5 each local file in that array
for i in "${array[@]}"
do
  md5 $i >> $root/$temp_dir/local.txt # remove local_dir from front
done

cd $root # at ROOT

###############
# DO COMPARISON
###############
cd $temp_dir
# comapre all local files with 
# downloaded files
# no output is good!
diff remote.txt local.txt

cd $root # at ROOT

# clean up
rm -rf $temp_dir
