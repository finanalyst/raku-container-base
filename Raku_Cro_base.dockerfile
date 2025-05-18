FROM alpine:latest

ARG RAKU_RELEASE=2025.03

ENV PKGS="git make gcc musl-dev perl linux-headers bash openssl-dev"
ENV RAKULIB="inst#/home/raku/.raku"

RUN apk update && apk upgrade \
    && apk add --no-cache $PKGS \
    && git clone --depth 1 --branch ${RAKU_RELEASE} https://github.com/MoarVM/MoarVM.git \
    && cd MoarVM \
    && perl Configure.pl --prefix /usr \
    && make install\
    && cd .. \
    && git clone --depth 1 --branch ${RAKU_RELEASE} https://github.com/Raku/nqp.git \
    && cd nqp \
    && perl Configure.pl --backends=moar --prefix /usr \
    && make install \
    && cd .. \
    && git clone --depth 1 --branch ${RAKU_RELEASE} https://github.com/rakudo/rakudo.git \
    && cd rakudo \
    && perl Configure.pl --backends=moar --prefix /usr \
    && make install

ENV PATH="/usr/share/perl6/site/bin:$PATH"

ARG getopt=0.4.2
ARG prove6=0.0.17
ARG tap=0.3.14
ARG zef=v1.0.0

RUN git clone -b $zef https://github.com/ugexe/zef        \
 && raku -Izef/lib zef/bin/zef --/test install ./zef     \
    $([ -z $getopt ] || echo "Getopt::Long:ver<$getopt>") \
    $([ -z $prove6 ] || echo "App::Prove6:ver<$prove6>" ) \
    $([ -z $tap    ] || echo "TAP:ver<$tap>"            ) \
 && rm -rf zef

# install CRO
RUN zef install 'Cro::Core'
RUN zef install --/test 'Cro::HTTP'
RUN zef install --/test 'Cro::WebSocket'

