
# Don't bother if not running interactively
case $- in
  *i*) ;;
  *) return ;;
esac

# Add JBang to environment
if
  command -v jbang &>/dev/null
then
  alias j!=jbang
  export PATH="$HOME/.jbang/bin:$PATH"

  #export PATH="$HOME/.jbang/:$HOME/.jbang/currentjdk/bin::$PATH"
  #export JAVA_HOME=$HOME/.jbang/currentjdk

  source <(jbang completion)

  if
    command -v camel &>/dev/null
  then
    source <(camel completion)
  fi
fi
