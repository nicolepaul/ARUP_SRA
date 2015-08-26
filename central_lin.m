function [u v a]=central_lin(props,dt,p)

%Initialise properties and storage
m = props(1); k=props(2);c=props(3);
n=length(p);
n1=n+1;
u=zeros(1,n1); % u(2) = 0 is zero initial displ.

a1 = m/dt^2 - c/(2*dt);
b1 = k - 2*m/dt^2;
kb = m/dt^2 + c/(2*dt);

% Starting procedure
udd = p(1)/m;
u(1) = 0.5*dt^2*udd;

%Loop over time steps
for k=2:n
	j=k-1;
	pb = p(j) - a1*u(k-1) - b1*u(k);
	u(k+1) =pb/kb;
end

%calculate v
v = (u(3:length(u))-u(1:length(u)-2))/2/dt;
v = [0 v];

%calculate a
a = (u(3:length(u))-2*u(2:length(u)-1)+u(1:length(u)-2))/dt^2;

atest = (p - c*v - k*u(2:length(u)))/m;

a = [0 a];


%assumes p=-m*ag
ag = -p/m;
a = a+ag;


%shift u
u=u(2:n1); 


