# luks-kickstarts

> :warning: **archived**: This has been superseded by [facebookincubator/linux-desktop-kickstarts](https://github.com/facebookincubator/linux-desktop-kickstarts)

Kickstarts demonstrating automated provisioning with LUKS

## Requirements
- pykickstart (for ksflatten and ksvalidate)
- lorax (for mkksiso and dependent tools like xorriso)


## License note
While this repo is under the MIT license (see `LICENSE`), `mkksiso`
from Lorax is under the GPLv2 - see

  https://github.com/weldr/lorax/blob/master/COPYING

## Usage
```
./gen.sh KICKSTARTFILE
./rebuild.sh SRCISO VOLID
```
