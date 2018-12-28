FROM node:10.15

ENV YARN_VERSION 1.12.3

RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz

RUN apt-get update && apt-get install -y unzip \
	&& curl -fSL https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz -o google-cloud-sdk.tar.gz \
	&& tar -xzf google-cloud-sdk.tar.gz \
	&& google-cloud-sdk/install.sh \
		--usage-reporting=false \
		--path-update=true \
		--bash-completion=false \
		--rc-path=/.bashrc \
	\
	&& google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true \
	&& sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH

ADD https://releases.hashicorp.com/vault/0.9.0/vault_0.9.0_linux_amd64.zip /tmp

WORKDIR /tmp
RUN unzip vault_0.9.0_linux_amd64.zip && mv vault /usr/local/bin
RUN chmod +x /usr/local/bin/vault

VOLUME ["/.config"]
CMD ["/bin/sh"]