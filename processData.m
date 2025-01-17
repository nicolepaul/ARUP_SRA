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
    [outx, outy, dtx, dty, outvx, outvy, outtx, outty] = processOutcrop(outcropfolder);
end

for i = 1:nfolders
    % Prelim
    foldername = fullfile(directorystr, FileList(i).name);

    disp(['Currently reading: ' foldername]);

    % Extract node set data
    for j = 1:num_nset
        node_dat = textscan(fopen(fullfile(foldername,'req_node_sets.csv')),'%f %s %f %f %f','Headerlines',1,'Delimiter',',');

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
        
        node_optc = strcmp(node_dat{2},names_nset{j});
        node_opt = find(node_optc==1);
        NDAT{i,j}.surfid = node_dat{5}(node_opt) == max(node_dat{5}(node_opt));
        NDAT{i,j}.bedid = node_dat{5}(node_opt) == min(node_dat{5}(node_opt));
        [tok, rem] = strtok(names_nset{j}, '_');
        NDAT{i,j}.profile = tok;
        NDAT{i,j}.case = rem(2:end);

        
        % Determine response spectrum for given E
        disp(['Determining response spectrum for damping of ' num2str(E) ' (' names_nset{j} ')']);
        
        % Surface   
        NDAT{i,j}.RSx = getPSA(fn, data(2,1), NDAT{i,j}.ax(:,NDAT{i,j}.surfid)./G, E, G);
        NDAT{i,j}.RSy = getPSA(fn, data(2,1), NDAT{i,j}.ay(:,NDAT{i,j}.surfid)./G, E, G);
        
        NDAT{i,j}.Sdx = NDAT{i,j}.RSx./(2*pi.*fn').^2;
        NDAT{i,j}.Sdy = NDAT{i,j}.RSy./(2*pi.*fn').^2;
        
        % Infield
        NDAT{i,j}.RS_x = getPSA(fn, data(2,1), NDAT{i,j}.ax(:,NDAT{i,j}.bedid)./G, E, G);
        NDAT{i,j}.RS_y = getPSA(fn, data(2,1), NDAT{i,j}.ay(:,NDAT{i,j}.bedid)./G, E, G);
        
        NDAT{i,j}.SA_x = NDAT{i,j}.RSx./NDAT{i,j}.RS_x;
        NDAT{i,j}.SA_y = NDAT{i,j}.RSy./NDAT{i,j}.RS_y;
        
        
        
        %Outcrop if available
        if outcrop
            NDAT{i,j}.outx = getPSA(fn, dtx(i), outx{i}./G, E, G);
            NDAT{i,j}.outy = getPSA(fn, dty(i), outy{i}./G, E, G);
            NDAT{i,j}.SAx = NDAT{i,j}.RSx./NDAT{i,j}.outx;
            NDAT{i,j}.SAy = NDAT{i,j}.RSy./NDAT{i,j}.outy;
            NDAT{i,j}.outvx = outvx{i};
            NDAT{i,j}.outvy = outvy{i};
            NDAT{i,j}.outax = outx{i};
            NDAT{i,j}.outay = outy{i};
            NDAT{i,j}.outtx = outtx{i};
            NDAT{i,j}.outty = outty{i};
        end
        
        lay_requested = 1:numel(NDAT{i,j}.z);
        NDAT{i,j}.SA_layx = NaN(numel(fn), numel(lay_requested));
            NDAT{i,j}.SA_layy = NaN(numel(fn), numel(lay_requested));
            NDAT{i,j}.SA_layno = cell(1, numel(lay_requested));
        for k = lay_requested
%         if ~isempty(lay_requested)
            
            
%             for k = 1:numel(lay_requested)
                disp(['Determining response spectrum for damping of ' num2str(E) ' (Layer ' num2str(lay_requested(k)) ')']);
                NDAT{i,j}.SA_layno{k} = strcat('Z = ',num2str(NDAT{i,j}.z(k)));
                if outcrop
                    NDAT{i,j}.RS_layx(:,k) = getPSA(fn, data(2,1), NDAT{i,j}.ax(:,k)./G, E, G);
                    NDAT{i,j}.RS_layy(:,k) = getPSA(fn, data(2,1), NDAT{i,j}.ay(:,k)./G, E, G);
                    NDAT{i,j}.SA_layx(:,k) = NDAT{i,j}.RS_layx(:,k)./NDAT{i,j}.outx;
                    NDAT{i,j}.SA_layy(:,k) = NDAT{i,j}.RS_layy(:,k)./NDAT{i,j}.outy;
                else
                    NDAT{i,j}.RS_layx(:,k) = getPSA(fn, data(2,1), NDAT{i,j}.ax(:,k)./G, E, G);
                    NDAT{i,j}.RS_layy(:,k) = getPSA(fn, data(2,1), NDAT{i,j}.ay(:,k)./G, E, G);
                    NDAT{i,j}.SA_layx(:,k) = NDAT{i,j}.RS_layx(:,k)./NDAT{i,j}.RS_x;
                    NDAT{i,j}.SA_layy(:,k) = NDAT{i,j}.RS_layy(:,k)./NDAT{i,j}.RS_y;
                end
%             end
        end
        
        
        NDAT{i,j}.E = E;
        NDAT{i,j}.T = T_range;
        
    end
    % Extract solid set data
    for j = 1:num_sset
        solid_dat = textscan(fopen(fullfile(foldername,'req_solid_sets.csv')),'%f %s %f','Headerlines',1,'Delimiter',',');

        data = csvread(fullfile(foldername,strcat('Solids_',names_sset{j},'.csv')), 0,2)';
        inds_sid = not(cellfun('isempty',strfind(solid_dat{2},names_sset{j})));
        SDAT{i,j}.nids = solid_dat{1}(inds_sid);
        SDAT{i,j}.t = data(:,1);
        
        solid_optc = strcmp(solid_dat{2},names_sset{j});
        solid_opt = find(solid_optc==1);
        
        SDAT{i,j}.z = solid_dat{3}(solid_opt);
%         [zsort, sortinds] = sort(SDAT{i,j}.z);
%         
%         SDAT{i,j}.z = zsort;
%         data = data(:, sortinds);
        
        SDAT{i,j}.epsyz = data(:,2:4:end);
        SDAT{i,j}.epszx = data(:,3:4:end);
        SDAT{i,j}.sigyz = data(:,4:4:end);
        SDAT{i,j}.sigzx = data(:,5:4:end);

        
        SDAT{i,j}.erateyz = bsxfun( @rdivide, (SDAT{i,j}.epsyz(2:end,:) - SDAT{i,j}.epsyz(1:end-1,:)) , (SDAT{i,j}.t(2:end,1) - SDAT{i,j}.t(1:end-1,1)) );
        SDAT{i,j}.eratezx = bsxfun( @rdivide, (SDAT{i,j}.epszx(2:end,:) - SDAT{i,j}.epszx(1:end-1,:)) ,  (SDAT{i,j}.t(2:end,1) - SDAT{i,j}.t(1:end-1,1)) );
        
       
        % Sort elevation
        
        if exist(fullfile(foldername,strcat('VertStress_',names_sset{j},'.csv')),'file')
            vertdata = csvread(fullfile(foldername,strcat('VertStress_',names_sset{j},'.csv')), 0, 0);
            vertstress = interp1(vertdata(:,1),vertdata(:,2),SDAT{i,j}.z);
            SDAT{i,j}.csryz = SDAT{i,j}.sigyz./repmat(vertstress',numel(SDAT{i,j}.t),1);
            SDAT{i,j}.csrzx = SDAT{i,j}.sigzx./repmat(vertstress',numel(SDAT{i,j}.t),1);
        end
        
        
        SDAT{i,j}.surfid = solid_dat{3}(solid_opt) == max(solid_dat{3}(solid_opt));
        SDAT{i,j}.bedid = solid_dat{3}(solid_opt) == min(solid_dat{3}(solid_opt));
        [tok, rem] = strtok(names_sset{j}, '_');
        SDAT{i,j}.profile = tok;
        SDAT{i,j}.case = rem(2:end);
    end
    
    disp('  ');
end

% Getting rid of extraneous variables
clearvars -except directorystr NDAT SDAT nprofile ncase;

% Saving data structures to directory

disp('Saving data....');
save(fullfile(directorystr,'zPROCESSED_DATA.mat'),'-v7.3'),
disp('Processing data complete');
toc

end