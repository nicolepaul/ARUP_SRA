function [NDAT, SDAT, nprofile, ncase] = processData(directorystr, E, outcrop, outcropfolder)
tic
% Creating list of folders and files
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
nprofile = numel(unique(tok));
ncase = numel(unique(rem));


% Initializing data structures
NDAT = cell(nfolders, num_nset);
SDAT = cell(nfolders, num_sset);

% Response spectrum information
G = 9.81;
np = 100;
T_range = linspace(1e-3,10,np);
fn = 1./T_range;

if outcrop;
    [outx, outy] = processOutcrop(outcropfolder);
end

for i = 1:nfolders
    % Prelim
    foldername = fullfile(directorystr, FileList(i).name);
<<<<<<< HEAD
    disp(['Currently reading: ' foldername]);
=======
    
>>>>>>> origin/master
    % Extract node set data
    for j = 1:num_nset
        data = csvread(fullfile(foldername,strcat('Nodes_',names_nset{j},'.csv')), 0,2)';
        inds_nid = find(not(cellfun('isempty',strfind(node_dat{2},names_nset{j}))));
        NDAT{i,j}.nids = node_dat{1}(inds_nid);
        NDAT{i,j}.t = data(:,1);
        NDAT{i,j}.dx = data(:,2:6:end);
        NDAT{i,j}.dy = data(:,3:6:end);
        NDAT{i,j}.vx = data(:,4:6:end);
        NDAT{i,j}.vy = data(:,5:6:end);
        NDAT{i,j}.ax = data(:,6:6:end);
        NDAT{i,j}.ay = data(:,7:6:end);
        NDAT{i,j}.z = node_dat{5}(inds_nid);
        NDAT{i,j}.surfid = node_dat{5}(inds_nid) == max(node_dat{5}(inds_nid));
        NDAT{i,j}.bedid = node_dat{5}(inds_nid) == min(node_dat{5}(inds_nid));
        [tok, rem] = strtok(names_nset{j}, '_');
        NDAT{i,j}.profile = tok;
        NDAT{i,j}.case = rem(2:end);
        
        % Determine response spectrum for given E
        disp(['Determining response spectrum for damping of ' num2str(E) ' (' names_nset{j} ')']);
        
        % Surface
        NDAT{i,j}.RSx = getPSA(fn, data(2,1), NDAT{i,j}.ax(:,NDAT{i,j}.surfid)./G, E, G);
        NDAT{i,j}.RSy = getPSA(fn, data(2,1), NDAT{i,j}.ay(:,NDAT{i,j}.surfid)./G, E, G);
        % Infield
        NDAT{i,j}.RS_x = getPSA(fn, data(2,1), NDAT{i,j}.ax(:,NDAT{i,j}.bedid)./G, E, G);
        NDAT{i,j}.RS_y = getPSA(fn, data(2,1), NDAT{i,j}.ay(:,NDAT{i,j}.bedid)./G, E, G);
        
        %Outcrop if available
        if outcrop
            NDAT{i,j}.outx = getPSA(fn, data(2,1), outx{i}./G, E, G);
            NDAT{i,j}.outy = getPSA(fn, data(2,1), outy{i}./G, E, G);
            NDAT{i,j}.SAx = NDAT{i,j}.RSx./NDAT{i,j}.outx;
            NDAT{i,j}.SAy = NDAT{i,j}.RSx./NDAT{i,j}.outy;
        else
            NDAT{i,j}.SAx = NDAT{i,j}.RSx./NDAT{i,j}.RS_x;
            NDAT{i,j}.SAy = NDAT{i,j}.RSx./NDAT{i,j}.RS_y;
        end
        
        NDAT{i,j}.E = E;
        NDAT{i,j}.T = T_range;
        
    end
    % Extract solid set data
    for j = 1:num_sset
        data = csvread(fullfile(foldername,strcat('Solids_',names_sset{j},'.csv')), 0,2)';
        inds_sid = find(not(cellfun('isempty',strfind(solid_dat{2},names_sset{j}))));
        SDAT{i,j}.nids = solid_dat{1}(inds_sid);
        SDAT{i,j}.t = data(:,1);
        SDAT{i,j}.epsyz = data(:,2:4:end);
        SDAT{i,j}.epszx = data(:,3:4:end);
        SDAT{i,j}.sigyz = data(:,4:4:end);
        SDAT{i,j}.sigzx = data(:,5:4:end);
        
        
        
        SDAT{i,j}.erateyz = bsxfun( @rdivide, (SDAT{i,j}.epsyz(2:end,:) - SDAT{i,j}.epsyz(1:end-1,:)) , (SDAT{i,j}.t(2:end,1) - SDAT{i,j}.t(1:end-1,1)) );
        SDAT{i,j}.eratezx = bsxfun( @rdivide, (SDAT{i,j}.epszx(2:end,:) - SDAT{i,j}.epszx(1:end-1,:)) ,  (SDAT{i,j}.t(2:end,1) - SDAT{i,j}.t(1:end-1,1)) );
        
        SDAT{i,j}.z = solid_dat{3}(inds_sid);
        SDAT{i,j}.surfid = solid_dat{3}(inds_sid) == max(solid_dat{3}(inds_sid));
        SDAT{i,j}.bedid = solid_dat{3}(inds_sid) == min(solid_dat{3}(inds_sid));
        [tok, rem] = strtok(names_sset{j}, '_');
        SDAT{i,j}.profile = tok;
        SDAT{i,j}.case = rem(2:end);
    end
    
    disp('  ');
end

% Getting rid of extraneous variables
clearvars -except directorystr NDAT SDAT nprofile ncase;

% Saving data structures to directory
<<<<<<< HEAD
disp('Saving data....');
save(fullfile(directorystr,'zPROCESSED_DATA.mat'),'-v7.3'),
disp('Processing data complete');
toc
=======
save(fullfile(directorystr,'PROCESSED_DATA.mat'),'-v7.3'),

>>>>>>> origin/master
end