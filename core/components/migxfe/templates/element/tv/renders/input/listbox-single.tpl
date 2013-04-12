{
        xtype: 'listbox_single'
        ,id: 'tv[[+tv.id]]'
        ,name: 'tv[[+tv.id]]'
        ,triggerAction: 'all'
        ,width: 400
        ,allowBlank: '[[+params.allowBlank:is=`1`:then=`true`:else=`false`]]'
        [[+params.title:isnot=``:then=`,title:[[+params.title]]`:else=``]]
        [[+params.listWidth:isnot=``:then=`,listWidth:[[+params.listWidth]]`:else=``]]
        [[+params.maxHeight:isnot=``:then=`,maxHeight:[[+params.maxHeight]]`:else=``]]
        [[+params.typeAhead:is=`1`:then=`
            ,typeAhead: true
            ,typeAheadDelay: [[+params.typeAheadDelay:isnot=``:then=`[[+params.typeAheadDelay]]`:else=`250`]]
        `:else=`
            ,editable: false
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
        ,queryMode: 'local'
        ,store: Ext.create('Ext.data.Store', {
            fields: ['value', 'text'],
            data : Ext.decode('[[+inputoptions]]')
        })        
        //,listeners: { 'select': { fn:MODx.fireResourceFormChange, scope:this}}
}

