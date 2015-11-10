function write_timeHistory(NDAT, t, x, y, eqname, str, unitno, convf, unitstr, surfbool, nprofile, ncase, dirpath)
% plot_timeHistory
%
% INPUTS:
% - NDAT: Node data structure
% - x: Field name of x direction values
% - y: Field name of y direction values
% - eqname: List of "earthquake" names
% - str: String that will appear in title
% - unitno: 1 for acceleration, 2 for velocity, 3 for displacement, 4 for stress
% - convf: Unit conversion factors
% - unitstr: String of unit names
% - surfbool: 1 if Surface, 0 if Bedrock * Currently infield
% - nprofile: Number of soil profiles (to each have their own subplot)
% - ncase: Number of cases (to appear on same plot)

% Writing header lines
n_eq = numel(eqname);
for i = 1:n_eq
    if i == 1
        colhead1 = {eqname{i}, eqname{i}, eqname{i}};
        colhead2 = {'Time [s]', [str ', X [' unitstr{unitno} ']'], [str ', Y [' unitstr{unitno} ']']};
    else
        colhead1 = [colhead1, eqname{i}, eqname{i}, eqname{i}];
        colhead2 = [colhead2, 'Time [s]', [str ', X [' unitstr{unitno} ']'], [str ', Y [' unitstr{unitno} ']']];
    end
end

% Spreadsheet name
friendlystr = str;
friendlystr(ismember(friendlystr,' ,.:;!()')) = [];
filename = strcat('TimeHistory_',friendlystr,'.xls');
filepath = fullfile(dirpath,filename);
disp(['Opening ' strcat('TimeHistory_',friendlystr,'.xls')]);


% Creating data matrix
datcell = cell(1, n_eq*3);
for i = 1:nprofile
    for j = 1:ncase
        for k = 1:n_eq
            % Finding inds for surface if requested
            if surfbool
                inds = NDAT{k, ncase*i-(ncase-j)}.surfid';
            else % or for outcrop / infield
                if strcmpi(x,'outvx') 
                    inds = 1;
                elseif strcmpi(x,'outax')
                    inds = 1;
                else
                    inds = NDAT{i,ncase*j-(ncase-k)}.bedid';
                end
            end
            datcell{1, k*3 - 2} = NDAT{k, ncase*i-(ncase-j)}.(t);
            datcell{1, k*3 - 1} = convf(unitno).*NDAT{k, ncase*i-(ncase-j)}.(x)(:, inds);
            datcell{1, k*3    } = convf(unitno).*NDAT{k, ncase*i-(ncase-j)}.(y)(:, inds);
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
        xlswrite(filepath, [colhead1; colhead2; csized], strcat(NDAT{1, i*ncase}.profile,'_',NDAT{1, j}.case));
        disp(['Written sheet for: ' strcat(NDAT{1, i*ncase}.profile,'_',NDAT{1, j}.case)]);
    end
end

end