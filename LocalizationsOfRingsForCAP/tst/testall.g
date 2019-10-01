#
# LocalizationsOfRingsForCAP: category of rows over localizations of rings
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "LocalizationsOfRingsForCAP" );
HOMALG_IO.show_banners := false;
HOMALG_IO.suppress_PID := true;
HOMALG_IO.use_common_stream := true;

TestDirectory(DirectoriesPackageLibrary( "LocalizationsOfRingsForCAP", "tst" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
