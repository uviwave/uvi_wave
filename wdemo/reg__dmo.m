%REG__DMO   Demo script on regularity estimates
%
%           REG__DMO is a demo script that illustrates the use and
%	    the main features of some regularity estimates for
%	    wavelet filters. 
%   
%           REG__DMO may be accessed from the 'Filter Design' menu
%	    section of WTDEMO, choosing the 'Regularity Estimates' button.

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
%--------------------------------------------------------

% A filter is regular when it converges, through the cascade algorithm
% implemented by the WAVELET function, to a wavelet and scale function
% with some smoothness.

% In order to provide a regularity estimate, several algorithms have
% been proposed in the literature. Some of them have been implemented
% in Uvi_Wave. 

% Press any key to continue ...
pause
%--------------------------------------------------------

% First, let us see a method based on the temporal filter response.
% It provides an optimal Holder regularity estimate. The function which
% implements this method is TEMPREG. For example, let us take a length-10
% Symlet filter:

	h=symlets(10);
	figure(1)
	set (1,'Position',[100,100,500,400])
	plot(h)
	title('Symlet filter, 10 coefficients')
	r=tempreg(h,5,4)

% The result above is the estimate for that filter. Because of the iterative
% nature of the estimation, we have to set the number of iterations (4 for
% this example). Moreover, the number of zeros in z=-1 is known, in this case,
% to be length(h)/2.

% Press any key to continue ...
pause
%--------------------------------------------------------

% The accuracy of the estimate grows as the number of iterations do (and the
% CPU time!).

% Please, wait ...

	for i=2:10
		e(i-1)=tempreg(h,5,i);
	end
	stem([2:10],e)
	axis([1 11 1.6 1.8])
	xlabel('Number of iterations N')
	ylabel('Holder regularity estimate')

% Press any key to continue ...
pause
%--------------------------------------------------------

% Other methods give an estimate based on the spectrum of the filters.
% So, the SPECREG function estimates the regularity order by a brute force
% method based on Fourier Transform.

% For the same filter as before:

	r=specreg(h,5)

% Press any key to continue ...
pause
%--------------------------------------------------------

% Another example, for a 20-length maximally flat filter:

	h=maxflat(7,7);
	r=specreg(h,7)

% In this case, parameter N (number of zeros in z=-1) follows from the degree of
% flatness in w=pi passed to MAXFLAT.

% Press any key to continue ...
pause
%--------------------------------------------------------

% For Daubechies' filters, there is a Holder regularity estimate proposed by Ingrid
% Daubechies herself. The method is based on a generalization of a technique
% used by Riesz. It works very well for small values of L, but does not give good
% asymptotic results.

% Figure 1 shows their results for filter lengths ranging from 4 to 20:

	for i=2:10
		e(i-1)=regdaub(2*i);
	end
	stem([4:2:20],e), grid
	xlabel('Filter length L')
	ylabel('Holder regularity estimate')	
	
% Press any key to continue ...
pause
%--------------------------------------------------------

% Finally, we are going to compare the performance of the TEMPREG and
% REGDAUB estimates. The filters are the same as before: Daubechies', with
% length from 4 to 20.

% Please, wait ...

	r=zeros(9,2);
	r(:,2)=e';
	for i=2:10
		h=daub(2*i);
		r(i-1,1)=tempreg(h,i,8);
	end
	plot((4:2:20),r(:,1))
	hold on
	plot((4:2:20),r(:,2),'g')
	hold off
	xlabel('Daubechies'' filters length')
	ylabel('Holder Regularity estimate')

% Yellow: using TEMPREG
% Green:  using REGDAUB

% Press any key to finish...
pause
%--------------------------------------------------------

echo off
close(1)
