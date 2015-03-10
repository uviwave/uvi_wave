function w=wpk(x,h,g,order,basis,flag,flag2)

% WPK   Discrete Wavelet Packet Transform
%
%       WPK(X,H,G,ORDER,BASIS) calculates the Wavelet Packet 
%       Transform of vector X. The second argument H is the 
%       lowpass filter and the third argument G the highpass filter.
%       The ORDER argument indicates the type of tree:
%            0 -> band sorting according to the filter bank
%            1 -> band sorting according to the frequency 
%                 decomposition
%       The BASIS argument specifies the desired subband decomposition. 
%       It can be obtained using a selection algorithm function. It may 
%       be switched from one format to another using CHFORMAT.
%       The different bands are sorted according to ORDER and BASIS.
%
%       If BASIS is omitted, the output is a matrix with the coefficients 
%       obtained from all the wavelet packet basis in the library. Each 
%       column in the matrix represents the outputs for a level in the tree. 
%       The first column is the original signal. If the length of X is not 
%       a power of 2, the columns are zero padded to fit the different lengths.
%    
%       Run the script 'BASIS' for help on the basis format.
%       See also:  IWPK, CHFORMAT, PRUNEADD, PRUNENON, GROWADD, GROWNON.

%       Auxiliary input argument for recursion:
%       flag: if set to 1, indicates that no basis is specified
%          and the output will be a matrix
%       flag2: if set to 1 the function was called with the detail signal,
%	   then the coefficients must be rearranged

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


if ((nargin==4)|(nargin==5))
	if nargin==4
		L=floor(log2(length(x)));       % initialization when
		basis=ones(2^L,1)*(L-1);        % no basis was specified
		flag=1;
		flag2=0;
	else                                    % basis was specified 
		if (~basis)
			w=x;
			return
		end
		basis=basis-1;
		flag=0;
		flag2=0;
	end
	if size(x,2)~=1                 % shapes the signal as column
		x=x(:);                 % vector if necessary
		fil=1;
	else
		fil=0;
	end
end

wx=wt(x,h,g,1);                         % perform one analysis level
					% into the analysis tree

N=length(wx);                           % separate approximation and detail
a=wx(1:N/2);                            % at the analysis output
d=wx(N/2+1:N);

if (flag2*order)                        % if the recursion is going to be
	s1=d;s2=a;                      % performed on the detail signal,
else                                    % and it is frequency sorted, the
	s1=a;s2=d;                      % outputs must be swapped
end

if all(basis==0)                           % two ending nodes achieved
	w=[s1;s2];                         
	if (nargin==5)&(fil), w=w'; end
	return
end;

tope=1;                                 % finds the point where the
suma=2^(-basis(1));                     % basis vector must be divided
i=1;                                    % in order to call the recursion
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end

if all(basis(1:i)~=0)                                   % a level with an ending node
	wa=wpk(s1,h,g,order,(basis(1:i)-1),flag,0);     % but the other node continues
else wa=s1;
end

if all(basis(i+1:length(basis))~=0)
	wd=wpk(s2,h,g,order,(basis(i+1:length(basis))-1),flag,1);   % complementary case
else wd=s2;
end

if flag                                 % output is a matrix
	lwd=length(wd);
	lwx=length(wx);
	nz=2*lwd-lwx;                   % find the number of zeros
					% to be inserted for padding

	w=[ [s1;zeros(nz/2,1);s2;zeros(nz/2,1)] , [wa;wd] ];
else
	w=[wa;wd];
end

if nargin==4
	N=size(w,1);
	w=[ [x;zeros(N-length(x),1)] w];
elseif (nargin==5)&(fil), w=w'; end
