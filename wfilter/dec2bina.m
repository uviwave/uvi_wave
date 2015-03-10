function  bin=dec2bina(num,bits)

%DEC2BINA    BIN = DEC2BINA(NUM,BITS) returns a vector which contains 
%	     the decimal number NUM in binary format, with a number of 
%	     digits equal to BITS. It is an auxiliary function used by
%	     SYMLETS.

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


if nargin<2
	flag=0;
else
	flag=1;
end

bin=[];
coc=num;
while coc>1
	bin=[rem(coc,2) bin];
	coc=fix(coc/2);
end
bin=[coc bin];
if flag 
 	if length(bin)<bits
		bin=[zeros(1,bits-length(bin)) bin];
	end
end
