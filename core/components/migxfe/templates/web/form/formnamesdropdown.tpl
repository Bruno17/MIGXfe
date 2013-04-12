{if count($formnames) > 0}
{if $smarty.foreach.cat.first}
    <div class="x-form-item x-tab-item {cycle values=",alt"} modx-tv" id="tvFormname-tr">
        <label for="tvFormname" class="modx-tv-label">
            <span class="modx-tv-caption" id="tvFormname-caption">Formname</span>
            <span class="modx-tv-reset" ></span> 
            {if $tv->descriptionX}<span class="modx-tv-description">{$tv->descriptionX}</span>{/if}
        </label>
        <div class="x-form-element modx-tv-form-element" style="padding-left: 200px;">
        <select id="tvFormname" name="tvFormname">
            {foreach from=$formnames item=item}
	            <option value="{$item.value}" {if $item.selected} selected="selected"{/if}>{$item.text}</option>
            {/foreach}
        </select>
        </div>

        <br class="clear" />
    </div>
<script type="text/javascript">
// <![CDATA[
{literal}

MODx.combo.FormnameDropdown = function(config) {
    config = config || {};
    Ext.applyIf(config,{
        transform: 'tvFormname'
        ,id: 'tvFormname'
        ,triggerAction: 'all'
        ,width: 350
        ,allowBlank: true
        ,maxHeight: 300
        ,editable: false
        ,typeAhead: false
        ,forceSelection: false
        ,msgTarget: 'under'
        ,listeners: { 
		    'select': {fn:this.selectForm,scope:this}
		}});

    MODx.combo.FormnameDropdown.superclass.constructor.call(this,config);
    //this.config = config;
    //return this;
};
Ext.extend(MODx.combo.FormnameDropdown,Ext.form.ComboBox,{
	selectForm: function() {
		var win = Ext.getCmp('{/literal}modx-window-mi-grid-update-{$win_id}{literal}');
        //win.fp.autoLoad.params.record_json=this.baseParams.record_json;
        win.switchForm();
		//panel.autoLoad.params['context']=this.getValue();
		//panel.doAutoLoad();
		//MODx.fireResourceFormChange();
	}
});
Ext.reg('modx-combo-formnamedropdown',MODx.combo.FormnameDropdown);

    MODx.load({
        xtype: 'modx-combo-formnamedropdown'

    });
    {/literal}

// ]]>
</script>    
{/if}
{/if}