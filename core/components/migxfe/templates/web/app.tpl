Ext.application({
    name: 'MigxFe',
    launch: function() {
         this.tb = Ext.create('Ext.toolbar.Toolbar',{
            renderTo: 'migxfe-toolbar',
            items:[ [[+buttons]] ]
        });
    },
    onButtonClick: function(){
        var _this= MigxFe.app;
        var data = this.data;
        data.btn_id = this.id;
        data.win_id = 'win-migxfe-'+data.btn_id;
        console.log(this);
        var button = this.getEl();
        var win = Ext.getCmp(data.win_id);
        if (!win){
            win=_this.createWin(data);
        }
        button.dom.disabled = true;
        if (win.isVisible()) {
            win.close();
        } else {
            win.show(this, function() {
                button.dom.disabled = false;
            });
        }        
    },
    createWin: function(data){
            return Ext.create('widget.window', {
                id: data.win_id,
                title: data.win_title,
                header: {
                     titleAlign: 'center'
                },
                closable: true,
                maximizable: true,
                closeAction: 'destroy',
                width: 600,
                minWidth: 350,
                height: 350,
                tools: [],
                layout: 'anchor',
                buttons: [{
                    text: '[[%cancel]]',
                    scope: this,
                    handler: function() {var win = Ext.getCmp(data.win_id); win.close(); }
                },{
                    text: '[[%done]]',
                    scope: this,
                    handler: function() {
                        var win = Ext.getCmp(data.win_id); 
                        win.form.submit();
                        
                    }
                }],                
                loader: {
                    url: 'assets/components/migxfe/connector.php',
                    params: {
                        action: data.action,
                        'HTTP_MODAUTH': '[[+auth]]',
                        configs: data.configs,
                        object_id: data.object_id,
                        resource_id: data.resource_id,
                        wctx: data.wctx,
                        field: data.field,
                        processaction: data.processaction,
                        btn_id: data.btn_id,
                        win_id: data.win_id,
                    },
                    loadMask: true,
                    autoLoad: true,
                    scripts: true
                },
                listeners:{
                    close:{
                        fn: function(){console.log(data);}
                    }
                }
                
            });        
    }
});
