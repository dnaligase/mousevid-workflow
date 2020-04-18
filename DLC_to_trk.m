dir = cd(fileparts(which('DLC_to_JAABA.m')));
source = load([dir '\source_file.trk'], '-mat');

new_folder_name = 'trk_data';
mkdir(new_folder_name);
folder_to_save = [dir '\' new_folder_name];

[file, path] = uigetfile({'*.csv', 'DeepLabCut file(s) (*.csv)'},...
    'Select One or More Files to Convert',...
    'MultiSelect', 'on',...
    'my_spreadsheet.csv');

if isa(file, 'cell') == 1
    waitfor(msgbox(sprintf('Operation Completed \nFiles uploaded: %d', length(file)),...
        'Success','help'))
else
    if isa(file, 'char') == 1
        file = {file};
        waitfor(msgbox(sprintf('Operation Completed \nFiles uploaded: %d', length(file)),...
            'Success','help'))
    else
        warndlg('Oops, it seems like you forgot to select any files',...
                'Warning');
            return        
    end
end

f = waitbar(0, sprintf('Progress: 0.00%% \n"%s"', strrep(file{1}, '_', '\_')),...
    'Name', 'Preparing your data...',...
    'CreateCancelBtn', 'setappdata(gcbf, ''canceling'', 1)');

setappdata(f, 'canceling', 0);

files_selected = length(file);
for i=1:files_selected
     if getappdata(f, 'canceling')
         files_selected = files_selected - 1;
         break
     end
     A = readmatrix([path file{i}]); % 'A' refers to read .csv data sheet
     A(:, 1) = [];
     A(:, 3:3:end) = []; 
     out = permute(reshape(A.', 1, 2, []), [3 2 1]);
     bdprts_count = size(A, 2) / 2;
     subtrahend = bdprts_count - 1;
     frames_count = length(out) / bdprts_count;

     c = zeros(numel(A), 1);
        for k = 1:frames_count
            a = out(bdprts_count * k-subtrahend : k * bdprts_count, 1);
            b = out(bdprts_count * k-subtrahend : k * bdprts_count, 2);
            features = bdprts_count * 2;
            c(features * k - features + 1 : features * k, 1) = [a; b];
        end
    
     pTrk = reshape(c, bdprts_count, 2, frames_count);
     pTrkFrm = double(1:frames_count);

     source.pTrk = pTrk;
     source.pTrkFrm = pTrkFrm;

     chars_ind = strfind(file{i}, 'DLC');
     file{i}(chars_ind: end) = [];
     fname = [file{i} '_'];
     save([folder_to_save '\' fname 'JAABA_rdy_'...
         datestr(now, 'ddmmmyyyy_HH-MM') '.trk'],...
         '-mat', '-struct', 'source');
     
     waitbar(i / length(file), f,...
         sprintf('Progress: %.2f%% \n"%s"',...
         i / length(file) * 100, strrep(file{i}, '_', '\_')))
end

delete(f)

msgbox(sprintf('Operation Completed \nFiles extracted: %d', files_selected),...
    'Success','help')
