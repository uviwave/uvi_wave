function c=cwent(y,p)

%CWENT	  Non-additive cost function: Coifman-Wickerhauser entropy
%		
%	  C=CWENT(Y) where C is the cost of the coefficients Y.
%	  This cost can be used with GROWNON and PRUNENON.
%
%	  See also: CMPNUM, CMPAREA, WEAKLP.
%
%	  References: R.R. Coifman and M.V. Wickerhauser
%	              "Entropy-based algorithms for best basis selection"
%	              IEEE Transactions on Information Theory, vol.38, no.2
%	              March 1992

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

n=norm(y,2)^2;
y=(y.^2)/n;
c=0;
L=length(y);
for i=1:L
	if y(i)~=0
		c=c-y(i)*log(y(i));
	end
end
