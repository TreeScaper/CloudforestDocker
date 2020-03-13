<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CloudForest Visualizations</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>

<body>

    <div class="container">
        <h2>Hello?</h2>
        <div id="start_div"></div>
    </div>

    <script src="/static/plugins/visualizations/cloudforest/static/js/libs/plotly-latest.min.js"></script>
    <script type="module">
            import {CloudForest} from "/static/plugins/visualizations/cloudforest/static/application.js";
            let config = {
                dbkey: '${hda.get_metadata().dbkey}',
                href: document.location.origin,
                dataName: '${hda.name}',
                historyID: '${trans.security.encode_id( hda.history_id )}',
                datasetID: '${trans.security.encode_id( hda.id )}',
                dom_base: 'start_div',
            };
            let cloudforest = CloudForest(config);
            cloudforest.run();
    </script>
</body>

</html>