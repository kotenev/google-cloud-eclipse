#!/bin/bash
#
# Signs JARs and generates a new p2 repo.
#

# Fail on any error.
set -e
# Display commands being run.
set -x

echo "KOKORO_GFILE_DIR: ${KOKORO_GFILE_DIR}"
ls -l "${KOKORO_GFILE_DIR}"
tar -C "${HOME}" -zxf "${KOKORO_GFILE_DIR}"/eclipse-jee-oxygen-*.tar.gz

readonly ECLIPSE_BIN="${HOME}/eclipse/eclipse"
readonly SIGNED_JAR_DIR="${KOKORO_GFILE_DIR}/signed_jars"
readonly NEW_REPO="${KOKORO_GFILE_DIR}/new_repository"

###############################################################################
# Sign `plugins/*.jar` and `features/*.jar`.

function sign_jars() {
  mkdir -p "${SIGNED_JAR_DIR}/${1}"
  for f in "${KOKORO_GFILE_DIR}/${1}"/*.jar
  do
    local filename=$( basename "${f}" )
    /escalated_sign/escalated_sign.py -j /escalated_sign_jobs -t signjar \
      "${f}" "${SIGNED_JAR_DIR}/${1}/${filename}"
  done
}

sign_jars plugins
sign_jars features

ls -lR "${SIGNED_JAR_DIR}"

###############################################################################
# Generate a new p2 repo from the signed artifacts.

"${ECLIPSE_BIN}" -nosplash -consolelog \
  -application org.eclipse.equinox.p2.publisher.FeaturesAndBundlesPublisher \
  -metadataRepositoryName 'Google Cloud Tools for Eclipse' \
  -metadataRepository file:"${NEW_REPO}" \
  -artifactRepositoryName 'Google Cloud Tools for Eclipse' \
  -artifactRepository file:"${NEW_REPO}" \
  -source "${SIGNED_JAR_DIR}" \
  -publishArtifacts \
  -compress

cp "${KOKORO_GFILE_DIR}/index.html" "${NEW_REPO}"

ls -lR "${NEW_REPO}"

###############################################################################
# Add additional p2 metadata to the new repo.

# Renaming required for the p2 ProductPublisher
mv "${KOKORO_GFILE_DIR}/metadata/metadata.p2.inf" \
   "${KOKORO_GFILE_DIR}/metadata/p2.inf"

"${ECLIPSE_BIN}" -nosplash -console -consolelog \
  -application org.eclipse.equinox.p2.publisher.ProductPublisher \
  -metadataRepository file:"${NEW_REPO}" \
  -productFile "${KOKORO_GFILE_DIR}/metadata/metadata.product" \
  -flavor tooling \
  -append \
  -compress

ls -lR "${NEW_REPO}"
