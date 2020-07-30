function [volume] = overlap(heatmap1,heatmap2)

% Normalization
heatmap1 = heatmap1/sum(heatmap1, 'a');
heatmap2 = heatmap2/sum(heatmap2, 'a');


overlap_location = abs(heatmap1-heatmap2)>1e-5;
volume = sum(min(heatmap1(overlap_location), heatmap2(overlap_location)));

end

