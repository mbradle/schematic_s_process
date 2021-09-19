bin_dir=../../single_zone
out=../../$1/
in_dir=${out}/ne_burning
out_dir=${out}/o_burning

mkdir -p ${out_dir}

${bin_dir}/single_zone_network @run.rsp --zone_xml ${in_dir}/out.xml --output_xml ${out_dir}/out.xml > ${out_dir}/log.txt
