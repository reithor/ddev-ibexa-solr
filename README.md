
# ddev-ibexa-solr

This repository allows you to quickly add *Solr* to an Ibexa DXP project running with ddev.

## Add Solr to an existing Ibexa DXP project

```

# run `ddev get` in Ibexa DXP project directory
ddev get reithor/ddev-ibexa-solr

# add solr config to .env.local
SEARCH_ENGINE=solr
SOLR_CORE=collection1
SOLR_DSN=http://solr:8983/solr

# restart & reindex
ddev restart
ddev php bin/console ibexa:reindex

```

