function tree(basis)

%TREE    Plots the decomposition tree of the wavelet or wavelet packet.
%
%	 TREE(K) draws the tree for the K-scales 1D wavelet
%	 transform. Upper branch of the basic cell corresponds
%	 to highpass filtering and lower one to lowpass filtering. 
%
%	 TREE(BASIS), for the 1D wavelet packet obtained
%	 with this basis specification. The depicted tree will be
%	 the filter bank scheme or the frequency decomposition
%	 according to the BASIS argument format. In the wavelet
%	 case, both trees coincide.
%
%	 See also:  WT, WPK, TFPLOT.
%        Run the script 'BASIS' for help on the basis format.

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


if length(basis)==1		% Wavelet case (number of scales is given)
	basis=[basis basis:-1:1];
end

L=max(basis);			% Maximum tree depth
tree=ones(1,2^(L+1)-1);		% Initialization: all nodes split
for k=1:length(basis)			% Labelling of the terminal nodes
        [j,i]=band2idx(basis,k);	% with zeros
        m=2^j+i;
        tree(m)=0;
end

dx=1/(L+2);	% Initialization of branch length and positions
x=1;		
y=1;
n=0;		% Present node index in 'tree' vector
k=1/(2^L+1);	% Final size for dy

clg
hold on
axis('off')

for l=0:L		% Level of tree
	ex=L-l;
	dy=(2^ex)*k;
	y_aux=y;
	x_aux=x+dx;
	
	for i=0:(2^l-1)		% Nodes at this level
		n=n+1;
		if tree(n)>=0
			plot([x x_aux],[y y])			% Horizontal line
		end
		if tree(n)==1
			plot([x_aux x_aux],[y-dy/2 y+dy/2])	% Vertical line
		elseif l~=L		% The descendants of a terminal node are not drawn
			tree(2*n:2*n+1)=[-1 -1];
		end
		if rem(i,2)	% For moving from one branch to the next at the same level
			y=y+2*dy;
		else
			y=y+2*dy;
		end
	end
	x=x_aux;
	y=y_aux-dy/2;
end

hold off
