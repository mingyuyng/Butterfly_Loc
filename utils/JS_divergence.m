function [JS] = JS_divergence(heatmap1,heatmap2)

% Normalization
heatmap1 = heatmap1/sum(heatmap1, 'a');
heatmap2 = heatmap2/sum(heatmap2, 'a');

% Calculate the JS divergence
average = (heatmap1 + heatmap2) / 2;

KL1 = nansum(heatmap1 .* (log2(heatmap1)-log2(average)), 'a');
KL2 = nansum(heatmap2 .* (log2(heatmap2)-log2(average)), 'a');
JS = (KL1+KL2)/2;

end

