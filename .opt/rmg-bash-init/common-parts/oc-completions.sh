
# Don't bother if not running interactively
case $- in
  *i*) ;;
  *) return ;;
esac

# Load oc completions if not generated as a file
if
  command -v oc &>/dev/null &&
  [ ! -e "$HOME/.bash_completions.d/oc" ]
then
  source <(oc completion bash)
fi
