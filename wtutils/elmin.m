function y=elmin(x,pc)

%  ELMIN  Deletes the smallest samples of a vector.
%
%         ELMIN (X,PC) sets to 0 the minimum absolute values of 
%         vector X. PC is the percentage of minimum values to be 
%         set to zero from the whole original signal X.
%
%         See also: LOCALEXT, BANDMAX.

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
%       Author: Sergio J. Garcia Galan 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

[ly,lx]=size(x);
l=length(x(:));
pc=floor(l*pc/100);
y=x;
ax=abs(x);
MX=max(max(abs(x)))+1;
if (ly==1 | lx==1)		% ONE DIMENSION
	for i=1:pc
		[m,d]=min(ax);
		y(d)=0;
		ax(d)=MX;
	end
else				% TWO DIMENSIONS
	for i=1:pc
		[m,py]=min(ax);
		[m,px]=min(m);
		py=py(px);
		y(py,px)=0;
		ax(py,px)=MX;
	end
end
