function orthoviewer(img)
%ORTHOVIEWER displays orthogonal views of an image stack
%
% orthoviewer(img) takes a grayscale image stack img and displays its
% orthogonal views

% Version 1.1
% Copyright Chao-Yuan Yeh, 2016

iptsetpref('ImshowBorder', 'tight');
x_num = size(img, 2); 
y_num = size(img, 1); 
z_num = size(img, 3);
x_ind = ceil(x_num/2); 
y_ind = ceil(y_num/2); 
z_ind = ceil(z_num/2);

f1 = figure(1);
f1.Position = [200, size(img, 3) + 140, size(img, 2), size(img, 1)];
ah1 = axes('XLim',[1,x_num],'YLim',[1,y_num]);
fh1 = imshow(squeeze(img(:, :, z_ind))); 
hold on;
h1 = line([x_ind x_ind], [1 y_num], 'color', 'red', 'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn1);
h2 = line([1 x_num], [y_ind y_ind], 'color', 'red', 'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn1);


f2 = figure(2);
f2.Position = [200 + size(img, 2) + 15, size(img, 3) + 140, ...
    size(img, 3), size(img, 1)];
ah2 = axes('XLim', [1, z_num], 'YLim', [1, y_num]);
fh2 = imshow(squeeze(img(:, x_ind, :))); 
hold on;
h3 = line([z_ind z_ind], [1 y_num], 'color', 'red', 'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn2);
h4 = line([1 z_num], [y_ind y_ind], 'color', 'red', 'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn2);


f3 = figure(3);
f3.Position = [200, 50 , size(img, 2), size(img, 3)];
ah3 = axes('XLim', [1, x_num], 'YLim',[1, z_num]);
fh3 = imshow(flip(permute(squeeze(img(y_ind, :, :)), [2 1 3]), 1)); 
hold on;
h5 = line([x_ind x_ind], [1 z_num], 'color', 'red', 'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn3);
h6 = line([1 x_num], [z_ind z_ind], 'color', 'red', 'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn3);



    function startDragFcn1(varargin)
        set(gcf, 'WindowButtonMotionFcn', @dragginFcn1);
        set(gcf, 'WindowButtonUpFcn', @stopDragFcn1);
    end

    function dragginFcn1(varargin)
        pt1 = get(ah1, 'CurrentPoint');
        set(h1, 'XData', pt1(1) * [1 1]);
        set(h2, 'YData', pt1(3) * [1 1]);
        set(h3, 'XData', z_ind * [1 1]);
        set(h4, 'YData', pt1(3) * [1 1]);
        set(h5, 'XData', pt1(1) * [1 1]);
        set(h6, 'YData', (z_num - z_ind) * [1 1]);
        x_ind_local = ceil(pt1(1));
        y_ind_local = ceil(pt1(3));
        % Setting cDATA of figure handle results in better performance than
        % using imshow to display new image. System will eventually hang if
        % using imshow to update image. 
        set(fh2, 'cDATA', squeeze(img(:,floor(x_ind_local), :)))
        set(fh3, 'cDATA', flip(permute(squeeze(...
            img(floor(y_ind_local), :, :)), [2 1 3]), 1))
    end

    function stopDragFcn1(varargin)
        pt1 = get(ah1, 'CurrentPoint');
        set(gcf, 'WindowButtonMotionFcn', ' ');
        set(gcf, 'WindowButtonUpFcn', ' ');
        x_ind = ceil(pt1(1)); 
        y_ind = ceil(pt1(3));

        figure(2)
        delete(h3)
        delete(h4)
        h3 = line([z_ind z_ind], [1 y_num], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn2);
        h4 = line([1 z_num], [y_ind y_ind], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn2);

        figure(3)
        delete(h5)
        delete(h6)
        h5 = line([x_ind x_ind], [1 z_num], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn3);
        h6 = line([1 x_num], [z_num-z_ind z_num-z_ind],'color', 'red', ...
            'linewidth', 1,'ButtonDownFcn', @startDragFcn3);        
    end


    function startDragFcn2(varargin)
        set(gcf,'WindowButtonMotionFcn', @dragginFcn2);
        set(gcf, 'WindowButtonUpFcn', @stopDragFcn2);
    end

    function dragginFcn2(varargin)
        pt2 = get(ah2, 'CurrentPoint');
        set(h1, 'XData', x_ind * [1 1]);
        set(h2, 'YData', pt2(3) * [1 1]);
        set(h3, 'XData', pt2(1) * [1 1]);
        set(h4, 'YData', pt2(3) * [1 1]);
        set(h5, 'XData', x_ind * [1 1]);
        set(h6, 'YData', (z_num - pt2(1)) * [1 1]); 
        z_ind_local = ceil(pt2(1)); 
        y_ind_local = ceil(pt2(3));
        set(fh1, 'cDATA', squeeze(img(:, :, floor(z_ind_local))))
        set(fh3, 'cDATA', flip(permute(squeeze(...
            img(floor(y_ind_local), :, :)), [2 1 3]), 1))
    end

    function stopDragFcn2(varargin)
        pt2 = get(ah2, 'CurrentPoint');
        set(gcf, 'WindowButtonMotionFcn', ' ');
        set(gcf, 'WindowButtonUpFcn', ' ');
        z_ind = ceil(pt2(1)); 
        y_ind = ceil(pt2(3));

        figure(1)
        delete(h1)
        delete(h2)
        h1 = line([x_ind x_ind], [1 y_num], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn1);
        h2 = line([1 x_num], [y_ind y_ind], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn1);

        figure(3)
        delete(h5)
        delete(h6)
        h5 = line([x_ind x_ind], [1 z_num], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn3);
        h6 = line([1 x_num], [z_num - z_ind z_num - z_ind], 'color', ...
            'red', 'linewidth', 1, 'ButtonDownFcn', @startDragFcn3);
    end


    function startDragFcn3(varargin)
        set(gcf, 'WindowButtonMotionFcn', @dragginFcn3);
        set(gcf, 'WindowButtonUpFcn', @stopDragFcn3);
    end

    function dragginFcn3(varargin)
        pt3 = get(ah3, 'CurrentPoint');
        set(h1, 'XData', pt3(1) * [1 1]);
        set(h2, 'YData', y_ind * [1 1]);
        set(h3, 'XData', (z_num - pt3(3)) * [1 1]);
        set(h4, 'YData', y_ind * [1 1]);
        set(h5, 'XData', pt3(1) * [1 1]);
        set(h6, 'YData', pt3(3) * [1 1]);
        z_ind_local = z_num - ceil(pt3(3)); 
        x_ind_local = ceil(pt3(1));
        set(fh1, 'cDATA', squeeze(img(:, :, floor(z_ind_local))))
        set(fh2, 'cDATA', squeeze(img(:, floor(x_ind_local), :)))
    end

    function stopDragFcn3(varargin)
        pt3 = get(ah3, 'CurrentPoint');
        set(gcf, 'WindowButtonMotionFcn', ' ');
        set(gcf, 'WindowButtonUpFcn', ' ');
        z_ind = z_num - ceil(pt3(3));
        x_ind = ceil(pt3(1));

        figure(1)
        delete(h1)
        delete(h2)
        h1 = line([x_ind x_ind], [1 y_num], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn1);
        h2 = line([1 x_num], [y_ind y_ind], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn1);

        figure(2)
        delete(h3)
        delete(h4)
        h3 = line([z_ind z_ind], [1 y_num], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn2);
        h4 = line([1 z_num], [y_ind y_ind], 'color', 'red', ...
            'linewidth', 1, 'ButtonDownFcn', @startDragFcn2);
    end

end

