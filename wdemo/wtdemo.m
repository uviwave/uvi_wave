% WTDEMO provides a demo on the Wavelet Toolbox facilities,
% allowing the selection of some items through an interactive
% menu.

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


k=0;

while (k~=9),
k=menu('Uvi_Wave Wavelet Toolbox','1-D Wavelet Transform','2-D Wavelet Transform','Multiresolution','1-D Wavelet Packets','2-D Wavelet Packets','Scalogram','Filter Design','Image Generation','Exit Demo');

if k==1,
	wt___dmo;	
end
if k==2,
	wt2d_dmo;	
end
if k==3, 
	mrs__dmo;
end
if k==4, 
	wpkdmo;
end
if k==5,
	wpk2ddmo;
end
if k==6, 
	scaldmo;
end
if k==7,
        flds_dmo;
end
if k==8, 
	gnimgdmo;
end
end
