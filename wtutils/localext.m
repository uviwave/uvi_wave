function [ou,k]=localext(sg)

% LOCALEXT  Extracts the local extremes of a vector.
%
%           LOCALEXT (X) returns a copy of vector X with all
%           non extreme values set to 0.
%
%           [Y,K] = LOCALEXT (X) will also return the number of
%           deleted samples of X.
%
%           See also:ELMIN, BANDMAX, BANDSITE, BANDEXT

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

[ly,lx]=size(sg);
if (ly==1 | lx==1)		% ONE DIMENSION
	l=length(sg);
	sg=sg(:)';
	ou=zeros(1,l);
	ax=abs(sg);
	ou(1)=sg(1);
	ou(l)=sg(l);
	k=0;
	for i=2:l-1
		if (sg(i)>sg(i-1))&(sg(i)>sg(i+1))
			ou(i)=sg(i);
			k=k+1;
		end
		if (sg(i)<sg(i-1))&(sg(i)<sg(i+1))
			ou(i)=sg(i);
			k=k+1;
		end
	end
else				% TWO DIMENSIONS
	ou=zeros(ly,lx);
	ax=abs(sg);
	ou(1,1)=sg(1,1);
	ou(ly,1)=sg(ly,1);
	ou(1,lx)=sg(1,lx);
	ou(ly,lx)=sg(ly,lx);
	k=0;
	for xi=1:lx
		for yi=2:ly-1
			if (sg(yi,xi)>sg(yi-1,xi))&(sg(yi,xi)>sg(yi+1,xi))
				ou(i)=sg(i);
				k=k+1;
			end
			if (sg(yi,xi)<sg(yi-1,xi))&(sg(yi,xi)<sg(yi+1,xi))
				ou(i)=sg(i);
				k=k+1;
			end
		end
	end
	for yi=1:ly
		for xi=2:lx-1
			if (sg(yi,xi)>sg(yi,xi-1))&(sg(yi,xi)>sg(yi,xi+1))
				ou(yi,xi)=sg(yi,xi);
				k=k+1;
			end
			if (sg(yi,xi)<sg(yi,xi-1))&(sg(yi,xi)<sg(yi,xi+1))
				ou(yi,xi)=sg(yi,xi);
				k=k+1;
			end
		end
	end
end

k=l-k;
