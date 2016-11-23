# returns true if it is installed
is_installed_postgresql () {
    is_stowed postgresql
}

# will exit with error if dependencies are not met 
# (0 means dependencies met, 1 means not met)
dependencies_satisfied_postgresql () {
    if [ $HOSTNAME = "user001" ]; then
        echo "Cannot install postgresql while on the user node. try getGPULikeNode first!"
        return 1
    fi
    require_packages gcc
}

uninstall_postgresql () {
    unstow postgresql
}

install_postgresql () {
    cd $TMPDIR
    mkdir postgresql; cd postgresql
    wget https://ftp.postgresql.org/pub/source/v9.3.13/postgresql-9.3.13.tar.gz
    tar xf postgresql-9.3.13.tar.gz
    cd postgresql-9.3.13
    ./configure --prefix=$INSTALL_DIR/stow/postgresql
    make 
    make install

    dostow postgresql

    cd $TMPDIR
    rm -rf postgresql
}

binary_deploy_postgresql () {
    binary_deploy_stow postgresql
}
binary_install_postgresql () {
    binary_install_stow postgresql
}
binary_available_postgresql () {
    binary_available_stow postgresql
}
