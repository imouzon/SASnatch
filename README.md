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

In SAS this can be done in a number of ways.<sup>1</sup> For instance:

    proc sort data = d; by obs descending; run;
    data d2; set d(keep = obs); order = _N_; if order < 51; drop order; run;
    proc sql; select mean(obs) into :meanObs from d2; quit;
    %put &meanObs;

Or:

    proc sort data = d; by obs descending; run;
    data d2; set d(keep = obs); order = _N_; if order < 51; drop order; run;
    proc means data = d2; run;

Although the second method only prints the mean to the output (along with all the other SAS output).
However, there are several pieces that may alarm others 
that haven't found themselves needing to do this kind of thing in SAS before
(``keep = `` but not ``drop = ``, using not just SQL but ``proc sql``, the colon to create the macro variable ``meanObs`` but a ampersand to call it, where does ``_N_`` come from, and so on).

Even being generally happy using just SAS, I often wish I could do 
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

### Using SASnatch
SAS natch is available of github and can be installed using the ``devtools`` package
in R, as follows:

    require('devtools')
    install_github('SASnatch','imouzon',arg='-l U://Documents/R/win-library/3.0')

In an .rnw file, include the following two packages:

    <<require-packages, cache=FALSE, message=FALSE, include = TRUE>>=
    require('devtools')
       require('knitr')
       require('SASnatch')
    @

and add the following chunk:

    <<SASnatch-settings, cache=FALSE, message=FALSE, include = TRUE>>=
       path_to_SAS.EXE <<- '"C:/Program Files/SASHome/SASFoundation/9.3/sas.exe"'
       knit_hooks$set(SASnatch = SASnatch_hook)
    @

To send a chunk to SAS for completion, add ``SAScache = c(INPUT_DATA, OUTPUT_DATA)`` where
``INPUT_DATA`` and ``OUTPUT_DATA`` are both characters with all input datasets and output datasets
separated by spaces (or commas).

At this point you are ready to use SASnatch.

A brief example
---------------

Consider the following dataset:

    <<setupChunk, echo=TRUE, cache=TRUE, include = TRUE>>=
       d.1 <- data.frame(x=1:100,y=.3+.2*(1:100)+rnorm(100,0,3),group=rep('A',100))
       d.2 <- data.frame(x=1:100,y=.1+.5*(1:100)+rnorm(100,0,3),group=rep('B',100))
       d <- rbind(d.1,d.2)
    @

We can plot these datasets simply enough

    <<plotchunk, fig.width=5, fig.height=5, out.width='.5\maxwidth', echo=TRUE>>=
        require(ggplot2)
        qplot(x,y,data = d,shape=group)
    @

Which can be run in SAS using the following:

    <<SASgroupreg, SASnatch = c('d','regd_out'), eval=FALSE, echo=FALSE, cache=FALSE>>=
       proc reg data = d; by group; model y = x; output out = regd_out p = yhat r = resid; run;
    @

The output dataset regd_out is stored in the folder ``cache/out/SAScache`` 
where ``cache`` is the knitr cache directory,
and HTML tables and TeX tables of the results are stored in the folder, 
named after the chunk 

**Footnotes**
1. These would actually be the examples I would use and probably the most effecient ones I have found. There is surely a simpler bit of code that could accomplish this task, but part of the reason I find this pacakge useful is that in addition to avoiding ungainly code, I can make up for blind spots in one language or the other as well.
