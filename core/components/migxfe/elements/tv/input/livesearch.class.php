<?php

/**
 * @package modx
 * @subpackage processors.element.tv.renders.mgr.input
 */
class modTemplateVarInputRenderLivesearch extends modTemplateVarInputRenderMigxFe {
    public function getTemplate() {
        return 'element/tv/renders/input/livesearch.tpl';
    }
    public function process($value, array $params = array()) {
        $options = $this->getInputOptions();
        $items = array();

        $tv_id = $this->tv->get('id');
        
        foreach ($options as $option) {
            $opt = explode("==", $option);
            if (!isset($opt[1]))
                $opt[1] = $opt[0];
            $item['text'] = htmlspecialchars($opt[0], ENT_COMPAT, 'UTF-8');
            $item['value'] = htmlspecialchars($opt[1], ENT_COMPAT, 'UTF-8');
            $item['selected'] = strcmp($opt[1], $value) == 0;

            $items[] = $item;
        }
        
        $this->setPlaceholder('dbvalue', $value);
        $this->setPlaceholder('inputoptions', $this->modx->toJson($items));
        $this->setPlaceholder('opts', $items);
        $this->setReplaceonlyfields('tv.value,dbvalue,inputoptions');
    }
    

    
}
return 'modTemplateVarInputRenderLivesearch';
