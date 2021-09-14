This is a work directory in which one can run calculations to produce the
data for the notebook in the parent directory.
Edit the input in the *runs.sh* script to
set the overall parameters for the calculations and the
files *run.rsp* in the various *input* subdirectories
to set the parameters for the single-zone
calculations.  Once those steps are done, execute the code by typing,
for example:

**./runs.sh --model model1**

The output will be in the user-defined directory (default is *output*)
and model subdirectory.

The directory also includes a *pbs* script.  If your system supports this,
you can run, for example,

**qsub -v model=model1,out_dir=my_output job.pbs**

Once the s-process output is computed (in the above, the file would be
*output/model1/s-process/out.xml*), you can compute the abundances averaged
over an exponential distribution of exposures with average exposure
*&tau;<sub>0</sub>*.  To do so for *&tau;<sub>0</sub> = 0.3*, type,

**python3 input/python/s-proc_average.py output/model1/s-process/out.xml 0.3 output/model1/s-process/exp_tau.xml**

The last command line entry is the resultant output file.

Of course you can edit the scripts according to your purposes.
