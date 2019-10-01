#
# LocalizationsOfRingsForCAP: category of rows over localizations of rings
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "LocalizationsOfRingsForCAP",
Subtitle := "category of rows over localizations of rings",
Version := "0.1",
Date := "30/09/2019", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Sebastian",
    LastName := "Posur",
    WWWHome := "https://sebastianpos.github.io",
    Email := "sebastian.posur@uni-siegen.de",
    PostalAddress := Concatenation(
               "Department Mathematik\n",
               "Universität Siegen\n",
               "Walter-Flex-Straße 3\n",
               "57068 Siegen\n",
               "Germany" ),
    Place := "Siegen",
    Institution := "University of Siegen",
  ),
],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
PackageWWWHome := "https://TODO/",
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL     := Concatenation( ~.PackageWWWHome,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "LocalizationsOfRingsForCAP",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "category of rows over localizations of rings",
),

Dependencies := rec(
  GAP := ">= 4.9",
    NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ],
                           [ "CAP", ">= 2019.09.17" ],
                           [ "FreydCategoriesForCAP", ">= 2019.08.07" ],
                           [ "MatricesForHomalg", ">= 2019.02.01" ],
                           [ "RingsForHomalg", ">=2019.06.01" ]
                         ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


