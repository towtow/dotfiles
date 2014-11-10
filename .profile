export LANG=$(locale)
# todo: cygwin    export LANG=$(locale -uU)

if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
  fi
fi
