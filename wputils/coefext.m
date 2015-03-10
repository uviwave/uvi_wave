function y=coefext(w,basis,len)

%COEFEXT     Extracts wavelet packet coefficients corresponding to 
%            a certain basis.
%
%            Y=COEFEXT(W,BASIS,LEN) returns a column vector Y. The first
%            argument W is the matrix containing all the Wavelet Packet
%            coefficients, given by the WPK function. BASIS indicates the
%            desired tree. The third argument LEN, has to be passed if the
%            length of the signal that was transformed was not a power of 2.
%            The format of BASIS must match the one used with WPK for
%            generating W.
%
%            See also: WPK, CHFORMAT.

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


[N,L]=size(w);
if nargin==2, len=N; end            % original signal size
L=L-1;                              % maximum depth of the tree

lo(1)=len;                                  % calculation of the 
for i=1:L                                   % successive coefficients size
	lo(i+1)=floor((lo(i)+1)/2);         % at every tree level
end

if nargin==3                                         % if the original signal
	nz(L+1)=0;                                   % length was not a power of 2,
	for i=L:-1:1                                 % zero padding size for matrix W
		nz(i)=(N-lo(i)*2^(i-1))/2^(i-1);     % is computed
	end
end

l=length(basis);
y=[];
inicio=1;
for i=1:l
	fin=inicio+lo(basis(i)+1)-1;            % we choose the coefficients
	y=[y;w(inicio:fin,basis(i)+1)];         % of the node related to
	if nargin==2                            % the i-th element of 'basis'
		inicio=fin+1;
	else
		inicio=fin+nz(basis(i)+1)+1;
	end
end
