function [basis,y,total]=prune2d(x,h,g,cost,par)

%PRUNE2D    Selects a Wavelet Packet basis using the pruning algorithm and
%           an additive cost measurement (Coifman-Wickerhauser algorithm).
%
%           [BASIS,Y,TOTAL]=PRUNE2D(X,H,G,COST,PAR) uses as input arguments
%           the 2-D signal to transform (X), the lowpass (H) and highpass (G)
%           analysis filters and a string (COST) specifying the name of
%           the cost measurement function to be used. If the cost function
%           requires some input arguments, these are passed through the
%           PAR argument.
%
%           The selected basis is returned in BASIS, as well as the
%           transform matrix Y and its cost TOTAL.
%
%           Remark: Selected basis is the optimal, with the information cost
%	    used, within the wavelet packet basis library.
%
%           See also: PRUNEADD, WPK2D.
%           Run the script 'BASIS' for help on the basis format and 'FORMAT2D'
%	    for help on the output format.
%
%           References: R.R. Coifman and M.V. Wickerhauser
%                       "Entropy-based algorithms for best basis selection"
%                       IEEE Transactions on Information Theory, vol.38, no.2
%                       March 1992


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


if nargin==4
	par=0;
end

[ly,lx]=size(x);
L=min(floor([log2(ly) log2(lx)]));      % Maximum depth in the filter bank tree

for i=1:2^L				% We construct an auxiliary vector for calculating
	j=i-1;				% the band position in the cost vector.
	tabla(i)=0;
	while j>1			% The vector holds a value per column of bands,
		l=floor(log2(j));	% from which a value per row can be derivated.
		tabla(i)=tabla(i)+4^l;	% The band number will be the sum of their
		j=rem(j,2^l);		% respective column and row values given by this
	end				% auxiliary vector.
	tabla(i)=tabla(i)+j;
end

c(1)=feval(cost,x,par);         % Initial case.
w=wt2d(x,h,g,1);

for l=1:L                       % Cost vector calculation; holds a value for every node.
	lx=floor((lx+1)/2);
	ly=floor((ly+1)/2);
	lc=length(c);           % Number of bands until the present level 'l'
	nb=2^l;                 % Number of band blocks per row/column at this level
	for i=0:(nb-1)                  % Rows
		n=1+i*lx;
		ind=2*tabla(i+1)+1;
		for j=0:(nb-1)                  % Columns
			m=1+j*ly;
			y=w(m:m+ly-1,n:n+lx-1);
			c(lc+ind+tabla(j+1))=feval(cost,y,par); % Cost of the band/block of coefficients located by (i,j)
			if l~=L
				w_aux2=[w_aux2 ; wt2d(y,h,g,1)];
			end
		end
		w_aux=[w_aux,w_aux2];
		w_aux2=[];
	end
	w=w_aux;
	w_aux=[];
	end
end

% Main algorithm

basis=2*L*ones(4^L,1);          % Initialization

for l=(L-1):-1:0                % Tree levels loop
	s=1;
	for b=0:(4^l-1)         % Level nodes/branches loop
		e=s;
		aux=2^(-basis(e));                      % The part of 'basis'
		while aux<4^(-l)                        % corresponding to the
			e=e+1;                          % current subnodes are
			aux=aux+2^(-basis(e));          % delimited by s and e.
		end

		m=(4^l+2)/3+b;                  % Costs for every node:
		cp=c(m);                        %  main (current) node,
		cha=c(4*m-2);                   %  approximation subnode,
		chv=c(4*m-1);                   %  vertical residue subnode,
		chh=c(4*m);                     %  horizontal residue subnode,
		chd=c(4*m+1);                   %  diagonal residue subnode.
		if cp<=(cha+chv+chh+chd)        % According to the result
			baux=[baux;2*l];        % we choose the nodes which
		else                            % will compose the basis.
			c(m)=cha+chv+chh+chd;
			baux=[baux;basis(s:e)];
		end
		s=e+1;
	end
	basis=baux;
	baux=[];
end

basis=basis/2;
y=wpk2d(x,h,g,basis);           % Calculates the coefficients corresponding
total=c(1);                     % to the selected basis.
