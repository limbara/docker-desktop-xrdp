install_required_packages() {
  # the commands to check for
  cmds=("speaker-test")
  # the packages to install relative to checked command index
  pkgs=("alsa-utils")
  pkgs_command=
  for cmd_idx in "${!cmds[@]}"; do
    if ! command -v "${cmds[$cmd_idx]}" 2>&1 >/dev/null; then
      pkgs_command="${pkgs_command} ${pkgs[$cmd_idx]}"
    fi
  done

  if [ ! -z "${pkgs_command}" ]; then
    echo "- Need to install packages :${pkgs_command}"
    echo
    echo "  These can be removed when this script completes with:-"
    echo "  sudo apt-get purge${pkgs_command} && apt-get autoremove"
    echo
    sudo apt-get update
    sudo apt-get install -y ${pkgs_command}
  fi
}

install_required_packages || exit $?

speaker-test -t wav -c 2 -l 1
