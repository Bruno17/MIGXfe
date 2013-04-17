{
        xtype: 'migx_textbox'
        ,id:'tv[[+tv.id]]-[[+request.win_id]]'
        ,name:'tv[[+tv.id]]'
        ,width: '100%'
        ,cls: 'textfield'
        ,tvtype: '[[+tv.type]]'
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
