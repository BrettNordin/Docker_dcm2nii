#Pull Sub image.
FROM ubuntu:bionic-20201119

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    jq \
                    pigz \
                    jo && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Add a shared home folder
RUN useradd -m -s /bin/bash -G users dcmnii
WORKDIR /home/dcmnii
ENV HOME="/home/dcmnii"

COPY docker/scripts/dcm2niix /home/dcmnii/dcm2niix
COPY docker/scripts/dicomconvert.sh /home/dcmnii/dicom.sh


RUN find $HOME -type d -exec chmod go=u {} + && \
    find $HOME -type f -exec chmod go=u {} + && \
    rm -rf $HOME/.empty
RUN touch /home/dcmnii/dicom.sh
RUN chmod -R 777 /home/dcmnii/
RUN chmod 777 /home/dcmnii/dcm2niix
ENTRYPOINT ["/home/dcmnii/dicom.sh"]


ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="DCMNII" \
      org.label-schema.description="DICOM to Nifti Converter by Brett Nordin" \
      org.label-schema.url="https://sphub.net" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/BrettNordin/fMRIprep.dcm2niix" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"



