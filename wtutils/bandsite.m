function [x1,y1,x2,y2]=bandsite(a1,a2,a3,a4,a5)

%BANDSITE  Locates a subband into a wavelet transform.
%
%          [X1,Y1,X2,Y2] = BANDSITE (WT,K,Q,BT) calculates the 
%          top-left (X1,Y1) and bottom-right (X2,Y2) coordinates of
%          the wavelet band at scale Q, with band specification BT
%          (see below) from a wavelet transform WT which contains
%          K scales. The parameter Q must be less or equal to K, and
%          the BT parameter can be set to:
%               0 : Lowpass residue if Q=K. If Q<>K returns 
%		    the coords. of a non existing band.
%               1 : Horizontal high frequency band.
%               2 : Vertical high frequency band. 
%               3 : Diagonal high frequency band.
%
%          This function works with two dimensional 
%          wavelet transforms, but can be applied to one dimensional
%          resulting the Y coordinates equal to 1 for row wavelet 
%          transforms and the X coordinates for column ones.
%
%          BANDSITE will calculate the size of the bands the
%          largest as possible, unless the original signal size is
%          provided using BANDSITE (SIZX,SIZY,K,Q,BT).
%
%          NOTE: for user programming, the BANDSITE function will
%          return a -1 in X1 if any bad argument is given.
%
%          See also: BANDEXT, BANDINS, WT2D, WT.


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
%  Modified by: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


if nargin==5,
	tamx=a1-(a1==1);	% To agree with the result
	tamy=a2-(a2==1);	% given by 'maxrsize' if nargin~=5
	k=a3;
	q=a4;
	a=a5;
else
	[tamy,tamx]=size(a1);
	k=a2;
	q=a3;
	a=a4;
	tamy=maxrsize(tamy,k);
	tamx=maxrsize(tamx,k);
end

		% Select the band:
b=-1;
if a==0
	a=0;
	b=0;
end
if a==1
	a=0;
	b=1;
end
if a==2
	a=1;
	b=0;
end
if a==3
	a=1;
	b=1;
end


if (b==-1)|(q>k),		% Error in arguments.
	x1=-1;
	disp('Bad band or scale selection.')
	disp('        Q must be less than or equal to K (highest scale).')
	disp('        BT must be: 0 for the lowpass residue (Q=K)')
	disp('                    1 for any horizontal high frequency band')
	disp('			  2 for any vertical high frequency band')
	disp('			  3 for any diagonal high frequency band')
	return
end


lox(1)=tamx;
loy(1)=tamy;
for i=1:k
	lox(i+1)=floor((lox(i)+1)/2);
	loy(i+1)=floor((loy(i)+1)/2);
end
lox(k+2)=lox(k+1);
loy(k+2)=loy(k+1);

if b==1
	x1=sum(lox((q+2):(k+2)))+1;
else
	if q==k
		x1=1;
	else
		x1=2*sum(lox(q+2:k+1))-sum(lox(q+1:k))+1;
	end
end	
x2=lox(q+1)+x1-1;
if a==1
	y1=sum(loy((q+2):(k+2)))+1;
else
	if q==k
		y1=1;
	else
		y1=2*sum(loy(q+2:k+1))-sum(loy(q+1:k))+1;
	end
end
y2=loy(q+1)+y1-1;


 	% CHECKS FOR THE 1D CASE :
if y2==0,	
	y2=1;
end
if x2==0,	
	x2=1;
end
