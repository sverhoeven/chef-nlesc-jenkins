# nlesc-jenkins cookbook

Application (wrapper) cookbook for Jenkins server and node for Netherlands eScience Center.

# Requirements

## Data bags

* A encrypted data bag called 'github' with item `user` with a `ssh_private_key` and 'ssh_public_key` key.
* A encrypted data bag called 'xenon' with item `user` with `name`, `password_hash`, `password`, `ssh_private_key`, `ssh_public_key` and `ssh_keys` keys. Example:

    {
      "id": "user",
      "name": "octopus",
      "password_hash": "<paste encrypted password here, made with `openssl passwd -1 plaintextpassword`",
      "password": "<paste clear text password here>",
      "ssh_private_key": "<paste ssh private key here>",
      "ssh_public_key": "<paste ssh public key here>",
      "ssh_keys": [
        "< List of public keys for in ~/.ssh/authorized_keys>"
      ]
    }


It can be created with:

  knife data bag create --secret-file ~/vmbuilder/encrypted_data_bag_secret xenon user

And stored into git in encrypted form using:

  knife data bag show xenon user -Fj > data_bags/xenon/user.json

To edit use:

  knife data bag edit --secret-file ~/vmbuilder/encrypted_data_bag_secret -Fj xenon user
  # do not to forget to save changes back in git

# Usage

# Attributes

* `node['nlesc-jenkins']['github']['user]'` - Username to which to add ssh key. Default is `jenkins`.
* `node['nlesc-jenkins']['github']['group']` - Group to which chgrp the ssh key. Default is `jenkins`.
* `node['nlesc-jenkins']['rdkit']['version']` - Version of RDKit to install.
* `node['nlesc-jenkins']['rdkit']['folder']` - Folder on RDKit sourceforge to download tarball from.
* `node['nlesc-jenkins']['senchacmd']['version']` - Version of SenchaCmd to install.
* `node['nlesc-jenkins']['senchacmd']['prefix']` - Location to install SenchaCmd.
* `node['nlesc-jenkins']['xenon']['config']` - Hash of xenon test configuration key/value pairs. See https://github.com/NLeSC/Xenon/blob/develop/test/xenon.test.properties.examples.

# Recipes

## Server

The server recipe will install a Jenkins build server.

## Node

The node recipe will install a Jenkins node (or slave).
It will install all requirements to build NLeSC projects.

## Github

Adds a private key from a encrypted data bag to ~jenkins-node/.ssh and modifies ~jenkins-node/.ssh/config to use that private key for github.com.
The public key should be registered at github.com to have pull rights on the private repos jenkins must build.

The recipe requires the user and it's home dir to exist.

## SenchaCmd

This recipe installs SenchaCmd.

## RDKit

This recipe installs RDKit with inchi suppport.
RDKit has to be compiled as RDKit from distro are missing inchi support.

## Xenon

This recipe makes a test account and config file for running the Octopus testsuite.

It also disables hashing of known hosts and automaticly accepts new host keys.

# Author

Author:: Netherlands eScience Center (<info@esciencecenter.nl>)
