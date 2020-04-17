"""
This script 'DLC_to_JAABA.m' is to convert DeepLabCut .csv data to JAABA .trk file.

To_keep_in_mind
_______________

* For successful work requires 'source_file.trk' located in the same directory.
* Creates 'trk_data' folder in the same as 'DLC_to_JAABA.m' directory.
"""

Warning:
	readmatrix() is deprecated in older versions of Matlab (< R2019a). Use xlsread() instead:
	>> A = xlsread([path file{i}]); % 'A' refers to read .csv data sheet