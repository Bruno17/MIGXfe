
Ext.application({
    name: 'MigxFe',
    launch: function() {
         this.tb = Ext.create('Ext.toolbar.Toolbar',{
            renderTo: 'migxfe-toolbar',
            items:[{
                id: 'show-btn',
                text: 'Users',
                iconCls: 'user',
                handler: this.onButtonClick
            }]
        });
    },
    onButtonClick: function(){
        var _this= MigxFe.app;
        var button = Ext.get('show-btn');
        var win = null;
        if (!_this.win){
            _this.createWin();
        }
        win = _this.win;
        button.dom.disabled = true;
        if (win.isVisible()) {
            _this.win = false;
            win.close();
        } else {
            win.show(this, function() {
                button.dom.disabled = false;
            });
        }        
    },
    createWin: function(){
            var config = [];
            this.win = Ext.create('widget.window', {
                id: 'win-migxfe-test',
                title: 'Layout Window with title <em>after</em> tools',
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
                    text: config.cancelBtnText || '[[%cancel]]',
                    scope: this,
                    handler: function() { this.close(); }
                },{
                    text: config.saveBtnText || '[[%done]]',
                    scope: this,
                    handler: this.submit
                }],                
                loader: {
                    url: 'assets/components/migxfe/connector.php',
                    params: {
                        action: 'web/fields'
                    },
                    autoLoad: true,
                    scripts: true
                },
                listeners:{
                    close:{
                        fn: function(){console.log('close');  MigxFe.app.win = false; }
                    }
                }
                
            });        
    }
});



