%% SCRIPT generating the batch for the BIDS hMRI data processing
%
% This is the same batch as for the "original" data but now accounting for
% the BIDS formatted dataset. It expects that 
% - the data are all in a single subject 'sub-01' folder in a specific
%   'derivatives' sub-folder: 
%       my_BIDS_data/derivatives/test_BIDS_hMRI/sub-01
% - the defult files, with the eTPM path fix!, is availabe in the main
%   derivative folder:
%       my_BIDS_data/derivatives/test_BIDS_hMRI/hmri_local_defaults.m
% The the scripts
% 1/ figure out where the data are stored
% 2/ set up the hMRI map creation batch, with the selection of the fixed
%    'hmri_local_defaults.m' file with default parameters
% 3/ saves the matlabbatch .mat file for further use, e.g. loading in the
%    batch-GUI
% 
%__________________________________________________________________________
% Copyright (C) 2021 GIGA Institute
%
% Written by C. Phillips, 2021.
% Cyclotron Research Centre, University of Liege, Belgium

%% 1/ Defining the 'rootDir' of the data folder.
rootDir = 'D:\ddd_Codes\Test_hMRI_BIDS\DATA\Results\BIDS\derivatives\test_BIDS_hmri';
% -> MUST BE UPDATED by each user. For example:
% rootDir = 'C:\Dox\2_Data\hmri_sample_dataset_with_maps';
fn_hmri_defs = ...
    fullfile(rootDir,'Batch_Script_hMRI_Config','hmri_local_defaults.m');

% Display folder that will be used
fprintf('\n Using ''rootDir'' (%s).\n',rootDir)

%% 2/ Create the hMRI batch
clear matlabbatch
% First with the loading of the hmri_local_defaults
matlabbatch{1}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {
    fn_hmri_defs};
% Then the map creation with all the field maps
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.output.indir = 'yes';
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_per_contrast.raw_sens_MT = {
    spm_select('FPListRec',rootDir,'^sub-.*headMTw_RB1COR\.nii$')
    spm_select('FPListRec',rootDir,'^sub-.*bodyMTw_RB1COR\.nii$')
    };
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_per_contrast.raw_sens_PD = {
    spm_select('FPListRec',rootDir,'.^sub-*headPDw_RB1COR\.nii$')
    spm_select('FPListRec',rootDir,'^sub-.*bodyPDw_RB1COR\.nii$')
    };
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_per_contrast.raw_sens_T1 = {
    spm_select('FPListRec',rootDir,'^sub-.*headT1w_RB1COR\.nii$')
    spm_select('FPListRec',rootDir,'^sub-.*bodyT1w_RB1COR\.nii$')
    };
% list of TB1EPI files + find reshuffling for echo 1-2 at same flip angle
fn_TB1EPI = spm_select('FPListRec',rootDir,'^sub-.*_TB1EPI\.nii$');
l_e1e2 = kron(1:11,[1 1]) + kron(ones(1,11),[0 11]);
% Adding the "FlipAngleSeries" to facilitate the BIDS-hMRI
crc_BIDShmri_FAseries(fn_TB1EPI);

matlabbatch{2}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1input = ...
    cellstr(fn_TB1EPI(l_e1e2,:));
%
fn_mag = spm_select('FPListRec',rootDir,'^sub-.*_magnitude\d\.nii$');
fn_phd = spm_select('FPListRec',rootDir,'^sub-.*_phasediff\.nii$');
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b0input = ...
    cellstr(char(fn_mag,fn_phd));
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.b1_type.i3D_EPI.b1parameters.b1metadata = 'yes';
%
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = ...
    cellstr(spm_select('FPListRec',rootDir,'^sub-.*_acq-MTw.*\.nii$'));
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD = ...
    cellstr(spm_select('FPListRec',rootDir,'^sub-.*_acq-PDw.*\.nii$'));
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 = ...
    cellstr(spm_select('FPListRec',rootDir,'^sub-.*_acq-T1w.*\.nii$'));
matlabbatch{2}.spm.tools.hmri.create_mpm.subj.popup = true;

%% 2/ save the resulting matlabbatch in a .mat file
fn_mat = fullfile(rootDir,'Batch_hMRI_BIDS.mat');
save(fn_mat,'matlabbatch')
