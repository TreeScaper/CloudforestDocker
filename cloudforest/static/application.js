import { build, file_chooser } from './js/modules/dom_builder.js';
import { make_request } from './js/modules/promises.js';
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
    let history_contents = undefined;

    let run = function () {
        let url = href + `/api/histories/${historyID}/contents`;
        make_request('GET', url)
            .then(function (data) {
                history_contents = JSON.parse(data);
                file_chooser(history_contents);
                build({
                    dom_id: dom_base,
                    href: href,
                    history_id: historyID,
                    dataset_id: datasetID
                });
            })
            .catch(function (err) {
                console.error('Augh, there was an error!', err.statusText);
            })
    };

    return {
        run
    };
}

export { CloudForest }
