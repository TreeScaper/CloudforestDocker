

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
    let galaxy_config = config;
    let run = function () {
        let base_elem = document.getElementById(galaxy_config.dom_base);
        base_elem.innerHTML = 'Hello I must be going.';
    };
    return {
        run
    };
}
