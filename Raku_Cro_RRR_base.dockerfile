FROM docker.io/finanalyst/raku-cro-base
RUN zef install --/test 'Rakuast::RakuDoc::Render'
