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
            win.hide(this, function() {
                button.dom.disabled = false;
            });
        } else {
            win.show(this, function() {
                button.dom.disabled = false;
            });
        }        
    },
    createWin: function(){
            this.win = Ext.create('widget.window', {
                id: 'win-migxfe-test',
                title: 'Layout Window with title <em>after</em> tools',
                header: {
                     titleAlign: 'center'
                },
                closable: true,
                maximizable: true,
                closeAction: 'hide',
                width: 600,
                minWidth: 350,
                height: 350,
                tools: [],
                layout: {
                    type: 'border',
                    padding: 5
                },
                items: [{
                    region: 'west',
                    title: 'Navigation',
                    width: 200,
                    split: true,
                    collapsible: true,
                    floatable: false
                }, {
                    region: 'center',
                    xtype: 'tabpanel',
                    items: [{
                        // LTR even when example is RTL so that the code can be read
                        rtl: false,
                        title: 'Bogus Tab',
                        html: '<p>Window configured with:</p><pre style="margin-left:20px"><code>header: {\n    titlePosition: 2,\n    titleAlign: "center"\n},\ntools: [{type: "pin"}],\nclosable: true</code></pre>'
                    }, {
                        title: 'Another Tab',
                        html: 'Hello world 2'
                    }, {
                        title: 'Closable Tab',
                        html: 'Hello world 3',
                        closable: true
                    }]
                }]
            });        
    }
});


/*
Ext.application({
  autoCreateViewport: false,
  launch: function() {
     Ext.create('YourApp.view.SomeView',{
         renderTo:Ext.getBody()
     })
  }
})
*/