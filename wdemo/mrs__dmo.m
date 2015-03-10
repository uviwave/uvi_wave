% MRS__DMO  Demo script on multiresolution analysis
%
%           MRS__DMO is a demo script that describes some
%           multiresolution analysis features for 1D and 
%           2D signals.
%
%           MRS__DMO may be accessed from the WTDEMO command 
%           interactive menu, choosing the 'Multiresolution'
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

figure(1);
subplot;
echo on;

%  Let's create a 1D signal. For example:

	i=1:500;
	x=sin(i/10)+sin(i/4)+2*rand(1,500);
	x=x-mean(x);

	plot(x); title('Original signal');


% Press any key to continue ...
pause
%----------------------------------------------------------

% Now let's load a set of Daubechies' wavelet filters

	load filtd8

% and make the 3-levels multiresolution approximation
% of the signal

	a=aprox(x,d8h,d8hr,3);
	plot(1:500,x,'b',1:500,a,'y'); 
	title('3 scales approximation');

% The blue plot is the original, and the yellow one is
% the 3-iterated lowpass approximation.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now we're calculating the 3-levels detail signal:

	d3=detail(x,d8h,d8hr,d8g,d8gr,3);
	plot(1:500,x,'b',1:500,d3,'y');
	title('3 scales detail signal');

% The yellow plot is now the difference between the
% 2-levels and the 3-levels approximations

% Press any key to continue ...
pause
%----------------------------------------------------------

% We can compute all successive details and the last
% approximation using the MULTIRES function. Let's do it
% for 5 levels:

	y=multires(x,d8h,d8hr,d8g,d8gr,5);
	set (1,'Position',[100,100,500,800]);
        split(y);
	subplot(611); title('5 successive details and approximation');

% The first 5 plots are the detail signals from the
% first level to the 5th. The 6th plot shows the 5-level
% aproximation of the original.

% Press any key to continue ...
pause
%----------------------------------------------------------

% The original can be computed by summing all the details
% and the lowpass approximation.

	set (1,'Position',[100,100,600,400]);
	subplot(111);
	plot(sum(y)); title('Reconstruction from details and aproximation');
	

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now let's generate an image...

	y=genimg(0);

% and see it.

	show(y);
	set (1,'Position',[100,100,400,400]);
	colormap(pink);
	title('Test image');

% This is a test square image.

% Press any key to continue ...
pause
%----------------------------------------------------------

% We're now computing some approximations. You'll see
% That the higher level gives a more lowpass image.
% Dark points are negative values, while bright ones
% are positive data.
% Wait now...

	y1=mres2d(y,d8h,d8hr,d8g,d8gr,1,0);
	subplot(131);
	show(y1); title ('1 scale approximation');
	colormap(pink);
	y2=mres2d(y,d8h,d8hr,d8g,d8gr,2,0);
	subplot(132);
	show(y2); title ('2 scales approximation');
	colormap(pink);
	y3=mres2d(y,d8h,d8hr,d8g,d8gr,3,0);
	subplot(133);
	show(y3); title ('3 scales approximation');
        set (1,'Position',[100,100,900,250]);
	colormap(pink);

% Ready !

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now let's see some detail images (wait another while)

	d11=mres2d(y,d8h,d8hr,d8g,d8gr,1,1);
	subplot(131);
	show(d11); title ('1 scale horizontal detail');
	colormap(pink);
	d12=mres2d(y,d8h,d8hr,d8g,d8gr,1,2);
	subplot(132);
	show(d12); title ('1 scale diagonal detail');
	colormap(pink);
	d13=mres2d(y,d8h,d8hr,d8g,d8gr,1,3);
	subplot(133);
	show(d13); title ('1 scale vertical detail');
	colormap(pink);

% The leftmost image is the Horizontal high frequency band,
% the centered is the diagonal high frequency one and the
% rightmost the vertical high frequency band, all of them
% computed for 1-level.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let`s see now the successive detail images along 3 levels,
% each of them being the sum of the H,V and D high freq. bands
% for each level.
% You'd wait a little long... (about 1 min. on a Sparc 10)

	d1=mres2d(y,d8h,d8hr,d8g,d8gr,1,4);
	subplot(131);
	show(d1); title ('1 scale full detail');
	colormap(pink);
	d2=mres2d(y,d8h,d8hr,d8g,d8gr,2,4);
	subplot(132);
	show(d2); title ('2 scales full detail');
	colormap(pink);
	d3=mres2d(y,d8h,d8hr,d8g,d8gr,3,4);
	subplot(133);
	show(d3); title ('3 scales full detail');
	colormap(pink);

% From the left to right, the details at 1,2 and 3 levels.

% Press any key to continue ...
pause
%----------------------------------------------------------

% The sum of all details (1,2 and 3 levels) and the 3-levels
% approximation should give the original:

	set (1,'Position',[100,100,400,400]);
	subplot
	show(d1+d2+d3+y3); 
 	title('Reconstruction from details and approximation');
	colormap(pink)

% Is that right?

% Press any key to continue ...
pause
%----------------------------------------------------------

% The last example. Let's load a "kitty"

	load kitten
	show(kitten); title('Kitty image');
	colormap(gray);

% We'll only compute the 2-level approximation and
% sum of details (press any key and then wait...)
pause

	a=mres2d(kitten,d8h,d8hr,d8g,d8gr,2,0);
	set (1,'Position',[100,100,900,400]);
	subplot(121);
	show(a); title('2 scales approximation image');
	colormap(gray);
	d=mres2d(kitten,d8h,d8hr,d8g,d8gr,2,4);
	subplot(122);
	show(d); title('2 scales full detail image');
	colormap(gray);

% That's all !!
% Press any key to end the Multiresolution demo ...
pause
%----------------------------------------------------------

echo off;
close(1)


