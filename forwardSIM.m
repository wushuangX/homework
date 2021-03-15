%%
% create an array with some magnetometers at 12cm distance from the origin
[X, Y, Z] = sphere(10);
pos = unique([X(:) Y(:) Z(:)], 'rows');
pos = pos(pos(:,3)>=0,:);
grad = [];
grad.coilpos = 12*pos;
grad.coilori = pos; % in the outward direction
% grad.tra = eye(length(pos)); % each coils contributes exactly to one channel
for i=1:length(pos)
  grad.label{i} = sprintf('chan%03d', i);
end

vol = [];
vol.r = [0.88 0.92 1.00]; % radii of spheres
vol.c = [1 1/80 1];       % conductivity
vol.o = [0 0 0];          % center of sphere

%%
% mri = ft_read_mri('yzwT1.nii');
mri = ft_read_mri('yzwT1.nii');
mri = ft_determine_coordsys(mri);

cfg     = [];
cfg.dim = mri.dim;
mri     = ft_volumereslice(cfg,mri);
cfg=[];
ft_sourceplot(cfg,mri);

cfg           = [];
cfg.output    = {'gray','white','csf','skull','scalp'};
segmentedmri  = ft_volumesegment(cfg, mri);

save segmentedmri segmentedmri

seg_i = ft_datatype_segmentation(segmentedmri,'segmentationstyle','indexed');

cfg              = [];
cfg.funparameter = 'seg';
cfg.funcolormap  = lines(6); % distinct color per tissue
cfg.location     = 'center';
cfg.atlas        = seg_i;    % the segmentation can also be used as atlas
ft_sourceplot(cfg, seg_i);

cfg        = [];
cfg.shift  = 0.3;
cfg.method = 'hexahedral';
mesh = ft_prepare_mesh(cfg, segmentedmri);

cfg        = [];
cfg.method ='simbio';
cfg.conductivity = [0.33 0.14 1.79 0.01 0.43];   % order follows mesh.tissyelabel
vol        = ft_prepare_headmodel(cfg, mesh);

%%
% note that beamformer scanning will be done with a 1cm grid, so you should
% not put the dipole on a position that will not be covered by a grid
% location later
cfg = [];
cfg.headmodel = vol;
cfg.grad = grad;
cfg.dip.pos = [0 0 4];    % you can vary the location, here the dipole is along the z-axis
cfg.dip.mom = [1 0 0]';   % the dipole points along the x-axis
cfg.relnoise = 10;
cfg.ntrials = 20;
data = ft_dipolesimulation(cfg);

% compute the data covariance matrix, which will capture the activity of
% the simulated dipole
cfg = [];
cfg.covariance = 'yes';
timelock = ft_timelockanalysis(cfg, data);

% do the beamformer source reconstuction on a 1 cm grid
cfg = [];
cfg.headmodel = vol;
cfg.grad = grad;
cfg.resolution = 1;
cfg.method = 'lcmv';
cfg.lcmv.projectnoise = 'yes'; % needed for neural activity index
source = ft_sourceanalysis(cfg, timelock);

% compute the neural activity index, i.e. projected power divided by
% projected noise
cfg = [];
cfg.powmethod = 'none'; % keep the power as estimated from the data covariance, i.e. the induced power
source_nai = ft_sourcedescriptives(cfg, source);

cfg = [];
cfg.method = 'ortho';
cfg.funparameter = 'nai';
cfg.funcolorlim = [1.4 1.5];  % the voxel in the center of the volume conductor messes up the autoscaling
ft_sourceplot(cfg, source_nai);