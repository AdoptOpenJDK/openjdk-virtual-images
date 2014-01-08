openjdk-virtual-images
======================

Virtual Images and the infrastructure that builds them for the Adopt OpenJDK programme.

See the [Wiki](https://github.com/AdoptOpenJDK/openjdk-virtual-images/wiki) for Documentation!

# Current Progress
Progress to date is that we have a valid packer.io template set which can create a VirtualBox image as well as a base box that can be maniuplated by Vagrant for OpenJDK development. As we want folks to be able to control this image through Vagrant, we need to add a post-processing step to create\add a base `Vagrantfile`.

After that we'll provide multiple `Vagrantfile` configurations for folks with different host machine capabilities.

Finally we need to merge in the great Chef work done by Andrejz & Co

The documentation in the wiki allows you to follow to that point.

