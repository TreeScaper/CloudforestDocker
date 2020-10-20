from galaxy.datatypes import data
from galaxy.datatypes.metadata import MetadataElement

import os
import logging

log = logging.getLogger(__name__)


class CloudForest(data.Text):
    file_ext = "cloudforest"


class CloudForestTrees(CloudForest):
    file_ext = "cloudforest.trees"

    def sniff(self, filename):
        try:
            line = str(open(filename).readline())
            line = line.strip()
            if line.startswith('#NEXUS'):   
                return True
            if  line.startswith('(') and line.endswith(');'):
                return True
            return False
        except Exception:
            return False
