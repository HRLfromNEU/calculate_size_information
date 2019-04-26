
%统计raw49文件夹三种不同的的肺结节信息

%%
clc,clear
file_name = '/Users/liuhaoran/Documents/MATLAB/开题报告/平扫动静脉期实验数据/RawFiles-49';
d_file = dir(file_name);
% 
isub = [d_file(:).isdir]; 
nameFolds = {d_file(isub).name}';
nd_first = length(nameFolds);
cont = 1;
i = 1;
for nfile_first = 3:nd_first
%     nfile_first = 3
    first_subfoldername = strcat(file_name, '/', d_file(nfile_first,1).name);

    d_fitst = dir(first_subfoldername);
    isub_first = [d_fitst(:).isdir]; 
    nameFolds_first = {d_fitst(isub_first).name}';
    nd_secend = length(nameFolds_first);
    
    for  nfile = 3:nd_secend
%         nfile = 3
        subfoldername = strcat(first_subfoldername, '/', d_fitst(nfile,1).name);
        files = dir([subfoldername,'/*.raw']);
         %读取coord数据和new数据
        if(strfind(files(1).name,'Coord'))
            fidraw_Coord = fopen(strcat(subfoldername, '/', files(1).name));
        else
            fidraw_Coord = fopen(strcat(subfoldername, '/', files(2).name));
        end
        if(strfind(files(2).name,'New'))
            fidraw_New = fopen(strcat(subfoldername, '/', files(2).name));
        else
            fidraw_New = fopen(strcat(subfoldername, '/', files(1).name));
        end


        nxyzraw_Coord = fread(fidraw_Coord, 3, 'int');
        fxyzraw_Coord = fread(fidraw_Coord, 3, 'float');
        irawlong_Coord = nxyzraw_Coord(1)*nxyzraw_Coord(2)*nxyzraw_Coord(3);
        irawxylong_Coord = nxyzraw_Coord(1)*nxyzraw_Coord(2);
        rawdata_Coord = fread(fidraw_Coord, irawlong_Coord, 'short');

        nxyzraw_New = fread(fidraw_New, 3, 'int');
        fxyzraw_New = fread(fidraw_New, 3, 'float');
        irawlong_New = nxyzraw_New(1)*nxyzraw_New(2)*nxyzraw_New(3);
        irawxylong_New = nxyzraw_New(1)*nxyzraw_New(2);
        rawdata_New = fread(fidraw_New, irawlong_New, 'short');


        ThreeDImages_Coord = reshape(rawdata_Coord,[nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3)]);
        ThreeDImages_New = reshape(rawdata_New,[nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3)]);
%         for con = 1 : nxyzraw_Coord(3)
%             stats = regionprops(logical(ThreeDImages_Coord(:,:,con)),'BoundingBox')
%             rects = cat(1,stats.BoundingBox);
%         end
        
%         figure
%         imshow(ThreeDImages_Coord(:,:,2));
%         hold on
%         for ii = 1 : nxyzraw_Coord(3)
            [r, c]=find(logical(ThreeDImages_Coord(:,:,2))==1);
            [rectx,recty,area,perimeter] = minboundrect(c,r,'p'); % 'a'是按面积算的最小矩形，如果按边长用'p'
%         end
    
%         line(rectx,recty);
        X = (max(rectx)-min(rectx))*fxyzraw_Coord(1)
        Y = (max(recty)-min(recty))*fxyzraw_Coord(2)
        Z = fxyzraw_Coord(3)*nxyzraw_Coord(3)
        R = max([X,Y,Z])
        T(i).name = subfoldername
        T(i).MAX = R
        T(i).X = X
        T(i).Y = Y
        T(i).Z = Z
        
        i = i + 1;
         
        
    end
end
