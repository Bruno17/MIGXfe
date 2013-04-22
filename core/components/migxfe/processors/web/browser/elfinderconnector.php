<?php


/**
 * Simple function to demonstrate how to control file access using "accessControl" callback.
 * This method will disable accessing files/folders starting from  '.' (dot)
 *
 * @param  string  $attr  attribute name (read|write|locked|hidden)
 * @param  string  $path  file path relative to volume root directory started with directory separator
 * @return bool|null
 **/
function accessdemo($attr, $path, $data, $volume) {
    return strpos(basename($path), '.') === 0 // if file/folder begins with '.' (dot)
        ? !($attr == 'read' || $attr == 'write') // set read+write to false, other (locked+hidden) set to true
        : null; // else elFinder decide it itself
}

/*
$props['roots'] = '[{
    "driver":"MySQL",
    "host":"localhost",
    "user":"XXX",
    "pass":"XXX",
    "db":"XXX",
    "base_path":"",
    "rootpath":"1",
    "thumbPath":"assets/cache/.tmb/",
    "hideurl":"1",
    "alias":"Home"    
    }]';
*/

$props['roots'] = '[{
    "rootpath":"",
    "hideurl":"1",
    "thumbPath":"assets/cache/.tmb/"
    }]';

$base_path = $modx->getOption('base_path', null, MODX_BASE_PATH);
$base_url = $modx->getOption('base_url', null, MODX_BASE_URL);

$elfinder = $modx->getService('elfinderx', 'ElfinderX', $modx->getOption('elfinderx.core_path', null, $modx->getOption('core_path') . 'components/elfinderx/') . 'model/elfinderx/', $props);
if (!($elfinder instanceof ElfinderX))
    return '';


return $elfinder->runConnector();