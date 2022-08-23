#!/usr/bin/env bash

# TODO: Update documentation for each respective function; Consider adding it to error catching and returning possible text explanation of error

# TODO: Add command line control switch to specify if production or development certificate

: '
NOTES prior to commit
v1 was au natural;

v2 scripts will be adapted from https://gist.github.com/cecilemuller/9492b848eb8fe46d462abeb26656c4f8

and will allow for creating production certificates per https://gist.github.com/cecilemuller/a26737699a7e70a7093d4dc115915de8

script 1:
openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout RootCA.key[priv] -out RootCA.pem[pub] -subj "/C=US/CN=Example-Root-CA"

openssl x509 -outform pem -in RootCA.pem[pub] -out RootCA.crt

script 2:
openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key[localhost_priv_key] -out localhost.csr[localhost_csr_key] -subj "/C=US/ST=YourState/L=YourCity/O=Example-Certificates/CN=localhost.local"

openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA RootCA.pem -CAkey RootCA.key -CAcreateserial -extfile domains.ext -out localhost.crt
'

: '
DESCRIPTION: Use this script to create new certificate pairs for any set + subset of domains hosted for local, development, or production website servers and ssh-authenticated server access instance(s).

PURPOSE: (see DESCRIPTION)

ARGS:
  (ARG1) CERTIFICATE_TYPE
    DATA TYPE: STR
    VALID VALUES: ["ssl",
                   "ssh",
                   "letsencrypt"]
    PURPOSE: DETERMINE CERTIFICATE REQUEST TYPE

  (ARG2) CERTIFICATE_NAME
    DATA TYPE: STR
    VALID VALUES: ANY STRING
    PURPOSE: REPRESENTATION FOR OUTPUT FILE NAME

  (ARG3) SSH_OPTION
    DATA TYPE: any
    VALID VALUES: None or !None # if none: use DEFAULT_ALGORITHM.
    PURPOSE: CONTROL SWITCH FOR MORE SECURE SSH CERTIFICATE CREATION
    *PRECONDITION(s):
      attempt to create CERTIFICATE_TYPE="ssh"
    *POSTCONDITION(s):
      IF SSH_OPTION is None return DEFAULT_ALGORITHM="rsa";
      ELSE return ARG3

  (CONSTANT) DEFAULT_ALGORITHM
    VALUE: "rsa"

  (CONSTANT) DEFAULT_BIT_SIZE
    VALUE: 4096

  # Consider changing OUTPUT_DIRECTORY to something more machine independent or possibly resolve to system packages; but that may be bad practice or require admin privileges
  (VARIABLE) OUTPUT_DIRECTORY
    VALUE: "$(dirname "$(pwd)")/_output"

EXAMPLE USAGE:
  $> ./create_certificate.sh CERTIFICATE_TYPE CERTIFICATE_NAME SSH_OPTION
'

# global variable declarations
CERTIFICATE_TYPE="$1";
CERTIFICATE_NAME="$2";
SSH_OPTION="$3";
DEFAULT_ALGORITHM="rsa";
DEFAULT_BIT_SIZE=4096;  # 2048 -or- 4096
OUTPUT_DIRECTORY="$(dirname "$(pwd)")/_output";

# ssl/letsencrypt variables
# DAYS may require mods depending on dev vs prod certificate creation
INIT_SUBJECT="/C=US/CN=Development-Root-CA";
SUBJECT="/C=US/ST=Arizona/L=Phoenix/O=Development-Certificates/CN=localhost";
DAYS=1024;

main() {

  # check for required args
  if [[ -z "${CERTIFICATE_TYPE}" ]]; then
      echo "(ARG1) CERTIFICATE_TYPE is required";
      exit;
    elif [[ -z "${CERTIFICATE_NAME}" ]]; then
      echo "(ARG2) CERTIFICATE_NAME is required";
      exit;
  fi


  # check for certificate type; defer to other functions
  if [[ "${CERTIFICATE_TYPE}" == 'ssl' ]]; then
      create_openssl_certificate;
    # TODO: create function for letsencrypt
    elif [[ "${CERTIFICATE_TYPE}" == 'letsencrypt' ]]; then
      create_letsencrypt_certificate;
    elif [[ "${CERTIFICATE_TYPE}" == 'ssh' ]]; then
      create_openssh_certificate;
    else
      echo "Unable to complete request; please verify that the specified certificate type is valid.";
  fi


}


