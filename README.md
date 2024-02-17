# OpenPLC_EtherCAT
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
sudo apt-get update
sudo apt-get install udev
sudo apt-get install libxml2-dev
sudo apt-get install autoconf
sudo apt-get install libtool
to install ethercat capable branch of OpenPLC
git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd OpenPLC_v3

**ethercat_src is arranged as submodules so these need to be fetched**
git submodule init
git submodule update
cd utils/ethercat_src

git submodule init
git submodule update
cd external/ethercat
**now Etherlabs IgH EtherCAT master needs to be built and installed**
./bootstrap
./configure --sysconfdir=/etc --enable-8139too=no
make
make modules

sudo make install
sudo make modules_install install
sudo depmod


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

At this point, OpenPLC may be built and installed
cd to OpenPLC_v3 source folder and ./install.sh linux ethercat to install OpenPLC along with ethercat_src

