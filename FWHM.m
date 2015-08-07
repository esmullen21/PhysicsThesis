clear all;
clear memory;
clc;
%clears memory and screen

dir_im=uigetdir('C:','Select image directory');
%gets directory that contains images of interest

cd(dir_im);
%changes current directory to the directory of interest

noofimages = dir('*.tif');
noofimages = numel(noofimages);
%gets number of image files in folder

disp(' ');
disp('Select first image in folder for calibration.');

[FileName,PathName] = uigetfile('*.tif','Select first image in folder for calibration');
clc;

disp(' ');
disp('Select fifth image in folder for calibration.');

[FileName2,PathName2] = uigetfile('*.tif','Select fifth image in folder for calibration');
clc;

Im = imread(FileName);
imshow(Im);
%Reads the first image in the folder and displays it on screen

h=imdistline;
api=iptgetapi(h);
disp(' ');
disp('Place the bar over the depth line along the right hand side of the image');
dist_pixel=api.getDistance();
dist_mm=input('enter the distance in mm: ');
pixels_per_mm=dist_mm./dist_pixel;


[x,y] = ginput(2);
disp(' ');
disp('Select a point above the filament, and one in a straight line below.');
line(x,y);

%Calibration ends, loop begins
FirstNamePart = double(FileName);
FileName2 = double(FileName2);
e = numel(FirstNamePart);
f = numel(FileName2);
%Finds the length of the first image file name, and the second image file
%name. 
 
j=1;
m = 1;

if (FirstNamePart(end-4) == 48)
   
    noofimages = noofimages - 1;
    k = 0;
    
else
    
    k = 1;

end

for j=k:noofimages
  
    if (e == 5)
   
        ImName = sprintf('%d.tif',k);
        %If the first image file name is 5 characters long, then it is
        %assumed that the files are numbered as 1.tif, 2.tif, 3.tif, etc. 
        %Assigns 1.tif, 2.tif etc to ImName as the for loop continues. 
    
    elseif (f > e)
        
        EndNamePart = sprintf('%d.tif',k);
        EndNamePart = double(EndNamePart);  
        
            
        FirstPart = FirstNamePart(1:end-5);
        FirstPart = horzcat(FirstPart, EndNamePart);
        ImName = char(FirstPart);
        %If the tenth image file name has more characters than the first
        %image file name, it is assumed the files are numbered in the following style;
        %im1.tif, im2.tif... im10.tif, im11.tif, etc. 
        %The beginning of the filename is read and saved as FirstNamePart. 
        %FirstNamePart is combined with EndNamePart to form the full image
        %file name. 
        %Assigns im1.tif, im2.tif... im10.tif etc to ImName as for loop continues
        
    else
    %else, assumes files are numbered in the following style; 
    %im0001.tif, im0002.tif, im0003.tif... im0010.tif, im0011.tif, im0012.tif, etc. 
        
    EndNamePart = sprintf('%d.tif',k);
    
    EndNamePart = double(EndNamePart);
    b = numel(EndNamePart);
    
        if (b == 5)
        
            FirstNamePart(end-4:end) = EndNamePart;
        
        elseif (b == 6)
        
            FirstNamePart(end-5:end) = EndNamePart;
        
        elseif (b == 7)
        
            FirstNamePart (end-6:end) = EndNamePart;
    
        end
        %Assembles next file name to be read according to style described
        %on line 238
        
    ImName = char(FirstNamePart);
    end
    
    Im = imread(ImName);
    

R = Im(:, :, 1);
G = Im(:, :, 2);
B = Im(:, :, 3);

improfile(R, x, y);
r=improfile(R, x, y);

n = numel(r);
d=n*pixels_per_mm;
t=linspace(0, d, n);
v=t';

w=max(r);

array_w(m,1,:)=w;


[Peaklist, PFWHH] = mspeaks(v, r);



if numel(PFWHH)==0
    FWHM=0;
    array_a=0;
    array_b=0;
