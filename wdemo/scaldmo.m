% SCALDMO   demo script on the scalogram.
%
%           SCALDMO is a demo script that illustrates the capabilities
%           of the scalogram function using the Morlet wavelet for
%           the signal analysis.
%
%           SCALDMO may be accessed from the WTDEMO command interactive
%           menu, choosing the 'Scalogram' demo section.

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

echo on;

%--------------------------------------------------------

% Let f(t) be a continous signal and F(a,b) its continous wavelet 
% transform. The representation of the modulus of the transform 
% (or its phase, if it is a complex signal) in the (b,a) open 
% half-plane is called a scalogram. The shift b is arbitrary and 
% the scale a is strictly positive (a>0).

% The most used prototype function for signal analysis is the 
% Morlet wavelet (a windowed complex exponential). The "morletw"
% function calculates this complex wavelet at any scale and
% sampled at the specified rate. Figure 1 shows its real and 
% imaginary part at scale 1 and a sampling rate of 400 Hz, and 
% taking the second as time unit.

	 [w,t]=morletw(400,1);
	 figure(1)
	 subplot(211); plot(t,real(w)); title('Real part')
	 subplot(212); plot(t,imag(w)); title('Imaginary part')

% Press any key to continue ...
pause
% --------------------------------------------------------
echo off
clear w
echo on

% The "scalog" function returns the scalogram of a finite length
% signal sampled at a certain rate. It uses the Morlet wavelet
% as the analyzing function. We have to set the minimum and
% maximum scale of the wavelet transform and the step between 
% them. Now, we will see some example signals and their corresponding 
% scalograms.

% In figure 1 you can see the first example signal: a rectangular 
% pulse which has been sampled at 8 kHz.

	 x=[zeros(1,362) ones(1,300) zeros(1,362)];
	 subplot(111); plot(x)

% Now we are going to compute its scalogram from scale 1 to 20, 
% with step 0.3:
	
	 figure(2)

% Please, wait ...

	 [sc,t,s]=scalog(x,8e3,1,20,0.3);  

    
% We can display the modulus of the transform with a 2-D plot, using 
% "show". The holes appearing in the scalogram are due to destructive 
% interference between the analyzing wavelets.

	 colormap('pink')
	 show(abs(sc),1,t,s); 
	 xlabel('Time'); ylabel('Scale')

% Press any key to continue ...
pause
%--------------------------------------------------------

% To obtain a 3-D plot we can use the "srf" function:

	 figure(3)
	 colormap('pink')
	 srf(abs(sc),5,5,t,s);             

% On the scalogram of a signal you can clearly detect abrupt changes 
% in it or in its derivatives. This is due to the good time localization 
% of the wavelet transform at low scales.

% You can observe this in the preceding example, where the start and the 
% end of the pulse are very sharp transitions. These changes lead to local 
% maxima in the modulus of the WT.
%
% You can see this clearly in figure 3. 
% When the scale grows, the analyzing wavelet dilates and then the
% scalogram focuses on long term details (the pulse itself).
	  
% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear s t sc
echo on

% You can set the time unit for Morlet wavelet at scale 1 or use the 
% default value, which is approximated according to the input sampling 
% rate. The effect of taking a shorter time unit is equivalent to decrease 
% the values of the employed scales. On the other hand, a longer time 
% unit corresponds to increase the scale (the prototype wavelet dilates).

% For our example signal, let us set the time unit to 0.5 ms (half the 
% default value of 1 ms):

% Please, wait ...

	 colormap('pink')
	 [sc,t,s]=scalog(x,8e3,1,20,0.3,0.5e-3); 
      
	 show(abs(sc),1,t,s)
	 xlabel('Time'); ylabel('Scale')

% As you can observe in the figure, the effect is similar to divide by 2 the
% scale values of the specified range (1 to 20).

% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear s t sc
echo on

% Now, setting the time unit to the double of the default value.

% Please, wait ...

	 [sc,t,s]=scalog(x,8e3,1,20,0.3,2e-3);
       
	 show(abs(sc),1,t,s)
	 xlabel('Time'); ylabel('Scale')

% It is equivalent to use higher scales in the analysis.  
	 
% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
close(2);close(3)
clear s t sc
echo on

% Now, we are going to calculate the scalogram for a finite signal 
% composed by two tones starting and finishing at different instants. 
% For example, let us take 80 and 240 Hz tones, sampled at 8 kHz:

	 x=[cos((2*pi*80/8000)*(0:723)) zeros(1,300)]+...
	 [zeros(1,400) cos((2*pi*240/8000)*(0:623))];
	 plot(x)

