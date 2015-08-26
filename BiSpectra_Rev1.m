function [PSAmaj,PSAmin,theta]=BiSpectra_Rev1(Ag,dt,Periods,damp)
%I have changed this function (24 February 2009) to also output minor axis
%This seems to have been my intent on some earlier plots but I'm not sure
%how I got it wrong!
%
%Edited 18/5/2012 to fix for short periods

%SD = zeros(length(Periods),length(damp));
%PSA=SD;        

        if (size(Ag,2)==2)|(size(Ag,2)==1)
            Ag = Ag';
        end
        
    
        
if size(Ag,1)==2
 
for iT=1:length(Periods)
    for iD=1:length(damp)
        
        T = Periods(iT);
        w = 2*pi/T;
        
        
        if dt>T/10;
            dtnew = T/10;
            r = ceil(dt/dtnew);
            dt1 = dt/r;
            Ag1x = interp1([0:length(Ag(1,:))-1]*dt, Ag(1,:), [0:r*length(Ag(1,:))-1]*dt1, 'linear');
            Ag1y = interp1([0:length(Ag(2,:))-1]*dt, Ag(2,:),[0:r*length(Ag(2,:))-1]*dt1, 'linear');

            %Ag1x = interp(Ag(1,:),r);
            %Ag1y = interp(Ag(2,:),r);
            Ag1 = [Ag1x; Ag1y];
        else
             dt1 = dt;
             Ag1 = Ag;
        end


        
        u1 = central_lin ([1 (2*pi/T)^2 2*w*1*damp(iD)],dt1,-Ag1(1,:));
        u2 = central_lin ([1 (2*pi/T)^2 2*w*1*damp(iD)],dt1,-Ag1(2,:));
        
        u=VectorNorm([u1;u2]);
        
        [SDmaj(iT,iD) imax] =max(abs(u));
        
        thetaTD = atan(u2(imax)/u1(imax));
        
        PSAmaj(iT,iD)=w^2*SDmaj(iT,iD);
        
        Ag_rot=[];
        %now calculate minor component by rotating by theta+pi/2
        acc_minor = Ag1(1,:)*cos(thetaTD+pi/2) + Ag1(2,:)*sin(thetaTD+pi/2);
        
        u = central_lin ([1 (2*pi/T)^2 2*w*1*damp(iD)],dt1,-acc_minor);
        SDmin(iT,iD)  =max(abs(u));
        
        PSAmin(iT,iD)=w^2*SDmin(iT,iD);
        
        theta(iT,iD) = thetaTD;
    end
end

else
    error('Just implemented BiSpectra. Use Accel_Spectra for single component')
end



    
    
