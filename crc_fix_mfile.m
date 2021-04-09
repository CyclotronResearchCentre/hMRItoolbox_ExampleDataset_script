function fn_in_copy = crc_fix_mfile(fn_in)
% Function to fix the hmri_local_defaults.m file provided with the hMRI
% toolbox demo data. See the
% - paper, https://doi.org/10.1016/j.dib.2019.104132 , and
% - data, https://owncloud.gwdg.de/index.php/s/iv2TOQwGy4FGDDZ
%
%__________________________________________________________________________
% Copyright (C) 2021 Cyclotron Research Centre

% Written by C. Phillips, 2021.
% GIGA Institute, University of Liege, Belgium

% 1. Define filter
% -------------------------------------------------------------------------
% Target:
% 'hmri_def.TPM = fullfile(fileparts(fileparts(fileparts(mfilename(''fullpath'')))),''etpm'',''eTPM.nii'');';
regexp_target = 'mfilename';
% catch the line with the problematic "mfilename", there should only be one
line_replace = ...
    'hmri_def.TPM = fullfile(fileparts(which(''hmri_autoreorient'')),''etpm'',''eTPM.nii'');';

% 2. Read in the whole file, line by line, into a cell array
% -------------------------------------------------------------------------
fid = fopen(fn_in);
tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline; %#ok<*AGROW>
    tline = fgetl(fid);
end
fclose(fid);

% 3. Find the target line and replace it
% -------------------------------------------------------------------------
subdirLines = regexp(tlines,regexp_target,'match','once');
l_subdirLines = find(~cellfun(@isempty, subdirLines));
% N_subdirLines = numel(l_subdirLines);
% there should only be 1
if numel(l_subdirLines)>1
    fprintf('\nPROBLEM: mulitple occurence of regexp target: ''%s''\n', ...
        regexp_target);
    fprintf('Only replacing 1st one!!!\n');
elseif numel(l_subdirLines)==0
    fprintf('\nPROBLEM?: no match of regexp target: ''%s''\n', ...
        regexp_target);
    fprintf('Therefore not changing anything!!!\n');
    fn_in_copy = '';
    return
end
tlines{l_subdirLines(1)} = line_replace;


% 4. Adding a small comment and warning
% -------------------------------------------------------------------------
% Extra comment to be added
add_lines = {
    '% NOTE:' ;
    sprintf('%% Function modified by ''%s'' on %s.', ...
        mfilename, ...
        datestr(datetime('now','Format','d-MMM-y HH:mm:ss')) ) ;
    sprintf(['%% Replacing relative path to eTPM.nii with absolute ' ...
    'on online %d'], l_subdirLines(1)+4) ;
    '' };

% Inserting comment at the very top
tlines_out = [ add_lines ; tlines ];

% 5. Write out fixed default file, with added comments
% ---------------------------------------------------------------------
% keep a copy of original default file with 'ORIG_' prefix
fn_in_copy = spm_file(fn_in,'prefix','ORIG_');
copyfile(fn_in,fn_in_copy);
% overwrite old one
fid = fopen(fn_in,'Wt');
if fid == -1
    error('Unable to write file %s.', f);
end
for i=1:numel(tlines_out)
    fprintf(fid,'%s\n',tlines_out{i});
end
fclose(fid);

end


% CP UPDATE:
% Making sure it picks the right eTPM folder even if current file is NOT in
% the toolbox tree
% hmri_def.TPM = fullfile(fileparts(which('hmri_autoreorient')),'etpm','eTPM.nii');