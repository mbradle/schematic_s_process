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

output=output/model
tau_0=0.3

# Download the data.

make data

# Run hydrogen burning

cd ../input/h_burning
./run.sh ${output}

# Run helium burning

cd ../he_burning
./run.sh ${output}

# Run the s process

cd ../s-process
./run.sh ${output} ${tau_0}

