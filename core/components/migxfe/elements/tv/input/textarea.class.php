<?php

/**
 * @package modx
 * @subpackage processors.element.tv.renders.mgr.input
 */
class modTemplateVarInputRenderTextarea extends modTemplateVarInputRenderMigxFe {
    public function getTemplate() {
        return 'element/tv/renders/input/textarea.tpl';
    }
    
    public function process($value, array $params = array()) {
        //print_r($params);
        //{if $params.allowBlank == 1 || $params.allowBlank == 'true'}true{else}false{/if}
    }

}


return 'modTemplateVarInputRenderTextarea';
