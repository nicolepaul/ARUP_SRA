function FileName = getfilename(testnum)
% GETNAME
% Finds datafile name from list or dialogue box

if nargin == 1
   fid = fopen('*.*','r');   
   FILE.directory = fgetl(fid);
   for i = 1:testnum-1
      ignore = fgetl(fid);
   end
   FILE.name = fgetl(fid);
   fclose(fid);
else
   [FILE.name,FILE.directory] = uigetfile('*.*','Select Data File');
end

if strcmp(pwd,FILE.directory)
   FileName = FILE.name;
else
   FileName = [FILE.directory,FILE.name];
end 
