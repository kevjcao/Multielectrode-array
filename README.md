# Multielectrode-array
The code is a simplified version of the old Kramer MEA analysis code for retinal measurements. It processes spike-sorted .xlsx files from Plexon sorter, and can utilize trigger time .txt files.

It will generate a histogram of the firing activity at x ms binsizing, and create firing rasters for all included units in the .xlsx file, and will calculate the photoswitch and/or light-response indeces.

concatMEA will concatenate all units from the .mat file generated in Plexon and removes electrodes without units.
