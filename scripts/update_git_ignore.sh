#!/usr/bin/env bash

# Simple script for fetching all .gitignore from GitHub repository into one .gitignore file.

set -e
set -u

URL_PREFIX='https://raw.githubusercontent.com/github/gitignore/main'
TMP_FILE='.new.gitignore'
SAVE_FILE='.gitignore'

echo >&2 "Preparing ${SAVE_FILE} ..."
echo -e '# -*- mode: gitignore; -*-\n' >"${SAVE_FILE}"

for ignore_path in 'Global/Linux.gitignore' 'Rust.gitignore' 'Python.gitignore' 'TeX.gitignore' 'Global/Emacs.gitignore' 'Global/JetBrains.gitignore' 'Global/VisualStudioCode.gitignore'; do
  ignore_name=$(basename "${ignore_path}")
  ignore_name="${ignore_name%.gitignore}"
  url="${URL_PREFIX}/${ignore_path}"

  echo >&2 "Fetching ${ignore_name} from: ${url}"
  wget -nv -O "${TMP_FILE}" "${url}"

  {
    echo -e "# ${ignore_name} #\n"
    sed '/mode: gitignore;/d' <"${TMP_FILE}"
  } >>"${SAVE_FILE}"
  echo -e '\n' >>"${SAVE_FILE}"

done

echo -e "# User #\n" >>"${SAVE_FILE}"
echo ".idea/" >>"${SAVE_FILE}"

rm -rf "${TMP_FILE}"

echo >&2 'DONE'
