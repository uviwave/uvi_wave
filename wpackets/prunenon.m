function [basis,y,total]=prunenon(x,h,g,cost,par)

%PRUNENON	Selects a Wavelet Packet basis using the pruning algorithm and
%		a non-additive cost measurement.
%
%		[BASIS,Y,TOTAL]=PRUNENON(X,H,G,COST,PAR) uses as input arguments
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
%               bank. Use CHFORMAT to switch to the other format.
%               - As the cost measurement is non-additive, the selected
%               basis may not be optimal. However, choosing an additive
%		cost measurement the optimal basis will be achieved.
%
%		See also: PRUNEADD, GROWNON, GROWADD.
%
%		References: C. Taswell, "Near-best basis selection algorithms 
%			    with non-additive information cost functions"
%			    Proc. IEEE-SP International Symposium on TFTSA-94
%			    October 1994

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
y=w(:,L+1);                % the last level is chosen at
basis=L*ones(2^L,1);	   % the start of the algorithm
lo=length(x);
for l=1:L                                   % number of coefficients
	lo(l+1)=floor((lo(l)+1)/2);         % for every level
end

%algoritmo principal

for l=(L-1):-1:0            % tree levels loop
	baux=[];
	yaux=[];
	s=1;
	inicio=1;
	inicio2=1;
	for b=0:(2^l-1)			% level nodes loop
		fin=inicio+lo(l+1)-1;
		p=w(inicio:fin,l+1);	% main (current) node coefficients

		e=s;
		fin2=inicio2+lo(basis(e)+1)-1;
		aux=2^(-basis(e));
		while aux<(2^(-l))                     % the parts of 'basis'
			e=e+1;                         % corresponding to the
			fin2=fin2+lo(basis(e)+1);      % current sub-nodes are
			aux=aux+2^(-basis(e));         % delimited by s and e
		end

		h=y(inicio2:fin2);		% sub-nodes coefficients

		cp=feval(cost,p,par);           % cost calculation for current
		ch=feval(cost,h,par);           % node and its sub-nodes

		if cp<=ch                          % according to the result
			baux=[baux;l];             % we choose the nodes which
			yaux=[yaux;p];		   % will compose the basis
		else                                
			baux=[baux;basis(s:e)];
			yaux=[yaux;h];
		end
		nz=(N-lo(l+1)*2^l)/2^l;         % if length of x is not a
		inicio=fin+nz+1;                % power of 2 the padding zeros
		inicio2=fin2+1;                 % must be considered
		s=e+1;
	end
	y=yaux;
	basis=baux;
end

total=min(cp,ch);         % total cost of the chosen coefficients

if fil
	y=y';
	basis=basis';
end
