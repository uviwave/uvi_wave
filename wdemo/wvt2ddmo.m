%WVT2DDMO   demo script on two dimensional Wavelet transform.
%
%           WVT2DDMO is a demo script that describes some 
%           two dimensional wavelet transform facilities for 
%           images.
%
%           WVT2DDMO may be accessed from the WTDEMO command 
%           interactive menu, choosing the '2-D Wavelet Transform'
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
%       Author: Sergio J. Garcia Galan 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

figure(1)
set (1,'Position',[100,100,400,400]);
subplot(111)
echo on;
%----------------------------------------------------------

% We'll create an image (from our GENIMG function )
% to work with:

	x = genimg(8,128,128);
	show(x)
	colormap(pink); title('Wavy Image');

% and load a set of wavelet filters,

	load filtd8

% Press any key to continue ...
pause
%----------------------------------------------------------

% The image has some particular regions with low and
% high frequencies.
% Let's separate them at 1 scale (wait a while):

	wx = wt2d(x,d8h,d8g,1);

% Ready.

% Press any key to continue ...
pause
%----------------------------------------------------------

	show(wx); title('1-scale 2D Wavelet transform');

% This is the 2D wavelet transform of our 'wavy' image.

% You can see the low frequency component at the upper-left
% corner of the wavelet image, the vertical high frequency
% band at the upper-right one, the horizontal high frequency
% band at the bottom-left corner and the diagonal high
% frequency component at the bottom-right.

% This wavelet image has frequency components enough to
% give the four squares, bright enough to see all of them.
% In other cases, image bands may be brightened for 
% showing with the BANDADJ function.

% Press any key to continue ...
pause
%----------------------------------------------------------

% We may also make a more scaled wavelet transform 
% (wait another while, please):

	wx = wt2d(x,d8h,d8g,3);
	show(wx);  title('3-scales 2D Wavelet transform');

% This is a 3-scales 2D wavelet transform of the original
% image. Some bright has been lost. We'll bright up the
% high frequency bands

	wxbr = bandadj(wx,3);

% Press any key to continue ...
pause
%----------------------------------------------------------

	show(wxbr); title('Brightened Wavelet transform');

% Now you see the same wavelet transform but brightened
% for a easier viewing. Note that this modified wavelet
% image should not be used for inverse transforming.


% Press any key to continue ...
pause
%----------------------------------------------------------

% Now we'll reconstruct the 'wavy' image by making the
% inverse 2D wavelet transform of wx (not the brightened
% version!), using the synthesis filters from the same set
% as the used in analysis (wait, please).

	rx= iwt2d( wx,d8hr,d8gr,3);
	show(rx); title('Reconstruction of the Original');

% The regenerated image. 

% Let's see the 'difference' image ...

% Press any key to continue ...
pause
%----------------------------------------------------------

	show(rx-x); title ('Reconstruction Error');

% It seems that the error is as greater than the image,
% but look at their maximum values

	original = max(max(x))
	error    = max(max(rx-x))
% Press any key to continue ...
pause
%----------------------------------------------------------

% Actually, the error image should look like white noise, 
% but we are using 16-sample filters, and they may have lost
% a bit of accuracy. This results in loosing some original
% components, which appear in the error image.

% Try yourself with smaller filters.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now a more real example. Let's load a photograph.

	load lena
	set (1,'Position',[100,100,400,400]);	
	subplot
	show(lena); title('Original Image');
	axis off
	colormap(gray)

% (Do you know her? )

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's make the 2-scales 2D wavelet transform 
% (wait a little more...)

	wlena = wt2d(lena,d8h,d8g,2);
	show(wlena); title('2-scales 2D Wavelet transform');

% Ready.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Maybe we should brighten the high frequency bands...

	wlbr = bandadj(wlena,2);
	show(wlbr); title('Brightened transform');
	
% Now you can see all the wavelet bands
% The lowpass residue is easy to locate; it carries the 
% most of the spectrum of the image (as it is usual with
% real images).
% The highpass bands highlight the image edges in the
% directions that every region should do. Vertical high
% frequencies show horizontal discontinuities, while
% horizontal high frequencies show vertical ones.

% Every one of them keeps the same phase that the original
% image, except, maybe, the highpass bands, but only for
% 1 row and column.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now let's recompose the original signal, but ...
% what could happen if we leave out one band (for
% instance, the lowpass residue)? We'll see it by 
% inserting a zero band at the location of the
% residue.

	pwlena = bandins(0,wlena,2,2,0);
	show(pwlena); title('Lowpass residue set to 0');

% That's the wavelet we're going to reconstruct.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Make the inverse wavelet transform (wait again...)

	pl = iwt2d(pwlena,d8hr,d8gr,2);
	show(pl); title('Reconstruction without lowpass data');

% We have eliminated the low frequencies of the image.
% (Should look like embossing the image)

% Press any key to continue ...
pause
%----------------------------------------------------------

% To make a whole recomposition (the last wait...)

	rlena = iwt2d(wlena,d8hr,d8gr,2);
	show(rlena); title('Full image reconstruction');

% Here's the original (reconstructed from wlena).


% Press any key to end the 2D transform demo ...
pause
%----------------------------------------------------------

echo off;
clear lena rlena wx wxpr pl wlena pwlena wlbr original error x rx 
clear d8h d8g d8hr d8gr
close(1)

