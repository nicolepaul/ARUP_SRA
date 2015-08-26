function [outcrop_x, outcrop_y, dt] = processOutcrop(outcropfolder)

% Creating list of folders and files
% FileList = dir('GM_2575yr');
FileList = dir(outcropfolder);

FileList = FileList(arrayfun(@(x) x.name(1), FileList) ~= '.');
N = size(FileList, 1);

% Initialization
outcrop_x = cell(N,1);
outcrop_y = cell(N,1);
dt = NaN(N,1);
for i = 1:N
    % Accessing first folder of interest
    foldername = fullfile(outcropfolder, FileList(i).name);
    
    % Opening node set and solid set lists
    x = csvread(fullfile(foldername,'outcrop_x.csv'));
    y = csvread(fullfile(foldername,'outcrop_y.csv'));
    tx = x(:,1);
    ty = y(:,1);
    
    dt(i) = tx(2);
    
    outcrop_x{i} = (x(2:end,2)-x(1:end-1,2))./tx(2);
    outcrop_y{i} = (y(2:end,2)-y(1:end-1,2))./ty(2);
    
end
