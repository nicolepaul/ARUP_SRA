function write_responseSpectrum(NDAT, x, y, E, unitstr, conv_val, eqname, str, unitno, nprofile, ncase, rs_bool, rec_bool, directorystr, rec_type, convtoSI, oneplot, zplot, lay_requested, dirpath)

% Checking damping
if E ~= NDAT{1,1}.E
    error(['Did not process data with E=' num2str(E)]);
    % Should recalc RS here
end

% Determine number of folders per case
nfolders = size(NDAT,2);
neq = size(NDAT,1);

% Determine summary plots needed
calc_rsmean = rs_bool(1);
calc_rsmax = rs_bool(2);
calc_rsmeanstd = rs_bool(3);
calc_rsmajor = rs_bool(4);
calc_rsstd = rs_bool(5);
calc_rsgeomean = rs_bool(6);


% Writing header lines
n_eq = numel(eqname);
if rec_type ~= 4
    for i = 1:n_eq
        if i == 1
            colhead1 = {eqname{i}, eqname{i}, eqname{i}};
            colhead2 = {'Period [s]', [str ', X [' unitstr{unitno} ']'], [str ', Y [' unitstr{unitno} ']']};
        else
            colhead1 = [colhead1, eqname{i}, eqname{i}, eqname{i}];
            colhead2 = [colhead2, 'Period [s]', [str ', X [' unitstr{unitno} ']'], [str ', Y [' unitstr{unitno} ']']];
        end
    end
else
    for i = 1:n_eq
        if i == 1
            colhead1 = {eqname{i}, eqname{i}, eqname{i}};
            colhead2 = {'Period [s]', [str ', X'], [str ', Y']};
        else
            colhead1 = [colhead1, eqname{i}, eqname{i}, eqname{i}];
            colhead2 = [colhead2, 'Period [s]', [str ', X'], [str ', Y']];
        end
    end
end

if zplot
    if rec_type ~= 4
        for i = 1:n_eq
            if i == 1
                for j = 1:numel(lay_requested)
                    if j == 1
                        zcolhead1 = {eqname{i}, eqname{i}, eqname{i}};
                        zcolhead2 = {'Period [s]', [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', X [' unitstr{unitno} ']'], [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', Y [' unitstr{unitno} ']']};
                    else
                        zcolhead1 = [zcolhead1, eqname{i}, eqname{i}, eqname{i}];
                        zcolhead2 = [zcolhead2, 'Period [s]', [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', X [' unitstr{unitno} ']'], [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', Y [' unitstr{unitno} ']']];
                    end
                end
            else
                for j = 1:numel(lay_requested)
                    zcolhead1 = [zcolhead1, eqname{i}, eqname{i}, eqname{i}];
                    zcolhead2 = [zcolhead2, 'Period [s]', [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', X [' unitstr{unitno} ']'], [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', Y [' unitstr{unitno} ']']];
                end
            end
        end
    else
        for i = 1:n_eq
            if i == 1
                for j = 1:numel(lay_requested)
                    if j == 1
                        zcolhead1 = {eqname{i}, eqname{i}, eqname{i}};
                        zcolhead2 = {'Period [s]', [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', X'], [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', Y']};
                    else
                        zcolhead1 = [zcolhead1, eqname{i}, eqname{i}, eqname{i}];
                        zcolhead2 = [zcolhead2, 'Period [s]', [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', X'], [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', Y']];
                    end
                end
            else
                for j = 1:numel(lay_requested)
                    zcolhead1 = [zcolhead1, eqname{i}, eqname{i}, eqname{i}];
                    zcolhead2 = [zcolhead2, 'Period [s]', [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', X'], [NDAT{i,1}.SA_layno{lay_requested(j)} ' ' str ', Y']];
                end
            end
        end
    end
end

% Spreadsheet name
friendlystr = str;
friendlystr(ismember(friendlystr,' ,.:;!()')) = [];
filename = strcat('ResponseSpectrum_',friendlystr,'.xls');
filename2 = strcat('ResponseSpectrumDepth_',friendlystr,'.xls');
filepath = fullfile(dirpath,filename);
filepath2 = fullfile(dirpath,filename2);

% Find time increment in each analysis
dt=NaN(neq,nfolders);
for i = 1:neq
    for j = 1:nfolders
        dt(i,j) = NDAT{i,j}.t(2);
    end
end

