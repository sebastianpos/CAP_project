gap> LoadPackage( "LocalizationsOfRingsForCAP", false );
true
gap> package_loading_info_level := InfoLevel( InfoPackageLoading );;
gap> SetInfoLevel( InfoPackageLoading, PACKAGE_INFO );;
gap> LoadPackage( "LocalizationsOfRingsForCAP" );
true
gap> SetInfoLevel( InfoPackageLoading, package_loading_info_level );;
