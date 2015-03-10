function tfplot(basis,k)

%TFPLOT    Plots the time-frequency plane tiling of a wavelet or
%	   wavelet packet transform.
%
%	   TFPLOT(K) for wavelet transform with K scales.
%	   TFPLOT(BASIS) for wavelet packet using a certain BASIS.
%	   Remark: For obtaining a correct drawing, BASIS must be
%	   frequency ordered.
%
%	   Use TFPLOT(K,SCMAX) or TFPLOT(BASIS,SCMAX) to set a maximum
%	   scale or level of the filter bank tree SCMAX. By default,
%	   it is K or maximum of BASIS respectively.
%
%	   See also: WT, WPK, TREE.
%          Run the script 'BASIS' for help on the basis format.

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


if length(basis)==1		% Wavelet transform: a wavelet packet basis
	for i=basis:-1:1	% vector is built.
		basis=[basis i];
	end
end

l=length(basis);
if nargin<2		% If the maximum tree depth is specified
	k=max(basis);
end

clg
axis([0 1 0 1])
hold on			% This freezes the axes

y2=0;			% Initial position for the boxes of this band

for i=1:l
	dt=2^(basis(i)-k);	% Time width of the 'Heisenberg box'	
	df=2^(-basis(i));	% Frequency height
	nb=1/dt;		% Number of boxes per frequency band
	x1=0;
	x2=dt;
	y1=y2;
	y2=y2+df;

	for j=1:nb			% Plot the boxes of each band, from left to right 
		plot([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1])
		x1=x1+dt;
		x2=x2+dt;		% Renew the positions
	end
end

g=gca;
set(g,'XTickLabels','','XTick',[0 1])	% Removing tick marks ... 
set(g,'YTickLabels','','YTick',[0 1])
xlabel('Time')				% ... but not axis labels
ylabel('Frequency  --->')
hold off				% Unfreezes the axes
