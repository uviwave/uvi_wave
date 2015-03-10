% WPKDMO allows the selection of some Wavelet Packet transform demos
% through a menu. This submenu may be accessed from the WTDEMO menu,
% choosing the '1-D Wavelet Packets' demo section. 

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

k=0;

while (k~=4),
   k=menu('One Dimensional Wavelet Packets','Basis Format','1-D WP Transform','Basis Selection Algorithms','Back');

   if k==1,
        formatdm;
   end

   if k==2,
        wp_dmo;
   end

   if k==3,
        basisdmo;
   end     
end
