%BAS2DDMO   demo script on Coifman-Wickerhauser basis selection
%	    algorithm for the 2D wavelet packet transform.
%
%           BAS2DDMO may be accessed from the WTDEMO command 
%           interactive menu, choosing the 'Basis Selection
%	    Algorithm' demo section within the '2-D Wavelet
%	    Packets' submenu.

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

% Binary tree structures using wavelet packets provide
% a library of orthonormal bases out of which the best
% basis, according to a given criterion, can be extracted.
%
% Pruning algorithm expands first the full tree of filter
% banks, and the search is performed from the 'leaves'
% towards the 'root'. It can be demonstrated that this kind
% of algorithm selects the 'best basis' within that basis library.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's load an image (Figure 1)
% and a set of Daubechies' filters.

	load lena2
	x=x(15:78,1:64);
	load filt3

	figure(1); set(1,'Position',[200,150,300,300])
	colormap('gray')
	show(x); title('Original signal')

% We are going to perform a best basis search for this image,
% using the Shannon entropy as cost function.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Please wait ...

	cost='shanent';
	[basis,y,total]=prune2d(x,h3,g3,cost);
	c=feval(cost,x);

	echo off
	fprintf('\nThe cost of the original image is : %g\n\n',c)
	fprintf('The cost of the transform : %g\n\n',total)
	fprintf('%c Figure 1 shows the wavelet packet coefficients and the band\n%c division obtained according to your choice.\n',37,37)
	band2d(y,basis)
	title('Wavelet Packet coefficients')
	echo on

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, select another cost function if you want.

	echo off
	par=0;
	
	k1=0;
	while k1~=3
		k1=menu('Cost Functions','Energy with l^p norm','''log energy'' functional','Continue demo');


		if k1==1
			fprintf('Please wait ...\n')
			cost='lpenerg';
			par=1;
			fprintf('\n%c Parameter ''p'' is set to 1 for this example.\n',37)
		elseif k1==2
			fprintf('Please wait ...\n')
			cost='logenerg';
		else
			break
		end

		[basis,y,total]=prune2d(x,h3,g3,cost,par);

		fprintf('%c The selected basis uses %i elements of the wavelet packet library.\n\n',37,length(basis))
		fprintf('%c The cost of the original signal is %g and\n',37,feval(cost,x,par))
		fprintf('%c the cost of the signal transformed with the chosen basis is %g\n\n',37,total)

		fprintf('%c Figure 1 shows the wavelet packet coefficients and the band\n%c division obtained according to your choice.\n',37,37)
		band2d(y,basis)
		title('Wavelet Packet coefficients')
		fprintf('%c----------------------------------------------------------\n\n',37)

	end % of while k1~=3

echo on

% We can easily compress the signal retaining only the largest
% coefficients in the transformed signal, and then reconstruct.

% For example, consider again our image and the last obtained
% wavelet packet coefficients.

	echo off
	n=input('Percentage of coefficients you want to retain (0-100): ');
	echo on

	y=y(:);
	[o,idx]=sort(abs(y).^2);
	idx=flipud(idx);
	n=round(n/100*length(y));
	py=zeros(64);
	for k=1:n
		i=rem(idx(k)-1,64);
		j=fix((idx(k)-1)/64);
		py(i+1,j+1)=y(idx(k));
	end
	rx=iwpk2d(py,rh3,rg3,basis);

	echo off
	set (1,'Position',[100,100,750,300])
	subplot(121)
	show(x)
	axis('off')
	title('Original image')
	subplot(122)
	show(rx)
	axis('off')
	title('Reconstructed after discarding smallest coefficients')
	disp(['Coefficients retained: ' int2str(n) ' out of 4096'])
	echo on

% Press any key to finish.
pause
%----------------------------------------------------------

echo off
clear x y rx py basis total o idx
clear h3 g3 rh3 rg3
close
