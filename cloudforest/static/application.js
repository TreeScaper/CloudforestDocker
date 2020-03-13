import { build } from './js/modules/dom_builder.js'

/**
 * dbkey: '${hda.get_metadata().dbkey}',
            href: document.location.origin,
            dataName: '${hda.name}',
            historyID: '${trans.security.encode_id( hda.history_id )}',
            datasetID: '${trans.security.encode_id( hda.id )}',
            dom_base: 'start_div',
 * @param {*} conf_obj 
 */

var CloudForest = function (config) {
    let { href, dataName, historyID, datasetID, dom_base } = config;
    let run = function () {
        build({
            dom_id: dom_base,
            href: href,
            history_id: historyID,
            dataset_id: datasetID
        });
    };
    return {
        run
    };
}

export { CloudForest }
