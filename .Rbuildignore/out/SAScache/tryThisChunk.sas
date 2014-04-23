ods noproctitle; title;

ods html body = "/Users/user/courses/stat585/SASnatch/.Rbuildignore/out/SAScache/SASnatch-chunk-name.html" NEWFILE = OUTPUT;

ods tagsets.tablesonlylatex file="/Users/user/courses/stat585/SASnatch/.Rbuildignore/out/SAScache/SASnatch-chunk-name.tex" (notop nobot) NEWFILE = table;

proc import datafile = "/Users/user/courses/stat585/SASnatch/.Rbuildignore/out/SAScache/d1.csv" out = d1 dbms = CSV replace; getnames = yes; run;

proc import datafile = "/Users/user/courses/stat585/SASnatch/.Rbuildignore/out/SAScache/d3.csv" out = d3 dbms = CSV replace; getnames = yes; run;

  proc glm data = d1; model y = x; run;

proc export data = d2 outfile = "/Users/user/courses/stat585/SASnatch/.Rbuildignore/out/SAScache/d2.csv" dbms = csv replace; run;

ods _all_ close;
