SetPackageInfo( rec(

PackageName := "GeneralizedMorphismsForCAP",
Subtitle := "Implementations of generalized morphisms for the CAP project",

Version := Maximum( [
  "2017.12.30", ## Sebas' version
## this line prevents merge conflicts
  "2018.02.02", ## Sepp's version
## this line prevents merge conflicts
  "2019.01.16", ## Mohamed's version
## this line prevents merge conflicts
   ] ),

Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),
License := "GPL-2.0-or-later",


Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Sebastian",
    LastName := "Gutsche",
    WWWHome := "http://www.uni-siegen.de/fb6/rmi/",
    Email := "gutsche@mathematik.uni-siegen.de",
    PostalAddress := Concatenation(
               "Department Mathematik\n",
               "Universität Siegen\n",
               "Walter-Flex-Straße 3\n",
               "57068 Siegen\n",
               "Germany" ),
    Place := "Siegen",
    Institution := "University of Siegen",
  ),
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

PackageWWWHome := "http://homalg-project.github.io/CAP_project/GeneralizedMorphismsForCAP/",

ArchiveURL     := Concatenation( "https://github.com/homalg-project/CAP_project/releases/download/GeneralizedMorphismsForCAP-", ~.Version, "/GeneralizedMorphismsForCAP-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

ArchiveFormats := ".tar.gz .zip",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "deposited",

AbstractHTML   :=  "<span class=\"pkgname\">GeneralizedMorphismsForCAP</span> provides the category of generalized morphisms associated to an abelian category.",

PackageDoc := rec(
  BookName  := "GeneralizedMorphismsForCAP",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Implementations of generalized morphisms for the CAP project",
),

Dependencies := rec(
  GAP := ">= 4.6",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ],
                           [ "CAP", ">= 2019.01.16" ],
                           [ "MonoidalCategories", ">= 2019.01.16" ],
                         ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,


#Keywords := [ "TODO" ],

));


