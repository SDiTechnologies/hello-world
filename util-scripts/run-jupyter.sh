#!/usr/bin/env bash

# certificate key assumed to be named test;
KEY="$(dirname "$(pwd)")/_output/ssl/test.key";
CERT="$(dirname "$(pwd)")/_output/ssl/test.pem";
IP_ADDRESS=127.0.0.1;
PORT=8888;
NOTEBOOK_DIRECTORY="$(dirname "$(pwd)")/jupyter-notebook/";


# CERTIFICATE_SCRIPT=$HOME/scripts/generate_certificate.sh
#
# if [ ! -d "${CERT_DIR}" ]; then
#   # mkdir "${CERT_DIR}";
#   # TODO: Add a call to the certificate script
#   bash "${CERTIFICATE_SCRIPT}";
# fi

# run jupyter notebook shell script
jupyter notebook --ip=$IP_ADDRESS \
		         --port=$PORT \
		         --certfile="${CERT}" \
		         --keyfile="${KEY}" \
		         --no-browser \
		         --notebook-dir="${NOTEBOOK_DIRECTORY}";
