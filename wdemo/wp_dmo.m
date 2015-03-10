%WP_DMO    demo script that describes some of the 1D wavelet
%          packet transform capabilities.
%
%          WP_DMO may be accessed from the WTDEMO command 
%          interactive menu, choosing the '1-D WP Transform'
%          section within the '1-D Wavelet Packets' submenu.

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
%               Nuria Gonzalez Prelcic
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

echo on

% We are going to perform a wavelet packet analysis of the audio
% signal you can see in the figure.

	load zappa
	plot(zappa); title('Original Signal');

% Press any key to continue ...
pause
%----------------------------------------------------------

% First, a pair of wavelets filters is generated.
% Then an existing basis is loaded. This basis
% has been obtained using the 'growadd' function with
% an additive cost given by the function 'shanent'.
% Finally, the wavelet packet analysis is performed
% using the function 'wpk' with the input 'ORDER' set
% to 0 (default value of the basis format when using
% 'growadd').

	load filtd8
	load basis
	y=wpk(zappa,d8h,d8g,0,base);
	plot(y); title('Transformed signal using Wavelet Packets')

% Press any key to continue ...
pause
%----------------------------------------------------------

% Using the utility 'extband' an specific subband can
% be extracted from the previously depicted coefficients.

	subplot(211)
	[b,x1,y1,x2,y2]=extband(y,base,9);
	bn=zeros(size(y)); bn(y1:y2,x1:x2)=b;
	plot(bn)
	title('Coefficients of the 9th subband')
	subplot(212)
	plot(iwpk(bn,d8hr,d8gr,0,base,length(zappa)))
	title('Reconstructed signal from this single subband')

% Press any key to continue ...
pause
%----------------------------------------------------------

% The time-frequency plane tiling performed by the wavelet
% packet basis can be drawn using the TFPLOT function.
% As the loaded basis was in natural order (i.e., according to
% the filter bank), we have to change its format before calling
% TFPLOT.

	base2=chformat(base,0);
	tfplot(base2)

% For seeing the filter bank structure, TREE function can be used.
% In this case, we pass the wavelet packet basis in natural order.

	figure(2)
	tree(base)
	title('Filter bank scheme implementing this wavelet packet transform')

% Press any key to continue ...
pause
%----------------------------------------------------------
close(2)

% When using 'wpk' without specifying the parameter
% 'BASIS' the full tree is obtained. The output is
% a matrix with the coefficients of all the wavelet
% packet basis library, with the original signal in
% the first column.

% Using the function 'coefext' the coefficients
% corresponding to any basis can be extracted.
% The figure shows some examples.

% Please wait ...

	y_all=wpk(zappa,d8h,d8g,0);

	y1=coefext(y_all,base);
	subplot(311); plot(y1)
	echo off
	set (1,'Position',[100,100,600,650])
	title('Previously computed basis')
	echo on

	base2=[10,10,(9:-1:1)];
	y2=coefext(y_all,base2);
	subplot(312); plot(y2)
	echo off
	title('Octave subband decomposition')
	echo on

	base3=3*ones(2^3);
	y3=coefext(y_all,base3);
	subplot(313); plot(y3)
	echo off
	title('Uniform subband decomposition')
	echo on

% Press any key to continue ...
pause
%----------------------------------------------------------

% We can easily compress a signal retaining only the biggest
% coefficients in the transformed signal, and then reconstruct.

% For example, consider again our audio signal.

	echo off
	n=input('Percentage of coefficients you want to retain (0-100): ');
	echo on

	[o,idx]=sort(abs(y).^2);
	idx=fliplr(idx);
	n=round(n/100*length(y));
	yc=zeros(1,length(y));
	yc(idx(1:n))=y(idx(1:n));
	rx=iwpk(yc,d8hr,d8gr,0,base,length(zappa));
	
	echo off
	set (1,'Position',[100,100,800,550])
	subplot(111); plot(zappa,'y')
	hold on;plot(rx,'r');hold off
	title('Yellow: original. Red :reconstructed after discarding smallest coefficients')
	xlabel(['Coefficients retained: ' int2str(n)])
	echo on

% Press any key to finish.
pause
%----------------------------------------------------------

echo off
close(1)
