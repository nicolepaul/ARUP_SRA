function plot_timeHistory(NDAT, t, x, y, eqname, str, unitno, convf, unitstr, surfbool, nprofile, ncase)
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
% plotline = {'b','m','g','r','c','y'};
plotline = {[0 0.4470 0.7410], ...
    [0.8500    0.3250    0.0980],...
    [0.9290    0.6940    0.1250],...
    [0.4940    0.1840    0.5560],...
    [0.4660    0.6740    0.1880],...
    [0.3010    0.7450    0.9330],...
    [0.6350    0.0780    0.1840]};

% Get size of screen in pixels
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
% Adjust display to these dimensions
xmult = Pix_SS(3)/1920; % originally was on 1280x800 display, so need to adjust for current size NOTE: may not work well for displays smaller than a 13" Macbook w/o retina display
ymult = Pix_SS(4)/1080;
ppinv = [1*xmult 1*ymult 1*xmult 1*ymult];

% Plotting individual time histories
n_eq = numel(eqname);
for i = 1:n_eq
    % X-direction
    figure;
    for j = 1:nprofile
        subplot(nprofile, 1, j);
        legendstr = cell(ncase, 1);
        for k = 1:ncase
            yvals = NDAT{i,ncase*j-(ncase-k)}.(x);
            if surfbool
                inds = NDAT{i,ncase*j-(ncase-k)}.surfid';
            else
                if strcmpi(x,'outvx') 
                    inds = 1;
                elseif strcmpi(x,'outax')
                    inds = 1;
                    yvals = [yvals; 0];
                else
                    inds = NDAT{i,ncase*j-(ncase-k)}.bedid';
                end
            end
            plot(NDAT{i,ncase*j-(ncase-k)}.(t), convf(unitno).*yvals(:, inds),'Color', plotline{k}, 'LineWidth', 1); 
            hold on; grid on;
            xlabel('Time [s]'); ylabel(strcat(str,', X',' [',unitstr{unitno},']'));
            title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
            legendstr{k} = NDAT{i,ncase*j-(ncase-k)}.case;
        end
        legend(legendstr,'Location','best');
        hold off;
    end
    linkaxes; axis tight;
    set(gcf,'Position',ppinv.*[50 50 1000 300*nprofile]);
    tightfig;
    
    % Y-direction
    figure;
    for j = 1:nprofile
        subplot(nprofile, 1, j);
        legendstr = cell(ncase, 1);
        for k = 1:ncase
            yvals = NDAT{i,ncase*j-(ncase-k)}.(y);
            if surfbool
                inds = NDAT{i,ncase*j-(ncase-k)}.surfid';
            else
                if strcmpi(y,'outvy')
                    inds = 1;
                elseif strcmpi(y,'outay')
                    inds = 1;
                    yvals = [yvals; 0];
                else
                    inds = NDAT{i,ncase*j-(ncase-k)}.bedid';
                end
            end
            plot(NDAT{i,ncase*j-(ncase-k)}.(t), convf(unitno).*yvals(:, inds),'Color', plotline{k}, 'LineWidth', 1); 
            hold on; grid on;
            xlabel('Time [s]'); ylabel(strcat(str,', Y',' [',unitstr{unitno},']'));
            title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', Y'));
            legendstr{k} = NDAT{i,ncase*j-(ncase-k)}.case;
        end
        legend(legendstr,'Location','best');
        hold off;
    end
    
    linkaxes; axis tight;
    set(gcf,'Position',ppinv.*[50 50 1000 350*nprofile]);
   tightfig;
    
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