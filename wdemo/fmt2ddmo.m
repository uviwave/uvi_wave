%FMT2DDMO   Demo script with help on the format used for the 2D
%           wavelet transform in the Uvi_Wave toolbox.

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

echo on

% At every level, the lowpass residue is placed at the top-left
% corner of the corresponding subimage, the horizontal detail 
% at the top-right, the vertical detail band at the bottom-left
% and the diagonal detail band at the bottom-right. So, every
% successive wavelet subimage substitutes the residue of the
% previous scale.
	
% For example, let's load a test image and a set of filters:

	x=genimg(0);
	colormap('gray')
	figure(1), set(1,'Position',[145 45 420 415])	
	show(x), title('Original image')
	load filt3

% Press any key to continue ...
pause
%----------------------------------------------------------

% And make its 1 scale wavelet trasform ...

	w=wt2d(x,h3,g3,1);

% In figure 1 you can see the lowpass residue at this scale.

	figure(1)
	b1=bandext(w,1,1,0);
	show(b1), title('Residue at the 1st scale')

% Its size is

	size(b1)

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, if we iterate the 1 scale transform on this lowpass
% band (as a 2 scales transform does), the coefficients
% on figure 2 are obtained.

	b2=wt2d(b1,h3,g3,1);
	figure(2), set(2,'Position',[600 45 420 415])
	colormap('gray')
	show(b2), title('2nd scale replacing 1st scale lowpass residue') 

% The size of this band is
	
	size(b2)

% Then, the overall 2 scales wavelet transform keeps the size of the
% original signal. This is always true if both dimensions of the
% original image are powers of 2.
% So, the transform of our 128x128 image will return the same size
% despite of the number of scales or the basis we use. 

% Press any key to continue ...
pause
%----------------------------------------------------------

% However, for images whose width/height is not a power of 2,
% every time its size is halved from an odd previous size, an
% extra  column/row is added to the wavelet transform.

% This produces that some wavelet image representations may be 
% greater than their original images, having partially blanked 
% columns/rows attached to the left/top side of some subbands.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's see an example.

	load lena2
	figure(1)
	show(x), title('Original image')
	w=wt2d(x,h3,g3,1);
	figure(2)
	band2d(w,1,101,101)
	title('1-scale Wavelet Transform')

% Consider the 101x101 image depicted in figure 1, that returns
% a 102x102 1-scale wavelet transform ((51+51)*(51+51)).
% In figure 2, the position of the different subbands in the 
% transform image has been marked.

% Press any key to continue ...
pause
%----------------------------------------------------------

% If we calculate the 2 scale wavelet transform, the residue would
% be 52*52 ((26+26)*(26+26)), which does not fit into the 51*51
% lowpass residue of the previous scale.

	w=wt2d(x,h3,g3,2);
	figure(1)
	band2d(w,2,101,101)
	title('2 scales Wavelet Transform')

% In order to fit the bands with different size, extra lines have to
% be added.

% As you can see in figure 1, a blank row is attached to the horizontal
% detail and a blank column to the vertical one. So, these lines are
% meaningless from the 53th sample to the last.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Finally, let's reconstruct the original signal:

	rx=iwt2d(w,rh3,rg3,2,101,101);
	show(rx), title('Reconstructed signal')

% Press any key to finish.
pause
%----------------------------------------------------------

echo off
clear x w wn rx h3 g3 rh3 rg3
close all
