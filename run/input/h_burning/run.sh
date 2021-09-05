bin_dir=../../single_zone
out=../../$1/
out_dir=${out}/h_burning

mkdir -p ${out_dir}

${bin_dir}/single_zone_network @run.rsp --output_xml ${out_dir}/out.xml > ${out_dir}/log.txt
