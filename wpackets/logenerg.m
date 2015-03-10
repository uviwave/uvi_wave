function c=logenerg(y,p)

%LOGENERG    Additive cost function: 'log energy' functional.   
%
%	     C=LOGENERG(Y) where C is the cost of the coefficients Y.
% 	     This cost function is a ln(l^2) functional related to the 
%	     Shannon entropy of a Gauss-Markov process.
%	     This cost function can be used with GROWADD, PRUNEADD
%	     and PRUNE2D.
%
%            See also: LPENERG, SHANENT.

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

aux1=(y.*(y~=0)).^2;
aux2=ones(size(y)).*(y==0);
aux=aux1+aux2;
c=sum(sum(log(aux)));
