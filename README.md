Description
===========
OpenJDK cookbook is intended to assist in creating a VM box for building OpenJDK from source code. Currently this chef recipe supports Ubuntu 12.04 only.

More work needs to be done to bring to provide support to muliple OS. Please feel free to repot for errors/bugs, suggetion/improvements and will try to improve this recipe.

Instructions below are only available for Linux at the moment, but such a VM box can be built on any OS of choice that support the below programs and instructions.

Requirements
============
- Installed VirtualBox (https://www.virtualbox.org/) - The build was done with version 4.2.8 
- Installed Vagrant (http://docs.vagrantup.com/v2/installation/index.html) -

Usage
=====

### Linux

Follow the below instructions in order to able to use this repo (the cookbook & recipes in this repo) to build and update your OpenJDK VM running on Ubuntu using VirtualBox.

 1) Download Virtualbox 4.2.xx (this version is necessary for Vagrant to run correctly) from:
    
    https://www.virtualbox.org/wiki/Download_Old_Builds_4_2

 2) Install Vagrant using the below command:
    
    sudo apt-get install vagrant 
    (this would replace your higher version of virtualbox with virtualbox 4.1)

   in case you wish to not get into the above tangle, please download vagrant from

    http://www.vagrantup.com/downloads.html (vagrant_1.4.2_x86_64.deb)

 3) Download the repo from https://github.com/AdoptOpenJDK/openjdk-chef-build by running the below command:

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

 9) Update the VM by running the below command:

    sudo apt-get update

10) Shutdown the box using the below command:

    vagrant halt

11) To start all over again, destroy the box created and restart by starting vagrant again

    vagrant destroy
    vagrant up

Once the box is ready to use in future you can start up the Ubuntu VM with vagrant using:

``'vagrant up'``

Vagrant is running chef cookbooks recipies to perform following tasks : 

- perform system update and upgrade (sudo apt-get update)
- download all the necessary packages and modules to be able to house OpenJDK sources 
- download and configure OpenJDK sources
- build the OpenJDK sources (done as part openjdk-chef-build recipe )
- download and build JTReg sources 
- optional script to run JTReg tests 


TODO
====
a) The jtreg recipe should not download   
    
     http://www.java.net/download/openjdk/jtreg/promoted/4.1/b05/jtreg-4.1-bin-b05_29_nov_2012.zip 
    
   anymore but instead from 
    
     https://adopt-openjdk.ci.cloudbees.com/job/jtreg/lastSuccessfulBuild/artifact/ 
    
   and pickup the latest file gz.tar file and do the rest of the untar-ring, setting up, installing.

b) Errors when running ```make test``` from CLI, hence the below need to be set manually or via recipe:

    export SOURCE_CODE=$HOME/sources
    export JTREG_INSTALL=$HOME/jtreg
    export JT_HOME=$JTREG_INSTALL
    export PRODUCT_HOME=$SOURCE_CODE/jdk8_tl/build/linux-x86_64-normal-server-release/images/j2sdk-image/
    export JPRT_JTREG_HOME=${JT_HOME}
    export JPRT_JAVA_HOME=${PRODUCT_HOME}=
    export JTREG_TIMEOUT_FACTOR=5
    export CONCURRENCY=auto
    
    PRODUCT_HOME will need some handy regex or sed work!

Note
====
Currently Vagrant is using two recipes: 
- "openjdk-build" - the original conntent of this repository
- "apt" - git submodule to perform system updates    
``'git submodule add git@github.com:opscode-cookbooks/apt.git cookbooks/apt'``


Additional resources
====================
Ready to use vagrant boxes: http://www.vagrantbox.es/
