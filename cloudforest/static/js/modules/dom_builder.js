/**
 * 
 * http://localhost:8080/api/histories/f597429621d6eb2b/contents/f2db41e1fa331b3e/display
 * 
 * 
 * @param {*} conf_obj 
 */

function request(method, url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url);
        xhr.onload = resolve;
        xhr.onerror = reject;
        xhr.send();
    });
}

let build = function (conf_obj) {
    let { dom_id, href, history_id, dataset_id } = conf_obj;
    let url = href + `/api/histories/${history_id}/contents/${dataset_id}/display`;
    console.log(url);
    request('GET', url)
        .then(function (data) {
            let e = document.getElementById(dom_id);
            e.innerHTML = data.target.response;
        })
        .then(function (error) {
            console.log(error);
        })
}

export { build }