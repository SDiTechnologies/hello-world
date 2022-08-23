#!/usr/bin/env bash


main() {
  update_pip;
  update_packages;
}


update_pip() {
  echo "upgrading pip in the current python environment...";
  pip install --upgrade pip;
  echo "pip successfully upgraded!";
  echo;
}


update_packages() {
  echo "upgrading all packages to latest version in the current python environment...";
  pip freeze — local | grep -v ‘^\-e’ | cut -d = -f 1 | xargs -n1 pip install -U;
  echo "all packages successfully upgraded!";
  echo;
  echo "WARNING: some package versions may be mismatched";
  echo "If errors occur:";
  echo "  1) review installed packages";
  echo "  2) manually resolve versioning issues";
}

# call main function
main;
