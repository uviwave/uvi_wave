%FORMAT2D   Script with help on the format used for the 2D
%           wavelet and wavelet packet transform in the
%	    Uvi_Wave toolbox.

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

% At every level, the lowpass band is placed at the top-left
% corner of the corresponding subimage, the horizontal high 
% frequency band at the top-right, the vertical high frequency 
% band at the bottom-left and the diagonal high frequency band 
% at the bottom-right. So, every splitting in four bands 
% substitutes the previous subband.
	
% Example with 2 levels and wavelet packet:
%
%	'basis' would be [1 1 2 2 2 2 1] for this example

%					 _______
%			1st level ---->	|   |_|_| <-- 2nd level of decomposition 
%			lowpass band	|_ _|_|_|     substituing the previous subband
%					|   |   | 
%		        1st level ---->	|___|___| <-- 1st level 
%	     vertical high frequency		      diagonal high frequency

% Press any key to continue ...
pause
%----------------------------------------------------------

% This is always true if both dimensions of the original image
% are powers of 2.
% So, the transform of an 64x32 image will return the same size,
% despite of the number of scales or the basis we use. 

% However, for images whose width/height is not a power of 2,
% every time its size is halved from an odd previous size, an
% extra  column/row is added to the wavelet (or wavelet packet)
% transform.

% This produces that some wavelet image representations may be 
% greater than their original images, having partially blanked 
% columns/rows attached to the left/top side of some subbands.
% The same apply for wavelet packets.

% Press any key to continue ...
pause
%----------------------------------------------------------

% For example: making the wavelet transform of a 101x101 image
% would give a 102x102 1-scale wavelet transform ((51+51)*(51+51)).
% If we calculate the 2-scale wavelet transform, the residue would
% be 52*52 ((26+26)*(26+26)), which does not fit into the 51*51 lowpass
% residue of the previous scale.
% So, 1 row and 1 column should be added at the top and left sides of
% the 2-scale wavelet transform. A blank row is attached to the horizontal
% detail and a blank column to the vertical one. These lines are meaningless
% (blank) from the 53th sample to the last.

%				blank row
%				 <----->
%			 _______ _______
%			|   	|-------|
%			|	|	|
%			| 52x52 | 51x52	|
%			|_______|_______|
%		      	||   	|	|
%	      blank --->||	|	|
%	      column    ||52x51 | 51x51	|
%			||______|_______|

% For obtaining the exact positions of the subbands in the transform
% matrix, you can use BANDSITE (for wavelet transform) and SITEBAND
% (for wavelet packet).

echo off

