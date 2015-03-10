function [basis,y,total]=pruneadd(x,h,g,cost,par)

%PRUNEADD	Selects a Wavelet Packet basis using the pruning algorithm and
%		an additive cost measurement (Coifman-Wickerhauser algorithm).
%
%		[BASIS,Y,TOTAL]=PRUNEADD(X,H,G,COST,PAR) uses as input arguments
%               the signal to transform (X), the lowpass (H) and highpass (G)
%               analysis filters and a string (COST) specifying the name of
%               the cost measurement function to be used. If the cost function
%               requires some input arguments, these are passed through the
%               PAR argument.
%
%		The selected basis is returned in BASIS, as well as the
%		coefficients Y and their cost TOTAL.
%
%               Remarks:
%               - Basis and coefficients are sorted acording to the filter
%               bank. Use CHFORMAT to switch to the other arrangement.
%		- Selected basis is the optimal, with the information cost used,
%		within the wavelet packet basis library.
%
%		See also: PRUNENON, GROWADD, GROWNON.
%
%	        References: R.R. Coifman and M.V. Wickerhauser
%			    "Entropy-based algorithms for best basis selection"
%			    IEEE Transactions on Information Theory, vol.38, no.2
%			    March 1992

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
if size(x,2)~=1            % if the input is a row vector
	fil=1;             % the output is returned the same way
else
	fil=0;
end
x=x(:);

w=wpk(x,h,g,0);            % calculates a matrix with all the
			   % possible wavelet packet coefficients
[N,L]=size(w);
L=L-1;
basis=L*ones(N,1);         % the last level is chosen at the start of the algorithm

lo=length(x);
for l=0:L		   % cost vector calculation; holds a value
	nb=2^l;            % for every node of the full expanded tree
	s=1;
	for b=0:(nb-1)
		e=s+lo-1;
		y=w(s:e,l+1);
		c(2^l+b)=feval(cost,y,par);
		nz=(N-lo*2^l)/2^l;
		s=e+nz+1;
	end
	lo=floor((lo+1)/2);
end

% main algorithm

for l=(L-1):-1:0            % tree levels loop
	baux=[];
	s=1;
	for b=0:(2^l-1)     % level nodes loop
		e=s;
		aux=2^(-basis(e));                     % the part of 'basis'
		while aux<(2^(-l))                     % corresponding to the
			e=e+1;                         % current sub-nodes are
			aux=aux+2^(-basis(e));         % delimited by s and e
		end
                                              % costs for every node:
		cp=c(2^l+b);                  % main (current) node
		ch1=c(2^(l+1)+2*b);           % upper sub-node
		ch2=c(2^(l+1)+2*b+1);         % lower sub-node
		if cp<=ch1+ch2                      % according to the result
			baux=[baux;l];              % we choose the nodes which
		else				    % will compose the basis
			c(2^l+b)=ch1+ch2;
			baux=[baux;basis(s:e)];
		end
		s=e+1;
	end
	basis=baux;
end
y=coefext(w,basis,length(x));        % extracts from all the coefficients 
total=c(1);                          % those corresponding to the selected basis

if fil
	y=y';
	basis=basis';
end
