Ext.define('MigxFe.updatewindow' ,{
    extend: 'Ext.Window',
    alias: 'widget.migxUpdatewindow',

    initComponent: function() {
        this.getLoader().baseParams.win_id = this.getId();
        this.callParent(arguments);
        this.getLoader().load();
    },
    addButton: function(button){
        var DockedItems = this.getDockedItems('toolbar[dock="bottom"]');
        var toolbar = DockedItems[0];
        toolbar.add(button);
    }
    
    
});

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
        var config = this.data;
        var params = this.params;
        params.btn_id = this.id;
        //data.win_id = 'win-migxfe-'+data.btn_id;
        //console.log(data);
        var button = this.getEl();
        //var win = Ext.getCmp(data.win_id);
        var win = this.win;
        if (win && typeof(win.getEl())=='undefined'){
            win = false;
            this.win = false;
        }
        
        if (!win){
            win=_this.createWin(params,config);
            this.win = win;
        }
        button.dom.disabled = true;
        if (win.isVisible()) {
            //win.close();
        } else {
            win.show(this, function() {
                button.dom.disabled = false;
            });
        }        
    },
    createWin: function(params,config){
            return Ext.create('widget.migxUpdatewindow', {
                //id: data.win_id,
                title: config.win_title || '',
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
                buttons: [],               
                loader: {
                    url: 'assets/components/migxfe/connector.php',
                    baseParams: {
                        'HTTP_MODAUTH': '[[+auth]]'
                    },
                    params: params,
                    loadMask: true,
                    autoLoad: false,
                    scripts: true
                },
                listeners:{
                    close:{
                        fn: function(){console.log(this);}
                    }
                }
                
            });        
    }
});
