Description
===========
OpenJDK cookbook is intended to assist in creating a VM box for building OpenJDK from source code. Currently this chef recipe supports Ubuntu 12.04 only (Guest OS).

More work needs to be done to provide support to muliple OS. Please feel free to report for errors/bugs, suggestion/improvements and will try to improve this recipe.

Instructions below are only available for Linux and MacOS at the moment, but such a VM box can be built on any OS of choice that support the below programs and instructions.

WARNING
=======
<b>The below are under rapid change and so please talk to the adopt-openjdk mailing list (adopt-openjdk@googlegroups.com) first before going about with the below.</b>


Requirements
============
- Installed VirtualBox (https://www.virtualbox.org/) - The build was done with version 4.2.8 
- Installed Vagrant (http://docs.vagrantup.com/v2/installation/index.html)
- <b>These instructions expect a 64-bit CPU running a 64-bit OS for a successful build.</b>


Known Issue on Mac OS
=====================
The below Vagrant file entry causes the vagrant startup process to fail under MacOS Snow Leopard and MacOS Lion:

         vb.customize ["modifyvm", :id, "--memory", "4096"]
         
Couple more reasons for the above failing are:
* your system does not have the necessary free memory (4GB) at the time of execution
* your system does not have the physical memory (4GB) at the time of execution

This issue is resolved by commenting out this line (Ruby commenting convention: #) and re-running:

         vagrant up


Usage
=====

Follow the below instructions in order to able spin off an VM running Ubuntu (Guest OS) with OpenJDK sources on it, running on the below Host OSes.

### Linux / MacOS

 1) Download least version of Virtualbox 4.3.xx (or higher) for your Host OS.

 2) Download least version of Vagrant 1.4.xx (or higher) for your Host OS.

 3) Finally clone the repo from https://github.com/AdoptOpenJDK/openjdk-chef-build:

    git clone https://github.com/AdoptOpenJDK/openjdk-chef-build

 4) Install chef as vagrant's plugin by running the below command:

    sudo vagrant plugin install vagrant-chef-apply
    [sudo] password for xxxxxxx: 
    Installing the 'vagrant-chef-apply' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-chef-apply (0.0.1)'!

 5) Check contents of the cookbooks folders and subfolders, both apt and openjdk-build should be populated with files.

 6) In case the cookbooks/apt folder is empty then do the below from within the openjdk-chef-build folder:

    rm -fr cookbooks/apt
    git rm --cached cookbooks/apt
    git submodule add git@github.com:opscode-cookbooks/apt.git cookbooks/apt
    
 If this still does not download the contents, do the below:
 
    cd cookbooks
    git clone git@github.com:opscode-cookbooks/apt.git
    

 7) Bring up the box (first time) by running the below command, which should create and install necessary components:
    
    vagrant up	
    
   And you should see the below, give it some time (a hour or so)....
   
    ###################################################
    Bringing machine 'default' up with 'virtualbox' provider...
    .
    .
    .

    Running chef-solo...
    stdin: is not a tty
    [2014-01-06T21:28:54+00:00] INFO: *** Chef 11.4.0 ***

    [2014-01-06T23:05:45+00:00] INFO: Chef Run complete in 5810.238662085 seconds
    [2014-01-06T23:05:45+00:00] INFO: Running report handlers
    [2014-01-06T23:05:45+00:00] INFO: Report handlers complete
    [2014-01-06T23:05:45+00:00] DEBUG: Exiting
    ###################################################

 8) Now you can ssh to the VM by running:

    vagrant ssh
    or
    vagrant ssh -p -- -l openjdk

 9) Update the VM by running the below command:

    sudo apt-get update

10) Shutdown the box using the below command:

    vagrant halt

11) To start all over again, destroy the box created and restart by starting vagrant again

    vagrant destroy
    vagrant up

12) Login and password details

    login: openjdk
    password: openjdk

13) When in the box, to switch between OpenJDK8 and OpenJDK9, use the below command:

    switchToJDK8 - to switch to OpenJDK8 environment variable settings
    or 
    switchToJDK9 - to switch to OpenJDK9 environment variable settings

Once the box is ready to use in future you can start up the Ubuntu VM with vagrant using:

``'vagrant up'``

In case a process has been abruptly terminated or wish to continuing a executing recipes on an active vagrant machine, do the below:

``'vagrant provision'``


Vagrant is running chef cookbooks recipies to perform following tasks : 

- perform system update and upgrade (sudo apt-get update)
- download all the necessary packages and modules to be able to house OpenJDK sources 
- download and configure OpenJDK sources
- build the OpenJDK sources (done as part openjdk-chef-build recipe, both OpenJDK8 and OpenJDK9)
- download JTReg binaries
- setting the environment variables
- optional script to run JTReg tests 
- facility to switch between OpenJDK8 and OpenJDK9

Note
====
- "openjdk-build" - OpenJDK cookbook
- "apt" - git submodule to perform system updates
``'git submodule add git@github.com:opscode-cookbooks/apt.git cookbooks/apt'``
- So far the above have been tested on Host OSes: Ubuntu 12.04, MacOS Lion, MacOS Snow Leopard and Mavericks


Additional resources
====================
Ready to use vagrant boxes: http://www.vagrantbox.es/
