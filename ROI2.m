avg = cell(116, 1);
for n = 1:size(minimum_norm_eeg.pos, 1)
    % 遍历源的坐标，对于超出aal坐标范围91 109 91的不考虑
    if abs(minimum_norm_eeg.pos(n, 1)) < 46
        if abs(minimum_norm_eeg.pos(n, 2)) < 55
            if abs(minimum_norm_eeg.pos(n, 3)) < 46
                % 在坐标范围内的
                if ~isnan(minimum_norm_eeg.avg.pow(n, 1))
                    if aal.tissue(46 + minimum_norm_eeg.pos(n, 1), 55 + minimum_norm_eeg.pos(n, 2), 46 + minimum_norm_eeg.pos(n, 3)) ~= 0
                        avg{aal.tissue(46 + minimum_norm_eeg.pos(n, 1), 55 + minimum_norm_eeg.pos(n, 2), 46 + minimum_norm_eeg.pos(n, 3))} ...
                            = [avg{aal.tissue(46 + minimum_norm_eeg.pos(n, 1), 55 + minimum_norm_eeg.pos(n, 2), 46 + minimum_norm_eeg.pos(n, 3))}; ...
                            minimum_norm_eeg.avg.pow(n, :)]
                    end
                end
            end
        end
    end
end
