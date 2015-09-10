function [outcrop_x, outcrop_y, dtx, dty, outcrop_vx, outcrop_vy, outcrop_tx, outcrop_ty] = processOutcrop(outcropfolder)

% Creating list of folders and files
% FileList = dir('GM_2575yr');
FileList = dir(outcropfolder);

FileList = FileList(arrayfun(@(x) x.name(1), FileList) ~= '.');
N = size(FileList, 1);

% Initialization
outcrop_x = cell(N,1);
outcrop_y = cell(N,1);
outcrop_vx = cell(N,1);
outcrop_vy = cell(N,1);
outcrop_tx = cell(N,1);
outcrop_ty = cell(N,1);
dtx = NaN(N,1);
dty = NaN(N,1);
for i = 1:N
    % Accessing first folder of interest
    foldername = fullfile(outcropfolder, FileList(i).name);
    
    % Opening node set and solid set lists
    x = csvread(fullfile(foldername,'outcrop_x.csv'));
    y = csvread(fullfile(foldername,'outcrop_y.csv'));
    tx = x(:,1);
    ty = y(:,1);
    
    dtx(i) = mean(tx(2:end)-tx(1:end-1));
    dty(i) = mean(ty(2:end)-ty(1:end-1));
    
    outcrop_x{i} = (x(2:end,2)-x(1:end-1,2))./(x(2:end,1)-x(1:end-1,1));
    outcrop_y{i} = (y(2:end,2)-y(1:end-1,2))./(y(2:end,1)-y(1:end-1,1));
    
    outcrop_vx{i} = x(:,2);
    outcrop_vy{i} = y(:,2);
    outcrop_tx{i} = x(:,1);
    outcrop_ty{i} = y(:,1);
    
end
