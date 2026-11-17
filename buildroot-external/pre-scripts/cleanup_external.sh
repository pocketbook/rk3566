#!/bin/bash
#

INFO "Checking external packages - ensuring that actual versions are built..."

BUILDROOTDIR=$PWD
DLDIR=$BUILDROOTDIR/dl
EXTPKGDIR=$BUILDROOTDIR/../buildroot-external/package

for pkg in $(ls $EXTPKGDIR) ; do
	PKG="${pkg^^}"
	MKFILE="$EXTPKGDIR/$pkg/$pkg.mk"
	[ -f "$MKFILE" ] || continue
	VER=$(grep "^${PKG}_VERSION" "$MKFILE" | sed 's/.*=[ \t]*//g')
	if [ -z "$VER" ] ; then
		INFO "$pkg: unknown version, skipping"
	elif [ -d "$DLDIR/$pkg/git" ] ; then
		LHASH=$(cd "$DLDIR/$pkg/git" && git rev-parse "$VER")
		LHASH=${LHASH:0:16}
		RHASH=$(cd "$DLDIR/$pkg/git" && timeout 3 git ls-remote origin "${VER#origin/}")
		RHASH=${RHASH:0:16}
		if [ "$LHASH" = "$RHASH" ] ; then
			INFO "$pkg: actual"
		else
			if [ -n "$RHASH" ] ; then
				INFO "$pkg: will update to $RHASH"
			else
				INFO "$pkg: some error, re-download"
			fi
			rm -rf $DLDIR/$pkg
			rm -f "$EXTPKGDIR/$pkg/$pkg.hash"
		fi
	elif [ -d "$DLDIR/$pkg" ] ; then
		INFO "$pkg: not a git package"
		rm -rf $DLDIR/$pkg
		rm -f "$EXTPKGDIR/$pkg/$pkg.hash"
		continue
	else
		INFO "$pkg: not cached"
	fi
	if [ $pkg = ebrmain ] && [ "${CLEAN_EBRMAIN:-true}" = false ]; then
		INFO "Skip clean $pkg"
		continue
	fi
	# rebuild in any case (some dependency package can change)
	rm -rf $BUILD_DIR/$pkg-* $BUILD_DIR/host-$pkg-*
done

