#
# DgCategoriesForCAP: Differential graded categories for CAP
#
# This file is a script which compiles the package manual.
#
LoadPackage( "AutoDoc" );

AutoDoc( "DgCategoriesForCAP" : scaffold := true, autodoc :=
         rec( files := [ "doc/Intros.autodoc" ],
         scan_dirs := [ "gap", "examples", "doc" ] ),
         maketest := rec( commands :=
                            [ "LoadPackage( \"CAP\" );",
                              "LoadPackage( \"IO_ForHomalg\" );",
                              "LoadPackage( \"GaussForHomalg\" );",
                              "LoadPackage( \"LinearAlgebraForCAP\" );",
                              "LoadPackage( \"DgCategoriesForCAP\" );",
                              "HOMALG_IO.show_banners := false;",
                              "HOMALG_IO.suppress_PID := true;",
                              "HOMALG_IO.use_common_stream := true;",
                             ]
                           )
);

QUIT;