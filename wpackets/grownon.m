function [basis,y,total]=grownon(x,h,g,cost,par,level,tope)

%GROWNON        Selects a Wavelet Packet basis using the growth algorithm
%               and a non-additive cost measurement.
%
%               [BASIS,Y,TOTAL]=GROWNON(X,H,G,COST,PAR) uses as input arguments
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
%               See also: GROWADD, PRUNENON, PRUNEADD.
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
end

w=wt(x,h,g,1);                % divides the parent node into two chidren

cp=feval(cost,x,par);         % parent node cost calculation
ch=feval(cost,w,par);         % child nodes cost

if (cp<ch)                    % this case ends
	basis=level;          % the recursion
	y=x;
elseif level<(tope-1)                     % continues the recursion,
	N=length(w);                      % updating basis and coefficients
	[b1,y1]=grownon(w(1:N/2),h,g,cost,par,level+1,tope);
	[b2,y2]=grownon(w(N/2+1:N),h,g,cost,par,level+1,tope);
	basis=[b1;b2];
	y=[y1;y2];
else                             % if this is the penultimate tree level
	basis=[tope;tope];       % and cp>ch1+ch2, the two descending
	y=w;                     % nodes are selected
end

if (level==0)
	total=feval(cost,y,par);
	if fil==1
		y=y';
		basis=basis';
	end
else
	return
end
