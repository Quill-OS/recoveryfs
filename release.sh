#!/bin/bash

if [ -z "${GITDIR}" ]; then
	echo "Please specify the GITDIR environment variable."
	exit 1
fi

cd "${GITDIR}"
git rev-parse HEAD > ./.commit
chmod u+s "${GITDIR}/bin/busybox"
find . -type f -name ".keep" -exec rm {} \;
rm -f ../recoveryfs.squashfs
mksquashfs . ../recoveryfs.squashfs -b 1048576 -comp xz -Xdict-size 100% -always-use-fragments -all-root -e .git -e release.sh
rm ./.commit
find . -type d ! -path "*.git*" -empty -exec touch '{}'/.keep \;
echo "Recovery filesystem has been compressed."
