A simple script to facilitate [wick checks](https://tvtropes.org/pmwiki/pmwiki.php/Administrivia/HowToDoAWickCheck) on TVTropes. This script works by taking a specified trope, downloading its Related To page, and extracting a random selection of related links ("wicks") equal to either 50 or the square root of the total number of wicks, whichever is higher. If there are fewer than 50 wicks, the script will simply return a complete list. The list of wicks is written to a specified output file, named "checklist.txt" by default.

USAGE

./wickcheck.sh [options [parameters] ] 

OPTIONS

Options passed to wickcheck.sh begin with a hyphen (-), as is standard on Unix and Unix-like operating systems, and may be followed by parameters. Some options have longer synonyms, which start with two hyphens (--). Each option must be passed seperately; for example, "wickcheck.sh -w MadScientist -f -t" is a valid command, but "wickcheck.sh -w MadScientist -ft" is not.

  -w TROPE
  
  Perform a wick check on TROPE. TROPE must start with a letter and can only contain letters, numbers, and hyphens; it must contain any special characters which require custom WikiWord editing. For example, to perform a wick check on the trope "You're Just Jealous", TROPE would consist of "YoureJustJealous". For single-word tropes, do not use curly braces: for example, enter "Ninja" instead of "{{Ninja}}".

  TROPE may consist of just a trope ("YoureJustJealous"), a trope with a namespace ("Quotes/YoureJustJealous") or a full URL ("https://tvtropes.org/pmwiki/pmwiki.php/Main/YoureJustJealous"). If -w is not specified, the script will attempt to find a valid value of TROPE from the list of arguments; as such, "./wickcheck.sh YoureJustJealous" should also work.

  Capitalisation does not matter; "YoureJustJealous", "YOUREJUSTJEALOUS", "yourejustjealous", "yOUREjUSTjEALOUS", and "yOuRjUsTjEaLoUs" are all valid values of TROPE.

  Note that if -n is specified, it will take priority over a namespace included in -w. Thus, for example,"./wickcheck.sh Quotes/YoureJustJealous -n Laconic" will perform a wick check on "Laconic/YoureJustJealous".

  -a
  --all
  
  Do not extract a subset of wicks; write them all to output file.

  -d
  --dot
  
  Replaced the final '/' in the output file with a '.'.

  -f
  --fun
  
  Include wicks in the 'fun' namespaces; by default, they are excluded from the wick check. The canonical 'fun' namespaces are:
    * AATAFOVS/
    * DarthWiki/
    * GrandUnifiedTimeline/
    * Haiki/
    * Headscratchers/
    * Horrible/
    * ImageLinks/
    * JustForFun/
    * Pantheon/
    * Sandbox/
    * SelfDemonstrating/
    * SoYouWantTo/
    * SugarWiki/
    * Timeline/
    * UsefulNotes/
    * VideoExamples/
    * WMG/

  Note that if -f and -i are both specified, -i takes priority and the check will only include those namespaces in the arguments to -i.

  -i NAMESPACE1[, NAMESPACE 2...]
  --include NAMESPACE1[, NAMESPACE 2...]
  
  Restrict wicks to namespaces specified following -i. This option takes priority over -f and -x. Namespaces do not need to include trailing slashes; "Laconic/" and "Laconic" are both valid. Capitalisation does not matter; "Laconic", "lACONIC", "LACONIC", "laconic", and "lAcOnIc" are all equally valid.
    
  -n NAMESPACE
  --namespace NAMESPACE
  
  Specify the namespace on which to perform the wick check (default is Main/). For example, "./wickcheck -w YoureJustJealous" will extract a list of pages linking to Main/YoureJustJealous, while "./wickcheck -w YoureJ\
ustJealous -n Quotes" will extract a list of pages linking to Quotes/YoureJustJealous. NAMESPACE does not need to include trailing slashes; "Laconic/" and "Laconic" are both valid. Capitalisation does not matter; "Laconic", "lACONIC", "LACONIC", "laconic", and "lAcOnIc" are all equally valid.

  Note that -n will override any namespace specified in -w.

  -o OUTFILE
  --output OUTFILE
  
  Write the final list of wicks to OUTFILE instead of the default.

  -x NAMESPACE1[, NAMESPACE 2...]
  --exclude NAMESPACE1[, NAMESPACE 2...]
  
  Omit links from namespaces following -x.Namespaces do not need to include trailing slashes; "Laconic/" and "Laconic" are both valid. Capitalisation does not matter; "Laconic", "lACONIC", "LACONIC", "laconic", and "lAcOnIc" are all equally valid.

  Note that -i takes priority over -x; if both are specified, only -i will be taken into account.

  -t
  --trope
  
  Output a list of tropes instead of a list of URLs. If -t and -u are both specified, the last one takes priority.

  -u
  --url
  Output a list of full URLs instead of just trope names (default behaviour). If -u and -t are both specified, the last one takes priority.

USABILITY

This script was written and tested in bash on Manjaro Linux.

It will work on GNU/Linux unless you have a really weird setup.

As far as I can tell, it depends on behaviour particular to GNU sed; as such, I can't guarantee it will work on BSD or Mac.

For MS Windows users, you can try installing bash through Windows Subsystem for Linux, but some changes may be necessary to account for the MS Windows filesystem.

COPYRIGHT

wickcheck.sh is copyright Chris McCrohan and distributed under the MIT license.
