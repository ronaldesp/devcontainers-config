ARG VARIANT="jammy"
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

SHELL ["bash", "-lc"]

# Install prerequisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl ca-certificates gnupg lsb-release apt-transport-https software-properties-common unzip wget \
       build-essential make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
       llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node LTS (20.x) via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 (default)
RUN add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y python3.12 python3.12-venv python3.12-distutils \
    && ln -sf /usr/bin/python3.12 /usr/local/bin/python3 \
    && ln -sf /usr/bin/python3.12 /usr/local/bin/python

# Install Python 3.13.7 in parallel via pyenv (fallback to latest 3.13 if exact patch unavailable)
ENV PYENV_ROOT=/usr/local/pyenv
ENV PATH=${PYENV_ROOT}/bin:${PATH}
RUN git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT} \
    && echo 'export PYENV_ROOT=/usr/local/pyenv' >> /etc/profile.d/pyenv.sh \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/profile.d/pyenv.sh \
    && echo 'eval "$(pyenv init -)"' >> /etc/profile.d/pyenv.sh \
    && eval "$(pyenv init -)" \
    && (pyenv install -s 3.13.7 || pyenv install -s 3.13.0 || pyenv install -s 3.13) \
    && pyenv rehash \
    && ln -sf ${PYENV_ROOT}/versions/3.13*/bin/python3 ${PYENV_ROOT}/versions/3.13*/bin/python3.13 \
    && ln -sf ${PYENV_ROOT}/versions/3.13*/bin/pip3 ${PYENV_ROOT}/versions/3.13*/bin/pip3.13 \
    && ln -sf ${PYENV_ROOT}/versions/3.13*/bin/python3.13 /usr/local/bin/python3.13 \
    && ln -sf ${PYENV_ROOT}/versions/3.13*/bin/pip3.13 /usr/local/bin/pip3.13

# Install .NET 8 SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN apt-get update \
    && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform 1.13.3
RUN wget -q https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_linux_amd64.zip \
    && unzip terraform_1.13.3_linux_amd64.zip -d /usr/local/bin \
    && rm terraform_1.13.3_linux_amd64.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | tee /usr/share/keyrings/cloud.google.gpg > /dev/null \
    && apt-get update -y \
    && apt-get install -y google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (bind mount host daemon)
RUN apt-get update \
    && apt-get install -y docker.io \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user if not present and add to docker group
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
      groupadd --gid ${USER_GID} ${USERNAME} && \
      useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}; \
    fi \
    && groupadd -f docker \
    && usermod -aG docker ${USERNAME}

USER ${USERNAME}
WORKDIR /workspaces

# Helper: switch to Python 3.13 for a session or single command
USER root
COPY scripts/use-py313 /usr/local/bin/use-py313
RUN chmod +x /usr/local/bin/use-py313
USER ${USERNAME}
