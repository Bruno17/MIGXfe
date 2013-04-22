<?php

/**
 * An abstract class meant to be used by TV renders. Do not extend this class directly; use its Input or Output
 * derivatives instead.
 *
 * @package modx
 */
abstract class modTemplateVarRenderMigxFe {
    /**
     @var modTemplateVar $tv */
    public $tv;
    /**
     @var modX $modx */
    public $modx;
    /**
     @var array $config */
    public $config = array();

    function __construct(modTemplateVar $tv, array $config = array()) {

        $corePath = dirname(dirname(dirname(__file__))) . '/';
        $this->tv = &$tv;
        $this->modx = &$tv->xpdo;
        $this->config = array_merge($this->config, $config);
        $template = $this->getTemplate();

        $xtype_template = str_replace('.tpl', '.xtype.tpl', $template);
        $this->tv->set('xtype_template', $corePath . 'templates/' . $xtype_template);
        $this->controller = new migxfeChunkie('@FILE ' . $template, $corePath . 'templates/');
        $this->setReplaceonlyfields('tv.value');

    }

    /**
     * Get any lexicon topics for your render. You may override this method in your render to provide an array of
     * lexicon topics to load.
     * @return array
     */
    public function getLexiconTopics() {
        return array('tv_widget');
    }

    /**
     * Render the TV render.
     * @param string $value
     * @param array $params
     * @return mixed|void
     */
    public function render($value, array $params = array()) {
        $this->_loadLexiconTopics();
        return $this->process($value, $params);
    }

    /**
     * Load any specified lexicon topics for the render
     */
    protected function _loadLexiconTopics() {
        $topics = $this->getLexiconTopics();
        if (!empty($topics) && !is_array($topics)) {
            foreach ($topics as $topic) {
                $this->modx->lexicon->load($topic);
            }
        }
    }

    /**
     * Set some placeholders as not to be processed
     * @param string $k
     * @param mixed $v
     */
    public function setReplaceonlyfields($f = '') {

        $this->controller->setReplaceonlyfields($f);
    }

    /**
     * @param string $value
     * @param array $params
     * @return void|mixed
     */
    public function process($value, array $params = array()) {
        return $value;
    }
}
/**
 * An abstract class for extending Input Renders for TVs.
 * @package modx
 */
abstract class modTemplateVarInputRenderMigxFe extends modTemplateVarRenderMigxFe {
    public function render($value, array $params = array()) {

        $this->setPlaceholder('tv', $this->tv->toArray());
        $this->setPlaceholder('id', $this->tv->get('id'));
        $this->setPlaceholder('ctx', isset($_REQUEST['ctx']) ? $_REQUEST['ctx'] : 'web');
        $this->setPlaceholder('params', $params);
        $this->setPlaceholder('request', $_REQUEST);

        $output = parent::render($value, $params);

        $tpl = $this->controller->render();

        $extraScripts = $this->getExtraScripts();
        if (count($extraScripts) > 0) {
            foreach ($extraScripts as $script) {
                if (file_exists($script)) {
                    $template = '@FILE ' . $script;
                    $this->controller->setBasepath('');
                    $template = $this->controller->getTemplate($template);
                    $this->controller->setTemplate($template);                    
                    echo $this->controller->render();
                }
            }
        }

        return !empty($tpl) ? $tpl : $output;
    }


    /**
     * Set a placeholder to be used in the template
     * @param string $k
     * @param mixed $v
     */
    public function setPlaceholder($k, $v) {
        $this->controller->setPlaceholder($k, $v);
    }

    /**
     * Return the template path to load
     * @return string
     */
    public function getTemplate() {
        return '';
    }

    /**
     * Return additional scripts for the TV
     * @return array
     */
    public function getExtraScripts() {
        return array();
    }

    /**
     * Return the input options parsed for the TV
     * @return mixed
     */
    public function getInputOptions() {
        return $this->tv->parseInputOptions($this->tv->processBindings($this->tv->get('elements'), $this->modx->resource->get('id')));
    }
}
