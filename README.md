openjdk-virtual-images
======================

Virtual Images and the infrastructure that builds them for the Adopt OpenJDK programme.

See the [Wiki](https://github.com/AdoptOpenJDK/openjdk-virtual-images/wiki) for Documentation!

# Current Progress
Progress to date is that we have a valid Veewee definition set which can create a base box, which in turn can be exported to a virtual image. In our case we're exporting to OVF format for VirtualBox/Vagrant compatibility.

The documentation in the wiki allows you to follow to that point.

I've held off committing various Vagrant/Base Box config as it looks like we'll have to swap to using packer.io.

