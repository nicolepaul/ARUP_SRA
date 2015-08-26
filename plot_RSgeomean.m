function plot_RSgeomean(dt, NDAT, E, nprofile, ncase, eqname, convf, str, unitstr)

% Determine number of folders per case
nfolders = size(NDAT,2);
neq = size(NDAT,1);

% Figure, axes, line properties
defaultFigureProperties;
plotline = {'m--','r','g','b','m','c','y'};
bval = 0.8;
gval = 0.1;
rval = linspace(0.2, 1, neq);

% Number of points requested for response spectrum plots
np = 150;
% Range of periods requested for response spectrum plots
T_range = linspace(1e-3,8,np)';
fn = 1./T_range;
G = 9.81;

% Initializing response spectrum matrices
RSx = NaN(np, nfolders, neq);
RSy = NaN(np, nfolders, neq);
RS_x = NaN(np, nfolders, neq);
RS_y = NaN(np, nfolders, neq);
RSgeomean = NaN(np, nfolders, neq);
RS_geomean = NaN(np, nfolders, neq);
RSmajor = NaN(np, nfolders, neq);
RS_major = NaN(np, nfolders, neq);

% Determine subplot layout
p = numSubplots(nprofile);
p2 = numSubplots(ncase);



% Plotting individual response spectra
for i = 1:neq
    % Computing response spectra
    for j = 1:nfolders
        RSx (:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ax(:,NDAT{i,j}.surfid)./G, E, G);
        RSy (:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ay(:,NDAT{i,j}.surfid)./G, E, G);
        Ag = [NDAT{i,j}.ax(:,NDAT{i,j}.surfid)  NDAT{i,j}.ay(:,NDAT{i,j}.surfid)];
        RSgeomean (:, j, i) = BiSpectra_Rev1(Ag,dt(i,j),T_range,E);
        RSmajor (:, j, i) = sqrt(RSx (:, j, i)./RSy (:, j, i));
        RS_x(:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ax(:,end)./G, E, G); % TEMP - bedid not working
        RS_y(:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ay(:,end)./G, E, G);
        RS_geomean (:, j, i) = sqrt(RS_x (:, j, i)./RS_y (:, j, i));
        Ag = [NDAT{i,j}.ax(:,end)  NDAT{i,j}.ay(:,end)];
        RS_major (:, j, i) = BiSpectra_Rev1(Ag,dt(i,j),T_range,E);
    end
end

% Summary plots -- GEOMEAN
if rsno == 1
    
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
%                 legendstr = cell(neq, 1);
                for i = 1:neq
                    % X-Direction
                    plot(T_range, convf(1)*squeeze(RSgeomean(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
                RSmean = mean(RSgeomean(:, ncase*j-(ncase-k), :), 3);
                plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

                RSmax = max(RSgeomean(:, ncase*j-(ncase-k), :), [], 3);
                plot(T_range, squeeze(RSmax), 'r--', 'LineWidth', 2, 'DisplayName', 'Max');
            

        end
    end
    
elseif rsno == 2 || rsno == 3
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
%                 legendstr = cell(neq, 1);
                for i = 1:neq
                    % X-Direction
                    plot(T_range, convf(1)*squeeze(RS_geomean(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
                RSmean = mean(RS_geomean(:, ncase*j-(ncase-k), :), 3);
                plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

                RSmax = max(RS_geomean(:, ncase*j-(ncase-k), :), [], 3);
                plot(T_range, squeeze(RSmax), 'r--', 'LineWidth', 2, 'DisplayName', 'Max');
            

        end
    end
elseif rsno == 4
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
%                 legendstr = cell(neq, 1);
                for i = 1:neq
                    % X-Direction
                    plot(T_range, convf(1)*squeeze(RSgeomean(:,ncase*j-(ncase-k),i))./squeeze(RS_geomean(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
                RSmean = mean(RSgeomean(:, ncase*j-(ncase-k), :), 3)./mean(RS_geomean(:, ncase*j-(ncase-k), :), 3);
                plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

                RSmax = max(RSgeomean(:, ncase*j-(ncase-k), :), [], 3)./max(RS_geomean(:, ncase*j-(ncase-k), :), [], 3);
                plot(T_range, squeeze(RSmax), 'r--', 'LineWidth', 2, 'DisplayName', 'Max');
            

        end
    end
    
end

% Summary plots -- MAJOR
if rsno == 1
    
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
%                 legendstr = cell(neq, 1);
                for i = 1:neq
                    % X-Direction
                    plot(T_range, squeeze(RSmajor(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
                RSmean = mean(RSmajor(:, ncase*j-(ncase-k), :), 3);
                plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

                RSmax = max(RSmajor(:, ncase*j-(ncase-k), :), [], 3);
                plot(T_range, squeeze(RSmax), 'r--', 'LineWidth', 2, 'DisplayName', 'Max');
            

        end
    end
    
elseif rsno == 2 || rsno == 3
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
%                 legendstr = cell(neq, 1);
                for i = 1:neq
                    % X-Direction
                    plot(T_range, squeeze(RS_major(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
                RSmean = mean(RS_major(:, ncase*j-(ncase-k), :), 3);
                plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

                RSmax = max(RS_major(:, ncase*j-(ncase-k), :), [], 3);
                plot(T_range, squeeze(RSmax), 'r--', 'LineWidth', 2, 'DisplayName', 'Max');
            

        end
    end
elseif rsno==4
    % X-Direction
    for j = 1:nprofile
        figure;
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            % Plot all motions on one figure
            if any(rs_bool(1:4))
%                 legendstr = cell(neq, 1);
                for i = 1:neq
                    % X-Direction
                    plot(T_range, squeeze(RSmajor(:,ncase*j-(ncase-k),i))./squeeze(RS_major(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
                    legend('-DynamicLegend');
                end
                grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
            end
            
            
                RSmean = mean(RSmajor(:, ncase*j-(ncase-k), :), 3)./mean(RS_major(:, ncase*j-(ncase-k), :), 3);
                plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

                RSmax = max(RSmajor(:, ncase*j-(ncase-k), :), [], 3)./max(RS_major(:, ncase*j-(ncase-k), :), [], 3);
                plot(T_range, squeeze(RSmax), 'r--', 'LineWidth', 2, 'DisplayName', 'Max');
            

        end
    end
    
end