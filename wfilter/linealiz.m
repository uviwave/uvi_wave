function fase=linealiz(f)

%LINEALIZ     PHASE = LINEALIZ(F) is an auxiliary function used
%	      by SYMLETS. It eliminates the linearity of the
%	      phase vector F.


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
%       Author: Jose Martin Garcia
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


if abs(sum(f(1,:))) >0.0001
	w=[0:2*pi/1e3:2*pi];
	[m,n]=size(f);
	fase=zeros(m,n);
	for cont=1 : m
		if sum(f(cont,:)) >0
			fase(cont,:)=f(cont,:)-w/2;
		else
			fase(cont,:)=f(cont,:)+w/2;
		end
	end
else
	fase=f;
end
