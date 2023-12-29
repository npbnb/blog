FROM basey

COPY environment.yml /tmp/env.yml

RUN micromamba create -y -n example_post_1 && \
    micromamba install -y -n example_post_1 -f /tmp/env.yml && \
    micromamba clean --all --yes

ENV PATH="/root/micromamba/envs/example_post_1/bin:$PATH"
