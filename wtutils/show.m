function show(x,s,ax,ay)

%SHOW   Display an image.    
%
%	SHOW(X,S) display the matrix in X as an image, scaling 
%       it to achieve the maximum color resolution. S is an 
%       optional brightening factor.
%
%       If S is not given or equal to 1, the dynamic range will
%       be fit into 0-63 (the size of the built in colormaps).
%       If it is set to another value, this range will be 
%       multiplied by S. A negative value will invert the image 
%       colors.
%
%       A gradient colormap (gray, pink, copper,...) should be
%       selected for nice pictures. Good B&W views can be obtained
%	if the gray or pink colormap is set.
%
%	SHOW(X,S,AX,AY) changes the plane axis to AX and AY. 
%
%       See also: BANDADJ, COLORMAP, IMAGE.

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
%       Author  : Sergio J. Garcia Galan
%       e-mail  : Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

[ly,lx]=size(x);

if nargin<2
	s=1;
end

if s<0,
	s=-s;
	x=-x;
end

M=max(max(x));
m=min(min(x));

if nargin>2
   	image(ax,ay,(x-m)*64/(M-m)*s);
else
   	image((x-m)*64/(M-m)*s);
end
