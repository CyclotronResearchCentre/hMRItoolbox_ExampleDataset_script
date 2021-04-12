function crc_BIDShmri_FAseries(fn_B1plus)
% Function to update the JSON header associated with the B1+ images, using 
% the SESTE protocoal, in order to ensure that the full series of flip
% angle values is truly available in a specific field "FlipAngleSeries".
% This "FlipAngleSeries" is not part of the BIDS specs but makes life
% easier and allows easy check of the results.
%
% INPUT
% fn_B1plus :   char array of filenames to the 2x11 images (or their
%               associated JSON files), in which to add the FA series
%__________________________________________________________________________
% Copyright (C) 2021 Cyclotron Research Centre

% Written by C. Phillips, 2021.
% GIGA Institute, University of Liege, Belgium

% Making sure we are working with the JSON files
fn_B1plus_json = spm_file(fn_B1plus,'ext','json');

% Check the 1st image, to see if the "FlipAngleSeries" field exist
json_fn1 = spm_jsonread(fn_B1plus_json(1,:));
if isfield(json_fn1,'FlipAngleSeries')
    fprintf('\nThe ''FlipAngleSeries'' field already exists, nothing to do.\n');
    return
end

% Deal with all the images and add the "FlipAngleSeries" field to each
% image's JSON file

% load all the "FlipAngles" from 1st echo
l_echo1 = find(~cellfun('isempty',regexp(cellstr(fn_B1plus_json),'.*echo-1.*')));
FAseries = zeros(numel(l_echo1),1);
for ii=1:numel(l_echo1)
    tmp = spm_jsonread(fn_B1plus_json(l_echo1(ii),:));
    FAseries(ii) = tmp.FlipAngle;
end

% add the "FlipAngleSeries" field to each image's JSON file
for ii=1:size(fn_B1plus_json,1)
    tmp = spm_jsonread(fn_B1plus_json(ii,:));
    tmp.FlipAngleSeries = FAseries;
    % keep the "history" field at the end
    field_nm = fieldnames(tmp); Nfields = numel(field_nm);
    p_hist = find(~cellfun('isempty',regexp(field_nm,'^history$')));
    if ~isempty(p_hist)
        perm_fields = 1:Nfields;
        perm_fields(Nfields) = p_hist;
        perm_fields(p_hist) = Nfields;
        tmp = orderfields(tmp,perm_fields);
    end
    % save file
    spm_jsonwrite(fn_B1plus_json(ii,:),tmp, ...
        struct('indent','\t') )
end
