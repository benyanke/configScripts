while getopts d:i:h flag; do
  case $flag in
    d) echo "You used a -d flag: $OPTARG"; ;;
    i) PUPPET_FILE=$OPTARG; ;;
    h) HIERA_CONFIG=$OPTARG; ;;
    ?) exit; ;;
  esac
done
