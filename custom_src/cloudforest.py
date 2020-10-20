from galaxy.datatypes import data

import os
import logging

log = logging.getLogger(__name__)

class CloudForest(data.Text):
   def __init__(self, **kwd):
        data.Text.__init__(self, **kwd)

class CloudForestCoordinates(CloudForest):
    file_ext = "cloudforest.coordinates"
    
    def __init__(self, **kwd):
        CloudForest.__init__(self, **kwd)

class CloudForestCovariance(CloudForest):
    file_ext = "cloudforest.covariance"
    
    def __init__(self, **kwd):
        CloudForest.__init__(self, **kwd)

class CloudForestCD(CloudForest):
    file_ext = "cloudforest.cd"
    
    def __init__(self, **kwd):
        CloudForest.__init__(self, **kwd)

class CloudForestTrees(CloudForest):
    file_ext = "cloudforest.trees"

    def __init__(self, **kwd):
        CloudForest.__init__(self, **kwd)

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
