SetPackageInfo( rec(

PackageName := "ComplexesAndFilteredObjectsForCAP",
Subtitle := "Implementation of complexes, cocomplexes and filtered objects for CAP",

Version := Maximum( [
  "2018.08-02", ## Sebas' version
## this line prevents merge conflicts
  "2015.04-15", ## Sepp's version
## this line prevents merge conflicts
  "2020.10-01", ## Fabian's version
   ] ),

Date := Concatenation( "01/", ~.Version{[ 6, 7 ]}, "/", ~.Version{[ 1 .. 4 ]} ),
License := "GPL-2.0-or-later",



Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Sebastian",
    LastName := "Posur",
    WWWHome := "https://sebastianpos.github.io",
    Email := "sposur@momo.math.rwth-aachen.de",
    PostalAddress := Concatenation(
               "Sebastian Posur\n",
               "Lehrstuhl B fuer Mathematik, RWTH Aachen\n",
               "Templergraben 64\n",
               "52062 Aachen\n",
               "Germany" ),
    Place := "Aachen",
    Institution := "RWTH Aachen University",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Sebastian",
    LastName := "Gutsche",
    WWWHome := "http://wwwb.math.rwth-aachen.de/~gutsche/",
    Email := "gutsche@momo.math.rwth-aachen.de",
    PostalAddress := Concatenation(
               "Department of Mathematics\n",
               "University of Kaiserslautern\n",
               "67653 Kaiserslautern\n",
               "Germany" ),
    Place := "Kaiserslautern",
    Institution := "TU Kaiserslautern",
  ),
],

# BEGIN URLS
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/homalg-project/CAP_project",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://homalg-project.github.io/pkg/ComplexesAndFilteredObjectsForCAP",
PackageInfoURL  := "https://homalg-project.github.io/CAP_project/ComplexesAndFilteredObjectsForCAP/PackageInfo.g",
README_URL      := "https://homalg-project.github.io/CAP_project/ComplexesAndFilteredObjectsForCAP/README.md",
ArchiveURL      := Concatenation( "https://github.com/homalg-project/CAP_project/releases/download/ComplexesAndFilteredObjectsForCAP-", ~.Version, "/ComplexesAndFilteredObjectsForCAP-", ~.Version ),
# END URLS

ArchiveFormats := ".tar.gz .zip",

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
  BookName  := "ComplexesAndFilteredObjectsForCAP",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Implementation of complexes, cocomplexes and filtered objects for CAP",
),

Dependencies := rec(
  GAP := ">= 4.6",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ],
                           [ "CAP", ">=2018.08.02" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));
