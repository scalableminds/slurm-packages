FROM debian:bookworm

ARG SLURM_VERSION
ARG SLURM_USER=slurm
ARG SLURM_GROUP=slurm

RUN apt-get update && apt-get upgrade --yes \
	libpmix-bin

RUN for name in "" "-client" "-slurmctld" "-slurmdbd"; do \
	curl https://github.com/scalableminds/slurm-packages/releases/download/${SLURM_VERSION}/slurm-smd${name}_${SLURM_VERSION}-1_amd64.deb \
		-o /build/slurm-smd${name}_${SLURM_VERSION}-1_amd64.deb \
done

RUN mkdir /build
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
