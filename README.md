# hMRI toolbox Example Dataset script
This repository contains a script to help the processing of the [example dataset](https://owncloud.gwdg.de/index.php/s/iv2TOQwGy4FGDDZ/download?path=%2F&files=hmri_sample_dataset_with_maps.zip) from the [hMRI toolbox](http://hmri.info).

After downloading the exampel dataset and un zipping the file, the set of images will be accessible on your own hard drive with a personnal path. In order to generate the quantitative maps from the raw images, they have to be entered carefully into the `matlabbatch` GUI. The aim of the little script is to help you automatically creating the `matlabbatch` file for the example data. Afterwards you can simply open the created `my_Create_Maps_Batch.mat` file into the "Batch Editor" window and run the map creation.

### References
- the [hMRI toolbox](http://hmri.info)
- main [reference paper](http://doi.org/10.1016/j.neuroimage.2019.01.029) for the hMRI toolbox
- [paper](https://doi.org/10.1016/j.dib.2019.104132) describing the example dataset
- [cloud storage](https://owncloud.gwdg.de/index.php/s/iv2TOQwGy4FGDDZ) with the publicly available data
