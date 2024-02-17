EtherCAT connection with OpenPLC


**Key Functions and Their Purposes:**
EtherCATinit: Initializes EtherCAT communication, sets up the master, and configures the slaves.
RegisterRxInDomain and RegisterTxInDomain: Registers the PDOs in the EtherCAT domain.
ConfigureSlave: Configures the slave settings, including PDOs and synchronization.
PlcInputOutputPrintout: Prints PLC Input and Output configurations for linking with the PLC program.
EtherCATcyclic: Handles cyclic EtherCAT communication, including reading inputs, writing outputs, and sending/receiving process data.
check_domain1_state and check_master_state: Monitor the state of EtherCAT domains and the master.
terminate_handler: Cleanup function to release allocated resources upon termination.

**Setup instructions**
Dependencies: 

`sudo apt-get update
sudo apt-get install udev
sudo apt-get install libxml2-dev
sudo apt-get install autoconf
sudo apt-get install libtool
to install ethercat capable branch of OpenPLC
git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd OpenPLC_v3`````

**ethercat_src is arranged as submodules so these need to be fetched**

`git submodule init
git submodule update
cd utils/ethercat_src

git submodule init
git submodule update
cd external/ethercat```

**now Etherlabs IgH EtherCAT master needs to be built and installed**

`./bootstrap
./configure --sysconfdir=/etc --enable-8139too=no
make
make modules

sudo make install
sudo make modules_install install
sudo depmod
```

**Configure the ethernet adapter**
configured to correct ethernet adapter, first figure out mac address of interface you wish to use (ifconfig)
and then configure ethercat
set correct mac address to MASTER0_DEVICE="xx:xx:xx:xx:xx:xx" and set DEVICE_MODULES="generic" unless you have a native driver available save the file and exit
a device reboot at this point is recommended
After startup etherlabs master should be running, this can be verified by ls /dev/EtherCAT0 and by information from sudo ethercat master which shows the state of the master interface. ethercat --help for more information.
if EtherCAT0 doesn't run, try to start it with
systemctl start ethercat   # For systemd based distro
/etc/init.d/ethercat start # For init.d based distro


**Install the OpenPLC**
sudo ethercat rescan and sudo ethercat xml obtains ethercat slave configuration which needs to be given to ethercat_src

**At this point, OpenPLC may be built and installed**
cd to OpenPLC_v3 source folder and ./install.sh linux ethercat to install OpenPLC along with ethercat_src

ethercat_src is controlled by conf files, in the OpenPLC folder OpenPLC_v3/utils/ethercat_src/build/ethercat.cfg are the main options

xml file is the previously mentioned slave configuration.

Now OpenPLC can be started, on startup OpenPLC will print out (also in web ide) the pdos - input / output variables it has on ethercat

e.g.

`Slave0_2nd_Send_PDO_Maping2_StatusRegister AT %IW0.0 : UINT; (* SD700_ECAT_V1.2_G *)
Slave0_2nd_Send_PDO_Maping2_ActualPosition AT %ID1.0 : DINT; (* SD700_ECAT_V1.2_G *)
Slave0_2nd_Send_PDO_Maping2_ActualVelocity AT %ID2.0 : DINT; (* SD700_ECAT_V1.2_G *)
Slave0_2nd_Recive_PDO_Maping_ControlRegister AT %QW0.0 : UINT; (* SD700_ECAT_V1.2_G *)
Slave0_2nd_Recive_PDO_Maping_TargetVelocity AT %QD1.0 : DINT; (* SD700_ECAT_V1.2_G *)
Slave0_2nd_Recive_PDO_Maping_Modes_of_operation AT %QB2.0 : BYTE; (* SD700_ECAT_V1.2_G *)```

![Screenshot from 2024-02-17 23-01-50](https://github.com/LRAJA33/OpenPLC_EtherCAT/assets/105126037/7aa38421-2fbb-4576-ab2f-f7dca8cfdb39)
If everything goes well then EtherCAT status will progress like so

4 slave(s).
AL states: PREOP.
Link is up.
Domain1: WC 3.
Domain1: State 1.
Domain1: WC 4.
Domain1: WC 5.
Domain1: WC 7.
Domain1: State 2.
AL states: OP.
WC or Working Counter is incremented each time a device successfully reads or writes from the datagram and as such is diagnostic indicator to show all the configured slaves recieved and sent their data. Correct WC value depends on how many and which devices are configured.

Domain1: State 2. is good state

AL states: OP. means all slave devices are operational

Advanced devices
Some devices like many servo drives will not start up unless they are correctly configured, which involves Service Data Objects

OpenPLC and ethercat_src provide no means to configure SDOs, but IgH EtherCAT master does

For example, running the following script before starting OpenPLC prepares EL7047 stepper driver in pos 4 for OP mode, it will not enter OP mode without this configuration

`ethercat states preop
sleep 3
ethercat download -p 4 -t uint16 0x10f3 5 0x0000
ethercat download -p 4 -t uint32 0xf081 1 0x00100000
ethercat download -p 4 -t uint8 0x1c12 0 0x00
ethercat download -p 4 -t uint8 0x1c13 0 0x00
ethercat download -p 4 -t uint16 0x1c12 1 0x1600
ethercat download -p 4 -t uint16 0x1c12 2 0x1602
ethercat download -p 4 -t uint16 0x1c12 3 0x1604
ethercat download -p 4 -t uint16 0x1c13 1 0x1a00
ethercat download -p 4 -t uint16 0x1c13 1 0x1a03
ethercat download -p 4 -t uint8 0x1c12 0 0x03
ethercat download -p 4 -t uint8 0x1c13 0 0x02`
The specific list of parameters and in which order they have to be written is device specific, one way to determine correct configuration is to set the device up in TwinCAT or other commercial EtherCAT capable PLC software and copy the configuration from there.
