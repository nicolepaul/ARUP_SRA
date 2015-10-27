function plot_responseSpectrum(NDAT, x, y, E, unitstr, conv_val, eqname, str, ystr, nprofile, ncase, rs_bool, rec_bool, directorystr, rec_type, convtoSI, oneplot, zplot, lay_requested)

% Checking damping
if E ~= NDAT{1,1}.E
    error(['Did not process data with E=' num2str(E)]);
    % Should recalc RS here
end

% Determine number of folders per case
nfolders = size(NDAT,2);
neq = size(NDAT,1);

% Figure, axes, line properties
defaultFigureProperties;
% plotline = {'b','m','g','r','c','y'};
plotline = {[0 0.4470 0.7410], ...
    [0.8500    0.3250    0.0980],...
    [0.9290    0.6940    0.1250],...
    [0.4940    0.1840    0.5560],...
    [0.4660    0.6740    0.1880],...
    [0.3010    0.7450    0.9330],...
    [0.6350    0.0780    0.1840]};
% plotline = {'r','m','k','g','c','b'};
% plotline = {'k', 'b','r'};
bval = 0.8;
gval = 0.1;
rval = linspace(0.2, 1, neq);

% Get size of screen in pixels
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
% Adjust display to these dimensions
xmult = Pix_SS(3)/1920;
ymult = Pix_SS(4)/1080;
ppinv = [1*xmult 1*ymult 1*xmult 1*ymult];

% Determine summary plots needed
calc_rsmean = rs_bool(1);
calc_rsmax = rs_bool(2);
calc_rsmeanstd = rs_bool(3);
calc_rsmajor = rs_bool(4);
calc_rsstd = rs_bool(5);
calc_rsgeomean = rs_bool(6);



% Find time increment in each analysis
dt=NaN(neq,nfolders);
for i = 1:neq
    for j = 1:nfolders
        dt(i,j) = NDAT{i,j}.t(2);
    end
end

% Number of points requested for response spectrum plots
np = 150;


% Determine subplot layout
p = numSubplots(nprofile);
p2 = numSubplots(ncase);

