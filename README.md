# luks-kickstarts
Kickstarts demonstrating automated provisioning with LUKS

## Requirements
- pykickstart (for ksflatten and ksvalidate)
- lorax (for mkksiso and dependent tools like xorriso)

## Usage
```
./gen.sh KICKSTARTFILE
./rebuild.sh SRCISO VOLID
```
