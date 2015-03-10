function [basis,y,total]=growadd(x,h,g,cost,par,cp,level,tope)

%GROWADD        Selects a Wavelet Packet basis using the growth algorithm
%               and an additive cost measurement. 
%
%               [BASIS,Y,TOTAL]=GROWADD(X,H,G,COST,PAR) uses as input arguments
%               the signal to transform (X), the lowpass (H) and highpass (G)
%               analysis filters and a string (COST) specifying the name of
%               the cost measurement function to be used. If the cost function
%               requires some input arguments, these are passed through the
%               PAR argument.
%
%               The selected basis is returned in BASIS, as well as the
%               coefficients Y and their cost TOTAL.
%
%               Remarks:
%               - Basis and coefficients are sorted acording to the filter
%               bank. Use CHFORMAT to switch to the other format.
%               - As the algorithm does not run through the whole tree,
%               the selected basis may not be optimal, no matter the cost is
%               additive or not.
%
%               See also: GROWNON, PRUNEADD, PRUNENON.
%
%               References: C. Taswell
%                           "Top-down and bottom-up tree search algorithms for
%                           selecting bases in wavelet packet transforms"
%                           Proceedings of the Villard de Lans Conference
%                           Springer Verlag, 1995  

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


if (nargin==4)|(nargin==5)              % initiates values before the recursion
	level=0;
	tope=floor(log2(length(x)));    % maximum tree level
	if (nargin==4)
		par=0;
	end
	if size(x,2)~=1                 % if the input is a row vector
		fil=1;                  % the output is returned the same way
	else
		fil=0;
	end
	x=x(:);
	cp=feval(cost,x,par);
end

w=wt(x,h,g,1);                  % divides the current node
N=length(w);                    % into two desdending ones
w1=w(1:N/2);
w2=w(N/2+1:N);

ch1=feval(cost,w1,par);              % cost calculation for
ch2=feval(cost,w2,par);              % each descending node

if (cp<ch1+ch2)                      % this case ends the
	basis=level;                 % recursion
	y=x;
	total=cp;
elseif level<(tope-1)                                                % continues the recursion,
	[b1,y1,t1]=growadd(w1,h,g,cost,par,ch1,level+1,tope);        % updating basis and coefficients
	[b2,y2,t2]=growadd(w2,h,g,cost,par,ch2,level+1,tope);
	basis=[b1;b2];
	y=[y1;y2];
	total=t1+t2;
else                             % if this is the penultimate tree level
	basis=[tope;tope];       % and cp>ch1+ch2, the two descending
	y=w;                     % nodes are selected
	total=ch1+ch2;
end

if (level==0)
	if fil==1
		y=y';
		basis=basis';
	end
end
