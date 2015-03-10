% WT___DMO is a demo script that describes some wavelet
% transform facilities for one dimensional vectors.
%
% WT___DMO may be accessed from the WTDEMO command interactive
% menu, choosing the '1-D Wavelet Transform' demo section. 

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


figure(1);
echo on;


%  Let's create a vector. For example:

	i=1:500;
	x=sin(i/10)+sin(i/4)+rand(1,500);
	x=x-mean(x);

	plot(x); title('Original Signal');

% Press any key to continue ...
pause
%----------------------------------------------------------

% Load an existing set of wavelet filters
% (These filters can be created too)
	load filt3
% and calculate the 3-scales Wavelet transform of x
% using the analysis filters of the previous set.

	wx = wt(x,h3,g3,3);
	plot(wx); title('Wavelet transform');
	
% Press any key to continue ...
pause
%----------------------------------------------------------

	plot([1:63],wx(1:63),[64:126],wx(64:126),[127:251],wx(127:251),[252:501],wx(252:501));
	title('Different Scales in the transform');

% Now you can see the four bands generated in the
% 3-scale wavelet, ordered as follows:
%
%	yellow  : Lowpass residue (3rd scale residue).
%	magenta : 3rd scale highpass band
%	blue    : 2nd scale highpass band
%	red     : 1st scale higpass band.


% Press any key to continue ...
pause
%----------------------------------------------------------

% Filter outputs are delayed so as to align all
% subbands with the original signal as much as possible
% along the scales of the Mallat's tree, no matter they
% are linear phase filters or not.

% For instance, let's see it with a low pass vector like

	x = sin(i/15);
	plot(x); title('A lowpass signal');

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now make its wt transform (1 scale):

	wx = wt(x,h3,g3,1);
	subplot(211)
	plot(x); title('Original');
	subplot(212)
	plot(wx); title('1-scale Wavelet transform');

% You can see that the two signals, original and lowpass
% residue of the wavelet transform, have the same phase.

% Press any key to continue ...
pause
%----------------------------------------------------------


% Now we'll see some steps in reconstruction of signals
% after the Wavelet transformation.

% Let's take the first signal we created:

	x=sin(i/10)+sin(i/4)+rand(1,500);
	x=x-mean(x);

	subplot(211)
	plot(x)
	title('Original signal')

% and make the 3-scales wavelet transform (for example)

	wx = wt(x,h3,g3,3);
	subplot(212);
	plot(wx)
	title('3-scales Wavelet transform')

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's make a smoother version of x by leaving out
% its highest frequency bands.
% This is the modified wavelet vector:

	pwx = bandins(0,wx,3,1,1);
        pwx = bandins(0,pwx,3,2,1);      
	subplot(212)
	plot(pwx)
	title('Modified Wavelet vector');

% Press any key to continue ...
pause
%----------------------------------------------------------

% And this one the result, using the iwt function with
% the synthesis filters given in the same set that those
% used in analysis.


	prx = iwt(pwx,rh3,rg3,3);
	subplot(212)
	plot(prx)
	title('Modified reconstructed signal');

% You'll see that some high frequency components have
% been filtered out.

% Press any key to continue ...
pause
%----------------------------------------------------------


% Now we reconstruct x from wx using the iwt transform
% with the same synthesis filters.

	rx = iwt(wx,rh3,rg3,3);
	subplot(211)
	plot(rx)
	title('Reconstructed signal')
	subplot(212)
	plot(rx-x)
	title('Reconstruction Error')

% In the upper plot, there's the reconstructed signal.
% At the bottom, the difference between rx and x
% (Note that it's amplitude is minimal, and is almost
% an error caused by Matlab finite resolution. This
% feature is limited by the precision and accuracy
% of the filters' coefficients)

% Press any key to end the 1D transform demo ...
pause
%----------------------------------------------------------

echo off;
close(1)
