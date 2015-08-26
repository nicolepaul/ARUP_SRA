function plot_responseSpectrum2(NDAT, E, unitstr, convf, eqname, str, rsno, nprofile, ncase, rs_bool)

% Determine number of folders per case
nfolders = size(NDAT,2);
neq = size(NDAT,1);

% Figure, axes, line properties
defaultFigureProperties;
plotline = {'r','g','b','m','c','y'};
bval = 0.8;
gval = 0.1;
rval = linspace(0.2, 1, neq);

% Determine summary plots needed
calc_rsmean = rs_bool(1);
calc_rsmax = rs_bool(2);
calc_rsmeanstd = rs_bool(3);
calc_rsmajor = rs_bool(4);
calc_rsstd = rs_bool(5);



% Find time increment in each analysis
dt=NaN(neq,nfolders);
for i = 1:neq
    for j = 1:nfolders
        dt(i,j) = NDAT{i,j}.t(2);
    end
end

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

% Determine subplot layout
p = numSubplots(nprofile);
p2 = numSubplots(ncase);

% Plotting individual response spectra
for i = 1:neq
    % Computing response spectra
    for j = 1:nfolders
        RSx (:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ax(:,NDAT{i,j}.surfid)./G, E, G);
        RSy (:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ay(:,NDAT{i,j}.surfid)./G, E, G);
        RS_x(:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ax(:,end)./G, E, G); % TEMP - bedid not working
        RS_y(:, j, i) = getPSA(fn, dt(i,j), NDAT{i,j}.ay(:,end)./G, E, G);
    end
    
    % Generating figures
    if rsno == 1
        % X-Direction
        figure;
        for j = 1:nprofile
            subplot(p(1), p(2), j);
            legendstr = cell(2, 1);
            for k = 2:ncase
                plot(T_range, convf(1)*squeeze(RSx(:,ncase*j-(ncase-k),i)), plotline{k}, 'LineWidth', 1.1);
                grid on; hold on;
                xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
                legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
        
        % Y-Direction
        figure;
        for j = 1:nprofile
            subplot(p(1), p(2), j);
            legendstr = cell(2, 1);
            for k = 2:ncase
                plot(T_range, convf(1)*squeeze(RSy(:,ncase*j-(ncase-k),i)), plotline{k}, 'LineWidth', 1.1);
                grid on; hold on;
                xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
                legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
        
    elseif rsno == 2 || rsno == 3 % TEMP - No outcrop yet
        % X-Direction
        figure;
        for j = 1:nprofile
            subplot(p(1), p(2), j);
            legendstr = cell(2, 1);
            for k = 2:ncase
                plot(T_range, convf(1)*squeeze(RS_x(:,ncase*j-(ncase-k),i)), plotline{k}, 'LineWidth', 1.1);
                grid on; hold on;
                xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
                legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
        
        % Y-Direction
        figure;
        for j = 1:nprofile
            subplot(p(1), p(2), j);
            legendstr = cell(2, 1);
            for k = 2:ncase
                plot(T_range, convf(1)*squeeze(RS_y(:,ncase*j-(ncase-k),i)), plotline{k}, 'LineWidth', 1.1);
                grid on; hold on;
                xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
                legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
        
    elseif rsno == 4
        % X-Direction
        figure;
        for j = 1:nprofile
            subplot(p(1), p(2), j);
            legendstr = cell(2, 1);
            for k = 2:ncase
                plot(T_range, squeeze(RSx(:,ncase*j-(ncase-k),i))./squeeze(RS_x(:,ncase*j-(ncase-k),i)), plotline{k}, 'LineWidth', 1.1);
                grid on; hold on;
                xlabel('Period [s]'); ylabel('Factor');
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
                legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
        
        % Y-Direction
        figure;
        for j = 1:nprofile
            subplot(p(1), p(2), j);
            legendstr = cell(2, 1);
            for k = 2:ncase
                plot(T_range, squeeze(RSy(:,ncase*j-(ncase-k),i))./squeeze(RS_y(:,ncase*j-(ncase-k),i)), plotline{k}, 'LineWidth', 1.1);
                grid on; hold on;
                xlabel('Period [s]'); ylabel('Factor');
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
                legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
        
    end
    
end

