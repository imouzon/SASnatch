STAT 585X: Data Technologies for Statistical Analysis
=============================

SASnatch: Using SAS kniturally
-----------------------------

###Motivation

This project deals with a problem that I have had for long time. 
I routinely use SAS and like SAS quite a bit. 
SAS is a powerful tool for statistical analysis and there are many reasons
that it might make it the best tool for a given situation. 
However, using SAS is often a less than satisfying experience. 
The output can be unwieldy and small steps can be frustrating (for instance,
in R we can store the mean of the top 50 observations can be found using

    mean(d$obs[order(d$obs,decreasing=TRUE)][1:50])

In SAS this can be done in a number of ways.[^1] For instance:

    proc sort data = d; by obs descending; run;
    data d2; set d(keep = obs); order = _N_; if order < 51; drop order; run;
    proc sql; select mean(obs) into :meanObs from d2; quit;
    %put &meanObs;

Or:

    proc sort data = d; by obs descending; run;
    data d2; set d(keep = obs); order = _N_; if order < 51; drop order; run;
    proc means data = d2; run;

Although the second method only prints the mean to the output (along with all the other SAS output).
I can appreciate this. 
However, there are several pieces that may alarm others 
that haven't found themselves needing to do so a thing in SAS
(``keep = `` but not ``drop = ``, using not just SQL but ``proc sql``, the colon to create the macro variable ``meanObs`` but a ampersand to call it, where does ``_N_`` come from, and so on).

Even being generally happy using SAS myself, I often wish I could do 
one or two operations in R along the way, if not simply for the reason that 
I find them simpler, then for the reason that others can better understand them.
This feeling arises most frequently when I want to create a final, professional looking
document, as I can using knitr and R.

For this reason, I am working on a way to make SAS work with R through knitr.
As of right now, I am calling the code that I am working on SASnatch, because the
basic idea behind what I am doing is "snatching" SAS's output and giving it to R.
I like this name because "natch" is slang-ish for "naturally" which is what 
I hope using it will feel like.

### Questions of Interest
*How can SAS and R share data and results in an efficient and straightforward way?
*What methods can I use so that the person actually using the package has to fuss with special features as little as possible?

### What data is available?
SAS has a wonderful system for generating output (the Output Delivery System, or ODS)
that I intend to take full advantage of, even though the final results will be officially
delivered through R.

knitr has a wonderful set up for creating chunk options that run 
code before the chunk is read and after the chunk is read. This will enable me identify
a section of code as needing to be run through SAS, which objects in R need to be made
available to SAS, and which objects need to be taken back from SAS and given to R.

Databases can be accessed by both SAS and R (with the proper packages installed)
and I intend to use them in the tools that pass the data back and forth.

### How is the data to be collected, collated, merged, and processed.
Ideally there would be a simple method for the user to interact with SAS through R,
something like

    <<sasBaseBall,SASnatch = TRUE, SASget = baseball, SASgive = ballout>>=
       proc reg data = baseball;
          id name team league;
          model logSalary = no_hits no_runs no_rbi no_bb yr_major cr_hits;
          output out = ballout p=logSal_hat r = logSalary_resid cookd = cookD;
       run;
    @

to produce an S4 object containing the results and the dataset 'ballout'
named after the chunk. 
Either methods for that S4 object (``HTMLoutput(sasBaseball)``, for instance)
or elbow grease (by digging into the resulting object) would give the results when placed
in an output chunk (or perhaps and S-expression inline).

[^1]: These would actually be the examples I would use.
