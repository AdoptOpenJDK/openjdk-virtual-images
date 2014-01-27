Description
===========
OpenJdk cookbook is intended to assist in building OpenJdk from source code. Currently this chef recipe support ubuntu 12.04.1.
In current state recipie is immature and work is done to bring it to more stable state and to provide support to muliple OS. Please feel free to repot for errors/bugs, suggetion/improvements and will try to improve this recipe

Requirements
============
This cookbook uses "Mercurial" cookbook from opscode community to support mercurial feature in chef and is used to pull / clone data from mercurical repository.

Also in order to build OpenJDK from source code, it is required to have JDK 7 installed and enviornment variable need to be set.

Attributes
==========
Defines directory structure and link to source code.

Usage
=====
Register you client node to chef-server and run chef-client command.

