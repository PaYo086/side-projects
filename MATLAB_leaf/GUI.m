function GUI(action)

if nargin < 1
    action = 'start';
end
    
global handle
global data

% 1. start
% 2. open
% 3. trunk
% 4. leaf
% 5. sky
% 6. result

%↓------------------------------↓start↓------------------------------↓
if strcmp(action, 'start')
%------↓bohan function↓------
    r=1600;
    for i=1:90
        b(i)=r*(cos((i/180)*pi));
        c(i)=r-b(i);
        d(i)=r*(sin((i/180)*pi));
        e(i)=(c(i)^2+d(i)^2)^(1/2);
        if i>=2
        f(i)=e(i)-e(i-1);
        end
    end
    for i=1:9
        data.g(i)=f(i*10);%度數(1~10,...)
        data.h(i)=b(i*10);%(圓圈半徑,半徑以外成以上面數字)
    end
%------↑bohan function↑------
%------↓setting↓------
    handle.openc = 0;
    handle.a_trunk = 50;
    handle.b_trunk = 0;
    handle.a_leaf = 120;
    handle.b_leaf = 3;
    handle.a_sky = 230;
%     clf reset;
%     axis('off')
    gcfPos =[0.025 0.18 0.75 0.75];
    handle.mainfig = figure('Units','normalized',...
        'NumberTitle','off','menubar','none',...
        'Name','GUI',...
        'Position',gcfPos);
%     h = actxserver('WScript.Shell');
%     figure(gcf); 
%     h.SendKeys('% '); %this is shortcut key ALT + {SPACE} 
%     h.SendKeys('{DOWN 4}'); 
%     h.SendKeys('~'); %This is enter
    
    filePos1=[.066 0.95 0.35 0.04];
    
    handle.open = uicontrol('Parent',handle.mainfig,'Units','normalized',...
        'Style','Pushbutton',...
        'Position',[0.005 0.95 0.06 0.04],...
        'Callback','GUI(''open'')',...
        'String','Open');
    
    handle.file_name = uicontrol('Parent',handle.mainfig,'Units','normalized',...
        'Style','edit',...
        'BackgroundColor','white',...
        'ForegroundColor','black',...
        'Position',filePos1,...
        'HorizontalAlignment','left');
    
    handle.leftpan = uipanel('Parent',handle.mainfig,'Title','original picture',...
        'FontSize',12,'Position',[0.005 0.005 0.4905 0.945]);
    
    handle.color_trunk = uicontrol('Parent',handle.leftpan,'Units','normalized',...
        'Style','Pushbutton',...
        'Position',[0.05 0.25 0.08 0.05],...
        'Callback','GUI(''trunk'')',...
        'String','Trunk');
    
    handle.color_leaf = uicontrol('Parent',handle.leftpan,'Units','normalized',...
        'Style','Pushbutton',...
        'Position',[0.135 0.25 0.08 0.05],...
        'Callback','GUI(''leaf'')',...
        'String','Leaf');
    
    handle.color_sky = uicontrol('Parent',handle.leftpan,'Units','normalized',...
        'Style','Pushbutton',...
        'Position',[0.220 0.25 0.08 0.05],...
        'Callback','GUI(''sky'')',...
        'String','Sky');
    
    handle.color_result1 = uicontrol('Parent',handle.leftpan,'Units','normalized',...
        'Style','Pushbutton',...
        'Position',[0.305 0.25 0.08 0.05],...
        'Callback','GUI(''result1'')',...
        'String','Result1');
    
    handle.color_result2 = uicontrol('Parent',handle.leftpan,'Units','normalized',...
        'Style','Pushbutton',...
        'Position',[0.390 0.25 0.08 0.05],...
        'Callback','GUI(''result2'')',...
        'String','Result2');

    handle.rightpan = uipanel('Parent',handle.mainfig,'Title','working',...
        'FontSize',12,'Position',[0.505 0.005 0.4905 0.945]);
%↑------------------------------↑start↑------------------------------↑

