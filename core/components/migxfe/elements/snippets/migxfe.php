<?php

$migxfe = $modx->getService('migxfe', 'MigxFe', $modx->getOption('migxfe.core_path', null, $modx->getOption('core_path') . 'components/migxfe/') . 'model/migxfe/', $scriptProperties);
if (!($migxfe instanceof MigxFe))
    return '';


//Add needed js-files to the head

$properties = array();
//$properties['auth']=$_SESSION["modx.{$modx->context->get('key')}.user.token"];


$buttons = $modx->getOption('buttons',$scriptProperties,'');

if (!empty($buttons)){
    $buttons = $modx->fromJson($buttons);
}
else{
    $buttons = array(array(
        'configs'=>'childstutorial',
        'text'=> 'Edit Resource '.$modx->resource->get('id')
    ));
}

$buttonsoutput = array();
if (!empty($buttons)){
    if (is_array($buttons)){
        foreach ($buttons as $button){
            $prop['text'] = $modx->getOption('text',$button,'');
            $prop['iconCls'] = $modx->getOption('iconCls',$button,'');
            $prop['configs'] = $modx->getOption('configs',$button,'childstutorial');
            $prop['resource_id'] = $modx->getOption('resource_id',$button,$modx->resource->get('id'));
            $prop['object_id'] = $modx->getOption('object_id',$button,$modx->resource->get('id'));
            $prop['wctx'] = $modx->getOption('wctx',$button,$modx->resource->get('context_key'));
            $prop['field'] = $modx->getOption('field',$button,'');
            $prop['action'] = $modx->getOption('action',$button,'web/migxdb/fields');
            $prop['processaction'] = $modx->getOption('processaction',$button,'');
            $prop['win_title'] = $modx->getOption('win_title',$button,'');//Todo: get it from configs
            $prop['handler'] = $modx->getOption('handler',$button,'this.onButtonClick');
            $templatePath = $migxfe->config['templatesPath'].'web/button.tpl';
            $buttonsoutput[] = $migxfe->parseChunk($templatePath,$prop);            
        }
    }
}


$properties['buttons']= implode(',',$buttonsoutput);
$properties['auth']=$_SESSION["modx.mgr.user.token"];
$properties['resource_id']=$modx->resource->get('id');
$properties['wctx']=$modx->getOption('wctx',$scriptProperties,$modx->resource->get('context_key'));

/*
$properties['buttons']= '
{
                id: 'show-btn',
                text: 'Users',
                iconCls: 'user',
                data: {
                    'configs':'childstutorial',
                    'object_id':'27',
                    'resource_id':'[[+resource_id]]',
                    'wctx':'[[+wctx]]',
                    'field':'',
                    'action':'web/fields',
                    'processaction':'',
                    'win_id':'win-migxfe-test',
                    'win_title':'Test Window'
                    },
                handler: this.onButtonClick
            },{
                id: 'show-btn2',
                text: 'Users2',
                iconCls: 'user2',
                data: {
                    'configs':'childstutorial',
                    'object_id':'28',
                    'resource_id':'[[+resource_id]]',
                    'wctx':'[[+wctx]]',
                    'field':'',
                    'action':'web/fields',
                    'processaction':'',
                    'win_id':'win-migxfe-test2',
                    'win_title':'Test Window 2'
                    },
                handler: this.onButtonClick
            }
';
*/

$scriptPath = $migxfe->config['templatesPath'].'web/app.tpl';
$script = $migxfe->parseChunk($scriptPath,$properties);

$script = '<script type="text/javascript" charset="utf-8">' . $script . '</script>';

$modx->regClientStartupScript($script);

$toolbar = '<div id="migxfe-toolbar" style="width:100%;"></div>';
return $toolbar;