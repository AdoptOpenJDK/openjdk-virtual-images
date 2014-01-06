Description
===========
OpenJdk cookbook is intended to assist in building OpenJdk from source code. Currently this chef recipe support ubuntu 12.04.1.
In current state recipie is immature and work is done to bring it to more stable state and to provide support to muliple OS. Please feel free to repot for errors/bugs, suggetion/improvements and will try to improve this recipe

Requirements
============
- Installed VirtualBox (https://www.virtualbox.org/) - The build was done with version 4.2.8 
- Installed Vagrant (http://docs.vagrantup.com/v2/installation/index.html) -

Usage
=====
Start up ubuntu with vagrant using:
``'vagrant up'``

Vagrant is running chef cookbooks recipies to perform following tasks : 

- perform system update and upgrade (sudo apt-get update)
- download all the necessary packages and modules to be able to house OpenJDK sources 
- download and configure OpenJDK sources
- build the OpenJDK sources (done as part openjdk-chef-build recipe )
- download and build JTReg sources 
- optional script to run JTReg tests 


Note
====
Currently Vagrant is using two recipes: 
- "openjdk-build" - the original conntent of this repository
- "apt" - git submodule to perform system updates    
``'git submodule add git@github.com:opscode-cookbooks/apt.git cookbooks/apt'``


Additional resources
====================
Ready to use vagrant boxes: http://www.vagrantbox.es/

