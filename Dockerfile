FROM debian:bookworm

ARG SLURM_VERSION

ARG SLURM_USER=slurm
ARG SLURM_UID=990

ARG SLURM_GROUP=slurm
ARG SLURM_GID=990

ARG MUNGE_UID=107
ARG MUNGE_GID=114

RUN apt-get update && apt-get upgrade --yes \
	libpmix-bin wget dpkg


RUN mkdir /build
RUN bash -c "for name in 'smd' 'smd-client' 'smd-slurmctld' 'smd-slurmdbd'; do \
	wget https://github.com/scalableminds/slurm-packages/releases/download/${SLURM_VERSION}/slurm-\${name}_${SLURM_VERSION}-1_amd64.deb -O /build/slurm-\${name}_${SLURM_VERSION}-1_amd64.deb; \
done"

COPY *.deb /build
RUN apt-get install --yes -f \
	/build/slurm-smd_$SLURM_VERSION-1_amd64.deb \
	/build/slurm-smd-client_$SLURM_VERSION-1_amd64.deb \
	/build/slurm-smd-slurmctld_$SLURM_VERSION-1_amd64.deb \
	/build/slurm-smd-slurmdbd_$SLURM_VERSION-1_amd64.deb

RUN groupadd -rg $SLURM_GID $SLURM_GROUP &&
	useradd -rg $SLURM_GROUP -u $SLURM_UID $SLURM_USER
RUN groupmod -g $MUNGE_GID munge && \
	usermod -g munge -u $MUNGE_UID munge && \
	chown -R munge:munge /var/lib/munge && \
	chown -R munge:munge /etc/munge
