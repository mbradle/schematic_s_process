This is a work directory in which one can run calculations to produce the
data for the notebook in the parent directory.
Edit the input in the *runs.sh* script to
set the overall parameters for the calculations and the
files *run.rsp* in the various *input* subdirectories
to set the parameters for the single-zone
calculations.  Once those steps are done, execute the code by typing,
for example:

**./runs.sh**

The output will be in the user-defined directory and model subdirectory.

The directory also includes a *pbs* script.  If your system supports this,
you can run

**qsub job.pbs**

Of course you can edit the scripts according to your purposes.
