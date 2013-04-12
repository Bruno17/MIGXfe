{foreach from=$category.tvs item=tv name='tv'}

{if $tv->type EQ "description_is_code"}
<div class="x-form-item x-tab-item {cycle values=",alt"} modx-tv" id="tv{$tv->id}-tr" style="padding: 10px 0 0 ;">
    {$tv->description}
    <br class="clear" />
</div>    
{elseif $tv->type NEQ "hidden"}
    <div class="x-form-item x-tab-item {cycle values=",alt"} modx-tv" id="tv{$tv->id}-tr" style="padding: 10px 0 0 ;">
        <label for="tv{$tv->id}" class="x-form-item-label modx-tv-label" style="width: auto;margin-bottom: 10px;">
            <div class="modx-tv-label-title"> 
                {if $showCheckbox}<input type="checkbox" name="tv{$tv->id}-checkbox" class="modx-tv-checkbox" value="1" />{/if}
                <span class="modx-tv-caption" id="tv{$tv->id}-caption">{$tv->caption}</span>
            </div>    
            <a class="modx-tv-reset" id="modx-tv-reset-{$tv->id}" onclick="MODx.resetTV({$tv->id});" title="{$_lang.set_to_default}"></a>
            
            {if $tv->description}<span class="modx-tv-label-description">{$tv->description}</span>{/if}
        </label>
        {if $tv->inherited}<br /><span class="modx-tv-inherited">{$_lang.tv_value_inherited}</span>{/if}
        <div class="x-form-clear-left"></div>
        <div class="x-form-element modx-tv-form-element" style="padding-left: 0px;">
            <input type="hidden" id="tvdef{$tv->id}" value="{$tv->default_text|escape}" />
            {$tv->get('formElement')}
        </div>

        <br class="clear" />
    </div>
    <script type="text/javascript">{literal}Ext.onReady(function() { new Ext.ToolTip({{/literal}target: 'tv{$tv->id}-caption',html: '[[*{$tv->name}]]'{literal}});});{/literal}</script>
{else}
    <input type="hidden" id="tvdef{$tv->id}" value="{$tv->default_text|escape}" />
    {$tv->get('formElement')}
{/if}
    {/foreach}