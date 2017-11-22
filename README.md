# SBC-JAVA-SDK-v2_0_3_2
**Paasmer IoT SDK** for Single Board Computers Running Linux

## Overview

The **Paasmer SDK** for **Single Board Computers (SBC)** like Raspberry-PI is a collection of source files that enables you to connect to the Paasmer IoT Platform. It includes the transport client for **MQTT** with **TLS** support.  It is distributed in source form and intended to be built into customer firmware along with application code, other libraries and RTOS.

## Features

The **SBC-JAVA-SDK-v2_0_3_2** simplifies access to the Pub/Sub functionality of the **Paasmer IoT** broker via **MQTT**. The SDK has been tested to work on the **Raspberry Pi 3** running Raspbian Jessie. Support for Other SBC's running any flavours of Linux would be available shortly.

## MQTT Connection

The **SBC-JAVA-SDK-v2_0_3_2** provides functionality to create and maintain a mutually authenticated TLS connection over which it runs **MQTT**. This connection is used for any further publish operations and allow for subscribing to **MQTT** topics which will call a configurable callback function when these topics are received.

## Pre Requisites

Registration on the portal http://developers.paasmer.co is necessary to connect the devices to the **Paasmer IoT Platform** .The SDK has been tested on the Raspberry PI 3 with Raspbian Jessie (https://downloads.raspberrypi.org/raspbian_latest)

# Installation

* Download the SDK or clone it using the command below.

```
$ git clone github.com/PaasmerIoT/SBC-JAVA-SDK-V2_0_3_2.git
$ cd SBC-JAVA-SDK-V2_0_3_2
```

* To install dependencies, follow the commands below

```
$ chmod 777 ./*
$ sudo ./install.sh
$ sudo reboot
```
## Device registration

##### Using command line interface
* To connect the device to Paasmer IoT Platform, run the below command under root directory of an SDK

```
$ sudo ./deviceRegistration.sh
```


* Go to the diectory below.
```
$ cd src/main/resources/com/paasmer/devicesdkjava/util/
```

* Edit the config.properties file to include feed names and Wiring Pi pin details.
```java

feed = [{"name":"javafeed1","type":"sensor","pin":3},{"name":"javafeed2","type":"actuator","pin":5}]

```
* Redirect back to the main directory and continue the Execution procedure.
##### Using web interface
* Login to http://developers.paasmer.co/, create a device and fill the feed details.
* Click on `save` icon to save changes. 
* After completion, Go to the `SDK` directory and run the command below.

```
sudo ./Update.sh
```
* This will ask for the UserName, DeviceName and Password. Give the DeviceName which is created in the Web UI.
* This will automatically download the necessary credentials and the config file, and place them in the respective directory.

# Execution
 Compiling the code and generate the output file. 
```
$ mvn clean package
```

 After successful compilation, Run the code using the command below.
```
$ java -cp target/sbc-java-sdk-2.0.3.2-SNAPSHOT.jar com.paasmer.devicesdkjava.App
```
The device would now be connected to the Paasmer IoT Platform and publishing sensor values are specified intervals.

*User can update the feed details for any Device in the WeB UI followed by running the below command`*
```
sudo ./Update.sh
```

## Support
The support forum is hosted on the GitHub, issues can be identified by users and the Team from Paasmer would be taking up requests and resolving them. You could also send a mail to support@paasmer.co with the issue details for a quick resolution.

## Note:

The Paasmer IoT SBC-JAVA-SDK-v2_0_3_2 utilizes the features provided by AWS-IOT-SDK for java.
