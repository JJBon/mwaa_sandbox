FROM public.ecr.aws/hashicorp/terraform:1.1.0-alpha20211020
#FROM public.ecr.aws/hashicorp/terraform:0.13.7
RUN ls
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
        awscli \
    && rm -rf /var/cache/apk/*