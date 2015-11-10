function plot_RSgeomean(fn, dt, NDAT, G, E)

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
            legendstr = cell(1, 1);
            for k = 3:ncase
                plot(T_range, convf(1)*squeeze( sqrt(RSx(:,ncase*j-(ncase-k),i).*RSx(:,ncase*j-(ncase-k),i))     ), plotline{k}, 'LineWidth', 1.5);
                grid on; hold on;
                xlabel('Period [s]'); ylabel(strcat('Pseudo-spectral Acceleration [',unitstr(1),']'));
                title(strcat(eqname{i},':  ',NDAT{i,j*ncase}.profile,'  -  ',str,', X'));
                legendstr{k-2} = NDAT{i,ncase*j-(ncase-k)}.case;
            end
            legend(legendstr,'Location','NorthEast');
            hold off;
        end
    end
end