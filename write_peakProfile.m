function write_peakProfile(SDAT, x, y, eqname, str, unitno, convf, unitstr, nprofile, ncase, dirpath)

% Determine number of folders per case
nfolders = size(SDAT,2);
neq = size(SDAT,1);

% Writing header lines
n_eq = numel(eqname);
for i = 1:n_eq
    if i == 1
        colhead1 = {eqname{i}, eqname{i}, eqname{i}};
        colhead2 = {'Depth [m]', [str ', YZ [' unitstr{unitno} ']'], [str ', ZX [' unitstr{unitno} ']']};
    else
        colhead1 = [colhead1, eqname{i}, eqname{i}, eqname{i}];
        colhead2 = [colhead2, 'Depth [m]', [str ', YZ [' unitstr{unitno} ']'], [str ', ZX [' unitstr{unitno} ']']];
    end
end

% Spreadsheet name
friendlystr = str;
friendlystr(ismember(friendlystr,' ,.:;!()')) = [];
filename = strcat('PeakProfile_',friendlystr,'.xls');
filepath = fullfile(dirpath,filename);
disp(['Opening ' strcat('PeakProfile_',friendlystr,'.xls')]);

% Initializing peak cells
peak_x = cell(neq, nfolders);
peak_y = cell(neq, nfolders);

% Finding peak values
for i = 1:neq
    for j = 1:nfolders
        peak_x{i, j} = max(SDAT{i, j}.(x))';
        peak_y{i, j} = max(SDAT{i, j}.(y))';
    end
end

% Writing individual peak profile data in each directions
datcell = cell(1, n_eq*3);
for i = 1:nprofile
    for j = 1:ncase
        for k = 1:n_eq
            [~,sortinds] = sort(SDAT{k, ncase*i-(ncase-j)}.z);
            datcell{1, k*3 - 2} = SDAT{k, ncase*i-(ncase-j)}.z(sortinds);
            datcell{1, k*3 - 1} = convf(unitno).*peak_x{k, ncase*i-(ncase-j)}(sortinds);
            datcell{1, k*3    } = convf(unitno).*peak_y{k, ncase*i-(ncase-j)}(sortinds);
        end
        % Extracting dimension of interest
        c = squeeze(datcell(1,:));
        % Padding empty values to create uniform size
        maxLength=max(cellfun(@(x)numel(x),c));
        cpad=cell2mat(cellfun(@(x)cat(1,x,NaN(maxLength-length(x),1)),c,'UniformOutput',false));
        % Converting to cell array with one cell per entry
        csized = num2cell(cpad);
        % Writing column headers and data into sheet of xls file
        warning('off','all');
        xlswrite(filepath, [colhead1; colhead2; csized], strcat(SDAT{1, i*ncase}.profile,'_',SDAT{1, j}.case));
        disp(['Written sheet for: ' strcat(SDAT{1, i*ncase}.profile,'_',SDAT{1, j}.case)]);
    end
end



end