## Managment of test VMs

Here are two main scripts presented:

- vm.sh
- update-vms.sh

Others are meant to work "under the hood".
While that's true, you must adjust some calls in *start-vms.sh* and *stop-vms.sh* scripts for your setup.
I'm expecting that for the most part, you'll need to edit the part of mounting drives. I need that, you might either need too or not. But /dev/sdx paths won't be the same as mine for sure.

At the moment, *update-vms.sh* is basically one big hardcode. Will change that in the near future.
*setup-net.sh* is not tested at all and most likely doesn't work.
*net-config* directory contains some basic setup for my DHCP and DNS VMs.

### Working with *vm.sh*

The script invokes either the start or stop script.
The start script accepts *ALL*, *NET* or filename arguments. You should pass *filename* when you have a .env, .txt or alike file in the base directory (where the script lies) that contains names of some VMs row by row.
For example:

```plaintext
-rw-r--r--. 1 user user   41 May  4 13:46 project-vms.env
drwxr-xr-x. 1 user user   32 Apr 17 21:47 net-config
-rw-r--r--. 1 user user    0 May  4 14:01 README.md
-rw-r--r--. 1 user user 1.1K Apr 21 15:43 setup-net.sh
-rwxr-xr-x. 1 user user 1.6K May  4 13:58 start-vms.sh
-rwxr-xr-x. 1 user user 1.2K May  3 20:15 stop-vms.sh
-rwxr-xr-x. 1 user user 1.4K Apr 21 15:11 update-vms.sh
-rwxr-xr-x. 1 user user  835 Apr 18 03:36 vm.sh
```

In *project-vms.env* you should have something like:

```plaintext
dhcp01
dns01
db01
keycloak01
ipa01
env01
```

The order matches which VM will be started first. 

The, you just pass the filename as an argument to *vm.sh:*

```plaintext
./vm.sh start project-vms.env
```

Using **ALL** and **NET** arguments is as simple as it can be:
- **ALL** - starts all the VMs that are present on the host and can be displayed by ```sudo virsh list --inactive```
```plaintext
./vm.sh start ALL
```
- **NET** - starts VMs that are named "dhcp01" and "dns01"
```plaintext
./vm.sh start NET
```

