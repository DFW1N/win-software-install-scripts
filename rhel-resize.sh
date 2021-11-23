## Resize
lvresize -L +35g /dev/mapper/rootvg-homelv

## Grow the xfs
xfs_growfs /dev/mapper/rootvg-homelv
