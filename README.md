# hMRI toolbox Example Dataset script
This repository contains a script to help the processing of the [example dataset](https://owncloud.gwdg.de/index.php/s/iv2TOQwGy4FGDDZ/download?path=%2F&files=hmri_sample_dataset_with_maps.zip) from the [hMRI toolbox](http://hmri.info).

After downloading the example dataset and unzipping the file, the set of images and batch script files will be accessible on your own hard drive at a specific location. Before using them, the `Create_Maps_Batch.mat` batch file and `hmri_local_defaults.m` default file provided with the data, in the `Batch_Script_hMRI_Config` folder, **must be** updated:

- in `Create_Maps_Batch.mat` all the paths to the data are hardcoded to Martina's setup and should thus be updated to match those of your local download. This is easy enough since the are organized in a fixed sub-folder structure;

- in `hmri_local_defaults.m` the path to the  `eTPM.nii` file is defined *relative* to the "default file" location, this works when it is place in the `path_to_hMRI\config\local` folder (2 folders up and then into `etpm`) but will NOT if placed elsewhere:

  ````
  hmri_def.TPM = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))),'etpm','eTPM.nii');
  ````

  One should rather define with respect to where the hMRI toolbox is found on Matlab path with, e.g.  found by locating the `hmri_autoreorient` function:

  ````
  hmri_def.TPM = fullfile(fileparts(which('hmri_autoreorient')),'etpm','eTPM.nii');
  ````

Therefore the aim of the `script_create_batch.m`  is to automatically fix these 2 issues by:

- automatically creating the `matlabbatch` file for the example data on your computer
- fix the `hmri_local_defaults.m` default function, whatever its location, with the path to the  `eTPM.nii` 

Afterwards you can simply open the created `my_Create_Maps_Batch.mat` file into the "Batch Editor" window and run the map creation.

### References
- the [hMRI toolbox](http://hmri.info)
- main [reference paper](http://doi.org/10.1016/j.neuroimage.2019.01.029) for the hMRI toolbox
- [paper](https://doi.org/10.1016/j.dib.2019.104132) describing the example dataset
- [cloud storage](https://owncloud.gwdg.de/index.php/s/iv2TOQwGy4FGDDZ) with the publicly available data
