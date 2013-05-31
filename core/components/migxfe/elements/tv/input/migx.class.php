<?php

/**
 * @var modX $this->modx
 * @var modTemplateVar $this
 * @var array $params
 *
 * @package modx
 * @subpackage processors.element.tv.renders.mgr.input
 */
class modTemplateVarInputRenderMigx extends modTemplateVarInputRenderMigxFe {
    public function process($value, array $params = array()) {

        $namespace = 'migx';
        $this->modx->lexicon->load('tv_widget', $namespace . ':default');
        //$properties = isset($params['columns']) ? $params : $this->getProperties();
        $properties = $params;

        require_once dirname(dirname(dirname(dirname(__file__)))) . '/model/migxfe/migxfe.class.php';
        $this->migx = new MigxFe($this->modx, $properties);
        
        
                
        /* get input-tvs */
        $this->migx->loadConfigs();

        //$default_formtabs = '[{"caption":"Default", "fields": [{"field":"title","caption":"Title"}]}]';
        $default_columns = '[{"header": "Title", "width": "160", "sortable": "true", "dataIndex": "title"}]';

        // get tabs from file or migx-config-table
        //$formtabs = $this->migx->getTabs();
        /* 
        if (empty($formtabs)) {
            // get them from input-properties
            $formtabs = $this->modx->fromJSON($this->modx->getOption('formtabs', $properties, $default_formtabs));
            $formtabs = empty($properties['formtabs']) ? $this->modx->fromJSON($default_formtabs) : $formtabs;
        }
        */
        //$inputTvs = $this->migx->extractInputTvs($formtabs);

        /* get base path based on either TV param or filemanager_path */
        $this->modx->getService('fileHandler', 'modFileHandler', '', array('context' => $this->modx->context->get('key')));

        $resource_array = array();
        //are we on a edit- or create-resource - managerpage?
        if (is_object($this->modx->resource)) {
            $resource_array = $this->modx->resource->toArray();
            $wctx = $this->modx->resource->get('context_key');
        } else {
            //try to get a context from REQUEST
            $wctx = isset($_REQUEST['wctx']) && !empty($_REQUEST['wctx']) ? $this->modx->sanitizeString($_REQUEST['wctx']) : '';
        }

        if (!empty($wctx)) {
            $this->migx->working_context = $wctx;
            $this->migx->source = $this->tv->getSource($wctx, false);
            
           
            //$workingContext = $this->modx->getContext($wctx);
            /*
            if (!$workingContext) {
            return $modx->error->failure($this->modx->lexicon('permission_denied'));
            }
            $wctx = $workingContext->get('key');
            */
        } else {
            //$wctx = $this->modx->context->get('key');
        }

        /* from image-TV do we need this somehow here?
        $source->setRequestProperties($_REQUEST);
        $source->initialize();
        $this->modx->controller->setPlaceholder('source',$source->get('id'));     
        */

        //$base_path = $modx->getOption('base_path', null, MODX_BASE_PATH);
        //$base_url = $modx->getOption('base_url', null, MODX_BASE_URL);

        $columns = $this->migx->getColumns();

        if (empty($columns)) {
            $columns = $this->modx->fromJSON($this->modx->getOption('columns', $properties, $default_columns));
            $columns = empty($properties['columns']) ? $this->modx->fromJSON($default_columns) : $columns;
        }

        $this->migx->loadLang();
        $lang = $this->modx->lexicon->fetch();
        $lang['migx_add'] = !empty($properties['btntext']) ? $properties['btntext'] : $lang['migx.add'];
        $lang['migx_add'] = str_replace("'", "\'", $lang['migx_add']);
        $this->migx->addLangValue('migx.add', $lang['migx_add']);
        $this->migx->migxlang['migx.add'] = $lang['migx_add'];

        $this->migx->prepareGrid($params, $this, $this->tv, $columns);
        //$grid = $this->migx->getGrid();
        
        //print_r($this->controller->getPlaceholders());  

        $filenames = array();
        $defaultpath = $this->migx->config['templatesPath'] . 'mgr/';
        $filename = 'iframewindow.tpl';
        if ($windowfile = $this->migx->findGrid($defaultpath, $filename, $filenames)) {
            //$this->setPlaceholder('iframewindow', $this->migx->replaceLang($this->modx->controller->fetchTemplate($windowfile)));
        }
        
        //$newitem[] = $item;
        $tv_value = $this->tv->processBindings($this->tv->get('value')); 
        $default_value = $this->tv->processBindings($this->tv->get('default_text'));
       
        if (empty($tv_value) && !empty($default_value) ){
           $tv_value = $default_value;
        }
        
        $rows = $this->migx->checkRenderOptions($this->modx->fromJson($tv_value));
        $tv_value = $this->modx->toJson($rows);
        
        $this->setPlaceholder('uniqueID', $this->modx->getOption('win_id', $_REQUEST, ''));
        $this->setPlaceholder('tv_type', 'migx');
        $this->setPlaceholder('tv_value', $tv_value);
        $this->setPlaceholder('i18n', $lang);
        $this->setPlaceholder('properties', $properties);
        $this->setPlaceholder('resource', $resource_array);
        $this->setPlaceholder('connected_object_id', $this->modx->getOption('object_id', $_REQUEST, ''));
        $this->setPlaceholder('base_url', $this->modx->getOption('base_url'));
        $this->setPlaceholder('myctx', $wctx);
        //$grid = 'migx';
        //echo $gridfile = $this->migx->config['templatesPath'] . 'web/grids/' . $grid . '.grid.tpl';
        //$this->setPlaceholder('grid', $this->migx->replaceLang($this->modx->controller->fetchTemplate($gridfile)));

    }
    
    public function getExtraScripts() {
        $grid = 'migx';
        $gridfile = $this->migx->config['templatesPath'] . 'web/grids/' . $grid . '.grid.tpl';
        return array($gridfile);
    }        
    
    public function getTemplate() {
        return 'element/tv/renders/input/migx.tpl';
    }
}
return 'modTemplateVarInputRenderMigx';
