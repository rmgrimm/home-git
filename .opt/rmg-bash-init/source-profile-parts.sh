# Only display echos from scripts if interactive

case $- in
  *i*)
    for i in $HOME/.profile.d/*.sh
    do
      if [ -r "$i" ]
      then
        . "$i"
      fi
    done
  ;;
  *)
    for i in $HOME/.profile.d/*.sh
    do
      if [ -r "$i" ]
      then
        . "$i" > /dev/null
      fi
    done
  ;;
esac

unset i
