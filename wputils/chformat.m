function [b,y]=chformat(basis,opt,w,len,flag)

% CHFORMAT  Changes the order of the basis or coefficient vector in the
%           Wavelet Packet Transform.
%
%           B=CHFORMAT(BASIS,OPT) changes BASIS vector from the format
%           given in OPT to the reciprocal one.
%
%           OPT:  0 ==> 'BASIS' is the filter bank scheme
%                 1 ==> 'BASIS' is the tree in frequency domain
%
%           [B,Y]=CHFORMAT(BASIS,OPT,W,LEN) also sorts the coefficients W
%           obtained with BASIS and format OPT, where W is the Wavelet
%           Packet coefficient vector; LEN (original signal length)
%           is only required if it is not a power of two.
%           CHFORMAT returns the basis B and the coefficients Y in the
%	    reciprocal format given in OPT.
%
%           See also:  WPK, IWPK.

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


N=length(basis);

if (nargin==2)|(nargin==3)|(nargin==4)          % we are at the root of the tree
	if (sum(2.^(-basis))~=1)                % check that 'basis' is possible
		disp('Error: wrong basis specification.')
		return
	end

	flag=0;

	if (size(basis,2)~=1)            % if 'basis' is a row vector
	basis=basis(:);                  % it is returned the same way
		fil1=1;
	else
		fil1=0;
	end

	if nargin==3
		len=length(w);
	end

	if nargin==2            % initialization when working
		w=[];           % with basis vector only
		len=[];
	end

	if (size(w,2)~=1)       % if 'w' is a row vector
		w=w(:);         % it is returned the same way
		fil2=1;
	else
		fil2=0;
	end
end

% cut 'basis' in 2 halves, each one of them matching the
% two branches/subtrees starting from the current node

tope=0.5;
suma=2^(-basis(1));
i=1;
while (suma<tope)
	i=i+1;
	suma=suma+2^(-basis(i));
end

if length(w)
	tope=max(basis(1:i));
	lo(1)=len;
	for j=1:tope
		lo(j+1)=floor((lo(j)+1)/2);
	end
	L=sum(lo(basis(1:i)+1));
	len=lo(2);
else
	L=[];
	len=[];
end

% For each subtree, if it is not an ending branch, the function
% is called recursively.
% For this recursion, an auxiliary variable is passed to the function.
% This variable is set to 1 when it is necessary to swap the two branches
% starting from the initial node of each subtree.

if (i==1)
	y1=w(1:L);
	b1=basis(1);
else
	[b1,y1]=chformat(basis(1:i)-1,opt,w(1:L),len,flag&(~opt));
end

if ((N-i)==1)
	y2=w(L+1:length(w));
	b2=basis(N);
else
	[b2,y2]=chformat(basis(i+1:N)-1,opt,w(L+1:length(w)),len,(~flag)|opt);
end

% if 'flag' is 1, the filter bank tree and the frequency division one
% differ from each other starting from the current node

if (flag)
	aux=b1;b1=b2;b2=aux;
	aux=y1;y1=y2;y2=aux;
end

y=[y1;y2];
b=[b1;b2];

if (nargin==5)
	b=b+1;
elseif fil1|fil2
	if fil1, b=b'; end
	if fil2, y=y'; end
end
