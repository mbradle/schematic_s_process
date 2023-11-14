import sys
import numpy as np
import wnutils.xml as wx
import matplotlib.pyplot as plt

if len(sys.argv) != 4:
    print('\nUsage: python ', sys.argv[0], 'input_file output_file')
    print('  input_file = input xml file')
    print('  tau_0 = average tau')
    print('  output_file = output xml file with averaged abundances\n')
    exit()

# Properties.  These will be included in the output.

props_list = [('exposure', 'n'), 'metallicity', 'scaled metallicity']

xml = wx.Xml(sys.argv[1])
nucs = xml.get_nuclide_data()
reacs = xml.get_reaction_data()
props = xml.get_properties_as_floats(props_list)
y = xml.get_all_abundances_in_zones()

nuc_dict = {}

for nuc in nucs:
    nuc_dict[(nucs[nuc]['z'], nucs[nuc]['a'])] = nuc

dtau = []
tau_old = 0
for tau in props[('exposure','n')]:
    dtau.append(tau - tau_old)
    tau_old = tau

w = 0
y_sum = np.zeros((y.shape[1], y.shape[2]))

tau_0 = float(sys.argv[2])

for i in range(y.shape[0]):
    factor = dtau[i] * np.exp(-props[('exposure','n')][i] / tau_0) / tau_0
    w += factor
    for z in range(y.shape[1]):
        for n in range(y.shape[2]):
            y_sum[z,n] += y[i,z,n] * factor

y_sum /= w

new_xml = wx.New_Xml('libnucnet_input')
new_xml.set_nuclide_data(nucs)
new_xml.set_reaction_data(reacs)

zones = {}

properties = {'tau_0': str(tau_0)}

for prop in props_list:
    properties[prop] = props[prop][len(props[prop]) - 1]

mass_fractions = {}

for jz in range(y.shape[1]):
    for jn in range(y.shape[2]):
        ja = jz + jn
        if y_sum[jz, jn] > 0:
            mass_fractions[(nuc_dict[jz, ja], jz, ja)] = ja * y_sum[jz, jn]

xsum = 0
for value in mass_fractions.values():
    xsum += value

for value in mass_fractions.values():
    value /= xsum

zones["0"] = {'properties': properties, 'mass fractions': mass_fractions}

new_xml.set_zone_data(zones)
new_xml.write(sys.argv[3])

