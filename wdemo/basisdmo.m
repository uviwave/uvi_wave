%BASISDMO   demo script on basis selection algorithms for
%           the 1D wavelet packet transform.
%
%           BASISDMO may be accessed from the WTDEMO command 
%           interactive menu, choosing the 'Basis Selection' demo
%           section within the '1-D Wavelet Packets' submenu.

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
% basis (or the near-best), according to a given
% criterion, can be extracted.
%
% The search algorithm of the basis is usually driven
% by the minimization process of an information cost
% function. This cost can be additive or non-additive.
% A cost function M is additive if M(0)=0 and
% M({x(i)})=sum(M(x(i))); it splits nicely across
% cartesian products. Non-additive costs do not verify
% these properties.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Two classes of search algorithms are considered:
% pruning and growth algorithms.
% Each of them have a different implementation
% according to the additiveness of the cost function.

% Pruning algorithms expands first the full tree
% of filter banks, and the search is performed
% from the 'leaves' towards the 'root'.
% Growth algorithms expand the tree step by step,
% starting from the root node and stopping
% when a minimization condition is achieved.

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's load a piece of an audio signal (Figure 1)
% and a set of Daubechies' filters.

	load zappa2
	load filtd8

	plot(zappa2);title('Original signal')

% For example, we are going to divide that signal into 8 frames
% of 128 samples, and we perform the best basis search for each frame,
% using the two types of algorithms and two different costs.

% Press any key to continue ...
pause
%----------------------------------------------------------

	echo off
	for j=1:8,
		x(j,1:128)=zappa2((j-1)*128+1:j*128);
	end
	echo on

% Please wait ...

	par=0;
	for i=1:2
	     for j=1:8
		   if i==1,
			cost='logenerg';
			[basis,y,total]=pruneadd(x(j,:),d8h,d8g,cost,par);
			p(i,j)=total;
			[basis,y,total]=growadd(x(j,:),d8h,d8g,cost,par);
			g(i,j)=total;
		   elseif i==2
			cost='cwent';
			[basis,y,total]=prunenon(x(j,:),d8h,d8g,cost,par);
			p(i,j)=total;
			[basis,y,total]=grownon(x(j,:),d8h,d8g,cost,par);
			g(i,j)=total;
		   end
		   c(i,j)=feval(cost,x(j,:),par);
	     end
	end

	echo off
	subplot(211)
	plot([(1:8)],c(1,:),'r')
	hold on
	plot(p(1,:),'y')
	plot(g(1,:),'g')
	hold off
	title('With ''log energy'' functional (additive cost)')
	ylabel('cost')
	subplot(212)
	plot([(1:8)],c(2,:),'r')
	hold on
	plot(p(2,:),'y')
	plot(g(2,:),'g')
	hold off
	title('With Coifman-Wickerhauser entropy (non-additive cost)')
	ylabel('cost')
	echo on

% Figure 1 shows the cost of the coefficients for each of the frames.
%     Red: Original signal
%  Yellow: Wavelet Packet, basis selected with pruning algorithm
%   Green: Wavelet Packet, basis selected with growth algorithm

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, we are going to work with the complete signal.
% Select the cost function you want to use.

	echo off
	par=0; k1=8;

	while (k1==8)
		k1=menu('Cost Functions','Shannon entropy','Energy with l^p norm','''log energy'' functional','Data compression number','Data compression area','Coifman-Wickerhauser entropy','Weak l^p norm','Continue demo');
		if (k1==8), fprintf(1,'\nYou have to select a cost function.\n'); end
	end

	while (k1~=8)

		if ((k1>0)&(k1<4)) flag=0; else flag=1; end
		if k1==1,
			cost='shanent';
		elseif k1==2,
			cost='lpenerg';
			par=1;
			disp(' ');disp('Parameter ''p'' is set to 1 for this example.')
		elseif k1==3,
			cost='logenerg';
		elseif k1==4,
			cost='cmpnum';
			par=0.95;
			disp(' ');disp('Percentage of retained energy is set to 0.95 (95%) for this example.')
		elseif k1==5,
			cost='cmparea';
			par=2;
			disp(' ');disp('Exponent of the coefficients is set to 2 for this example.')
		elseif k1==6,
			cost='cwent';
		elseif k1==7,
			cost='weaklp';
			par=0.5;
			disp(' ');disp('Parameter ''p'' is set to 0.5 for this example.')
		else
			break
		end

		disp(' ')
		disp('% And now, select the basis search algorithm.')
		disp(' ')

		k2=menu('Search Algorithms','Pruning','Growth');

		disp(' ')
		disp('% Please, wait ...')
		disp(' ')

		x=zappa2;
		if flag==0              % additive
			if k2==1
				[basis,y,total]=pruneadd(x,d8h,d8g,cost,par);
			else
				[basis,y,total]=growadd(x,d8h,d8g,cost,par);
			end
		else                    % non-additive
			if k2==1
				[basis,y,total]=prunenon(x,d8h,d8g,cost,par);
			else
				[basis,y,total]=grownon(x,d8h,d8g,cost,par);
			end
		end

		disp(' ')
		disp(['% The selected basis uses ' int2str(length(basis)) ' elements of the wavelet packet library.'])
		disp(' ')

		disp(['% The cost of the original signal is ' num2str(feval(cost,x,par)) ' and'])
		disp(['% the cost of the signal transformed with the chosen basis is ' num2str(total) '.'])

		disp(' ')
		disp('% Figure 1 shows the wavelet packet coefficients')
		disp('% obtained according to your choices.')
		subplot(111); plot(y); title('Wavelet Packet coefficients')
		disp(' ')
		disp('% Press any key to continue ...')
		pause
		disp('%----------------------------------------------------------')

		k1=menu('Cost Functions','Shannon entropy','Energy with l^p norm','''log energy'' functional','Data compression number','Data compression area','Coifman-Wickerhauser entropy','Weak l^p norm','Continue demo');

	end % of while (k1~=8)

echo on

% We can easily compress the signal retaining only the biggest
% coefficients in the transformed signal, and then reconstruct.

% For example, consider again our audio signal and the last obtained
% wavelet packet coefficients.

	echo off
	n=input('Percentage of coefficients you want to retain (0-100): ');
	echo on

	[o,idx]=sort(abs(y).^2);
	idx=fliplr(idx);
	n=round(n/100*length(y));
	yc=zeros(1,length(y));
	yc(idx(1:n))=y(idx(1:n));
	rx=iwpk(yc,d8hr,d8gr,0,basis,length(x(1,:)));

	echo off
	set (1,'Position',[100,100,700,450])
	plot(x(1,:),'y')
	hold on;plot(rx,'r');hold off
	title('Yellow: original. Red: reconstructed after discarding smallest coefficients')
	xlabel(['Coefficients retained: ' int2str(n)])
	echo on

% Press any key to finish.
pause
%----------------------------------------------------------

echo off
close
