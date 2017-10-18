function varargout=satsliceplot(PVTSatFileName,OutputFileName,xyzE,az,el)
% varargout = satsliceplot(PVTSatFileName,OutputFileName,xyzE,az,el)
% 
% Creates plots for each hour on the hour of the satellite orbit slices
% (the geometric distance between the satellite and a fixed point xyzE 
% determines the radius of this circular slice). Exports each plot to
% a .pdf file. The user needs the 'timeconv' and 'gnss_datevec' functions
% from my 'PEI-2017' github repository. Additionally,
% the user needs the functions 'defval' and 'polecircle2'
% from Frederik J. Simons' slepian github repository. Lastly, you will
% need the 'earth_sphere' function to be able to plot a 3D Earth. 
%
% INPUT:
%
% PVTSatFileName     The PVTSatCartesian file returned from a bin2asc
%                     conversion of SBF files
% 
% FileName           The outputted filename (it will be a sequence of 24 
%                    files with this inputted string as the beginning)
%
% xyzE               The x,y,z cartesian coordinates of a location on Earth
% 
% az                 The 3D plot viewing azimuth
%
% el                 The 3D plot viewing elevation 
% 
% OUTPUT:
%
% 24 .pdf files that show the spherical slices of all visible satellites
% in the sky each hour on the hour. The spherical slice is made using the
% radius of the geometric distance (direct distance between a satellite and
% the xyzE point). The number of space vehicles (SVs) is stated in the
% bottom right corner of the outputted .pdf files. 
%
% EXAMPLE:
% Complete a bin2asc conversion on an SBF file to retrieve a
% PVTSatCartesianfile. Below is an example file
% returned when I converted a file pton1900.17_ from SBF to ASCII using
% bin2asc: 
% PVTSat = 'pton1900.17__SBF_PVTSatCartesian.txt';
% I have included this file in my github repository 'PEI2017-jtralie' for use and
% demo purposes. 
% 
% Last modified by jtralie@princeton.edu on 08/02/2017

% Initialize variables.
delimiter = ',';
formatSpec = '%f%f%f%C%f%f%f%f%f%f%f%f%f%f%C%[^\n\r]';
fileID = fopen(PVTSatFileName,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);

% Allocate imported array to column variable names
TOW = dataArray{:, 1};
WN = dataArray{:,2};
SVID = dataArray{:,4};
px = dataArray{:, 7}/1000; %convert positions to km
py = dataArray{:, 8}/1000;
pz = dataArray{:, 9}/1000;

% time conversion to determine plot title
gnss = timeconv(WN,TOW);
gnssdatevec = gnss_datevec(gnss);

% these are the default x,y,z coordinates for the fixed Guyot Hall receiver
% position
defval('xyzE',[1288.235740520786 -4694.422921315988 4107.355881768032])

defval('az',98) % default azimuth viewing angle
defval('el',4) % default elevation viewing angle 

rX=xyzE(1);rY=xyzE(2);rZ=xyzE(3);
% distance calculation
r = sqrt((px-rX).^2 + (py-rY).^2 + (pz-rZ).^2);

% values for polecircle
tdat = linspace(TOW(1),TOW(end)-3585,24);
for i=1:length(tdat)
    T = TOW == tdat(i);
    for j = 1:length(T)
        if T(j) == 1
            pxc(j) = px(j);
            pyc(j) = py(j);
            pzc(j) = pz(j);
            rc(j) = r(j);
            svidc(j) = SVID(j);
            xyzR(j,1) = pxc(j);
            xyzR(j,2) = pyc(j);
            xyzR(j,3) = pzc(j);
            xyzR(j,4) = rc(j);
        end
    end
end

%define the xyzR arrays for input to polecircle2
for i =1:length(tdat)
    in1 = find(pxc ~= 0,1,'first');
    in2 = find(pxc == 0,1,'first');
    if i == 24
        xyzRfinal{24} = xyzR(in1:end,:);
        svr{24} = svidc(in1:end);
        rfinal{24} = rc(in1:end);
    else
        xyzRfinal{i} = xyzR(in1:in2-1,:);
        svr{i} = svidc(in1:in2-1);
        rfinal{i} = rc(in1:in2-1);
    end
    pxc = pxc(:,in2:end);
    rc = rc(in2:end);
    svidc = svidc(in2:end);
    xyzR = xyzR(in2:end,:);
    in3 = find(pxc ~= 0,1,'first');
    xyzR = xyzR(in3:end,:);
    rc = rc(in3:end);
    svidc = svidc(in3:end);
    pxc = pxc(:,in3:end);
end

% pole circle plotting
h = figure;
for j = 1:length(tdat)
    Files = [OutputFileName,num2str(j)];
    xyzRfinal1 = xyzRfinal{j};
    earth_sphere
    hold on
    for i = 1:length(xyzRfinal1)
    polecircle2(xyzE,xyzRfinal1(i,:),[],[],[],6371,[])
    hold on
    end
    xlim([-4*10^4 4*10^4])
    ylim([-4.5*10^4 2*10^4])
    zlim([-2*10^4 4*10^4])
    view(az,el)
    text(0,1.5*10^4,-1*10^4,['# SV: ' num2str(length(xyzRfinal1))])
    title([num2str(gnssdatevec(1,2)) '/' num2str(gnssdatevec(1,3)) ' ' num2str(j-1) ' hr'])
    print(h,Files,'-dpdf','-fillpage','-r0')
    clf
end 
hold off
