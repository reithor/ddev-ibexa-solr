#!/usr/bin/env bash

#
DESTINATION_IBEXA="/solr-conf/server/ibexa"
DESTINATION_TEMPLATE="${DESTINATION_IBEXA}/template"
SOURCE_SOLR="/opt/solr/server/solr/configsets/_default"

if [ ! -f ${DESTINATION_IBEXA}/solr.xml ]; then
    cp /opt/solr/server/solr/solr.xml ${DESTINATION_IBEXA}
    cp ${SOURCE_SOLR}/conf/{solrconfig.xml,stopwords.txt,synonyms.txt} ${DESTINATION_TEMPLATE}
    sed -i.bak '/<updateRequestProcessorChain name="add-unknown-fields-to-the-schema".*/,/<\/updateRequestProcessorChain>/d' ${DESTINATION_TEMPLATE}/solrconfig.xml
    sed -i.bak2 's/${solr.autoSoftCommit.maxTime:-1}/${solr.autoSoftCommit.maxTime:20}/' ${DESTINATION_TEMPLATE}/solrconfig.xml
fi

if [ ! -d ${DESTINATION_IBEXA}/collection1/ ]; then
    /opt/solr/bin/solr -s ${DESTINATION_IBEXA}
    /opt/solr/bin/solr create_core -c collection1 -d ${DESTINATION_TEMPLATE}
    /opt/solr/bin/solr stop -all
fi

# make new files writable from docker host
chmod -R uga+w "${DESTINATION_IBEXA}/collection1/"
chmod -R uga+w "${DESTINATION_IBEXA}/filestore/"
chmod -R uga+w "${DESTINATION_IBEXA}/userfiles/"
chmod uga+w "${DESTINATION_IBEXA}/solr.xml"

/opt/solr/bin/solr -s ${DESTINATION_IBEXA} -f
