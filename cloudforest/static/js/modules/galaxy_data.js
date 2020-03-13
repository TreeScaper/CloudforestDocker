/**
 * This module is the data source for the CloudForest js application.
 * It is tied very closely to Galaxy, while allowing the CloudForest js app
 * to be unaware of the ultimate data source.
 * 
 * dbkey: '${hda.get_metadata().dbkey}',
            href: document.location.origin,
            dataName: '${hda.name}',
            historyID: '${trans.security.encode_id( hda.history_id )}',
            datasetID: '${trans.security.encode_id( hda.id )}',
            dom_base: 'start_div',
 */

let make_request = function (method, url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url);
        xhr.onload = function () {
            if (this.status >= 200 && this.status < 300) {
                resolve(xhr.response);
            } else {
                reject({
                    status: this.status,
                    statusText: xhr.statusText
                });
            }
        };
        xhr.onerror = function () {
            reject({
                status: this.status,
                statusText: xhr.statusText
            });
        };
        xhr.send();
    });
}

let GalaxyData = function (conf_object) {
    let { href, dataName, historyID, datasetID, dom_base, subscribe, publish, unsubscribe } = conf_object;
    let url = href + `/api/histories/${historyID}/contents`;
    let valid_files = undefined;

    subscribe('FooFoo', function () {
        console.log('Got a FooFoo event');
    });

    let get_files = async function () {
        make_request('GET', url)
            .then(function (data) {
                let history_contents = JSON.parse(data);
                valid_files = history_contents.filter(f => {
                    return f.status === 'ok' && f.purged === false;
                });
                return valid_files.map(f => { return f.name });
            })
            .catch(function (err) {
                console.error(`There was an error: ${err.statusText}`);
            });
    }
    return {
        get_files
    };
}

export { GalaxyData }