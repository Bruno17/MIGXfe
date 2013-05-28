{
        xtype: 'livesearch'
        ,id: 'tv[[+tv.id]]-[[+request.win_id]]'
        ,name: 'tv[[+tv.id]]'
        ,triggerAction: 'all'
        ,allowBlank: '[[+params.allowBlank:is=`1`:then=`true`:else=`false`]]'
        [[+params.title:isnot=``:then=`,title:[[+params.title]]`:else=``]]
        [[+params.listWidth:isnot=``:then=`,listWidth:[[+params.listWidth]]`:else=``]]
        [[+params.maxHeight:isnot=``:then=`,maxHeight:[[+params.maxHeight]]`:else=``]]
        [[+params.typeAhead:is=`1`:then=`
            ,typeAhead: true
            ,typeAheadDelay: [[+params.typeAheadDelay:isnot=``:then=`[[+params.typeAheadDelay]]`:else=`250`]]
        `:else=`
            ,typeAhead: false        
        `]]
        [[+params.listEmptyText:isnot=``:then=`,listEmptyText:[[+params.listEmptyText]]`:else=``]]
        ,forceSelection: '[[+params.forceSelection:is=`1`:then=`true`:else=`false`]]'
        ,msgTarget: 'under'
        ,fieldLabel:'[[+tv.caption]]'
        ,labelAlign:'top'
        ,valueField: 'value'
        ,displayField: 'text'
        ,inputoptions:'[[+inputoptions]]'
        ,valuename:'original[[+request.win_id]]-[[+tv.id]]'
        ,win_id:'[[+request.win_id]]'
        //,queryMode: 'local'
        ,hideTrigger:true
        ,anchor: '100%' 
        ,pageSize: 10          
        ,listConfig: {
            //loadingText: 'Searching...',
            //emptyText: 'No matching posts found.',

            // Custom rendering template for each item
            getInnerTpl: function() {
                return '{display}';
                }
            }         
        ,store: Ext.create('Ext.data.Store', {
            fields: ['value', 'text', 'display'],
            pageSize: 10,
            //data : Ext.decode('[[+inputoptions]]'),
            proxy: {
                type: 'ajax',
                url: 'assets/components/migx/connector.php',
                extraParams: {
                    'HTTP_MODAUTH':'[[+request.HTTP_MODAUTH]]',
                    'configs':'[[+request.configs]]',
                    'action':'mgr/migxdb/process',
                    'processaction':'getlivesearch'
                    }, 
                reader: {
                    type: 'json',
                    root: 'results',
                    totalProperty: 'total'
                }
            }            
        })        
        //,listeners: { 'select': { fn:MODx.fireResourceFormChange, scope:this}}
}
