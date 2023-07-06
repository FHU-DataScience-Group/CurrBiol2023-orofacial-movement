<Computing environment>
・OS: MacOS version13.4.1
・MATLAB (version:R2023a (9.14.0)).

MATLAB codes for cell categories (Figure 6E).

1. modify Options.m to set directory containing folders of spike sorring results (the folder must contain *.npy file, and directry containing whisker movement data.

2. run "run_me.m" in MATLAB

if you want to skip the processes of data import and preprocess, just comment out "code1_Import_sorted_data" and "code2_Extract_Trials_Integrate_data" in "run_me.m". In this case, the rest of codes use "DATA.mat" instead of the raw data.