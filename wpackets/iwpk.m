function f=iwpk(w,rh,rg,order,basis,len,flag)

%IWPK   Discrete Inverse Wavelet Packet Transform
%
%       IWPK(W,RH,RG,ORDER,BASIS,LEN) calculates the Inverse Wavelet Packet
%	Transform of coefficients W, that should be obtained using BASIS
%       with the specified ORDER. The second argument RH is the synthesis
%	lowpass filter and the third argument RG, the synthesis highpass
%	filter. The fourth argument LEN is the size of the signal to be
%	rebuilt; by default it is set to the length of W.
%
%       The ORDER argument indicates the kind of tree:
%                  0 -> band sorting according to the filter bank
%                  1 -> band sorting according to the frequency decomposition
%       The BASIS argument specifies the used one. It can be obtained using
%       a selection algorithm function. It may be switched from one format
%	to another using CHFORMAT.
%       The coefficient bands are sorted according to ORDER and BASIS.
%
%       Run the script 'BASIS' for help on the basis format.
%       See also:  WPK, CHFORMAT, GROWNON, GROWADD, PRUNENON, PRUNEADD.

% Auxiliary input argument for recursion:
%    flag: if set to 1 indicates that coefficients must be rearranged,
%          so as to fit the result of the tree algorithm


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


if (nargin<=6)                          % set 'flag' and shape the
	if nargin==5			% signal as a column vector
		len=length(w);
	end
	flag=0;
	if (size(w,2)~=1)
		w=w(:);
		fil=1;
	else
		fil=0;
	end
end

N=length(w);

if all(basis==0)                        % the coefficients belong to an ending node
	f=w;                            % but the other branch ends at a different
	return                          % level
elseif all(basis==1)                                    % coefficients of two nodes
	w1=w(1:N/2);                                    % ending at the same level
	w2=w(N/2+1:N);
	if (flag&order), aux=w1;w1=w2;w2=aux; end   % the coeffs. are swapped if proceeds
	f=iwt([w1;w2],rh,rg,1,len);                 % performs a synthesis level of the tree
	if (nargin<=6)&(fil), f=f'; end
	return
else                                    % if coefficients do not belong to an ending node
	L=floor(log2(len));
	lo(1)=len;                      % 'lo' is a vector with the length of the
	for i=1:L                       % coefficients for each one of the scales
		lo(i+1)=floor((lo(i)+1)/2);
	end

	tope=0.5;                               % we search the point where to
	suma=2^(-basis(1));                     % split the coefficient and basis
	i=1;corte=0;                            % vectors (branch partitioning)
	while (suma<=tope)
		corte=corte+lo(basis(i)+1);
		i=i+1;
		suma=suma+2^(-basis(i));
	end

	w1=w(1:corte);w2=w(corte+1:N);                       % needed partitions are made
	basis1=basis(1:i-1);basis2=basis(i:length(basis));   % before calling the recursion
	if (flag&order)                 % swapped if proceeds
		aux=w1;w1=w2;w2=aux;
		aux=basis1;basis1=basis2;basis2=aux;
	end
	fw=iwpk(w1,rh,rg,order,basis1-1,lo(2),flag);    % recursive calls
	dw=iwpk(w2,rh,rg,order,basis2-1,lo(2),(~flag));
	f=iwt([fw;dw],rh,rg,1,len);                     % detail and approximation
end                                                     % synthesis for the 2^1 scale
if (nargin<=6)&(fil), f=f'; end
