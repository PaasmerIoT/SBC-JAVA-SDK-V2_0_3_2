trap ctrl_c INT
ctrl_c() {
        echo "** traped CTRL_C"
        stty echo
        exit
}

if [ -f src/main/resources/com/paasmer/devicesdkjava/util/config.properties ] ; then 
	username=$(sudo cat src/main/resources/com/paasmer/devicesdkjava/util/config.properties | grep "userName" | awk '{print $3}' | tr -d '"')
	echo $username
	device=$(sudo cat src/main/resources/com/paasmer/devicesdkjava/util/config.properties | grep "deviceName" | awk '{print $3}' | tr -d '"')
        echo $device
else
	read -p "$(echo  'Enter the Registered Email ID:\n\b')" username
	read -r -p "$(echo 'Enter the Devicename for which the Credentials are to be downloaded:\n\b')" device

fi	

# Dowloading Certs
download()
{
	echo "in download"
	echo $auth
	token=$(echo $auth | grep "token" | jq -r '.token')
	echo $token
	url=$(curl -X GET -i -H "Authorization: Bearer $token" https://developers.paasmer.co/api/device/downloadconfigfile/$device | grep "success")
	echo $url
	status=$(echo $url | grep "success" | jq -r '.success')
	if [ $status = true ]; then
		URL=$(echo $url | grep "filepath" | jq -r '.filepath')
		wget -O config.zip $URL
      		sudo unzip config.zip
		if [ -f config.h ] || [ -f config.py ] ; then 
			echo " You Have entered a Different Language SDK, Please enter Java SDK Device"
			if [ -f config.h ]; then
				sudo rm config.h
			elif [ -f config.py ]; then
				rm config.py
			fi	
			if [ -f $device-certificate.pem.crt ] || [ -f $device-private.pem.key ] ; then
				sudo rm $device-certificate.pem.crt
				sudo rm $device-private.pem.key
			fi
			exit
		fi
		if [ -f ./src/main/resources/com/paasmer/devicesdkjava/util/$device-certificate.pem.crt ] || [ -f ./src/main/resources/com/paasmer/devicesdkjava/util/$device-private.pem.key ]; then
	       		echo " Certificates are alredy Present for this device, Updating config file"
			sudo rm $device-certificate.pem.crt
			sudo rm $device-private.pem.key
			sudo mv config.properties src/main/resources/com/paasmer/devicesdkjava/util/  
			
		 else
			if [ -f $device-certificate.pem.crt ] || [ -f $device-private.pem.key ] ; then
				sudo mv  $device-certificate.pem.crt src/main/resources/com/paasmer/devicesdkjava/util/$device-certificate.pem.crt
				sudo mv  $device-private.pem.key src/main/resources/com/paasmer/devicesdkjava/util/$device-private.pem.key
				sudo mv config.properties src/main/resources/com/paasmer/devicesdkjava/util/
			else 
				echo " This Device is registered from SBC,only config file is downloaded"
			fi
		fi
	
	else
		echo "Device not found"
	fi
	if [ -f config.zip ]; then
		sudo rm config.zip
	fi
}

# Verification and Auth
getting_unique()
{
	realcounts=$(curl --data "deviceName="$device"&email="$username"" http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmerv2DevAvailability.php)
	if [ $realcounts = "devicename_accepted" ] ; then
        	echo "DeviceName doesn't match with the Username"
        	exit
	elif [ $realcounts = "devicename_already_there_for_this_user" ] ; then
	        
		stty -echo
		read -p "Please enter your Paasmer Password: " password
		stty echo	
		auth=$(curl -H "Content-Type: application/json" -X POST -d '{"email":"'$username'","password":"'$password'"}' https://developers.paasmer.co/api/auth/login)
		
		response=$(echo $auth | grep "success" | jq -r '.success')
	
		if [ $response = true ] ; then
			download
		else
			echo "***** Incorrect Password *****"
			read -r -p "Do you want to continue with Different Password ?? [y/n] " status
        		echo " "
        		echo $status
        		if [ $status = "y" ] ; then
				stty -echo
	         	       read -p "$(echo 'Enter the Password\n\b')" password
				stty echo 
				auth=$(curl -H "Content-Type: application/json" -X POST -d '{"email":"'$username'","password":"'$password'"}' https://developers.paasmer.co/api/auth/login)
				response=$(echo $auth | grep "success" | jq -r '.success') 
				if [ $response = true ] ; then 
					download  
				else 
					echo "***** Incorrect Password *****"
					exit 
				fi
			else
                		exit
			fi
		fi	
	fi
}


#Device name Verification
getting_devicename ()
{
	if [ ${#device} != 0 ] ; then
        	getting_unique
	else
        	getting_devicename
	fi

}


# Verifing User 
usercount=$(curl --data "UserName="$username"" http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmerv2UserVerify.php)
if  [ $usercount = 1 ]; then
	echo "UserName exists, Collecting DeviceName"
	getting_devicename
else 
	echo "User not Registered"
	echo "**********************"
	echo "Please Register to our PaasmerIoT platform at https://developers.paasmer.co/"
	exit
fi
