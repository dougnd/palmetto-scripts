#Added for Caffe
module add cuda-toolkit/7.5.18 gcc/4.8.1 ffmpeg/2.4
export ACLOCAL_PATH="$INSTALL_DIR/share/aclocal${ACLOCAL_PATH:+":$ACLOCAL_PATH"}"
export PKG_CONFIG_PATH="$INSTALL_DIR/lib/pkgconfig${PKG_CONFIG_PATH:+":$PKG_CONFIG_PATH"}"
export PATH="$INSTALL_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$INSTALL_DIR/lib64:$INSTALL_DIR/lib${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}"
export LIBRARY_PATH="$INSTALL_DIR/lib64:$INSTALL_DIR/lib${LIBRARY_PATH:+":$LIBRARY_PATH"}"
export PYTHONPATH="$INSTALL_DIR/python:$INSTALL_DIR/lib:$INSTALL_DIR/lib/python2.7/site-packages${PYTHONPATH:+":$PYTHONPATH"}"
export CPATH="$INSTALL_DIR/include${CPATH:+":$CPATH"}"
#Needed for Auto-Perl Exec
export PERL_MM_USE_DEFAULT=1
