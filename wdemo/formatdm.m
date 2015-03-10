%FORMATDM   demo script that describes the two possible 
%           formats when specifying a wavelet packet basis.
%
%           FORMATDM may be accessed from the WTDEMO command 
%           interactive menu, choosing the 'Basis Format' demo
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

% This is a demo about the two possible formats when
% specifying a wavelet packet basis.

% There are 2 possible options. In order to illustrate 
% the differences we are going to start defining
% an example filter bank structure:

%                         ______       
%                        |      
%                  ______|       ______  
%                 |      |      |
%                 |      |______|
%           ______|             |
%                 |             |______
%                 |
%                 |______

% (Upper branchs are highpass filterings, lower branchs are lowpass).

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's go with the first format ("natural order" in the literature).
 
% This option gives the basis ordered as the filter 
% bank scheme. The vector indicates the depth of every 
% terminal node in the tree.
% The vector elements always begin with the branch which
% performs the lowpass filter iteration.

% Then, the basis vector for the previous 
% example would be:
%                    basis=[1, 3, 3, 2]

% The wavelet packet coefficients obtained using such 
% format are ordered in the same way. 

% Press any key to continue ...
pause
%----------------------------------------------------------

% Let's make a signal composed by four tones:

	x1=cos((pi/4)*(0:1023));
	x2=cos((5*pi/8)*(0:1023));
	x3=cos((13*pi/16)*(0:1023));
	x4=cos((15*pi/16)*(0:1023));
	x=x1+x2+x3+x4;
	figure(1); plot(x)
	title('Example signal: 4 cosines')

% Then, we perform its direct transform with the previous
% basis values and format, and extract the coefficients
% for every filtering branch.

	load filtd16
	base=[1,3,3,2];
	y=wpk(x,h,g,0,base);

	aux=zeros(size(y));
	y1=insband(extband(y,base,1),aux,base,1);
	y2=insband(extband(y,base,2),aux,base,2);
	y3=insband(extband(y,base,3),aux,base,3);
	y4=insband(extband(y,base,4),aux,base,4);

% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, we perform the inverse transform of these subband
% coefficients. Figure 1 shows the spectra of their contributions.

	set (1,'Position',[100,100,550,825])
	rx1=iwpk(y1,rh,rg,0,base);
	[S1,w]=freqz(rx1,1,1024);
	subplot(411); plot(w,abs(S1).^2);
	title('For basis(1)');ylabel('dB') 

	rx2=iwpk(y2,rh,rg,0,base);
	[S2,w]=freqz(rx2,1,1024);
	subplot(412); plot(w,abs(S2).^2);
	title('For basis(2)');ylabel('dB') 

	rx3=iwpk(y3,rh,rg,0,base);
	[S3,w]=freqz(rx3,1,1024);
	subplot(413); plot(w,abs(S3).^2);
	title('For basis(3)');ylabel('dB')              

	rx4=iwpk(y4,rh,rg,0,base);
	[S4,w]=freqz(rx4,1,1024);
	subplot(414); plot(w,abs(S4).^2);
	title('For basis(4)');ylabel('dB'); xlabel('w'); 

% As you can observe in the figure, with this basis format
% the output subbands are not ordered in frequency.
 
% Press any key to continue ...
pause
%----------------------------------------------------------

% Therefore could be interesting a basis format that 
% provides the coefficients ordered in frequency.
% So, here we have the second format option.  
 
% This option is interesting because you can specify the
% parameter 'basis' in terms of a specific subband splitting. 
% So, you do not need to think about the filter bank structure
% that implement the desired frequency splitting. 

% Let's suppose we need to perform the following subband
% decomposition (that coincides with the one obtained by
% the filter bank proposed at the beginning of this demo):
 

%          |                |       |   |   |
%          |                |       |   |   |
%          |                |       |   |   |
%          |                |       |   |   |
%        -------------------------------------------> f
%          0               Fs/4            Fs/2 
 
% With this format, the 'basis' elements always begin with 
% the 'most' lowpass subband. 
% In this case, the vector elements will be:

%              basis=[1, 2, 3, 3]
 
% Think about this ... It is not trivial to know which is the
% filter bank structure that performs this subband decomposition.
% (And this is a simple case).
   
% Press any key to continue ...
pause
%----------------------------------------------------------

% Now, using this format of basis vector, we repeat the same
% steps for the example signal:
% Direct transform and extraction of the subband coefficients...

	base=[1,2,3,3];
	y=wpk(x,h,g,1,base);
	y1=insband(extband(y,base,1),aux,base,1);
	y2=insband(extband(y,base,2),aux,base,2);
	y3=insband(extband(y,base,3),aux,base,3);
	y4=insband(extband(y,base,4),aux,base,4);

% Inverse transform of them and plotting of spectra...

	rx1=iwpk(y1,rh,rg,1,base);
	[S1,w]=freqz(rx1,1,1024);
	figure(2); set (2,'Position',[200,100,550,825])
	subplot(411); plot(w,abs(S1).^2);
	title('For basis(1)');ylabel('dB')

	rx2=iwpk(y2,rh,rg,1,base);
	[S2,w]=freqz(rx2,1,1024);
	subplot(412); plot(w,abs(S2).^2);
	title('For basis(2)');ylabel('dB')

	rx3=iwpk(y3,rh,rg,1,base);
	[S3,w]=freqz(rx3,1,1024);
	subplot(413); plot(w,abs(S3).^2);
	title('For basis(3)');ylabel('dB')

	rx4=iwpk(y4,rh,rg,1,base);
	[S4,w]=freqz(rx4,1,1024);
	subplot(414); plot(w,abs(S4).^2);
	title('For basis(4)');ylabel('dB'); xlabel('w');

% As you can observe in figure 2, with this basis format
% the output subbands are frequency ordered.
 
% Press any key to continue ...
pause
%----------------------------------------------------------

% Using the function 'chformat' you can easily change from one
% basis format to the other one. Moreover, you can change the
% order of the output of the wpk function.
 
% In figure 2, we can observe as after applying 'chformat' to
% the basis that provides frequency order, the frequency responses
% coincides with the ones in figure 1.

	base=[1,2,3,3];
	base=chformat(base,1);
		  
	y=wpk(x,h,g,0,base);
	y1=insband(extband(y,base,1),aux,base,1);
	y2=insband(extband(y,base,2),aux,base,2);
	y3=insband(extband(y,base,3),aux,base,3);
	y4=insband(extband(y,base,4),aux,base,4);

	rx1=iwpk(y1,rh,rg,0,base);
	rx2=iwpk(y2,rh,rg,0,base);
	rx3=iwpk(y3,rh,rg,0,base);
	rx4=iwpk(y4,rh,rg,0,base);	

	echo off
	[S1,w]=freqz(rx1,1,1024);
	subplot(411); plot(w,abs(S1).^2);
	title('For basis(1)');ylabel('dB')

	[S2,w]=freqz(rx2,1,1024);
	subplot(412); plot(w,abs(S2).^2);
	title('For basis(2)');ylabel('dB')

	[S3,w]=freqz(rx3,1,1024);
	subplot(413); plot(w,abs(S3).^2);
	title('For basis(3)');ylabel('dB')

	[S4,w]=freqz(rx4,1,1024);
	subplot(414); plot(w,abs(S4).^2);
	title('For basis(4)');ylabel('dB'); xlabel('w');
	echo on
 
% Press any key to finish ...
pause
%----------------------------------------------------------

echo off
close(1), close(2)
