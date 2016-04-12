# `lyonfnal/jupyter`

This image adds on to `lyonfnal/mu_1_17_07_base` adding `root v6` and `jupyter` built with the `python` in `/products`. 

You can run Jupyter notebooks and root v6 (note that mu `v1_17_07` is compiled with root 5) as a `RootBook`. 

This image adds,

* graphviz
* Python libraries requests, Jupyter, nbconvert, numpy, pandas, matplotlib, and seaborn (includes scipy)

The Root6 kernel is loaded in the appropriate area. 

Note that python libraries are saved to,
`/home/gm2/.local` and Jupyter config is in `/home/gm2/.jupyter`. 

Jupyter kernels go into `/home/gm2/.local/share/jupyter/kernels`. 

The `.bash_profile` starts CVMFS, setups up `art v1_17_07` and `cmake`. 

If you want `root v6`, then run from the shell `setuproot6` (this is a bash function defined in `/usr/local/bin/startenv.sh`, which is loaded by `.bash_profile`. 

The jupyter notebook config allows connections from all IP addresses, so be careful. By default, the notebook runs on port `8888` and that port is exposed. 

The following `jupyter extensions` are loaded...

* Jupyter themes at https://github.com/merqurio/jupyter_themes
* IPython Notebook Extensions at https://github.com/ipython-contrib/IPython-notebook-extensions . Go to the `nbextensions` web page to activate particular extensions. 

Here are how to do some things.

## Run jupyter notebook

```bash
jupyter notebook
```