if ~oneplot
    if ~zplot
        % Plotting individual response spectra
        for i = 1:neq

            % Generating figures

            % X-Direction
            figure;
            for j = 1:nprofile
                subplot(p(1), p(2), j);
                for k = 1:ncase
                    plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(x),'Color', plotline{k}, 'LineWidth', 1.5, 'DisplayName', NDAT{i,ncase*j-(ncase-k)}.case);
                    grid on; hold on;
                    xlabel('Period [s]'); ylabel(ystr);
                    title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
                end
                % Add recorded plots if requested
                if rec_bool
                    % Surface Acceleration
                    if rec_type == 1

                        [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
                        num_rec = size(RS_rec,2);
                        shade = [0 0.4 0.8];
                        for m = 1:num_rec
                            plot(RS_rec{i,m}(:,1), conv_val*RS_rec{i,m}(:,2), '--', 'Color', [1 1 1]*shade(m), 'LineWidth', 2, 'DisplayName', name_rec{i,m});
                        end
                        % Spectral Amplificaiton
                    elseif rec_type == 4

                        [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
                        num_rec = size(RS_rec,2);
                        shade = [0 0.4 0.8];

                        for m = 1:num_rec
                            RS = interp1(RS_rec{i,m}(:,1), RS_rec{i,m}(:,2), NDAT{i,1}.T)';
                            if isfield(NDAT{i,1},'outx')
                                SA = RS ./ NDAT{i,1}.outx;
                            else
                                SA = RS ./ NDAT{i,1}.RS_x;
                            end
                            plot(NDAT{i,1}.T, SA, '--', 'Color', [1 1 1]*shade(m), 'LineWidth', 2, 'DisplayName', name_rec{i,m});
                        end


                    end
                end
                legend('-dynamicLegend','Location','NorthEast');
                hold off;
            end
            set(gcf,'Position',ppinv.*[50 50 400*p(2) 450*p(1)]);
            linkaxes; tightfig;

            % Y-Direction
            figure;
            for j = 1:nprofile
                subplot(p(1), p(2), j);
                for k = 1:ncase
                    plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(y),'Color', plotline{k}, 'LineWidth', 1.5, 'DisplayName', NDAT{i,ncase*j-(ncase-k)}.case);
                    grid on; hold on;
                    xlabel('Period [s]'); ylabel(ystr);
                    title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
                end
                % Add recorded plots if requested
                if rec_bool
                    % Surface Acceleration
                    if rec_type == 1

                        [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
                        num_rec = size(RS_rec,2);
                        shade = [0 0.4 0.8];
                        for m = 1:num_rec
                            plot(RS_rec{i,m}(:,1), conv_val*RS_rec{i,m}(:,3), '--', 'Color', [1 1 1]*shade(m), 'LineWidth', 2, 'DisplayName', name_rec{i,m});
                        end
                        % Spectral Amplificaiton
                    elseif rec_type == 4

                        [RS_rec,name_rec]=processRecorded(directorystr, convtoSI);
                        num_rec = size(RS_rec,2);
                        shade = [0 0.4 0.8];

                        for m = 1:num_rec
                            RS = interp1(RS_rec{i,m}(:,1), RS_rec{i,m}(:,3), NDAT{i,1}.T)';
                            if isfield(NDAT{i,1},'outy')
                                SA = RS ./ NDAT{i,1}.outy;
                            else
                                SA = RS ./ NDAT{i,1}.RS_y;
                            end
                            plot(NDAT{i,1}.T, SA, '--', 'Color', [1 1 1]*shade(m), 'LineWidth', 2, 'DisplayName', name_rec{i,m});
                        end


                    end
                end

                legend('-dynamicLegend','Location','NorthEast');
                hold off;
            end
            set(gcf,'Position',ppinv.*[50 50 400*p(2) 450*p(1)]);
            linkaxes; tightfig;

        end
    else
        % If plotting layers
        % Plotting individual response spectra
        for i = 1:neq

            % Generating figures

            % X-Direction
            figure;
            for j = 1:nprofile
                subplot(p(1), p(2), j);
                for k = 1:ncase
                    plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(x)(:,lay_requested), 'LineWidth', 1.5);
                    grid on; hold on;
                    xlabel('Period [s]'); ylabel(ystr);
                    title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
                end
                legend(NDAT{i,ncase*j-(ncase-k)}.SA_layno{lay_requested},'Location','NorthEast');
                hold off;               
            end
            
            set(gcf,'Position',ppinv.*[50 50 400*p(2) 450*p(1)]);
            linkaxes; tightfig;

            % Y-Direction
            figure;
            for j = 1:nprofile
                subplot(p(1), p(2), j);
                for k = 1:ncase
                    plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(y)(:,lay_requested), 'LineWidth', 1.5);
                    grid on; hold on;
                    xlabel('Period [s]'); ylabel(ystr);
                    title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
                end

                legend(NDAT{i,ncase*j-(ncase-k)}.SA_layno{lay_requested},'Location','NorthEast');
                hold off;
            end
            set(gcf,'Position',ppinv.*[50 50 400*p(2) 450*p(1)]);
            linkaxes; tightfig;

        end
        
    end
    
    % If putting all folder analyses on one plot
else
    % X-Direction
    tfact = 1;
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            %                 legendstr = cell(neq, 1);
            xarray = [];
            for i = 1:neq
                % X-Direction
                xarray = [xarray NDAT{i,ncase*j-(ncase-k)}.(x)];
                plot(NDAT{i,ncase*j-(ncase-k)}.T, tfact*conv_val*NDAT{i,ncase*j-(ncase-k)}.(x), 'Color', plotline{i}, 'DisplayName', eqname{i}, 'LineWidth', 1.5); hold on;
                legend('-DynamicLegend','Location','NorthEast');
            end
            grid on; xlabel('Period [s]'); ylabel(ystr);
            title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            
            
        end
        set(gcf,'Position',ppinv.*[50 50 400*p2(2) 400*p2(1)]);
        linkaxes; tightfig;
    end
    
    % Y-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            
            yarray = [];
            for i = 1:neq
                % Y-Direction
                yarray = [xarray NDAT{i,ncase*j-(ncase-k)}.(y)];
                plot(NDAT{i,ncase*j-(ncase-k)}.T, tfact*conv_val*NDAT{i,ncase*j-(ncase-k)}.(y), 'Color', plotline{i}, 'DisplayName', eqname{i}, 'LineWidth', 1.5); hold on;
                legend('-DynamicLegend','Location','NorthEast');
            end
            grid on; xlabel('Period [s]'); ylabel(ystr);
            title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Y'));
            
        end
        
        set(gcf,'Position',ppinv.*[50 50 400*p2(2) 400*p2(1)]);
        linkaxes; tightfig;
    end