create_directory_if_not_exists() {
: '
DESCRIPTION:

PURPOSE:

'
  local DIRECTORY="$1";
  shift 1;

  if [[ ! -d "${DIRECTORY}" ]]; then
    echo "${DIRECTORY} does not exist";
    echo "Creating Directory:'${DIRECTORY}' now...";
    mkdir -p "${DIRECTORY}";
    echo "...Complete";
  else
    echo "${DIRECTORY} exists...";
    echo "Moving on...";
  fi

  return 1;


}

update_certificate_file_permissions() {
: '
DESCRIPTION:

PURPOSE:

Permissions:
  ~/.ssh              700 (drwx------)
  ~/.ssh/(public)     644 (-rw-r--r--)
  ~/.ssh/(private)    600 (-rw-------)
'

  local certDirectory="$(dirname "$1")";
  local pubKey="$1";
  local privKey="$2";

  chmod 700 "${certDirectory}";
  chmod 644 "${pubKey}";
  chmod 600 "${privKey}";

  return 1;


}

create_openssl_certificate() {
  # TODO: add logic from notes above concerning suggestions from cecilemuller github account; consider attribution
  # TODO: Document usage
  # TODO: Research & Update certificate permissions; Certificate permissions are already updated upon completion of this process -- No need to call to update_certificate_file_permissions()

: '

'
  # SUBJECT ARGS
  # /C Country
  # /ST State
  # /L Locale
  # /O Organization
  # /CN CName

  # Example by Cecile only uses /C /CN -or- /C /ST /L /O /CN
  # local SUBJECT="/C=US/ST=Arizona/L=Phoenix/O=Development-Certificates/CN=test.com"
  # local DAYS=1024
  local OPENSSL_CERTIFICATE_DIRECTORY="${OUTPUT_DIRECTORY}/ssl";

  local PUB_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/${CERTIFICATE_NAME}.pem";

  local PRIV_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/${CERTIFICATE_NAME}.key";
  local LOCALHOST_PRIV_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/localhost.key";

  local CERT_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/${CERTIFICATE_NAME}.crt";
  local LOCALHOST_CERT_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/localhost.crt";

  local CSR_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/${CERTIFICATE_NAME}.csr";
  local LOCALHOST_CSR_KEY="${OPENSSL_CERTIFICATE_DIRECTORY}/localhost.csr";

  create_directory_if_not_exists "${OPENSSL_CERTIFICATE_DIRECTORY}";

  # Original code
  openssl req -x509 \
              -nodes \
              -new \
              -sha256 \
              -days "${DAYS}" \
              -newkey "${DEFAULT_ALGORITHM}:${DEFAULT_BIT_SIZE}" \
              -subj "${SUBJECT}" \
              -keyout "${PRIV_KEY}" \
              -out "${PUB_KEY}";


  # ## SCRIPT 1
  # openssl req -x509 \
  #             -nodes \
  #             -new \
  #             -sha256 \
  #             -days "${DAYS}" \
  #             -newkey "${DEFAULT_ALGORITHM}:${DEFAULT_BIT_SIZE}" \
  #             -subj "${INIT_SUBJECT}" \
  #             -keyout "${PRIV_KEY}" \
  #             -out "${PUB_KEY}";
  #
  # openssl x509 -outform pem \
  #              -in ${PUB_KEY} \
  #              -out ${CERT_KEY};
  #
  # ## SCRIPT 2
  # openssl req -new \
  #             -nodes \
  #             -newkey "${DEFAULT_ALGORITHM}:${DEFAULT_BIT_SIZE}" \
  #             -keyout "${LOCALHOST_PRIV_KEY}" \
  #             -out "${LOCALHOST_CSR_KEY}" \
  #             -subj "${SUBJECT}";
  #
  # openssl x509 -req \
  #              -sha256 \
  #              -days "${DAYS}" \
  #              -in "${LOCALHOST_CSR_KEY}" \
  #              -CA "${PUB_KEY}" \
  #              -CAkey "${PRIV_KEY}" \
  #              -CAcreateserial \
  #              -extfile domains.ext \
  #              -out "${LOCALHOST_CERT_KEY}";

### TEST CODE
  # ## SCRIPT 1
  # echo 'openssl req -x509 \
  #                   -nodes \
  #                   -new \
  #                   -sha256 \
  #                   -days "${DAYS}" \
  #                   -newkey "${DEFAULT_ALGORITHM}:${DEFAULT_BIT_SIZE}" \
  #                   -subj "${SUBJECT}" \
  #                   -keyout "${PRIV_KEY}" \
  #                   -out "${PUB_KEY}";';
  #
  # echo 'openssl x509 -outform pem \
  #                    -in ${PUB_KEY} \
  #                    -out ${CERT_KEY};';
  #
  # ## SCRIPT 2
  # echo 'openssl req -new \
  #                   -nodes \
  #                   -newkey "${DEFAULT_ALGORITHM}:${DEFAULT_BIT_SIZE}" \
  #                   -keyout "${LOCALHOST_PRIV_KEY}" \
  #                   -out "${LOCALHOST_CSR_KEY}" \
  #                   -subj "${SUBJECT}";';
  #
  # echo 'openssl x509 -req \
  #                    -sha256 \
  #                    -days "${DAYS}" \
  #                    -in "${LOCALHOST_CSR_KEY}" \
  #                    -CA "${PUB_KEY}" \
  #                    -CAkey "${PRIV_KEY}" \
  #                    -CAcreateserial \
  #                    -extfile domains.ext \
  #                    -out "${LOCALHOST_CERT_KEY}";';

  # TODO: possibly remove -- reason: dead code
  # # finally update file permissions;
  # update_certificate_file_permissions "${PUB_KEY}" "${PRIV_KEY}";
  # update_certificate_file_permissions "${}" "${}";

}

