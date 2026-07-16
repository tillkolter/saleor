# pylint: disable=W0401, W0614
SECRET_KEY = 'NOTREALLY'
from saleor.settings import *  # noqa

IS_TESTING = True
REMOTE = False

import logging
from django.db import connection
connection.force_debug_cursor = True

DEFAULT_CURRENCY = 'USD'

LANGUAGE_CODE = 'en-us'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3'
    },
    'test': {
        'ENGINE': 'django.db.backends.sqlite3'
    },
    'other': {
        'ENGINE': 'django.db.backends.sqlite3',
    }
}


STATICFILES_STORAGE = "django.contrib.staticfiles.storage.StaticFilesStorage"
