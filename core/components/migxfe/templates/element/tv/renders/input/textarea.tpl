{
        xtype: 'migx_textarea'
        ,id:'tv[[+tv.id]]'
        ,name:'tv[[+tv.id]]'
        ,width: '100%'
        ,height: 200
        ,cls: 'textfield'
        ,tvtype: '[[+tv.type]]'
        //,resizable: true
        //,resizeHandles: 's'
        ,enableKeyEvents: true
        ,msgTarget: 'under'
        ,fieldLabel:'[[+tv.caption]]'
        ,labelAlign:'top'
        ,valuename:'original[[+request.win_id]]-[[+tv.id]]'
        ,win_id:'[[+request.win_id]]'
        ,allowBlank: [[+params.allowBlank:is=`1`:then=`true`:else=`false`]] 
        [[+params.maxLength:isnot=``:then=`,maxLength:[[+params.maxLength]]`:else=``]]
        [[+params.minLength:isnot=``:then=`,minLength:[[+params.maxLength]]`:else=``]]  
        //,listeners: { 'keydown': { fn:MODx.fireResourceFormChange, scope:this}}
    }