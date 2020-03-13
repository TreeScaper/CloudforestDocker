// import { make_request } from './promises.js';

// let active_files = undefined;

// let build = function (conf_obj) {
//     let { dom_id, href, history_id, dataset_id } = conf_obj;
//     let url = href + `/api/histories/${history_id}/contents/${dataset_id}/display`;
//     console.log(url);
//     make_request('GET', url)
//         .then(function (data) {
//             let e = document.getElementById(dom_id);
//             e.innerHTML = data;
//         })
//         .catch(function (error) {
//             console.log(error.statusText);
//         });
// }

// let file_chooser = function (files) {
//     active_files = files.filter(file => {
//         return file.state === 'ok' && file.purged === false;
//     });
//     active_files.forEach(f => {
//         console.log(`File ${f.name} is good.`);
//     })
// }


// export { build, file_chooser }