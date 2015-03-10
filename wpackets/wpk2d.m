function w=wpk2d(x,lp,hp,basis)

%WPK2D    2-D Discrete Wavelet Packet Transform
%
%         Y = WPK2D(X,H,G,BASIS) calculates the Wavelet Packet 
%         Transform of vector X. The second argument H is the 
%         lowpass filter and the third argument G the highpass filter.
%         The BASIS argument specifies the desired subband decomposition. 
%         It can be obtained using a basis selection algorithm.
%
%         Run the script 'BASIS' for help on the basis format and 'FORMAT2D'
%	  for help on the output format.
%
%         See also:  IWPK2D, WPK, PRUNE2D.

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


if (~basis)			       % trivial case
	w=x;
	return			       	
end
basis=basis-1;

wx=wt2d(x,lp,hp,1);                    % perform one analysis level
				       % into the analysis tree

if all(basis==0)                       % four ending nodes achieved
	w=wx;                         
	return
end

[ly,lx]=size(wx);                      % separate approximation and details
a=wx(1:ly/2,1:lx/2);                   % at the analysis output
v=wx(ly/2+1:ly,1:lx/2);
h=wx(1:ly/2,lx/2+1:lx);
d=wx(ly/2+1:ly,lx/2+1:lx);


% Approximation case

tope=1;					% finds the point where the
suma=2^(-basis(1)*2);                   % basis vector must be divided
i=1;                                    % in order to call the recursion
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i)*2);
end

if all(basis(1:i)~=0)                   % a level with an ending node
	wa=wpk2d(a,lp,hp,basis(1:i));   % but the other node continues
else wa=a;
end


% Vertical residue case

basis=basis(i+1:length(basis));
suma=2^(-basis(1)*2);
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i)*2);
end

if all(basis(1:i)~=0)
	wv=wpk2d(v,lp,hp,basis(1:i));
else wv=v;
end


% Horizontal residue case

basis=basis(i+1:length(basis));
suma=2^(-basis(1)*2);
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i)*2);
end

if all(basis(1:i)~=0)
	wh=wpk2d(h,lp,hp,basis(1:i));
else wh=h;
end


% Diagonal residue case

basis=basis(i+1:length(basis));

if all(basis~=0)
	wd=wpk2d(d,lp,hp,basis);
else wd=d;
end

% arrangement of the band sizes
% it is necessary when any of the original sizes is not a power of 2

c1=size(wa,2)-size(wv,2);	% difference in the number of columns
if c1<0				% between the approx. and vertical residue band
	wa=[zeros(size(wa,1),-c1) wa];  	% we add blank columns to the smallest,
elseif c1>0					% in order to match band sizes
	wv=[zeros(size(wv,1),c1) wv];
end

c2=size(wh,2)-size(wd,2);	% idem, between horizontal and diagonal residues
if c2<0
	wh=[zeros(size(wh,1),-c2) wh];
elseif c2>0
	wd=[zeros(size(wd,1),c2) wd];
end

f1=size(wa,1)-size(wh,1);	% difference in the number of rows
if f1<0				% between the approx. and horizontal residue band
	wa=[zeros(-f1,size(wa,2)) ; wa];	% we add blank rows to the smallest,
elseif f1>0					% in order to match band sizes
	wh=[zeros(f1,size(wh,2)) ;  wh];
end

f2=size(wv,1)-size(wd,1);	% idem, between vertical and diagonal residues
if f2<0
	wv=[zeros(-f2,size(wv,2)) ; wv];
elseif f2>0
	wd=[zeros(f2,size(wd,2)) ;  wd];
end

w=[ [wa,wh] ; [wv,wd] ];	% fit the four bands