%↓------------------------------↓open↓------------------------------↓
elseif strcmp(action, 'open')
    if handle.openc ~= 0
        cla(handle.opicp)
    end
    handle.openc = 0;
    [infile,inpath] = uigetfile('*.*','Open Data File');
    if (infile ~= 0)
        File = [inpath infile];
        handle.opic = imread(File);
        handle.red = handle.opic(:,:,1); % Red channel
        handle.green = handle.opic(:,:,2); % Green channel
        handle.blue = handle.opic(:,:,3); % Blue channel
        handle.a = length(handle.red(:,1));
        handle.b = length(handle.red(1,:));
        handle.opicp = axes('Parent',handle.leftpan,'Units','normalized',...
            'Position',[0.01 0.2 0.96 0.96]);
        axes(handle.opicp); handle.image = image(handle.opic); axis equal; axis off; box off;
        handle.openc = handle.openc + 1;
    end
    set(handle.file_name,'String',File);
%↑------------------------------↑open↑------------------------------↑
    
%↓------------------------------↓trunk↓------------------------------↓
%                -----open----
elseif strcmp(action, 'trunk')
    handle.rightpan = uipanel('Parent',handle.mainfig,'Title','Trunk',...
        'FontSize',12,'Position',[0.505 0.005 0.4905 0.945]);
    handle.slider1_trunk = uicontrol('Parent', handle.rightpan,'Units','normalized',...
        'Style','slider',...
        'Min', 0, 'Max', 200, 'SliderStep', [0.05 0.05], 'Value', handle.a_trunk, ...
        'Position',[0.05 0.2 0.9 0.075],...
        'callback','GUI(''slider1_trunk'')'); 
	handle.slider2_trunk = uicontrol('Parent', handle.rightpan,'Units','normalized',...
        'Style','slider',...
        'Min', -5, 'Max', 5, 'SliderStep', [0.05 0.05], 'Value', handle.b_trunk, ...
        'Position',[0.05 0.1 0.9 0.075],...
        'callback','GUI(''slider2_trunk'')');
    
    a = handle.a_trunk;
    b = handle.b_trunk;
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) < a ...
                        && red(j,i)-green(j,i) > b
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_trunk(:,:,1) = red;
    data.opic_trunk(:,:,2) = green;
    data.opic_trunk(:,:,3) = blue;
    handle.opicp_trunk = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_trunk); handle.image_trunk = image(data.opic_trunk); axis equal; axis off; box off;
%                -----open----
%                -----trunk_slider1----
elseif strcmp(action, 'slider1_trunk')
    handle.a_trunk = get(handle.slider1_trunk, 'value');
    handle.b_trunk = get(handle.slider2_trunk, 'value');
    a = handle.a_trunk;
    b = handle.b_trunk;
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) < a ...
                        && red(j,i)-green(j,i) > b
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_trunk(:,:,1) = red;
    data.opic_trunk(:,:,2) = green;
    data.opic_trunk(:,:,3) = blue;
    handle.opicp_trunk = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_trunk); handle.image_trunk = image(data.opic_trunk); axis equal; axis off; box off;
%                -----trunk_slider1----
%                -----trunk_slider2----
elseif strcmp(action, 'slider2_trunk')
    handle.a_trunk = get(handle.slider1_trunk, 'value');
    handle.b_trunk = get(handle.slider2_trunk, 'value');
    a = handle.a_trunk;
    b = handle.b_trunk;
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) < a ...
                        && red(j,i)-green(j,i) > b
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_trunk(:,:,1) = red;
    data.opic_trunk(:,:,2) = green;
    data.opic_trunk(:,:,3) = blue;
    handle.opicp_trunk = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_trunk); handle.image_trunk = image(data.opic_trunk); axis equal; axis off; box off;
%                -----trunk_slider2----
%↑------------------------------↑trunl↑------------------------------↑

