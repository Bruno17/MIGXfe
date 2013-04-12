<?php

/**
 * Loads the TV panel for MIGX.
 *
 * Note: This page is not to be accessed directly.
 *
 * @package migx
 * @subpackage processors
 */

class migxFormProcessor extends modProcessor {

    public function process() {
        //require_once dirname(dirname(dirname(__file__))) . '/model/migx/migx.class.php';
        //$migx = new Migx($this->modx);
        $modx = &$this->modx;

        $corePath = dirname(dirname(dirname(__file__))) . '/';
        require_once $corePath . 'model/chunkie/chunkie.class.inc.php';
        //require_once $modx->getOption('core_path') . 'model/modx/modtemplatevar.class.php';
        require_once $corePath . '/model/migxfe/modtemplatevarinputrendermigxfe.class.php';
        $template = '@FILE form.tpl';
        $controller = new revoChunkie($template, $corePath . 'templates/web/form/');

        $scriptProperties = $this->getProperties();

        // special actions, for example the selectFromGrid - action
        $tempParams = $this->modx->getOption('tempParams', $scriptProperties, '');
        $action = '';
        if (!empty($tempParams)) {
            $tempParams = $this->modx->fromJson($tempParams);
            if (array_key_exists('action', $tempParams) && !empty($tempParams['action'])) {
                $action = strtolower($tempParams['action']);
                if ($action == 'selectfromgrid') {
                    $scriptProperties['configs'] = !empty($tempParams['selectorconfig']) ? $tempParams['selectorconfig'] : $action;
                }
                $action = '_' . $action;
            }

        }

        //$controller->loadControllersPath();

        // we will need a way to get a context-key, if in CMP-mode, from config, from dataset..... thoughts??
        // can be overridden in custom-processors for now, but whats with the preparegrid-method and working-context?
        // ok let's see when we need this.
        $this->modx->migxfe->working_context = 'web';


        if ($this->modx->resource = $this->modx->getObject('modResource', $scriptProperties['resource_id'])) {
            $this->modx->migxfe->working_context = $this->modx->resource->get('context_key');

            //$_REQUEST['id']=$scriptProperties['resource_id'];
        }

        //$controller->setPlaceholder('_config', $this->modx->config);
        $task = $this->modx->migxfe->getTask();
        $filename = str_replace(array('.class', '.php'), '', basename(__file__)) . $action . '.php';
        $processorspath = $this->modx->migxfe->config['migxCorePath'] . 'processors/mgr/';
        $filenames = array();
        if ($processor_file = $this->modx->migxfe->findProcessor($processorspath, $filename, $filenames)) {
            $processor_file;
            include_once ($processor_file);
        }

        //$object = $this->modx->getObject('Angebote',$scriptProperties['angebot']);
        //if (empty($object)) return $this->modx->error->failure($this->modx->lexicon('quip.thread_err_nf'));
        //if (!$thread->checkPolicy('view')) return $this->modx->error->failure($this->modx->lexicon('access_denied'));

        //return $this->modx->error->success('',$angebot);

        //echo '<pre>'.print_r($angebot->toArray(),1).'</pre>';

        $sender = isset($sender) ? $sender : '';

        $this->modx->migxfe->loadConfigs(true, true, $scriptProperties, $sender);
        $tabs = $this->modx->migxfe->getTabs();

        $fieldid = 0;
        $allfields[] = array();
        $categories = array();
        $xtypes = array();

        $template = '@FILE fields.tpl';
        $this->modx->controller = new revoChunkie($template, $corePath . 'templates/web/form/');

        //needed because TVs are using smarty
        //$this->modx->getService('smarty', 'smarty.modSmarty');
        //$this->modx->controller = new MigxFormController($this->modx);
        //$this->modx->controller->loadTemplatesPath();
        $this->modx->controller->setPlaceholder('_config', $this->modx->config);
        $this->modx->migxfe->createForm($tabs, $record, $allfields, $categories, $scriptProperties, $xtypes);

        $formcaption = $this->modx->migxfe->customconfigs['formcaption'];

        //collect custom TV-xtypes
        $xtypesoutput = '';
        if (is_array($xtypes)) {
            foreach ($xtypes as $xtype) {
                if (file_exists($xtype)) {
                    $template = '@FILE '.$xtype;
                    $parser = new revoChunkie($template, '', false);
                    //print_r($parser->getPlaceholders());
                    $xtypesoutput .= $parser->render();
                }
            }
        }

        //$innerrows['tab']='Test';<- parse categories to tabs here
        //{if count($categories) < 2 OR ($smarty.foreach.cat.first AND $category.print_before_tabs)}

        $tabsoutput = array();
        if (is_array($categories)) {
            $i = 0;
            foreach ($categories as $category) {
                $i++;
                $template = '@FILE tab.tpl';
                $parser = new revoChunkie($template, $corePath . 'templates/web/form/');
                $parser->createVars($category);
                $parser->setPlaceholder('innerrows.input', implode(',', $category['inputs']));
                $is_xtab = count($categories) < 2 || ($i == 1 && $category['print_before_tabs']) ? '0' : '1';
                $parser->setPlaceholder('is_xtab', $is_xtab);
                //print_r($parser->getPlaceholders());
                $tabsoutput[] = $parser->render();
            }
        }
        $tabsoutput = implode(',', $tabsoutput);

        $innerrows['tab'] = $tabsoutput;
        $innercounts['tab'] = count($categories);

        $controller->setPlaceholder('xtypes', $xtypesoutput);
        $controller->setPlaceholder('formcaption', $this->modx->migxfe->renderChunk($formcaption, $record, false));
        $controller->setPlaceholder('fields', $this->modx->toJSON($allfields));
        $controller->setPlaceholder('customconfigs', $this->modx->migxfe->customconfigs);
        $controller->setPlaceholder('object', $object->toArray());
        $controller->setPlaceholder('innerrows', $innerrows);
        $controller->setPlaceholder('innercounts', $innercounts);
        $controller->setPlaceholder('request', $_REQUEST);
        $controller->setPlaceholder('migxfeconfig', $this->modx->migxfe->config);

        //$controller->setPlaceholder('win_id', $scriptProperties['tv_id']);
        $controller->setPlaceholder('win_id', isset($this->modx->migxfe->customconfigs['win_id']) ? $this->modx->migxfe->customconfigs['win_id'] : $scriptProperties['tv_id']);
        //$c->setPlaceholder('id_update_window', 'modx-window-midb-grid-update');
        $tabs_js = '';
        if (count($categories) > 1) {
            $template = '@FILE tabs_js.tpl';
            $parser = new revoChunkie($template, $corePath . 'templates/web/form/');
            $parser->createVars($controller->getPlaceholders());
            $tabs_js = $parser->render();
        }

        $controller->setPlaceholder('tabs_js', $tabs_js);

        if (!empty($_REQUEST['showCheckbox'])) {
            $controller->setPlaceholder('showCheckbox', 1);
        }

        //echo '<pre>' .print_r($controller->getPlaceholders(),1) .'</pre>';

        $output = $controller->render();
        //$this->modx->getParser();
        /*parse all non-cacheable tags and remove unprocessed tags, if you want to parse only cacheable tags set param 3 as false*/
        //$this->modx->parser->processElementTags('', $output, true, true, '[[', ']]', array(), $counts);

        return $output;

    }
}
return 'migxFormProcessor';
