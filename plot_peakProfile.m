function plot_peakProfile(SDAT, x, y, eqname, str, unitno, convf, unitstr, nprofile, ncase, oneplot)

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
neq = numel(eqname);
rval = linspace(0.2, 1, neq);
p2 = numSubplots(ncase);

% Get size of screen in pixels
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
% Adjust display to these dimensions
xmult = Pix_SS(3)/1920; % originally was on 1280x800 display, so need to adjust for current size NOTE: may not work well for displays smaller than a 13" Macbook w/o retina display
ymult = Pix_SS(4)/1080;
ppinv = [1*xmult 1*ymult 1*xmult 1*ymult];

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

if ~oneplot
    % Plotting individual peak profile data
    for i = 1:neq
        % YZ-Direction
        figure;
        for j = 1:nprofile
            subplot(1, nprofile, j);
            legendstr = cell(ncase,1);
            for k = 1:ncase
                [~,sortinds] = sort(SDAT{i,ncase*j-(ncase-k)}.z);
                plot(peak_x{i,ncase*j-(ncase-k)}(sortinds)*convf(unitno), SDAT{i,ncase*j-(ncase-k)}.z(sortinds),'Color', plotline{k}, 'LineWidth', 1, 'DisplayName', SDAT{i,ncase*j-(ncase-k)}.case);
                grid on; hold on;
                xlabel(strcat(str, ', YZ',' [',unitstr{unitno},']'));
                ylabel('Depth [m]');
%                 legendstr{k} = SDAT{i,ncase*j-(ncase-k)}.case;
                title(strcat(eqname{i},':  ',SDAT{i,j*ncase}.profile,' ', '-',' ',str,' Profile, YZ'));
            end
%             legend(legendstr,'Location','SouthEast');
            legend('-dynamicLegend','Location','SouthEast');
            hold off
        end
        set(gcf, 'Position', ppinv.*[50 50 250*nprofile 600]);
        linkaxes; tightfig; axis tight;
    end
    % ZX-Direction
    for i = 1:neq
        figure;
        for j = 1:nprofile
            subplot(1, nprofile, j);
            legendstr = cell(ncase,1);
            for k = 1:ncase
                [~,sortinds] = sort(SDAT{i,ncase*j-(ncase-k)}.z);
                plot(peak_y{i,ncase*j-(ncase-k)}(sortinds)*convf(unitno), SDAT{i,ncase*j-(ncase-k)}.z(sortinds),'Color', plotline{k}, 'LineWidth', 1, 'DisplayName', SDAT{i,ncase*j-(ncase-k)}.case);
                grid on; hold on;
                xlabel(strcat(str, ', ZX',' [',unitstr{unitno},']'));
                ylabel('Depth [m]');
%                 legendstr{k} = SDAT{i,ncase*j-(ncase-k)}.case;
                title(strcat(eqname{i},':  ',SDAT{i,j*ncase}.profile,' ', '-',' ',str,' Profile, ZX'));
            end
%             legend(legendstr,'Location','SouthEast');
            legend('-dynamicLegend','Location','SouthEast');
            hold off
        end
        set(gcf, 'Position', ppinv.*[50 50 250*nprofile 600]);
        linkaxes; tightfig; axis tight;
    end
    
    
else
    % Plotting  peak profile data on one plot
   % ZX-Direction
    for j = 1:nprofile
        figure;
        
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            for i = 1:neq
                [~, sortinds] = SDAT{i,ncase*j-(ncase-k)}.z;
                plot(peak_x{i,ncase*j-(ncase-k)}(sortinds)*convf(unitno), SDAT{i,ncase*j-(ncase-k)}.z(sortinds), plotline{i},  'LineWidth', 1, 'DisplayName', eqname{i}); hold on;
                grid on;
                xlabel(strcat(str, ', YZ',' [',unitstr{unitno},']'));
                ylabel('Depth [m]');
                legend('-DynamicLegend','Location','SouthEast');
                title(strcat(eqname{i},':  ',SDAT{i,j*ncase}.profile,' ', '-',' ',str,' Profile, YZ'));
            end
            hold off
        end
        
    end
    set(gcf, 'Position', ppinv.*[50 50 250*nprofile 600]);
    linkaxes; tightfig; axis tight;
    
    % ZX-Direction
    for j = 1:nprofile
        figure;
        
        for k = 1:ncase
            subplot(p2(1),p2(2),k);
            for i = 1:neq
                [~, sortinds] = SDAT{i,ncase*j-(ncase-k)}.z;
                plot(peak_y{i,ncase*j-(ncase-k)}(sortinds)*convf(unitno), SDAT{i,ncase*j-(ncase-k)}.z(sortinds), plotline{i},  'LineWidth', 1, 'DisplayName', eqname{i}); hold on;
                grid on;
                xlabel(strcat(str, ', ZX',' [',unitstr{unitno},']'));
                ylabel('Depth [m]');
                legend('-DynamicLegend','Location','SouthEast');
                title(strcat(eqname{i},':  ',SDAT{i,j*ncase}.profile,' ', '-',' ',str,' Profile, ZX'));
            end
            hold off
        end
        
    end
    set(gcf, 'Position', ppinv.*[50 50 250*nprofile 600]);
    linkaxes; tightfig; axis tight;
end

end