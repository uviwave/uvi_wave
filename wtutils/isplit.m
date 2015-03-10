function y=isplit(w,k,axs,str,lcol,ecol)

%ISPLIT   Splits a wavelet transform in subbands.
%
%         ISPLIT (W,K)  plots the K-scales wavelet transform vector
%         W split into K+1 separated discrete plots, from the 
%	  lowpass residue to the higher scale highpass band.
%
%	  ISPLIT (W,K,'off') Hides the axis frames of plots.
%
%	  ISPLIT (W,K,'(whatever)',STR) passes the STR string
%	  to the PLOT command when drawing the band. The default
%	  value is '.', for dot-plotting. Colours can be also 
%	  specified as in PLOT.
%
%	  ISPLIT (W,K,'(whatever)',STR,LCOL) sets the color
%	  of the sample lines to the specified in string LCOL.
%	  The X-axis is also plotted with that color.
%
%	  ISPLIT (W,K,'(whatever)',STR,LCOL,ECOL) works the
%	  same as the previous but changing the colour of
%	  the X-axis to the specified by ECOL.
%
%         See also: DISCPLOT, PLOT, SPLIT, SHOW, WT.

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


[ly,lx]=size(w);

if (ly>1 & lx>1)
	disp('Cannot ISPLIT a matrix. Maybe you want to use SPLIT instead.');
	return;
end 
if nargin<3,
	axs='';
end
if axs~='off',
	axs='on';
end
if nargin<4,
	str='.';
end
if nargin<5,
	lcol='';
end
if nargin<6,
	ecol=lcol;
end
w=w(:)';
ls=bandext(w,k,k,0); 	% extract the lowpass residue
subplot(k+1,1,1);
if nargin>4
	discplot(ls,str,lcol,ecol); axis (axs);
else
	discplot(ls,str); axis (axs);
end
for i=k:-1:1,
	bs=bandext(w,k,i,1);
	subplot(k+1,1,k-i+2);
	if nargin>4
		discplot(bs,str,lcol,ecol); axis (axs);
	else
		discplot(bs,str); axis (axs);
	end	
end
