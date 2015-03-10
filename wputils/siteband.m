function [x1,y1,x2,y2]=siteband(sizx,sizy,basis,q,nivel)

%SITEBAND    Locates a subband into a wavelet packet transform.
%
%	     [X1,Y1,X2,Y2] = SITEBAND(SIZX,SIZY,BASIS,N) returns the
%	     top-left (X1,Y1) and bottom-right (X2,Y2) coordinates of
%	     the N-th band from the transform obtained with BASIS.
%	     SIZX and SIZY are the number of columns and rows of the
%	     original signal.
%
%	     This function works with two dimensional wavelet
%	     packet transforms, but can be applied to one dimensional
%	     ones. The X or Y coordinates will be equal to 1 depending
%	     on SIZX, SIZY. 
%	
%            NOTE: for user programming, the SITEBAND function will
%            return a -1 in X1 if any bad argument is given.     
%
%	     See also: EXTBAND, INSBAND, WPK2D, WPK, BANDSITE.

%--------------------------------------------------------
% Copyright (C) 1994, 1995, 1996, by Universidad de Vigo 
%                                                      
%                                                      
% Uvi_Wave is free software; you can redistribute it and/or modify it      
% under the terms of the GNU General Public License as published by the    
% Free Software Foundation; either version 2, or (at your option) any      
% later version.                                                           
%                                                                          
% Uvi_Wave is distributed in the hope that it will be useful, but WITHOUT  
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or    
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License    
% for more details.                                                        
%                                                                          
% You should have received a copy of the GNU General Public License        
% along with Uvi_Wave; see the file COPYING.  If not, write to the Free    
% Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.             
%                                                                          
%       Author: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


if nargin==4            		% initial recursive level
	if (q<1) | (q>length(basis))		% checking of the specified subband
		disp('Error: wrong subband number.')
		disp(' ')
		x1=-1;
		return
	end
	if basis==[0]				% there is a single band
		x1=1; y1=1;
		x2=sizx; y2=sizy;
		return
	end
	fin=basis(q);				% maximum depth of decomposition until the specified band
	if (sizx==1)|(sizy==1)                          % 1-D transform case
		lo(1)=max([sizx sizy]);
		for i=1:max(basis(1:q))
			lo(i+1)=floor((lo(i)+1)/2);
		end
		x1=sum(lo(basis(1:q-1)+1))+1;
		x2=(x1-1)+lo(fin+1);
		y1=1; y2=1;
		if sizx==1
			aux=x1; x1=y1; y1=aux;
			aux=x2; x2=y2; y2=aux;
		end
		return
	else                                            % 2-D transform case
		q=[zeros(1,q-1) 1 zeros(1,length(basis)-q)];
		basis=2*basis;		% in order to divide correctly into 4 branchs every tree node 
		nivel=0;
	end
end

basis=basis-2;
lox=floor((sizx+1)/2);		% sizes of the 4 bands descending from the present one
loy=floor((sizy+1)/2);

if basis==0			% we have reached an ending branch
	if any(q)			% if the present band contains the specified one, we set
		x2=lox*(q(3)+q(4)+1);   % the last output arguments to the bottom-right coordinates
		y2=loy*(q(2)+q(4)+1);
	else                            % if it doesn't contain the desired band
		x2=0;   
		y2=0;
	end
	if ~nivel                       % the first outputs depend on finishing or not the function
		x1=x2-lox+1;		% adjust 
		y1=y2-loy+1;
	else                            % the parameters return the total size, including 
		x1=2*lox;		% blank rows/columns
		y1=2*loy;
	end
	return
end


% Approximation (lowpass subband)

tope=1;                                 % finds the point where the
suma=2^(-basis(1));                     % basis vector must be divided
i=1;                                    % in order to call the recursion
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end

if all(basis(1:i)~=0)			% if there is descendent branches, the recursion is called
	[x1a,y1a,x2a,y2a]=siteband(lox,loy,basis(1:i),q(1:i),nivel+1);
else                                    % in this case, basis(1:i)=[0]
	x1a=lox;			% top-left coordinates
	y1a=loy;
	if any(q(1:i))                  % the present band contains the specified one
		x2a=x1a;		% only in this case, bottom-right coords. are set
		y2a=y1a;
	else
		x2a=0; y2a=0;
	end
end
		
% Vertical high frequency

q=q(i+1:length(q));
basis=basis(i+1:length(basis));
suma=2^(-basis(1));
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end

if all(basis(1:i)~=0)
	[x1v,y1v,x2v,y2v]=siteband(lox,loy,basis(1:i),q(1:i),nivel+1);
else
	x1v=lox;
	y1v=loy;
	if any(q(1:i))
		x2v=x1v;
		y2v=y1v;
	else
		x2v=0; y2v=0;
	end
end
	
% Horizontal high frequency

q=q(i+1:length(q));
basis=basis(i+1:length(basis));
suma=2^(-basis(1));
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end
	
if all(basis(1:i)~=0)
	[x1h,y1h,x2h,y2h]=siteband(lox,loy,basis(1:i),q(1:i),nivel+1);
else
	x1h=lox;
	y1h=loy;
	if any(q(1:i))
		x2h=x1h;
		y2h=y1h;
	else
		x2h=0; y2h=0;
	end
end

% Diagonal high frequency

q=q(i+1:length(q));
basis=basis(i+1:length(basis));

if all(basis~=0)
	[x1d,y1d,x2d,y2d]=siteband(lox,loy,basis,q,nivel+1);
else
	x1d=lox;
	y1d=loy;
	if any(q)
		x2d=x1d;
		y2d=y1d;
	else
		x2d=0; y2d=0;
	end
end
	
% And now, we arrange the coordinates. It is necessary if any of the original
% sizes is not a power of two.

x2=0;
y2=0;

c1=x1a-x1v;	% Difference of rows/columns between each band
c2=x1h-x1d;	% and two of the adjacent ones at the same level
f1=y1a-y1h;
f2=y1v-y1d;

x1a=x1a-c1*(c1<0);	% adjust the lowpass (at the present level) band size
y1a=y1a-f1*(f1<0);
if (x2a)
	x2=x2a-c1*(c1<0);
	y2=y2a-f1*(f1<0);
end

x1v=x1a;		% adjust the vertical high frequency band size
y1v=y1v-f2*(f2<0);
if (x2v)
	x2=x2v+c1*(c1>0);
	y2=y2v-f2*(f2<0)+y1a;
end

x1h=x1h-c2*(c2<0);	% adjust the horizontal high frequency band size
y1h=y1a;
if (x2h)
	x2=x2h-c2*(c2<0)+x1a;
	y2=y2h+f1*(f1>0);
end

x1d=x1h;		% adjust the diagonal high frequency band size
y1d=y1v;
if (x2d)
	x2=x2d+c2*(c2>0)+x1a;
	y2=y2d+f2*(f2>0)+y1a;
end

if nivel                % if the function doesn't finish, the first outputs are
	x1=x1a+x1h;	% the global size (including blank rows/columns)
	y1=y1a+y1v;
else                    % if it finishes (again at level 0), the outputs are the
	for i=2:fin	% exact top-left coordinates
		lox=floor((lox+1)/2);
		loy=floor((loy+1)/2);
	end
	x1=x2-lox+1;
	y1=y2-loy+1;
end
