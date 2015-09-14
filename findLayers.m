function layer_cellstr = findLayers(directorystr)
%%
FileList = dir(directorystr);

FileList = FileList(arrayfun(@(x) x.name(1), FileList) ~= '.');
N = size(FileList, 1);
nfolders = N;
% N = size(FileList, 1);
% nfolders = N - 2;
% FileList = FileList(3:end);

% Accessing first folder of interest
foldername = fullfile(directorystr, FileList(1).name);

% Opening node set and solid set lists
node_dat = textscan(fopen(fullfile(foldername,'req_node_sets.csv')),'%f %s %f %f %f','Headerlines',1,'Delimiter',',');
solid_dat = textscan(fopen(fullfile(foldername,'req_solid_sets.csv')),'%f %s %f','Headerlines',1,'Delimiter',',');

% Determine number of cases, profiles for node and solid sets
names_nset = unique(node_dat{2});
names_sset = unique(solid_dat{2});

num_nset = numel(names_nset);
num_sset = numel(names_sset);

% Determine numbe of cases and profiles
% *EXPECTED TO BE SAME FOR NODES AND SOLIDS
[tok, rem] = strtok(names_nset, '_');
profiles = unique(tok);
nprofile = numel(unique(tok));
ncase = numel(unique(rem));

% For each node in set, determine depth
% layerstr = cell(nprofile,1);
% for i = 1:nprofile
%     layerstr{i} = {strcat('==  ', profiles{i}, '  ==')};
%     relevant_layers = 
% end

layer_cellstr = arrayfun(@num2str, node_dat{5}, 'unif', 0);
%%

end