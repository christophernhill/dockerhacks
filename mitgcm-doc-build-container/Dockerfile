# Dockerfile to build Ubuntu Linux image for working with MITgcm documentation
# To build image:
#   docker build -t mitgcm/doc-build:ubuntu1804 .
#
FROM ubuntu:18.04

COPY  setup_base.sh setup_base.sh
RUN ./setup_base.sh

COPY  setup_packages.sh setup_packages.sh
RUN ./setup_packages.sh

COPY  setup_conda.sh setup_conda.sh
RUN   ./setup_conda.sh

CMD "/bin/bash"
