margs=1

function example {
    echo -e "example: $0 --model model1\n"
}

function usage {
    echo -e "usage: $0 MANDATORY [OPTION]\n"
}

function help {
  usage
    echo -e "MANDATORY:"
    echo -e "  --model  VAL  The output subdirectory"
    echo -e "OPTION:"
    echo -e "  --out_dir  VAL  The output directory (output)"
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

while [ "$1" != "" ];
do
   case $1 in
   --model )  shift
              model=$1
              ;;
   --out_dir )  shift
              out_dir=$1
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

margs_check ${model}

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

output=${out_dir}/$model

# Download the data.

make data

# Run hydrogen burning

cd ../input/h_burning
cp run.rsp ${output}/h_burning
./run.sh ${output}

# Run helium burning

cd ../he_burning
cp run.rsp ${output}/he_burning
./run.sh ${output}

# Run the s process

cd ../s-process
cp run.rsp ${output}/s-process
./run.sh ${output}

# Tar and zip model

cd ../..
cd ${out_dir}
tar cvf ${model}.tar ${model}/h_burning/out.xml ${model}/he_burning/out.xml ${model}/s-process/out.xml ${model}/h_burning/run.rsp ${model}/he_burning/run.rsp ${model}/s-procss/run.rsp
gzip ${model}.tar