%↓------------------------------↓leaf↓------------------------------↓
%                -----open----
elseif strcmp(action, 'leaf')
    handle.rightpan = uipanel('Parent',handle.mainfig,'Title','Leaf',...
        'FontSize',12,'Position',[0.505 0.005 0.4905 0.945]);
    handle.slider1_leaf = uicontrol('Parent', handle.rightpan,'Units','normalized',...
        'Style','slider',...
        'Min', 0, 'Max', 200, 'SliderStep', [0.05 0.05], 'Value', handle.a_leaf, ...
        'Position',[0.05 0.2 0.9 0.075],...
        'callback','GUI(''slider1_leaf'')'); 
	handle.slider2_leaf = uicontrol('Parent', handle.rightpan,'Units','normalized',...
        'Style','slider',...
        'Min', -3, 'Max', 10, 'SliderStep', [0.05 0.05], 'Value', handle.b_leaf, ...
        'Position',[0.05 0.1 0.9 0.075],...
        'callback','GUI(''slider2_leaf'')');
    
    a = get(handle.slider1_leaf, 'value');
    b = get(handle.slider2_leaf, 'value');
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) < a && green(j,i)-red(j,i) > b
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_leaf(:,:,1) = red;
    data.opic_leaf(:,:,2) = green;
    data.opic_leaf(:,:,3) = blue;
    handle.opicp_leaf = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_leaf); handle.image_leaf = image(data.opic_leaf); axis equal; axis off; box off;
%                -----open----
%                -----leaf_slider1----
elseif strcmp(action, 'slider1_leaf')
    handle.a_leaf = get(handle.slider1_leaf, 'value');
    handle.b_leaf = get(handle.slider2_leaf, 'value');
    a = handle.a_leaf;
    b = handle.b_leaf;
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) < a && green(j,i)-red(j,i) > b
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_leaf(:,:,1) = red;
    data.opic_leaf(:,:,2) = green;
    data.opic_leaf(:,:,3) = blue;
    handle.opicp_leaf = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_leaf); handle.image_leaf = image(data.opic_leaf); axis equal; axis off; box off;
%               -----leaf_slider1----
%               -----leaf_slider2----
elseif strcmp(action, 'slider2_leaf')
    handle.a_leaf = get(handle.slider1_leaf, 'value');
    handle.b_leaf = get(handle.slider2_leaf, 'value');
    a = handle.a_leaf;
    b = handle.b_leaf;
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) < a && green(j,i)-red(j,i) > b
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_leaf(:,:,1) = red;
    data.opic_leaf(:,:,2) = green;
    data.opic_leaf(:,:,3) = blue;
    handle.opicp_leaf = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_leaf); handle.image_leaf = image(data.opic_leaf); axis equal; axis off; box off;
%                -----leaf_slider2----
%↑------------------------------↑leaf↑------------------------------↑

%↓------------------------------↓sky↓------------------------------↓
%                -----open----
elseif strcmp(action, 'sky')
    handle.rightpan = uipanel('Parent',handle.mainfig,'Title','Sky',...
        'FontSize',12,'Position',[0.505 0.005 0.4905 0.945]);
    handle.slider1_sky = uicontrol('Parent', handle.rightpan,'Units','normalized',...
        'Style','slider',...
        'Min', 150, 'Max', 255, 'SliderStep', [0.05 0.05], 'Value', handle.a_sky, ...
        'Position',[0.05 0.2 0.9 0.075],...
        'callback','GUI(''slider1_sky'')'); 
    
    a = get(handle.slider1_sky, 'value');
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) >= a
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_sky(:,:,1) = red;
    data.opic_sky(:,:,2) = green;
    data.opic_sky(:,:,3) = blue;
    handle.opicp_sky = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_sky); handle.image_sky = image(data.opic_sky); axis equal; axis off; box off;
%                -----open----
%                -----leaf_slider1----
elseif strcmp(action, 'slider1_sky')
    handle.a_sky = get(handle.slider1_sky, 'value');
    a = handle.a_sky;
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    gray = rgb2gray(handle.opic);
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600
                if gray(j,i) >= a
                    red(j,i) = 255; green(j,i) = 0; blue(j,i) = 0;
                end
            else
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
        end
    end
    data.opic_sky(:,:,1) = red;
    data.opic_sky(:,:,2) = green;
    data.opic_sky(:,:,3) = blue;
    handle.opicp_sky = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_sky); handle.image_sky = image(data.opic_sky); axis equal; axis off; box off;
