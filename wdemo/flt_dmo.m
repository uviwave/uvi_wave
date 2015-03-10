%FLT_DMO   menu for selecting a wavelet filters family
%	   for the demo on filter generation

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
while (k~=7)
	k=menu('Wavelet Filters','Daubechies','Spline','Maximal flatness','Remez','Battle-Lemarie','Symlets','Back');
	if k==1,
		daub_dmo;	
	end
	if k==2,
		wspl_dmo;	
	end
	if k==3, 
		flat_dmo;
	end
	if k==4,
		remezdmo;
	end
	if k==5, 
		btlmrdmo;
	end
	if k==6, 
		syml_dmo;
	end
end
k=0;
