To start using this home directory:

```bash
# Copy stdin to another descriptor before feeding the script to bash
exec 3<&1
/bin/bash <&3 <(curl "http://https://raw.githubusercontent.com/rmgrimm/home-git/master/.local/sh_init/install.sh")
```

_Note: It's a good idea to double-check the contents of that URL prior to
running it blindly._

On ubuntu, this will likely follow with:

```bash
. .bashrc
,setup-ubuntu-desktop.sh
```