else
    a = PFWHH(1);
    b = PFWHH(2);
    FWHM=b-a;
    
    array_a(m,1,:)=a;
    array_b(m,1,:)=b;
end
 array_f(m,1,:)=FWHM;
 
  improfile(G, x, y);
g=improfile(G, x, y);

n = numel(g);
d=n*pixels_per_mm;
t=linspace(0, d, n);
v=t';

z=max(g);

array_z(m,1,:)=z;

[Peaklist, PFWHH] = mspeaks(v, g);



if numel(PFWHH)==0
    gFWHM=0;
    array_c=0;
    array_d=0;
else
    a = PFWHH(1);
    b = PFWHH(2);
    gFWHM=b-a;
    
    array_c(m,1,:)=a;
    array_d(m,1,:)=b;
end
 array_g(m,1,:)=gFWHM;
 
  improfile(B, x, y);
p=improfile(B, x, y);

n = numel(p);
d=n*pixels_per_mm;
t=linspace(0, d, n);
v=t';

l=max(p);

array_l(m,1,:)=l;

[Peaklist, PFWHH] = mspeaks(v, p);



if numel(PFWHH)==0
    bFWHM=0;
    array_k=0;
    array_s=0;
else
    a = PFWHH(1);
    b = PFWHH(2);
    bFWHM=b-a;

array_k(m,1,:)=a;
array_s(m,1,:)=b;
end
 
 array_t(m,1,:)=bFWHM;

 k = k+1;
 m = m+1;
end

filename = {'Image 1'};
xlswrite('Results.xls', filename,'sheet1','A2')
filename = {'Image 2'};
xlswrite('Results.xls', filename,'sheet1','A3')
filename = {'Image 3'};
xlswrite('Results.xls', filename,'sheet1','A4')
filename = {'Image 4'};
xlswrite('Results.xls', filename,'sheet1','A5')
filename = {'Image 5'};
xlswrite('Results.xls', filename,'sheet1','A6')

 filename = {'Max(Red)'};
xlswrite('Results.xls', filename,'sheet1','B1')
xlswrite('Results.xls', array_w,'sheet1','B2:B6');

filename = {'Max(Green)'};
xlswrite('Results.xls', filename,'sheet1','C1')
xlswrite('Results.xls', array_z,'sheet1','C2:C6');

filename = {'Max(Blue)'};
xlswrite('Results.xls', filename,'sheet1','D1')
xlswrite('Results.xls', array_l,'sheet1','D2:D6');


filename = {'X1(Red)'};
xlswrite('Results.xls', filename,'sheet1','F1')
xlswrite('Results.xls', array_a,'sheet1','F2:F6');

filename = {'X1(Green)'};
xlswrite('Results.xls', filename,'sheet1','G1')
xlswrite('Results.xls', array_c,'sheet1','G2:G6');

filename = {'X1(Blue)'};
xlswrite('Results.xls', filename,'sheet1','H1')
xlswrite('Results.xls', array_k,'sheet1','H2:H6');


filename = {'X2(Red)'};
xlswrite('Results.xls', filename,'sheet1','J1')
xlswrite('Results.xls', array_b,'sheet1','J2:J6');

filename = {'X2(Green)'};
xlswrite('Results.xls', filename,'sheet1','K1')
xlswrite('Results.xls', array_d,'sheet1','K2:K6');

filename = {'X2(Blue)'};
xlswrite('Results.xls', filename,'sheet1','L1')
xlswrite('Results.xls', array_s,'sheet1','L2:L6');

filename = {'FWHM(Red)'};
xlswrite('Results.xls', filename,'sheet1','N1')
xlswrite('Results.xls', array_f,'sheet1','N2:N6');

filename = {'FWHM(Green)'};
xlswrite('Results.xls', filename,'sheet1','O1')
xlswrite('Results.xls', array_g,'sheet1','O2:O6');

filename = {'FWHM(Blue)'};
xlswrite('Results.xls', filename,'sheet1','P1')
xlswrite('Results.xls', array_t,'sheet1','P2:P6');