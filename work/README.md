This is a work directory in which one can run calculations to produce the
data for the notebook in the parent directory.
Set the overall parameters for the calculation
file *run.rsp* in the *input/s_process* subdirectory
for the single-zone calculations.  Once that step is done,
execute the code by typing, for example:

**./run.sh --model model1 --input_xml input_xml_file**

where *input_xml_file* is the xml file used as input for the calculation.
The script chooses by default the last zone in *input_xml_file* for the initial composition
for the calculation.  To change that, use an XPath expression with the
option *zone_xpath*.  For example, to use the zone labeled *label1="186"* in the
default input xml file *input/example.xml*, type

**./run.sh --model model1 --input_xml \`pwd\`/input/example.xml --zone_xpath "[@label1='186']"**

The default is to choose the last zone in the input xml file.
The output will be in the user-defined directory (default is *output*)
and model subdirectory.

Once the s-process output is computed (in the above, the file would be
*output/model1/s-process/out.xml*), you can compute the abundances averaged
over an exponential distribution of exposures with average exposure
*&tau;<sub>0</sub>*.  To do so for *&tau;<sub>0</sub> = 0.3*, type,

**python3 input/python/s-proc_average.py output/model1/out.xml 0.3 output/model1/exp_tau.xml**

The last command line entry is the resultant output file.

Of course you can edit the scripts according to your purposes.