create_letsencrypt_certificate() {
  # TODO
  echo "Coming Soon! Now get to work on it, Code Monkey!!!!";

}


create_openssh_certificate() {
: '

'
  local OPENSSH_CERTIFICATE_DIRECTORY="${OUTPUT_DIRECTORY}/ssh";
  local PUB_KEY="${OPENSSH_CERTIFICATE_DIRECTORY}/${CERTIFICATE_NAME}.pub";
  local PRIV_KEY="${OPENSSH_CERTIFICATE_DIRECTORY}/${CERTIFICATE_NAME}";

  create_directory_if_not_exists "${OPENSSH_CERTIFICATE_DIRECTORY}";

  # actual magic happens here
  if [[ -n "${SSH_OPTION}" ]]; then
    ssh-keygen -f "${PRIV_KEY}" -t ed25519 -a 100 -C "";
  else
    # -o flag uses latest openssh private key format instead of .pem
    # ed25519 uses new openssh private key format by default
    ssh-keygen -f "${PRIV_KEY}" -t "${DEFAULT_ALGORITHM}" -b "${DEFAULT_BIT_SIZE}" -o -a 100 -C "";
  fi

  # finally update file permissions;
  update_certificate_file_permissions "${PUB_KEY}" "${PRIV_KEY}";


  # # create configuration file in the new directory;
  # # keys will need to be moved there most likely
  # touch "$HOME/.ssh/config";
  # #
  #
  # # config format will reflect similar structure
  # : '
  # Host alias-or-shortened-hostname
  #     HostName FQDN-dev.example.com-or-ip-address
  #     Port 22
  #     User username
  #     PubKeyAuthentication yes
  #     IdentityFile ~/.ssh/id_rsa
  #     IdentitiesOnly yes
  # '

  # send new key to host machine
  # Preconditions(HOST):
  #   host machine will need /etc/ssh/sshd_config modified to allow password login
  #   two lines in particular:
  #     PubKeyAuthentication yes
  #     PasswordAuthentication yes

  #   execute restart for ssh server
  #   $> sudo systemctl restart ssh

  # Setup(CLIENT):
  #   send key: $> ssh-copy-id -i ~/.ssh/{file}.pub {user}@{domain}

  # PostConditions(HOST):
  #   modify /etc/ssh/sshd_config to disallow password logins
  #   and restrict permissions on the keys

}


# run the sauce
main;
