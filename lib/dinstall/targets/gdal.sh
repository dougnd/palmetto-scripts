# returns true if it is installed
is_installed_gdal () {
    is_stowed gdal
}

# will exit with error if dependencies are not met 
# (0 means dependencies met, 1 means not met)
dependencies_satisfied_gdal () {
    if [ $HOSTNAME = "user001" ]; then
        echo "Cannot install gdal while on the user node. try getGPULikeNode first!"
        return 1
    fi
    require_packages gcc
}

uninstall_gdal () {
    unstow gdal
}

install_gdal () {
    cd $TMPDIR

    mkdir gdal; cd gdal
    wget http://download.osgeo.org/gdal/2.0.2/gdal-2.0.2.tar.gz
    tar xf gdal-2.0.2.tar.gz
    cd gdal-2.0.2
    ./configure --prefix=$INSTALL_DIR/stow/gdal
    make -j$cores
    make install

    dostow gdal

    cd $TMPDIR
    rm -rf gdal
}
