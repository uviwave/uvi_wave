%WP2D_DMO   demo script on two dimensional Wavelet Packet transform
%
%           WP2D_DMO is a demo script that shows some two
%           dimensional wavelet packet transform facilities
%	    for images.
%
%           WP2D_DMO may be accessed from the WTDEMO command 
%           interactive menu, choosing the '2-D Wavelet Packets'
%           demo section. 

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

figure(1)
set (1,'Position',[100,100,400,400])
subplot(111)
echo on
%----------------------------------------------------------

% Let's generate an image (from our 'genimg' function)
% to work with:

	x = genimg(0,128,128);
	show(x)
	colormap(gray); title('Test Image');

% and load a set of biorthogonal wavelet filters,

	load filt3

% and a 2-D wavelet packet basis,

	load basis2d

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, we perform the wavelet packet transform using
% that basis.
% Wait a while ...

	w = wpk2d(x,h3,g3,basis2d);

% Ready.

	show(w)
	title('2D Wavelet Packet transform');

% This is the 2D wavelet transform of our 'test' image.
% This wavelet packet image has frequency components enough
% to get the bands bright enough to see all of them.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, we are going to extract the coefficients of the
% marked subband ...

	[b,x1,y1,x2,y2]=extband(w,basis2d,4);
	hold on
	plot([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1])
	hold off

% Press any key to continue ...
pause
%----------------------------------------------------------

% ... and we recontruct using this single subband:

	aux=zeros(128);
	aux=insband(b,aux,basis2d,4);
	rx = iwpk2d(aux,rh3,rg3,basis2d);
	show(rx)
	title('Reconstructed signal')

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now we'll reconstruct the original image by making the
% inverse 2D wavelet packet transform of w, using the
% synthesis filters from the same set.

% Wait, please ...

	rx = iwpk2d(w,rh3,rg3,basis2d);
	show(rx); title('Full image reconstruction');

% Here is the original.
% Let's see the 'difference' image ...

% Press any key to continue ...
pause
%----------------------------------------------------------

	show(rx-x); title ('Reconstruction Error');

% Look at their maximum values:

	echo off
	fprintf('\nOriginal = %i\n',max(max(x)))
	fprintf('Error    = %g\n',max(max(rx-x)))
	echo on

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, let's load 'Lena' image.

	load lena
	set (1,'Position',[100,100,400,400])
	subplot
	show(lena); title('Original Image');
	axis off
	colormap('gray')

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's make the 2D wavelet packet transform using
% the same basis as before.
% (Wait a little more; this is a bigger image ...)

	w = wpk2d(lena,h3,g3,basis2d);
	show(w); title('2D Wavelet Packet transform');

% Ready.

% Press any key to continue ...
pause
%----------------------------------------------------------

% This image does not have energy enough in all subbands
% to see them clearly. So, we can brighten the high
% frequency bands using 'bandadj':

	wbr = bandadj(w,basis2d);
	band2d(wbr,basis2d), title('Brightened transform');
	
% Now you can see all the wavelet bands.
% The lowpass residue is easy to locate; it carries the 
% most of the spectrum of the image (as it is usual with
% real images).
% The highpass bands highlight the image edges in the
% directions that every region should do. Vertical high
% frequencies show horizontal discontinuities, while
% horizontal high frequencies show vertical ones.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now let's recompose the original signal, but leaving
% out one band (for example, the lowpass residue).
% We can nullify it using 'insband':

	pw = insband(0,w,basis2d,1);
	band2d(pw,basis2d),  title('Lowpass band set to 0');

% Press any key to continue ...
pause
%----------------------------------------------------------

% Make the inverse wavelet packet transform (wait again...)

	p = iwpk2d(pw,rh3,rg3,basis2d);
	show(p); title('Reconstruction without lowpass data');

% We have eliminated the low frequencies of the image.
% (Should look like embossing the image)

% Press any key to finish.
pause
%----------------------------------------------------------

echo off
clear lena w p pw wbr original error x rx basis2d aux b x1 y1 x2 y2
close(1)
