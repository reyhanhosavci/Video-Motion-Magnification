function [gaussout] = gauss_pyramid(im, levels)
    gaussout = cell(1,levels+1);
    gaussout{1} = im;
    pyr=im;
    for i = 2 : levels+1
        pyr = impyramid(pyr,'reduce');
        gaussout{i} = pyr;
    end
end