% Writing individual peak profile data in each directions
if ~zplot
    datcell = cell(1, n_eq*3);
    disp(['Opening ' strcat('ResponseSpectrum_',friendlystr,'.xls')]);
    for i = 1:nprofile
        for j = 1:ncase
            for k = 1:n_eq
                datcell{1, k*3 - 2} = NDAT{k, ncase*i-(ncase-j)}.T';
                datcell{1, k*3 - 1} = conv_val.*NDAT{k, ncase*i-(ncase-j)}.(x);
                datcell{1, k*3    } = conv_val.*NDAT{k, ncase*i-(ncase-j)}.(y);
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
else
    disp(['Opening ' strcat('ResponseSpectrumDepth_',friendlystr,'.xls')]);
    zdatcell = cell(1, n_eq*(3*numel(lay_requested)));
    for i = 1:nprofile
        for j = 1:ncase
            for k = 1:n_eq
                for m = 1:numel(lay_requested)
                    zdatcell{1, (k-1)*3*numel(lay_requested) + 1 + (m-1)*3} = NDAT{k, ncase*i-(ncase-j)}.T';
                    zdatcell{1, (k-1)*3*numel(lay_requested) + 2 + (m-1)*3} = conv_val.*NDAT{k, ncase*i-(ncase-j)}.(x)(:,lay_requested(m));
                    zdatcell{1, (k-1)*3*numel(lay_requested) + 3 + (m-1)*3} = conv_val.*NDAT{k, ncase*i-(ncase-j)}.(y)(:,lay_requested(m));
                end
            end
            % Extracting dimension of interest
            c = squeeze(zdatcell(1,:));
            % Padding empty values to create uniform size
            maxLength=max(cellfun(@(x)numel(x),c));
            cpad=cell2mat(cellfun(@(x)cat(1,x,NaN(maxLength-length(x),1)),c,'UniformOutput',false));
            % Converting to cell array with one cell per entry
            csized = num2cell(cpad);
            % Writing column headers and data into sheet of xls file
            warning('off','all');
            xlswrite(filepath2, [zcolhead1; zcolhead2; csized], strcat(NDAT{1, i*ncase}.profile,'_',NDAT{1, j}.case));
            disp(['Written sheet for: ' strcat(NDAT{1, i*ncase}.profile,'_',NDAT{1, j}.case)]);
        end
    end
end


% % Number of points requested for response spectrum plots
% np = 150;
%
%
% if ~zplot
%     for i = 1:neq
%         for j = 1:nprofile
%             for k = 1:ncase
%                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(x), 'DisplayName', NDAT{i,ncase*j-(ncase-k)}.case);
%             end
%             % Add recorded plots if requested
%             if rec_bool
%                 % Surface Acceleration
%                 if rec_type == 1
%                     [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
%                     num_rec = size(RS_rec,2);
%                     for m = 1:num_rec
%                         plot(RS_rec{i,m}(:,1), conv_val*RS_rec{i,m}(:,2), '--', 'DisplayName', name_rec{i,m});
%                     end
%                     % Spectral Amplificaiton
%                 elseif rec_type == 4
%                     for m = 1:num_rec
%                         RS = interp1(RS_rec{i,m}(:,1), RS_rec{i,m}(:,2), NDAT{i,1}.T)';
%                         if isfield(NDAT{i,1},'outx')
%                             SA = RS ./ NDAT{i,1}.outx;
%                         else
%                             SA = RS ./ NDAT{i,1}.RS_x;
%                         end
%                         plot(NDAT{i,1}.T, SA, '--', 'DisplayName', name_rec{i,m});
%                     end
%
%                 end
%             end
%         end
%         % Y-Direction
%         for j = 1:nprofile
%             for k = 1:ncase
%                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(y),'DisplayName', NDAT{i,ncase*j-(ncase-k)}.case);
%             end
%             % Add recorded plots if requested
%             if rec_bool
%                 % Surface Acceleration
%                 if rec_type == 1
%                     [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
%                     num_rec = size(RS_rec,2);
%                     for m = 1:num_rec
%                         plot(RS_rec{i,m}(:,1), conv_val*RS_rec{i,m}(:,3), '--', 'DisplayName', name_rec{i,m});
%                     end
%                     % Spectral Amplificaiton
%                 elseif rec_type == 4
%                     [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
%                     num_rec = size(RS_rec,2);
%                     for m = 1:num_rec
%                         RS = interp1(RS_rec{i,m}(:,1), RS_rec{i,m}(:,3), NDAT{i,1}.T)';
%                         if isfield(NDAT{i,1},'outy')
%                             SA = RS ./ NDAT{i,1}.outy;
%                         else
%                             SA = RS ./ NDAT{i,1}.RS_y;
%                         end
%                         plot(NDAT{i,1}.T, SA, '--', 'DisplayName', name_rec{i,m});
%                     end
%                 end
%             end
%         end
%     end
% else
%     % If plotting layers
%     % Plotting individual response spectra
%     for i = 1:neq
%         % X-Direction
%         for j = 1:nprofile
%             for k = 1:ncase
%                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(x)(:,lay_requested));
%             end
%             legend(NDAT{i,ncase*j-(ncase-k)}.SA_layno{lay_requested},'Location','NorthEast');
%         end
%         % Y-Direction
%        for j = 1:nprofile
%             for k = 1:ncase
%                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(y)(:,lay_requested));
%             end
%             legend(NDAT{i,ncase*j-(ncase-k)}.SA_layno{lay_requested},'Location','NorthEast');
%        end
%     end
% end


