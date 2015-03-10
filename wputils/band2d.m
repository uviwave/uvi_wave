function band2d(w,basis,sizx,sizy)

%BAND2D    Plots the subband division for 2D transforms.
%
%	   BAND2D(W,K) marks the subband positions for a K-scales
%	   wavelet transform. BAND2D(W,BASIS) works for a
%	   wavelet packet obtained with BASIS.
%
%	   BAND2D(W,(whatever),SIZX,SIZY) must be used when any
%	   dimension of the original signal is not a power of two.
%	   By default, these values are set the largest as possible
%          (wavelet case) or to the size of WT (wavelet packet case).
%
%          See also: WT2D, WPK2D.    
%          Run the script 'FORMAT2D' for more help on the output format.

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


if nargin==2
	sizx=size(w,2);
	sizy=size(w,1);
end

if length(basis)==1		% Wavelet case (number of scales is given)
	if nargin==2
		sizx=maxrsize(sizx,basis);
		sizy=maxrsize(sizy,basis);
	end
	aux=basis:-1:1;
	aux=[aux;aux;aux];
	basis=[basis aux(:)'];
end
l=length(basis);

show(w)
hold on

for i=1:l
	[x1,y1,x2,y2]=siteband(sizx,sizy,basis,i);
	x1=x1-0.5;		% We have to adjust these values to
	y1=y1-0.5;		% properly display the subband limits.
	x2=x2+0.5;
	y2=y2 +0.5;
	plot([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1])
end

hold off


