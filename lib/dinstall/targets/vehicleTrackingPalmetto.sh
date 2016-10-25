# returns true if it is installed
is_installed_vehicleTrackingPalmetto () {
    is_stowed vehicleTrackingPalmetto
}

# will exit with error if dependencies are not met 
# (0 means dependencies met, 1 means not met)
dependencies_satisfied_vehicleTrackingPalmetto () {
    return 0
}

uninstall_vehicleTrackingPalmetto () {
    unstow vehicleTrackingPalmetto
}

install_vehicleTrackingPalmetto () {
    cd $INSTALL_DIR/stow
    git clone https://github.com/dougnd/vehicleTrackingPalmetto.git
    dostow vehicleTrackingPalmetto
}