%% NOT  YET INCLUDED - Summary xls writing
% % % % % Summary plots
% % % % if any(rs_bool(1:4))
% % % %     % Summary Spreadsheet name
% % % %     filename2 = strcat('ResponseSpectrumSummary_',friendlystr,'.xls');
% % % %     filepath2 = fullfile(dirpath,filename2);
% % % %     disp(['Opening ' strcat('ResponseSpectrumSummary_',friendlystr,'.xls')]);
% % % %
% % % %     % X-Direction
% % % %     for j = 1:nprofile
% % % %         for k = 1:ncase
% % % %             subplot(p2(1),p2(2),k);
% % % %             % Plot all motions on one figure
% % % %             if any(rs_bool(1:4))
% % % %                 xarray = [];
% % % %                 for i = 1:neq
% % % %                     % X-Direction
% % % %                     xarray = [xarray NDAT{i,ncase*j-(ncase-k)}.(x)];
% % % %                     plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(x), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
% % % %                 end
% % % %                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
% % % %             end
% % % %
% % % %             if calc_rsmean
% % % %                 RSmean = mean(xarray,2);%mean(RSx(:, ncase*j-(ncase-k), :), 3);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
% % % %             end
% % % %
% % % %             if calc_rsmax
% % % %                 RSmax = max(xarray, [], 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
% % % %             end
% % % %
% % % %             if calc_rsmeanstd
% % % %                 RSmean = mean(xarray, 2);
% % % %                 RSstd = std(xarray, 0, 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean+calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean-calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
% % % %             end
% % % %         end
% % % %     end
% % % %
% % % %     % Y-Direction
% % % %     for j = 1:nprofile
% % % %         for k = 1:ncase
% % % %             % Plot all motions on one figure
% % % %             if any(rs_bool(1:4))
% % % %                 yarray = [];
% % % %                 for i = 1:neq
% % % %                     % Y-Direction
% % % %                     yarray = [yarray NDAT{i,ncase*j-(ncase-k)}.(x)];
% % % %                     plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(y), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i});  hold on;
% % % %                 end
% % % %             end
% % % %
% % % %             if calc_rsmean
% % % %                 RSmean = mean(yarray, 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
% % % %             end
% % % %
% % % %             if calc_rsmax
% % % %                 RSmax = max(yarray, [], 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
% % % %             end
% % % %
% % % %             if calc_rsmeanstd
% % % %                 RSmean = mean(yarray, 2);
% % % %                 RSstd = std(yarray, 0, 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean+calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean-calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
% % % %             end
% % % %         end
% % % %     end
% % % %
% % % %
% % % %
% % % % end
% % % %
% % % %
% % % % % Major and geomean figures -- only for surface response spectrum
% % % % if strcmpi(x,'RSx') && rs_bool(4)
% % % %
% % % %     for j = 1:nprofile
% % % %         figure;
% % % %         for k = 1:ncase
% % % %             % Plot all motions on one figure
% % % %             marray = [];
% % % %             for i = 1:neq
% % % %                 % X-Direction
% % % %                 surfid = NDAT{i,ncase*j-(ncase-k)}.surfid;
% % % %                 Ag =[NDAT{i,ncase*j-(ncase-k)}.ax(:,surfid) NDAT{i,ncase*j-(ncase-k)}.ay(:,surfid)];
% % % %                 marray = [marray BiSpectra_Rev1(Ag, NDAT{i,ncase*j-(ncase-k)}.t(2), NDAT{i,ncase*j-(ncase-k)}.T, E)];
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*marray(:,end), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
% % % %             end
% % % %
% % % %             if calc_rsmean
% % % %                 RSmean = mean(marray, 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
% % % %             end
% % % %
% % % %             if calc_rsmax
% % % %                 RSmax = max(marray, [], 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
% % % %             end
% % % %         end
% % % %     end
% % % % end
% % % %
% % % % if rs_bool(6)
% % % %     for j = 1:nprofile
% % % %         for k = 1:ncase
% % % %             % Plot all motions on one figure
% % % %             marray = [];
% % % %             for i = 1:neq
% % % %                 % X-Direction
% % % %                 marray = [marray sqrt(NDAT{i,ncase*j-(ncase-k)}.RSx.*NDAT{i,ncase*j-(ncase-k)}.RSy)];
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*marray(:,end), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
% % % %             end
% % % %
% % % %             if calc_rsmean
% % % %                 RSmean = mean(marray, 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
% % % %             end
% % % %
% % % %             if calc_rsmax
% % % %                 RSmax = max(marray, [], 2);
% % % %                 plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
% % % %             end
% % % %
% % % %         end
% % % %     end
% % % % end
