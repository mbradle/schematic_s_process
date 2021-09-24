bin_dir=../../single_zone
echo "$2"
${bin_dir}/single_zone_network @run.rsp --zone_xml $1/input.xml --output_xml $1/out.xml --zone_xpath "$2" > $1/log.txt
