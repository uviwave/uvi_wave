function srf(x,dx,dy,ax,ay)

%SRF    Shows a 3D representation of a surface.
%
%	SRF is a shortcut to the surfl function, written for easy
%	representation of 3D surface scalograms using 'shading interp'.
%       A gradient colormap (gray, pink, copper,...) should be
%       selected for nice pictures.
%
%	SRF (X,DX,DY) shows the matrix X in 3D previously decimating
%	it in x by DX and y by DY. This helps on fastening the plot of
%	huge smooth matrices. Enter 1's for no decimation.
%
%	SRF (X,DX,DY,AX,AY) changes the plane axis to AX and AY.
%
% 	See also: SURFL, VIEW, SHOW.
%

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
%  Last modif.: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

[ly,lx]=size(x);
y=x(1:dy:ly,1:dx:lx);
if nargin>3
	ax=ax(1:dx:lx);
	ay=ay(1:dy:ly);
	surfl(ax,ay,y);
	shading interp
	a=axis;
	axis([ax(1),ax(length(ax)),ay(1),ay(length(ay)),a(5),a(6)]);	
	xlabel('Time');
	ylabel('Scale');
else
	ax=(1:dx:lx);
	ay=(1:dy:ly);
	surfl(ax,ay,y);
	shading interp
	ax=axis;
	axis([1,lx,1,ly,ax(5),ax(6)]);	
end
