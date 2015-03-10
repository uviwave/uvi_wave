% GNIMGDMO  Demo on test images generation.
%
%           GNIMGDMO is a demo menu that shows the 
%           different type of images that the GENIMG 
%           function can create.
%
%           GNIMGDMO may be accessed from the WTDEMO 
%           command interactive menu, choosing the 
%           'Image Generation' demo section. 

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

echo on
figure(1);
%---------------------------------------------------------

% The GENIMG function gives some images which can be
% used to test the 2D Wavelet transform properties.

% Now let's see a representative group. 
% Choose from the menu.

echo off
m=0;
while m~=13,
m=menu('Genimg Images','0 - Square test','1 - Sharp wavy','2 - Diagonal','3 - Horizon','4 - Square filled','5 - Growing squares','6 - Dust among bars','7 - Wavy diagonals','8 - Round wavy 1','9 - Round wavy 2','10- Multiple square','11- All of them','12- Quit genimg demo');

if m==12,
	set(1,'Position',[100 100 900 300]);
	fprintf(1,'Wait, please ... [----------]\b\b\b\b\b\b\b\b\b\b\b');
	for i=1:10,
		r=genimg(i,128,128);
		subplot(2,5,i);
		show(r);
		axis off;
		if i<10
			xlabel(['TYPE ',setstr(i+48)]);
		else
			xlabel('TYPE 10');
		end
		fprintf(1,'#');
	end
	colormap(pink);
	fprintf(1,'\b\b\b\b\b\b\b\b\b\b*COMPLETE*]\n');
end

if m<12
	fprintf(1,'Wait, please...');
	r=genimg(m-1,128,128);
	set(1,'Position',[100 100 400 400]);
	subplot
	show(r)
	colormap(pink)
	axis off
	if m<10
		xlabel(['TYPE ',setstr(m+48)]);
	else
		xlabel('TYPE 10');
	end
	fprintf(1,' Done.\n');
end

end
echo off
close(1)



