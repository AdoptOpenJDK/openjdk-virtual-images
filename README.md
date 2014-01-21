openjdk-virtual-images
======================

Virtual Images and the infrastructure that builds them for the Adopt OpenJDK programme.

See the [Wiki](https://github.com/AdoptOpenJDK/openjdk-virtual-images/wiki) for Documentation!

# Current Progress
Progress to date is that we have a valid packer.io template set which can create a VirtualBox image as well as a base box that can be manipulated by Vagrant for OpenJDK development. As we want folks to be able to control this image through Vagrant, we are now using the to use a base `Vagrantfile` in the openjdk-chef-build project.

After that we'll provide multiple `Vagrantfile` configurations for folks with different host machine capabilities.

We will then merge in the great Chef work done by Andrejz & Co

Finally, Murali et al will tighten up the whole process using Puppet and other devops pro techniques.

The documentation in the wiki allows you to follow current progress.