% % Summary plots 
% if rsno == 1
%     
%     % X-Direction
%     for j = 1:nprofile
%         figure;
%         for k = 1:ncase
%             subplot(p2(1),p2(2),k);
%             % Plot all motions on one figure
%             if any(rs_bool(1:4))
% %                 legendstr = cell(neq, 1);
%                 for i = 1:neq
%                     % X-Direction
%                     plot(T_range, squeeze(RSx(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
%                     legend('-DynamicLegend');
%                 end
%                 grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
%                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
%             end
%             
%             
%             if calc_rsmean
%                 RSmean = mean(RSx(:, ncase*j-(ncase-k), :), 3);
%                 plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
%             end
%             
%             if calc_rsmax
%                 RSmax = max(RSx(:, ncase*j-(ncase-k), :), [], 3);
%                 plot(T_range, squeeze(RSmax), 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
%             end
%             
%             if calc_rsmeanstd
%                 RSmean = mean(RSx(:, ncase*j-(ncase-k), :), 3);
%                 RSstd = std(RSx(:, ncase*j-(ncase-k), :), 0, 3);
%                 plot(T_range, squeeze(RSmean)+calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
%                 plot(T_range, squeeze(RSmean)-calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
%             end 
%         end
%     end
%     
%     % Y-Direction
%     for j = 1:nprofile
%         figure;
%         for k = 1:ncase
%             subplot(p2(1),p2(2),k);
%             % Plot all motions on one figure
%             if any(rs_bool(1:4))
% %                 legendstr = cell(neq, 1);
%                 for i = 1:neq
%                     % X-Direction
%                     plot(T_range, squeeze(RSy(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
%                     legend('-DynamicLegend');
%                 end
%                 grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
%                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Y'));
%             end
%             
%             
%             if calc_rsmean
%                 RSmean = mean(RSy(:, ncase*j-(ncase-k), :), 3);
%                 plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
%             end
%             
%             if calc_rsmax
%                 RSmax = max(RSy(:, ncase*j-(ncase-k), :), [], 3);
%                 plot(T_range, squeeze(RSmax), 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
%             end
%             
%             if calc_rsmeanstd
%                 RSmean = mean(RSy(:, ncase*j-(ncase-k), :), 3);
%                 RSstd = std(RSy(:, ncase*j-(ncase-k), :), 0, 3);
%                 plot(T_range, squeeze(RSmean)+calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
%                 plot(T_range, squeeze(RSmean)-calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
%             end 
%         end
%     end
%     
% elseif rsno == 2 || rsno == 3
%     
%     % X-Direction
%     for j = 1:nprofile
%         figure;
%         for k = 1:ncase
%             subplot(p2(1),p2(2),k);
%             % Plot all motions on one figure
%             if any(rs_bool(1:4))
% %                 legendstr = cell(neq, 1);
%                 for i = 1:neq
%                     % X-Direction
%                     plot(T_range, squeeze(RS_x(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
%                     legend('-DynamicLegend');
%                 end
%                 grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
%                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
%             end
%             
%             
%             if calc_rsmean
%                 RSmean = mean(RS_x(:, ncase*j-(ncase-k), :), 3);
%                 plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
%             end
%             
%             if calc_rsmax
%                 RSmax = max(RS_x(:, ncase*j-(ncase-k), :), [], 3);
%                 plot(T_range, squeeze(RSmax), 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
%             end
%             
%             if calc_rsmeanstd
%                 RSmean = mean(RS_x(:, ncase*j-(ncase-k), :), 3);
%                 RSstd = std(RS_x(:, ncase*j-(ncase-k), :), 0, 3);
%                 plot(T_range, squeeze(RSmean)+calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
%                 plot(T_range, squeeze(RSmean)-calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
%             end 
%         end
%     end
%     
%     % Y-Direction
%     for j = 1:nprofile
%         figure;
%         for k = 1:ncase
%             subplot(p2(1),p2(2),k);
%             % Plot all motions on one figure
%             if any(rs_bool(1:4))
% %                 legendstr = cell(neq, 1);
%                 for i = 1:neq
%                     % X-Direction
%                     plot(T_range, squeeze(RS_y(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
%                     legend('-DynamicLegend');
%                 end
%                 grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
%                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Y'));
%             end
%             
%             
%             if calc_rsmean
%                 RSmean = mean(RS_y(:, ncase*j-(ncase-k), :), 3);
%                 plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
%             end
%             
%             if calc_rsmax
%                 RSmax = max(RS_y(:, ncase*j-(ncase-k), :), [], 3);
%                 plot(T_range, squeeze(RSmax), 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
%             end
%             
%             if calc_rsmeanstd
%                 RSmean = mean(RS_y(:, ncase*j-(ncase-k), :), 3);
%                 RSstd = std(RS_y(:, ncase*j-(ncase-k), :), 0, 3);
%                 plot(T_range, squeeze(RSmean)+calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
%                 plot(T_range, squeeze(RSmean)-calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
%             end 
%         end
%     end
%     
%     
% elseif rsno == 4
%     
%     % X-Direction
%     for j = 1:nprofile
%         figure;
%         for k = 1:ncase
%             subplot(p2(1),p2(2),k);
%             % Plot all motions on one figure
%             if any(rs_bool(1:4))
% %                 legendstr = cell(neq, 1);
%                 for i = 1:neq
%                     % X-Direction
%                     plot(T_range, squeeze(RSx(:,ncase*j-(ncase-k),i))./squeeze(RS_x(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
%                     legend('-DynamicLegend');
%                 end
%                 grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
%                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', X'));
%             end
%             
%             
%             if calc_rsmean
%                 RSmean = mean(RSx(:, ncase*j-(ncase-k), :)./RS_x(:, ncase*j-(ncase-k), :), 3);
%                 plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
%             end
%             
%             if calc_rsmax
%                 RSmax = max(RSx(:, ncase*j-(ncase-k), :)./RS_x(:, ncase*j-(ncase-k), :), [], 3);
%                 plot(T_range, squeeze(RSmax), 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
%             end
%             
%             if calc_rsmeanstd
%                 RSmean = mean(RSx(:, ncase*j-(ncase-k), :)./RS_x(:, ncase*j-(ncase-k), :), 3);
%                 RSstd = std(RSx(:, ncase*j-(ncase-k), :)./RS_x(:, ncase*j-(ncase-k), :), 0, 3);
%                 plot(T_range, squeeze(RSmean)+calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
%                 plot(T_range, squeeze(RSmean)-calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
%             end 
%         end
%     end
%     
%     % Y-Direction
%     for j = 1:nprofile
%         figure;
%         for k = 1:ncase
%             subplot(p2(1),p2(2),k);
%             % Plot all motions on one figure
%             if any(rs_bool(1:4))
% %                 legendstr = cell(neq, 1);
%                 for i = 1:neq
%                     % X-Direction
%                     plot(T_range, squeeze(RSy(:,ncase*j-(ncase-k),i))./squeeze(RS_y(:,ncase*j-(ncase-k),i)), 'Color', [rval(i) gval bval], 'DisplayName', eqname{i}); hold on;
%                     legend('-DynamicLegend');
%                 end
%                 grid on; xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
%                 title(strcat(NDAT{i,j*ncase}.profile,': ',NDAT{i,ncase*j-(ncase-k)}.case,' ','-',' ',str,', Y'));
%             end
%             
%             
%             if calc_rsmean
%                 RSmean = mean(RSy(:, ncase*j-(ncase-k), :)./RS_y(:, ncase*j-(ncase-k), :), 3);
%                 plot(T_range, squeeze(RSmean), 'k-', 'LineWidth', 2, 'DisplayName', 'Mean');
%             end
%             
%             if calc_rsmax
%                 RSmax = max(RSy(:, ncase*j-(ncase-k), :)./RS_y(:, ncase*j-(ncase-k), :), [], 3);
%                 plot(T_range, squeeze(RSmax), 'r-', 'LineWidth', 2, 'DisplayName', 'Max');
%             end
%             
%             if calc_rsmeanstd
%                 RSmean = mean(RSy(:, ncase*j-(ncase-k), :)./RS_y(:, ncase*j-(ncase-k), :), 3);
%                 RSstd = std(RSy(:, ncase*j-(ncase-k), :)./RS_y(:, ncase*j-(ncase-k), :), 0, 3);
%                 plot(T_range, squeeze(RSmean)+calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean + ', num2str(calc_rsstd),' ' , 'Std.'));
%                 plot(T_range, squeeze(RSmean)-calc_rsstd*squeeze(RSstd), 'k--', 'LineWidth', 2, 'DisplayName', strcat('Mean - ', num2str(calc_rsstd),' ' , 'Std.'));
%             end 
%         end
%     end
%     
% end

end

