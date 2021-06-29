id=$1
ssh_file=$2
ssh_key=$(cat $ssh_file)
env=$3
profile=$4

rm user.json 2>/dev/null
rm user_data_bag_secret 2>/dev/null

aws s3 cp s3://acq-"$env"-bootstrap.cfcore.net/chef/user_data_bag_secret ./ --profile $profile

cat > user.json <<- EOM
  {
    "id": "$id",
    "shell": "/bin/bash",
    "ssh_key": "$ssh_key",
    "groups": [
      "wheel"
    ],
    "comment": "Outside collaborator"
  }
EOM

knife data bag from file "$env"_acquiring_users user.json --secret-file user_data_bag_secret

#echo "User Added. Showing Users..."

knife data bag show "$env"_acquiring_users