FROM node:lts-buster-slim AS development
 
WORKDIR /usr/src/app
 
# COPY package.json ./package.json
# COPY package-lock.json ./package-lock.json
# RUN npm ci
 
COPY . .
 
EXPOSE 3000
 
CMD [ "npm", "start" ]
 
FROM development as dev-envs

RUN <<EOF
  apt-get update
  apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
  useradd -s /bin/bash -m vscode
  groupadd docker
  usermod -aG docker vscode
EOF

USER vscode

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

RUN echo "alias alias ll='ls -la'" >> ~/.bashrc

CMD [ "npm", "start" ]
