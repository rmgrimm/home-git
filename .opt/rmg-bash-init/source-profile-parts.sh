# Only display echos from scripts if interactive

if [ "x$RMG_PROFILE_SOURCED" = "x" ]
then
  RMG_PROFILE_SOURCED=y

  case $- in
    *i*)
      for i in $HOME/.profile.d.rmg/*.sh
      do
        if [ -r "$i" ]
        then
          . "$i"
        fi
      done
    ;;
    *)
      for i in $HOME/.profile.d.rmg/*.sh
      do
        if [ -r "$i" ]
        then
          . "$i" > /dev/null
        fi
      done
    ;;
  esac

  unset i
fi
