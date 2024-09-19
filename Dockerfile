FROM debian:bookworm

ARG SLURM_VERSION
ARG SLURM_USER=slurm
ARG SLURM_GROUP=slurm

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

RUN groupadd -rg 1001 $SLURM_GROUP && useradd -rg $SLURM_GROUP -u 1001 $SLURM_USER
RUN groupmod -g 1002 munge && \
	usermod -g munge -u 1002 munge && \
	chown -R munge:munge /var/lib/munge && \
	chown -R munge:munge /etc/munge
RUN groupadd -rg 1003 slurmrestd && useradd -rg slurmrestd -u 1003 slurmrestd
