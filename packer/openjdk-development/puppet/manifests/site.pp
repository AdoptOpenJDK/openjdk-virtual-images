node 'packer-virtualbox-iso' {
  include openjdk::packages
  include openjdk::ruby
  include openjdk::chef
}
