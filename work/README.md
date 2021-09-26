This is a work directory in which one can run calculations to produce the
data for the notebook in the parent directory.
Edit the input in the *run.sh* script to
set the overall parameters for the calculations and the
files *run.rsp* in the various *input* subdirectories
to set the parameters for the single-zone
calculations.  Once those steps are done, execute the code by typing,
for example:

**./run.sh --model model1 --input_xml `pwd`/input/example.xml**

Here *model* is the required input option naming the output model and
*input_xml* file is the required option giving the input xml file.
Choose a different model (than *example.xml*) according to your purposes.
The output will be in the user-defined directory (default is *output*)
and the chosen model subdirectory.

You may choose a particular zone in the input file for the input to the
s-process calculation with the *zone_xpath* option.  For example,
type

**./run.sh --model model1 --input_xml `pwd`/input/example.xml --zone_xpath "[@label1='186']"**

The default is to choose the last zone in the input xml file.

Once the s-process output is computed (in the above, the file would be
*output/model1/s-process/out.xml*), you can compute the abundances averaged
over an exponential distribution of exposures with average exposure
*&tau;<sub>0</sub>*.  To do so for *&tau;<sub>0</sub> = 0.3*, type,

**python3 input/python/s-proc_average.py output/model1/s-process/out.xml 0.3 output/model1/s-process/exp_tau.xml**

The last command line entry is the resultant output file.

Of course you can edit the scripts according to your purposes.
