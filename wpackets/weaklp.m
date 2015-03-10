function c=weaklp(y,p)

%WEAKLP      Non-additive cost function: weak l^p norm.
%		
%	     C=WEAKLP(Y,P) where C is the cost of the coefficients Y.
%	     A single parameter P is passed to the function.
%	     This cost can be used with GROWNON and PRUNENON.
%
%	     See also: CMPNUM, CMPAREA, CWENT.
%
%	     References: C. Taswell, "Near-best basis selection algorithms 
%			 with non-additive information cost functions"
%			 Proc. IEEE-SP International Symposium on TFTSA-94
%			 October 1994

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

N=length(y);
y=y(:);
y=flipud(sort(abs(y)));

k=(1:N)';
c=max((k.^(1/p)).*y);
