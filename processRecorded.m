function [RS_rec, name_rec] = processRecorded(directorystr, convtoSI)

% Creating list of folders and files
% FileList = dir('GM_2575yr');
FileList = dir(directorystr);

FileList = FileList(arrayfun(@(x) x.name(1), FileList) ~= '.');
N = size(FileList, 1);

% Initial counts
foldername = fullfile(directorystr, FileList(1).name);

fList = dir(fullfile(foldername, 'recorded_rs*'));
nrec = numel(fList);

% Initialization
RS_rec = cell(N-1,nrec);
name_rec = cell(N-1,nrec);
for i = 1:N-1
    % Accessing first folder of interest
    foldername = fullfile(directorystr, FileList(i).name);
    fList = dir(fullfile(foldername,'recorded_rs*'));

    for j = 1:nrec
        filename = fullfile(foldername, fList(j).name);
        % Opening node set and solid set lists
        data = textscan(fopen(filename),'%f %f %f','Delimiter',',','Headerlines',1,'CollectOutput',true);
        RS_rec{i,j} = data{1};
        RS_rec{i,j}(:,[2 3]) = RS_rec{i,j}(:,[2 3])*convtoSI;
        [~,name] = fileparts(filename);
        name_rec{i,j} = name(13:end);
    end
   
end
