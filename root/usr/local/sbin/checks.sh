check_true() {
  case "$1" in
    True|true|TRUE|ON|On|on|Yes|yes|1)
      echo "true"
      ;;
    *)
      echo "false"
      ;;
  esac
}