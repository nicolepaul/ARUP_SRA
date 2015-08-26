function plot_peakProfile2(SDAT, x, y, eqname, str, unitno, convf, unitstr, nprofile, ncase, pp_bool)

defaultFigureProperties;
plotline = {'r','g','b','m','c','y'};


% Determine number of folders per case
nfolders = size(SDAT,2);
neq = size(SDAT,1);

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

% Plotting individual peak profile data
for i = 1:neq
    % YZ-Direction
    figure;
    for j = 1:nprofile
        subplot(1, nprofile, j);
        legendstr = cell(2,1);
        for k = 2:ncase
            plot(peak_x{i,ncase*j-(ncase-k)}*convf(unitno), SDAT{i,ncase*j-(ncase-k)}.z, plotline{k}, 'LineWidth', 1);
            grid on; hold on;
            xlabel(strcat(str, ', YZ',' [',unitstr{unitno},']'));
            ylabel('Depth [m]');
            legendstr{k-1} = SDAT{i,ncase*j-(ncase-k)}.case;
            title(strcat(eqname{i},':  ',SDAT{i,j*ncase}.profile,' ', '-',' ',str,' Profile, YZ'));
        end
        legend(legendstr,'Location','SouthEast');
        hold off
    end
    
    % ZX-Direction
    figure;
    for j = 1:nprofile
        subplot(1, nprofile, j);
        legendstr = cell(2,1);
        for k = 2:ncase
            plot(peak_y{i,ncase*j-(ncase-k)}*convf(unitno), SDAT{i,ncase*j-(ncase-k)}.z, plotline{k}, 'LineWidth', 1);
            grid on; hold on;
            xlabel(strcat(str, ', ZX',' [',unitstr{unitno},']'));
            ylabel('Depth [m]');
            legendstr{k-1} = SDAT{i,ncase*j-(ncase-k)}.case;
            title(strcat(eqname{i},':  ',SDAT{i,j*ncase}.profile,' ', '-',' ',str,' Profile, ZX'));
        end
        legend(legendstr,'Location','SouthEast');
        hold off
    end
end
        

end