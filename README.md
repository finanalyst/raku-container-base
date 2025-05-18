
# Raku docker container base

----

## Table of Contents

<a href="#Introduction">Introduction</a>   
<a href="#Rationale">Rationale</a>   
<a href="#Useage">Useage</a>   
&nbsp;&nbsp;- <a href="#Base_with_Cro">Base with Cro</a>   
<a href="#Base_with_Rakuast::RakuDoc::Render">Base with Rakuast::RakuDoc::Render</a>   


<span class="para" id="e3d0f66"></span>This repository is not a *Raku* module per se. It only contains Docker files with Github CI to create images. 

<div id="Introduction"></div>

## Introduction
<span class="para" id="3cf8b77"></span>Two base containers are created using Alpine that are syncronised to the current Rakudo release and the associated `zef`. 

<span class="para" id="7588534"></span>These images are **NOT** intended to be run as containers! The images are intended as base containers with 



1. Base with Cro  



&nbsp;&nbsp;&nbsp;&nbsp;▹ raku  
&nbsp;&nbsp;&nbsp;&nbsp;▹ zef  
&nbsp;&nbsp;&nbsp;&nbsp;▹ Cro (and its dependents)  


2. Base with CRO and Rakuast-RakuDoc-Render  

<div id="Rationale"></div>

## Rationale
<span class="para" id="ae511e0"></span>Raku base images either have too much or too little. The Rakudo-star image has way too many modules, while the images produced by **JJ** (many thanks to him), change the user to `raku`, and the images on `rakuland` remove some important dependencies. 

<span class="para" id="0cc7af4"></span>Some Raku modules need `git` to be installed, and a few require `make` and `gcc`. 

<span class="para" id="cdd5615"></span>Cro requires `open-ssl-dev` library to be available, while Rakuast-RakuDoc-Render requires *sass* and *graphviz*. All of these can be installed on an Alpine based docker container, but the base images needs to be retained and the user should still be `root`. 

<div id="Useage"></div>

## Useage
<span class="para" id="e7b2fc9"></span>The following are examples with the recommended addition of an appuser and the removal of base dependencies. 


<div id="Base with Cro"></div><div id="Base_with_Cro"></div>

### Base with Cro

```
FROM docker.io/finanalyst/raku-cro-base

# set up a directory for the new Raku module
RUN mkdir /app

# copy in the user's Raku module code, including META6.json if necessary
COPY . /app

# install the main Raku dependencies with zef

WORKDIR /app
RUN zef . --deps-only -/test

# any other tests.
# perhaps run a compile only to eliminate any compile time errors, eg
RUN raku -I. -c service.raku

# Now prepare for production

# remove unneeded dependents
RUN apk del gcc linux-headers make musl-dev perl

# create a new user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

#add a CMD if necessary, eg.
CMD raku -I. service.raku
```

<div id="Base with Rakuast::RakuDoc::Render"></div><div id="Base_with_Rakuast::RakuDoc::Render"></div>

## Base with Rakuast::RakuDoc::Render

```
FROM docker.io/finanalyst/raku-cro-rrr-base

# set up a directory for the new Raku module
RUN mkdir /app

# copy in the user's Raku module code, including META6.json if necessary
COPY . /app

# install the main Raku dependencies with zef

WORKDIR /app
RUN zef . --deps-only -/test

# any other tests.
# perhaps run a compile only to eliminate any compile time errors, eg
RUN raku -I. -c service.raku

# Now prepare for production

# remove unneeded dependents
RUN apk del gcc linux-headers make musl-dev perl

# create a new user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

#add a CMD if necessary, eg.
CMD raku -I. service.raku
```



----

----

Rendered from docs/README.rakudoc/README at 13:46 UTC on 2025-05-18

Source last modified at 13:45 UTC on 2025-05-18

