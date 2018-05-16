# Using the Scripts - Public-Routed Network

The primary expected use case for these scripts is in a network that is able to to reach Internet-hosted resources. In such usage-contexts, the tools would typically be executed similarly to:

1. Launch an AMI to act as a build host
2. Attach a 1GiB EBS to the build host
3. Attach a 20GiB EBS to the build host
4. Login to the build host and escalate privileges to root
5. Clone this project to the build host (make sure the destination filesystem allows script-execution)
6. Execute the following sequence:

~~~
    cd /PROJECT/CLONE/PATH ; \
      ./DiskSetup.sh -b /boot -v vg01 -d /dev/xvdb -p /dev/xvdc ; \
      ./MkChrootTree.sh	/dev/xvdb /dev/xvdc ; \
      ./MkTabs.sh /dev/xvdb ; \
      ./ChrootBuild.sh ; \
      ./AWScliSetup.sh ; \ # currently broken
      ./ChrootCfg.sh ; \
      ./GrubSetup.sh /dev/xvdb ; \
      ./NetSet.sh ; \
      ./CleanChroot.sh ; \
      ./PreRelabel.sh	 ; \
      ./Umount.sh
~~~

Once the above sequence exits successfully, an AMI may be created from the target-disk (/dev/xvdb in the example above):

1. Shut down the build-host
1. Detach boot EBS
1. Detach build-EBS
1. Re-attach build-EBS to boot EBS's original location
1. Create or register an AMI:
    * If you wish to inherit an attribute like a [`billingProducts` tag](https://thjones2.blogspot.com/2015/03/so-you-dont-want-to-byol.html), use the `register-image` AMI-creation method to create an AMI from the stopped image.
    * If you wish to ensure that the AMI does not inherit an attribute like a `billingProducts`, create a snapshot of the boot EBS and use the `create-image` AMI-creation method to create an AMI from the snapshot.
1. Launch a test-instance from the newly-created AMI and verify that it functions as expected.

The OS-specific components can be further automated by using frameworks like [Packer](https://www.packer.io/). One such project that does this is Plus3 IT's [spel](https://github.com/plus3it/spel) project.
