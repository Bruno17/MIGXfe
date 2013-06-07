<?php

/**
 * Gets all files in a directory
 *
 * @param string $dir The directory to browse
 * @param boolean $prependPath (optional) If true, will prepend rb_base_dir to
 * the final path
 * @param boolean $prependUrl (optional) If true, will prepend rb_base_url to
 * the final url
 *
 * @var modX $modx
 * @var array $scriptProperties
 * @var modProcessor $this
 *
 * @package migxfe
 * @subpackage processors.web.browser
 */


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


class elfinderconnectProcessor extends modProcessor {
    /**
     *  * @var modMediaSource|modFileMediaSource $source */
    public $source;
    public function checkPermissions() {
        return $this->modx->hasPermission('file_list');
    }

    public function getLanguageTopics() {
        return array('file');
    }

    public function initialize() {
        $this->setDefaultProperties(array('dir' => '', ));
        if ($this->getProperty('dir') == 'root') {
            $this->setProperty('dir', '');
        }
        return true;
    }

    public function process() {
        if (!$this->getSource()) {
            return $this->failure($this->modx->lexicon('permission_denied'));
        }
        
        $this->source->setRequestProperties($this->getProperties());
        $this->source->initialize();
        
     
        if (!$this->source->checkPolicy('list')) {
            return $this->failure($this->modx->lexicon('permission_denied'));
        }
        
 
        /*
        [[!elfinderX_connector_multiselect? 
        &roots=`[{
        "rootpath":"[[!getUserDir]]",
        "hideurl":"1",
        "thumbPath":"assets/cache/.tmb/",
        "alias":"Home",
        "uploadAllow":["image"],
        "uploadOrder":["allow"]
        }]`
        ]]        
        */

        //$bases = $this->source->getBases();
        
        //echo $bases['path'];
        //echo $this->source->getBasePath();

        $props['roots'] = '[{
            "rootpath":"",
            "hideurl":"1",
            "alias":"/",
            "thumbPath":"assets/cache/.tmb/"
        }]';
        
        $props['defaultroot'] = '{
            "base_url":"'.$this->source->getBaseUrl().'",
            "base_path":"'.$this->source->getBasePath().'",
            "rootpath":"",
            "hideurl":"",
            "driver":"LocalFileSystem",
            "accessControl":"accessdemo"
        }';        

        $base_path = $this->modx->getOption('base_path', null, MODX_BASE_PATH);
        $base_url = $this->modx->getOption('base_url', null, MODX_BASE_URL);

        $elfinder = $this->modx->getService('elfinderx', 'ElfinderX', $this->modx->getOption('elfinderx.core_path', null, $this->modx->getOption('core_path') . 'components/elfinderx/') . 'model/elfinderx/', $props);
        if (!($elfinder instanceof ElfinderX))
            return '';

        return $elfinder->runConnector();

        $list = $this->source->getObjectsInContainer($this->getProperty('dir'));
        return $this->outputArray($list);
    }

    /**
     * Get the active Source
     * @return modMediaSource|boolean
     */
    public function getSource() {
        $this->modx->loadClass('sources.modMediaSource');
        $this->source = modMediaSource::getDefaultSource($this->modx, $this->getProperty('source'));
        if (empty($this->source) || !$this->source->getWorkingContext()) {
            return false;
        }
        return $this->source;
    }
}
return 'elfinderconnectProcessor';
