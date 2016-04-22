# rails_friendly_extensions

[![Build Status](https://travis-ci.org/florianeck/rails_friendly_extensions.png?branch=master)](https://travis-ci.org/florianeck/rails_friendly_extensions)

## Migrating from old versions to 0.1

The Labels have been moved from database to locale YAML files.

Please run `rake friendly_extensions:migrate_old_labels` to copy labels from database to yaml file

After that run `rake friendly_extensions:install:migrations` to copy the migration that drops the labels table

======

This is my personal lib to extend Rails basic methods for String, Date, Number, Hash and serveral other classes just for easy use...

To get an idea of what this plugin provides, you can easyli generate the documentation with the `rdoc` command. Also the lib folder contains all methods ordered by the class which is extended.
Most of the features are tested as well.


## Current documentation status:

    Files:       12

    Classes:      1 ( 1 undocumented)
    Modules:     11 ( 6 undocumented)
    Constants:    7 ( 1 undocumented)
    Attributes:   0 ( 0 undocumented)
    Methods:     94 (55 undocumented)

    Total:      113 (63 undocumented)
     44.25% documented