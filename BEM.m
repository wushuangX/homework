%%
mri = ft_read_mri('T1.nii');
% mri = ft_read_mri('Subject01.mri');
mri = ft_determine_coordsys(mri)
%%
cfg           = [];
cfg.output    = {'brain','skull','scalp'};
segmentedmri  = ft_volumesegment(cfg, mri);

save segmentedmri segmentedmri

%%
cfg=[];
cfg.tissue={'brain','skull','scalp'};
cfg.numvertices = [3000 2000 1000];
bnd=ft_prepare_mesh(cfg,segmentedmri);

save bnd bnd

%%
% Create a volume conduction model using 'dipoli', 'openmeeg', or 'bemcp'.
% Dipoli
cfg        = [];
cfg.method ='bemcp'; % You can also specify 'openmeeg', 'bemcp', or another method.
vol        = ft_prepare_headmodel(cfg, bnd);

save vol vol

%%
figure;
ft_plot_mesh(vol.bnd(3),'facecolor','none'); %scalp
figure;
ft_plot_mesh(vol.bnd(2),'facecolor','none'); %skull
figure;
ft_plot_mesh(vol.bnd(1),'facecolor','none'); %brain

%%
% ft_plot_mesh(vol.bnd(1), 'facecolor',[0.2 0.2 0.2], 'facealpha', 0.3, 'edgecolor', [1 1 1], 'edgealpha', 0.05);
% hold on;
% ft_plot_mesh(vol.bnd(2),'edgecolor','none','facealpha',0.4);
% hold on;
% ft_plot_mesh(vol.bnd(3),'edgecolor','none','facecolor',[0.4 0.6 0.4]);
% 
% 
% %%
% elec = ft_read_sens('standard_1020.elc');
% % load volume conduction model
% load vol;
% figure;
% % head surface (scalp)
% ft_plot_mesh(vol.bnd(1), 'edgecolor','none','facealpha',0.8,'facecolor',[0.6 0.6 0.8]);
% hold on;
% % electrodes
% ft_plot_sens(elec,'red', 'sk');