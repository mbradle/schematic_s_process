margs=2

function example {
    echo -e "example: $0 --model model1 --input_xml input_xml_file\n"
}

function usage {
    echo -e "usage: $0 MANDATORY [OPTION]\n"
}

function help {
  usage
    echo -e "MANDATORY:"
    echo -e "  --model  VAL  The output subdirectory"
    echo -e "  --input_xml  VAL  The input XML file"
    echo -e "OPTION:"
    echo -e "  --out_dir  VAL  The output directory (default: output)"
    echo -e "  --zone_xpath  VAL  The zone XPath (default: \"[last()]\")"
    echo -e "  -h, --help  Prints this help\n"
  example
}

function margs_precheck {
	if [ $2 ] && [ $1 -lt $margs ]; then
		if [ $2 == "--help" ] || [ $2 == "-h" ]; then
			help
			exit
		else
	    	usage
			example
	    	exit 1 # error
		fi
	fi
}

function margs_check {
	if [ $# -lt $margs ]; then
	    usage
	  	example
	    exit 1 # error
	fi
}

margs_precheck $# $1

# Args while-loop

out_dir=output
zone_xpath="[last()]"

while [ "$1" != "" ];
do
   case $1 in
   --model )  shift
              model=$1
              ;;
   --input_xml )  shift
              input_xml=$1
              ;;
   --out_dir )  shift
              out_dir=$1
              ;;
   --zone_xpath )  shift
              zone_xpath="$1"
              ;;
   -h   | --help )        help
                          exit
                          ;;
   *)                     
                          echo "$script: illegal option $1"
                          usage
						  example
						  exit 1 # error
                          ;;
    esac
    shift
done

# Mandatory paramter check

margs_check ${model} ${input_xml}

# Clone the necessary codes.

if [[ ! -d wn_user ]]
then
   git clone https://bitbucket.org/mbradle/wn_user
else
   git -C wn_user pull
fi

if [[ ! -d single_zone ]]
then
   git clone https://bitbucket.org/mbradle/single_zone
else
   git -C single_zone pull
fi

# Save home directory

HOME=`pwd`

# Set the includes and make the code.

cd wn_user
git checkout develop
cd ..
export WN_USER=1
cp input/master.h single_zone
cd single_zone
git checkout develop
./project_make

# Set key data

output=${HOME}/${out_dir}/$model
mkdir -p ${output}

# Download the data.

make data

# Run s-process

cp ${input_xml} ${output}/input.xml
cp ${HOME}/input/s_process/run.rsp ${output}
cd ${HOME}/input/s_process
./run.sh ${output} "${zone_xpath}"
