FROM docker.io/shenxn/protonmail-bridge:3.19.0-1

# Bridge's internal self-updater silently downloads newer releases at
# runtime (independent of this image's tag) and refuses to fall back to
# the version baked into the base image if the download fails to launch.
# Newer releases (>=3.25.0) link against libfido2 for hardware security
# key support, which the base image does not ship, so an in-place
# self-update crashes the container outright. Install it so a
# self-update can actually start instead of crash-looping.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libfido2-1 \
    && rm -rf /var/lib/apt/lists/*