end
% TEMP TEMP TEMP





% Summary plots
if any(rs_bool(1:4))
    
    
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
                %                 legendstr = cell(neq, 1);
                xarray = [];
                for i = 1:neq
                    % X-Direction
                    xarray = [xarray NDAT{i,ncase*j-(ncase-k)}.(x)];
                    plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(x), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(ystr);
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
            if calc_rsmean
                RSmean = mean(xarray,2);%mean(RSx(:, ncase*j-(ncase-k), :), 3);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
            end
            
            if calc_rsmax
                RSmax = max(xarray, [], 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
            end
            
            if calc_rsmeanstd
                RSmean = mean(xarray, 2);
                RSstd = std(xarray, 0, 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean+calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean-calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
            end
        end
        set(gcf,'Position',ppinv.*[50 50 400*p2(2) 400*p2(1)]);
        linkaxes; tightfig;
    end
    
    % Y-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
                %                 legendstr = cell(neq, 1);
                yarray = [];
                for i = 1:neq
                    % Y-Direction
                    yarray = [xarray NDAT{i,ncase*j-(ncase-k)}.(y)];
                    plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*NDAT{i,ncase*j-(ncase-k)}.(y), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(ystr);
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Y'));
            end
            
            
            if calc_rsmean
                RSmean = mean(yarray, 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
            end
            
            if calc_rsmax
                RSmax = max(yarray, [], 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
            end
            
            if calc_rsmeanstd
                RSmean = mean(yarray, 2);
                RSstd = std(yarray, 0, 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean+calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*(RSmean-calc_rsstd*RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
            end
        end
        
        set(gcf,'Position',ppinv.*[50 50 400*p2(2) 400*p2(1)]);
        linkaxes; tightfig;
    end
    
    
    
end


% Major and geomean figures -- only for surface response spectrum
if strcmpi(x,'RSx') && rs_bool(4)
    
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            
            %                 legendstr = cell(neq, 1);
            marray = [];
            for i = 1:neq
                % X-Direction
                surfid = NDAT{i,ncase*j-(ncase-k)}.surfid;
                Ag =[NDAT{i,ncase*j-(ncase-k)}.ax(:,surfid) NDAT{i,ncase*j-(ncase-k)}.ay(:,surfid)];
                marray = [marray BiSpectra_Rev1(Ag, NDAT{i,ncase*j-(ncase-k)}.t(2), NDAT{i,ncase*j-(ncase-k)}.T, E)];
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*marray(:,end), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                legend('-DynamicLegend');
            end
            grid on; xlabel('Period [s]'); ylabel(ystr);
            title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Major'));
            
            if calc_rsmean
                RSmean = mean(marray, 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
            end
            
            if calc_rsmax
                RSmax = max(marray, [], 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
            end
        end
        
        set(gcf,'Position',ppinv.*[50 50 400*p2(2) 400*p2(1)]);
        linkaxes; tightfig;
    end
end

if rs_bool(6)
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            
            %                 legendstr = cell(neq, 1);
            marray = [];
            for i = 1:neq
                % X-Direction
                marray = [marray sqrt(NDAT{i,ncase*j-(ncase-k)}.RSx.*NDAT{i,ncase*j-(ncase-k)}.RSy)];
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*marray(:,end), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                legend('-DynamicLegend');
            end
            grid on; xlabel('Period [s]'); ylabel(ystr);
            title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Geomean'));
            
            if calc_rsmean
                RSmean = mean(marray, 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmean, 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
            end
            
            if calc_rsmax
                RSmax = max(marray, [], 2);
                plot(NDAT{i,ncase*j-(ncase-k)}.T, conv_val*RSmax, 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
            end
            
        end
        
        set(gcf,'Position',ppinv.*[50 50 400*p2(2) 400*p2(1)]);
        linkaxes; tightfig;
    end
end
