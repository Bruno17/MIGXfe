/*
a fix in Ext JS 4.2.1 that adds the x-border-box class to top level components instead of the html tag.
see: http://www.sencha.com/forum/showthread.php?260608-New-theme-CSS-breaks-other-CSS-on-the-page
*/

Ext.define('Ext.BorderBoxFix', {
    override: 'Ext.AbstractComponent',
    initStyles: function(targetEl) {
        this.callParent(arguments);
        if (Ext.isBorderBox && !this.ownerCt) {
            targetEl.addCls(Ext.baseCSSPrefix + 'border-box');
        }
    }
});


Ext.onReady(function() {
    Ext.fly(document.documentElement).removeCls(Ext.baseCSSPrefix + 'border-box');
});


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

Ext.define('MigxFe.combo.Browser' ,{
    extend: 'Ext.form.field.Trigger',
    alias: 'widget.migx-combo-browser',
    triggerAction: 'all',
    dialog: 'init',
    onTriggerClick : function(btn){
        if (this.disabled){
            return false;
        }
        //console.log(this);
        dialog = MigxFe.app.openBrowser(this);
        if (dialog){
            this.dialog = dialog;
        }
    },    
    initComponent: function() {
        var field = Ext.get(this.valuename);
        this.callParent(arguments);
        if (field){
            this.setValue(field.getValue());
        }    
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
    [[+customhandlers]]
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
            win=_this.createWin(params,config,button);
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
    createWin: function(params,config,el){
            var el = el;
            if (typeof(el) != 'undefined'){
                win_x = el.win_x || false;
                win_y = el.win_y || false;
                win_width = el.win_width || false;
                win_height = el.win_height || false;
            }
           
            var win = Ext.create('widget.migxUpdatewindow', {
                //id: data.win_id,
                title: config.win_title || '',
                header: {
                     titleAlign: 'center'
                },
                closable: true,
                modal: true,
                maximizable: true,
                closeAction: 'destroy',
                width: win_width || 1000,
                minWidth: 350,
                height: win_height || 600,
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
                        fn: function(){
                            if (typeof(el) != 'undefined'){
                                el.win_x = this.x;
                                el.win_y = this.y;
                                el.win_width = this.width;
                                el.win_height = this.height;
                            }    
                        }
                    }
                }
                
            }); 
            if (typeof(el) != 'undefined'){
                if (el.win_x){
                    win.x = el.win_x;
                }
                if (el.win_y){
                    win.y = el.win_y;
                }
            }            
            return win;
            
                   
    }

    ,openBrowser: function(field){
            
            var params = field.params || {};
            params['HTTP_MODAUTH'] = '[[+auth]]';
            params['action'] = 'web/browser/elfinderconnector';
            params['wctx'] = '[[+wctx]]';            
            
            //console.log(typeof(field.dialog));
            //console.log(field.dialog);
            
            if (field.dialog != 'init' ){
                //console.log(field.dialog.dialogelfinder('instance'));
                //field.dialog.dialogelfinder('instance').sync();
                //field.dialog.dialogelfinder('destroy');
            }
            console.log(typeof(field.dialog));

            //console.log(params);
         
            var dialog = $('#elfinder').dialogelfinder({
                url: 'assets/components/migxfe/connector.php',
                modal: true,
                customData : params,                
                commandsOptions: {
                    getfile: {
                        oncomplete: 'close'
                        //,multiple : true
                    }
                }
                ,getFileCallback: function(file) {
                    console.log(this.fm.field);
                    console.log(field);
                    this.fm.field.setValue(file.path.replace('//',''));
                    //select_elfinder_files(files)
                    //fileCopier(files);
                }
                ,handlers : {
                    /*
                    select : function(event, elfinderInstance) {
                        selected_files = event.data.selected;
                    }
                    */
                }
            });

            var dialog_instance = $('#elfinder').dialogelfinder('instance');
            console.log(typeof(dialog_instance.initialised));
            if (typeof(dialog_instance.initialised) != 'undefined'){
                if (dialog_instance.visible()){
                    //if dialog open, do nothing    
                } else {
                    if (dialog_instance.initialised){
                        dialog_instance.customData = params;
                        dialog_instance.options.customData = params;
                        dialog_instance.sync();
                        dialog.dialogelfinder('open');  
                    }                    
                }
            }
            console.log(dialog_instance);
            console.log('visible:' + dialog_instance.visible());

            
            dialog.css('top','50');
            console.log(dialog.css('z-index'));
            dialog.css('z-index','100000');
            dialog_instance.initialised = true;
            dialog_instance.field = field;
            
            return dialog;
    }         
    
});
