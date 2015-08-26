function plot_timeHistory2(NDAT, x, y, eqname, str, unitno, convf, unitstr, surfbool, nprofile, ncase)
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

defaultFigureProperties;
plotline = {'r','g','b','m','c','y'};

% Plotting individual time histories
n_eq = numel(eqname);
for i = 1:n_eq
    % X-direction
    figure;
    for j = 1:nprofile
        subplot(nprofile, 1, j);
        legendstr = cell(2, 1);
        for k = 2:ncase
            yvals = NDAT{i,ncase*j-(ncase-k)}.(x);
            if surfbool
                inds = NDAT{i,ncase*j-(ncase-k)}.surfid';
            else
                inds = NDAT{i,ncase*j-(ncase-k)}.bedid';
            end
            plot(NDAT{i,ncase*j-(ncase-k)}.t, convf(unitno).*yvals(:, inds), plotline{k}, 'LineWidth', 1); 
            hold on; grid on;
            xlabel('Time [s]'); ylabel(strcat(str,', X',' [',unitstr{unitno},']'));
            title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
            legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
        end
        legend(legendstr,'Location','NorthEast');
        hold off;
    end
    
    % Y-direction
    figure;
    for j = 1:nprofile
        subplot(nprofile, 1, j);
        legendstr = cell(2, 1);
        for k = 2:ncase
            yvals = NDAT{i,ncase*j-(ncase-k)}.(y);
            if surfbool
                inds = NDAT{i,ncase*j-(ncase-k)}.surfid';
            else
                inds = NDAT{i,ncase*j-(ncase-k)}.bedid';
            end
            plot(NDAT{i,ncase*j-(ncase-k)}.t, convf(unitno).*yvals(:, inds), plotline{k}, 'LineWidth', 1); 
            hold on; grid on;
            xlabel('Time [s]'); ylabel(strcat(str,', Y',' [',unitstr{unitno},']'));
            title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
            legendstr{k-1} = NDAT{i,ncase*j-(ncase-k)}.case;
        end
        legend(legendstr,'Location','NorthEast');
        hold off;
    end
end
    

% figure;
% for i = 1:nprof
%     subplot(2,1,i-1);
%     plotinds = ismember(nid,nid_selected(:,i));
%     plot(t, convf(unitno)*x(:,plotinds),'LineWidth',1); grid on;
%     xlabel('Time [s]'); ylabel(strcat(str,', X',' [',unitstr{unitno},']'));
%     legend('Non-Masing','Masing','Linear','Location','NorthWest');
%     title(strcat(profid{i},': ',str,', X'));
% end
% 
% figure;
% for i = 1:nprof
%     subplot(2,1,i-1);
%     plotinds = ismember(nid,nid_selected(:,i));
%     plot(t, convf(unitno)*y(:, plotinds),'LineWidth',1); grid on;
%     xlabel('Time [s]'); ylabel(strcat(str,', Y',' [',unitstr{unitno},']'));
%     legend('Non-Masing','Masing','Linear','Location','NorthWest');
%     title(strcat(profid{i},': ',str,', Y'));
% end

end