%                -----leaf_slider1----
%↑------------------------------↑sky↑------------------------------↑

%↓------------------------------↓result1↓------------------------------↓
% sky > leaf > trunk
elseif strcmp(action, 'result1')
    handle.rightpan = uipanel('Parent',handle.mainfig,'Title','Result1',...
        'FontSize',12,'Position',[0.505 0.005 0.4905 0.945]);
    
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    sky_r = data.opic_sky(:,:,1);
    sky_g = data.opic_sky(:,:,2);
    sky_b = data.opic_sky(:,:,3);
    leaf_r = data.opic_leaf(:,:,1);
    leaf_g = data.opic_leaf(:,:,2);
    leaf_b = data.opic_leaf(:,:,3);
    trunk = data.opic_trunk;
    skyc = 0;
    leafc = 0;
    trunkc = 0;
    total = 0;
    skyc_c = 0;
    leafc_c = 0;
    trunkc_c = 0;
    total_c = 0;
    g = data.g;
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600 && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(1)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(1);
                    total_c = total_c + g(1);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(1);
                    total_c = total_c + g(1);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(1);
                    total_c = total_c + g(1);
                end
            elseif ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) > 1600
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(1) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(2)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(2);
                    total_c = total_c + g(2);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(2);
                    total_c = total_c + g(2);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(2);
                    total_c = total_c + g(2);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(2) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(3)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(3);
                    total_c = total_c + g(3);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(3);
                    total_c = total_c + g(3);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(3);
                    total_c = total_c + g(3);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(3) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(4)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(4);
                    total_c = total_c + g(4);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(4);
                    total_c = total_c + g(4);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(4);
                    total_c = total_c + g(4);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(4) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(5)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(5);
                    total_c = total_c + g(5);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(5);
                    total_c = total_c + g(5);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(5);
                    total_c = total_c + g(5);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(5) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(6)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(6);
                    total_c = total_c + g(6);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(6);
                    total_c = total_c + g(6);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(6);
                    total_c = total_c + g(6);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(6) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(7)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(7);
                    total_c = total_c + g(7);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(7);
                    total_c = total_c + g(7);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(7);
                    total_c = total_c + g(7);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(7) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(8)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(8);
                    total_c = total_c + g(8);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(8);
                    total_c = total_c + g(8);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(8);
                    total_c = total_c + g(8);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(8)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(9);
                    total_c = total_c + g(9);
                elseif leaf_r(j,i) == 255 && leaf_g(j,i) == 0 && leaf_b(j,i) == 0
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(9);
                    total_c = total_c + g(9);
                else
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(9);
                    total_c = total_c + g(9);
                end
            end
        end
    end
    data.opic_result1(:,:,1) = red;
    data.opic_result1(:,:,2) = green;
    data.opic_result1(:,:,3) = blue;
    handle.opicp_result1 = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_result1); handle.image_result1 = image(data.opic_result1); axis equal; axis off; box off;
    
    pixelsky = ['pixels of sky: ' num2str(skyc)];
    pixelleaf = ['pixels of leaf: ' num2str(leafc)];
    pixeltrunk = ['pixels of trunk: ' num2str(trunkc)];
    pixeltotal = ['total pixels: ' num2str(total)];
    handle.text_result1_sky = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixelsky,'FontSize',12,'Position', [0.05 0.25 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_leaf = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixelleaf,'FontSize',12,'Position', [0.55 0.25 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_trunk = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixeltrunk,'FontSize',12,'Position', [0.05 0.2 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_total = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixeltotal,'FontSize',12,'Position', [0.55 0.2 0.6 0.1],'HorizontalAlignment','left');

    o_sky_total = skyc/total*100;
    o_leaf_total = leafc/total*100;
    o_trunk_total = trunkc/total*100;
    c_sky_total = skyc_c/total_c*100;
    c_leaf_total = leafc_c/total_c*100;
    c_trunk_total = trunkc_c/total_c*100;
    o_sky = ['ratio of sky: ' num2str(o_sky_total) '%'];
    o_leaf = ['ratio of leaf: ' num2str(o_leaf_total) '%'];
    o_trunk = ['ratio of trunk: ' num2str(o_trunk_total) '%'];
    c_sky = ['ratio of sky: ' num2str(c_sky_total) '%'];
    c_leaf = ['ratio of leaf: ' num2str(c_leaf_total) '%'];
    c_trunk = ['ratio of trunk: ' num2str(c_trunk_total) '%'];
    handle.text_result1_o_ratio = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', 'Origin ratio:','FontSize',12,'Position', [0.05 0.15 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_o_sky = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', o_sky,'FontSize',12,'Position', [0.05 0.1 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_o_leaf = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', o_leaf,'FontSize',12,'Position', [0.35 0.1 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_o_trunk = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', o_trunk,'FontSize',12,'Position', [0.65 0.1 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_ratio = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', 'Modified ratio:','FontSize',12,'Position', [0.05 0.05 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_sky = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', c_sky,'FontSize',12,'Position', [0.05 0 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_leaf = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', c_leaf,'FontSize',12,'Position', [0.35 0 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_trunk = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', c_trunk,'FontSize',12,'Position', [0.65 0 0.6 0.1],'HorizontalAlignment','left');
%↑------------------------------↑result1↑------------------------------↑

%↓------------------------------↓result2↓------------------------------↓
% sky > trunk > leaf
elseif strcmp(action, 'result2')
    handle.rightpan = uipanel('Parent',handle.mainfig,'Title','Result2',...
        'FontSize',12,'Position',[0.505 0.005 0.4905 0.945]);
    
    red = handle.red;
    green = handle.green;
    blue = handle.blue;
    sky_r = data.opic_sky(:,:,1);
    sky_g = data.opic_sky(:,:,2);
    sky_b = data.opic_sky(:,:,3);
    trunk_r = data.opic_trunk(:,:,1);
    trunk_g = data.opic_trunk(:,:,2);
    trunk_b = data.opic_trunk(:,:,3);
    leaf = data.opic_leaf;
    skyc = 0;
    leafc = 0;
    trunkc = 0;
    total = 0;
    skyc_c = 0;
    leafc_c = 0;
    trunkc_c = 0;
    total_c = 0;
    g = data.g;
    for i = 1:length(red(1,:))
        for j = 1:length(red(:,1))
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= 1600 && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(1)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(1);
                    total_c = total_c + g(1);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(1);
                    total_c = total_c + g(1);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(1);
                    total_c = total_c + g(1);
                end
            elseif ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) > 1600
                red(j,i) = 0; green(j,i) = 0; blue(j,i) = 0;
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(1) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(2)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(2);
                    total_c = total_c + g(2);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(2);
                    total_c = total_c + g(2);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(2);
                    total_c = total_c + g(2);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(2) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(3)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(3);
                    total_c = total_c + g(3);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(3);
                    total_c = total_c + g(3);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(3);
                    total_c = total_c + g(3);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(3) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(4)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(4);
                    total_c = total_c + g(4);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(4);
                    total_c = total_c + g(4);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(4);
                    total_c = total_c + g(4);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(4) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(5)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(5);
                    total_c = total_c + g(5);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(5);
                    total_c = total_c + g(5);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(5);
                    total_c = total_c + g(5);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(5) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(6)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(6);
                    total_c = total_c + g(6);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(6);
                    total_c = total_c + g(6);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(6);
                    total_c = total_c + g(6);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(6) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(7)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(7);
                    total_c = total_c + g(7);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(7);
                    total_c = total_c + g(7);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(7);
                    total_c = total_c + g(7);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(7) && ...
                    ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) >= data.h(8)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(8);
                    total_c = total_c + g(8);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(8);
                    total_c = total_c + g(8);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(8);
                    total_c = total_c + g(8);
                end
            end
            if ((abs(3000-i))^2 + (abs(2000-j))^2)^(1/2) <= data.h(8)
                if  sky_r(j,i) == 255 && sky_g(j,i) == 0 && sky_b(j,i) == 0
                    red(j,i) = 255; green(j,i) = 255; blue(j,i) = 255;
                    skyc = skyc + 1;
                    total = total + 1;
                    skyc_c = skyc_c + g(9);
                    total_c = total_c + g(9);
                elseif trunk_r(j,i) == 255 && trunk_g(j,i) == 0 && trunk_b(j,i) == 0
                    red(j,i) = 50; green(j,i) = 45; blue(j,i) = 23;
                    trunkc = trunkc + 1;
                    total = total + 1;
                    trunkc_c = trunkc_c + g(9);
                    total_c = total_c + g(9);
                else
                    red(j,i) = 126; green(j,i) = 144; blue(j,i) = 45;
                    leafc = leafc + 1;
                    total = total + 1;
                    leafc_c = leafc_c + g(9);
                    total_c = total_c + g(9);
                end
            end
        end
    end
    data.opic_result2(:,:,1) = red;
    data.opic_result2(:,:,2) = green;
    data.opic_result2(:,:,3) = blue;
    handle.opicp_result2 = axes('Parent',handle.rightpan,'Units','normalized',...
        'Position',[0.01 0.2 0.96 0.96]);
    axes(handle.opicp_result2); handle.image_result2 = image(data.opic_result2); axis equal; axis off; box off;
    
    pixelsky = ['pixels of sky: ' num2str(skyc)];
    pixelleaf = ['pixels of leaf: ' num2str(leafc)];
    pixeltrunk = ['pixels of trunk: ' num2str(trunkc)];
    pixeltotal = ['total pixels: ' num2str(total)];
    handle.text_result1_sky = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixelsky,'FontSize',12,'Position', [0.05 0.25 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_leaf = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixelleaf,'FontSize',12,'Position', [0.55 0.25 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_trunk = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixeltrunk,'FontSize',12,'Position', [0.05 0.2 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_total = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', pixeltotal,'FontSize',12,'Position', [0.55 0.2 0.6 0.1],'HorizontalAlignment','left');
    
    o_sky_total = skyc/total*100;
    o_leaf_total = leafc/total*100;
    o_trunk_total = trunkc/total*100;
    c_sky_total = skyc_c/total_c*100;
    c_leaf_total = leafc_c/total_c*100;
    c_trunk_total = trunkc_c/total_c*100;
    o_sky = ['ratio of sky: ' num2str(o_sky_total) '%'];
    o_leaf = ['ratio of leaf: ' num2str(o_leaf_total) '%'];
    o_trunk = ['ratio of trunk: ' num2str(o_trunk_total) '%'];
    c_sky = ['ratio of sky: ' num2str(c_sky_total) '%'];
    c_leaf = ['ratio of leaf: ' num2str(c_leaf_total) '%'];
    c_trunk = ['ratio of trunk: ' num2str(c_trunk_total) '%'];
    handle.text_result1_o_ratio = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', 'Origin ratio:','FontSize',12,'Position', [0.05 0.15 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_o_sky = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', o_sky,'FontSize',12,'Position', [0.05 0.1 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_o_leaf = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', o_leaf,'FontSize',12,'Position', [0.35 0.1 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_o_trunk = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', o_trunk,'FontSize',12,'Position', [0.65 0.1 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_ratio = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', 'Modified ratio:','FontSize',12,'Position', [0.05 0.05 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_sky = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', c_sky,'FontSize',12,'Position', [0.05 0 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_leaf = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', c_leaf,'FontSize',12,'Position', [0.35 0 0.6 0.1],'HorizontalAlignment','left');
    handle.text_result1_c_trunk = uicontrol('Parent',handle.rightpan,'style', 'text','Units','normalized',...
        'String', c_trunk,'FontSize',12,'Position', [0.65 0 0.6 0.1],'HorizontalAlignment','left');
    
%↑------------------------------↑result2↑------------------------------↑



end
end