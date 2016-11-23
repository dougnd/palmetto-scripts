# returns true if it is installed
is_installed_libpqxx () {
    is_stowed libpqxx
}

# will exit with error if dependencies are not met 
# (0 means dependencies met, 1 means not met)
dependencies_satisfied_libpqxx () {
    if [ $HOSTNAME = "user001" ]; then
        echo "Cannot install libpqxx while on the user node. try getGPULikeNode first!"
        return 1
    fi
    require_packages gcc
}

uninstall_libpqxx () {
    unstow libpqxx
}

install_libpqxx () {
    cd $TMPDIR
    mkdir libpqxx; cd libpqxx
    wget http://pqxx.org/download/software/libpqxx/libpqxx-4.0.1.tar.gz
    tar xf libpqxx-4.0.1.tar.gz
    cd libpqxx-4.0.1
    ./configure --prefix=$INSTALL_DIR/stow/libpqxx
    make
    make install

    dostow libpqxx

    cd $TMPDIR
    rm -rf libpqxx
}

binary_deploy_libpqxx () {
    binary_deploy_stow libpqxx
}
binary_install_libpqxx () {
    binary_install_stow libpqxx
}
binary_available_libpqxx () {
    binary_available_stow libpqxx
}