% The duration of the signal is 128 ms. The tone of lowest frequency 
% finishes 37.5 ms before the end of the signal and the other one 
% begins 50 ms later Figure 1 depicts this signal.

% Press any key to continue ...
pause
%--------------------------------------------------------
 
% We analyze the signal using the "scalog" function, with the scale ranging
% from 1 to 14 and a step of 0.1.

% Please, wait ...

	 figure(2); colormap('pink')
	 [sc,t,s]=scalog(x,8e3,1,14,0.1); 
      
	 show(abs(sc),1,t,s) 
	 xlabel('Time'); ylabel('Scale')                 

% Figure 2 shows its scalogram, where you can notice the presence of two
% parallel strips of constant scale, corresponding to each one of the tones. 
% Moreover, you can observe their points of start and end.

% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear s t sc
echo on

% In order to achieve a high temporal resolution, we calculate the transform
% at lower scales:

	 figure(3); colormap('pink')
	 [sc,t,s]=scalog(x,8e3,0.3,0.75,0.03); 
   
	 show(abs(sc),10,t,s)
	 xlabel('Time'); ylabel('Scale')           

% Figure 3 shows these 'zoomed' analysis of the signal.

% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear s t sc
close(2); close(3)
echo on

% Now, let us consider a a 'chirp' signal, as depicted in the figure. 
% The frequency grows linearly from 120 to 240 Hz, and the sampling 
% rate is 8000 Hz again.

	 w=(2*pi*120/8000)*(1+(0:1023)/512);
	 x=cos(w.*(0:1023)); plot(x)

% We calculate its scalogram for the scales from 1 to 10, with a step 0.1
% between them. You can see it in figure 2.

% Please, wait ...

	 figure(2); colormap('pink')
	 [sc,t,s]=scalog(x,8e3,1,10,0.1);  
       
	 show(abs(sc),1,t,s)                      
	 xlabel('Time'); ylabel('Scale')

% The linear growing of the frequency appears as a curve in the scalogram
% because of its proportionality to (1/a), where a is the scale.

% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear w s t sc
close(2)
echo on

% For the next example we are going to use a speech signal sampled at 8 kHz.

	 load speech1
	 figure(1); plot(x)

% As you can see in the figure, it is a voiced sound.
% Now, we display its scalogram for the scales ranging from 2 to 10, 
% with step 0.1.

% Please, wait ...

	 figure(2); colormap('pink')
	 [sc,t,s]=scalog(x,8e3,2,10,0.1);  
      
	 show(abs(sc),1,t,s)
	 xlabel('Time'); ylabel('Scale')                 

% The two strips of high value of the modulus reveal the presence of two of
% the formants of this voiced sound. Moreover, you can observe, at low scales,
% several vertical lines approximately equally spaced. They are due to the
% onset of the pitch periods.

% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear s t sc
echo on
					     
% We can obtain a closer view of this pitch lines in the scalogram using lower
% scales. Then, we are going to take a scale range from 0.3 to 1. In this way, 
% you can improve the time localization of the transform, as you can see in 
% figure 2.

% Please, wait ...

	 [sc,t,s]=scalog(x,8e3,0.3,1,0.0125);
       
	 colormap('pink')
	 show(abs(sc),1,t,s)                  
	 xlabel('Time'); ylabel('Scale')

% Together with the vertical lines of pitch, another formant of the signal
% appears in this scalogram.

% Press any key to continue ...
pause
%--------------------------------------------------------
echo off
clear w s t sc
close(2)
echo on

% Finally, let us consider another speech signal:

	 load speech2
	 plot(x)

% This signal contains the short attack of a 't', a vowel and a voiced
% consonant. Now, we calculate its transform and display the scalogram.

% Please, wait ...

	 figure(2); colormap('pink')
	 [sc,t,s]=scalog(x,8e3,0.4,7,0.1);  
     
	 show(abs(sc),1,t,s)     
	 xlabel('Time'); ylabel('Scale')

% You can see, at scales from 3 to 7, the effect of the 't', followed by
% the appearing of the formants and the vertical lines of the pitch. In
% the transition between the vowel and the voiced consonant, the formants lose
% some energy and change their frequency position.

% Press any key to finish ...
pause
%--------------------------------------------------------
echo off
clear s t sc
close(1); close(2)
