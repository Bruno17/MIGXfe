<script type="text/javascript">

Ext.define('MigxFe.input.migxValueHidden' ,{
    extend: 'Ext.form.Hidden',
    alias: 'widget.migxValueHidden',

    initComponent: function() {
        var win = Ext.getCmp(this.win_id);
        var field = Ext.get(this.valuename);
        this.callParent(arguments);
        if (field){
            this.setValue(field.getValue());
        }
        
    }
});

Ext.define('MigxFe.input.migxgridpanel' ,{
    extend: 'Ext.grid.GridPanel',
    alias: 'widget.migxgridpanel',

    initComponent: function() {
        var win = Ext.getCmp(this.win_id);        
        var field = Ext.get(this.valuename);
        this.callParent(arguments);
        if (field){
            console.log(field.getValue());
        }
    //this._makeTemplates();
    //this.getStore().pathconfigs=config.pathconfigs;
	this.loadData();
    //this.on('click', this.onClick, this);          
        
    }
	,loadData: function(){
	   console.log(this);
        var field = Ext.get(this.valuename);
        if (field){
           var items_string = field.getValue(); 
        }   
        else{
            return;
        }
	    
        var items = [];
        var item = {};
        try {
            items = Ext.decode(items_string);
        }
        catch (e){
        }
                
        this.autoinc = 0;
        for(i = 0; i <  items.length; i++) {
 		    item = items[i];
            if (item.MIGX_id){
                if (parseInt(item.MIGX_id)  > this.autoinc){
                    this.autoinc = item.MIGX_id;
                }
            }else{
                item.MIGX_id = this.autoinc +1 ;
                this.autoinc = item.MIGX_id;                 
            }	
           items[i] = item;  
        } 
        
		this.getStore().sortInfo = null;
		this.getStore().loadData(items);
			
    },getMenu: function() {
		var n = this.menu.record; 
        var m = [];
        m.push({
            text: '[[%migx.edit]]'
            ,handler: this.update
            
        });
        m.push({
            text: '[[%migx.duplicate]]'
            ,handler: this.duplicate
        });        
        m.push('-');
        m.push({
            text: '[[%migx.remove]]'
            ,handler: this.remove
            ,scope: this
        });
        
    	return m;
    }
	,remove: function() {
		var _this = this;
        Ext.Msg.confirm('','[[%migx.remove_confirm]]' || '',function(e) {
            if (e == 'yes') {
                console.log(_this);
				_this.getStore().removeAt(_this.menu.recordIndex);
                _this.getView().refresh();
		        _this.collectItems();
                //MODx.fireResourceFormChange();	
                }
            }),this;		
	}   
	,collectItems: function(){
		var items=[];
		// read jsons from grid-store-items 
        var griddata=this.store.data;
		for(i = 0; i <  griddata.length; i++) {
 			items.push(griddata.items[i].raw);
        }

        if (this.call_collectmigxitems){
        items = Ext.util.JSON.encode(items); 
        MODx.Ajax.request({
            url: MODx.config.assets_url+'components/migx/connector.php'
            ,params: {
                action: 'mgr/migxdb/process'
                ,processaction: 'collectmigxitems'
                ,resource_id: '{/literal}{$resource.id}{literal}'
				,co_id: '{/literal}{$connected_object_id}{literal}'
                ,tv_name: '{/literal}{$tv->name}{literal}'
                ,items: items 
                ,configs: '{/literal}{$properties.configs}{literal}'      
                
            }
            ,listeners: {
                'success': {fn:function(res){
                    if (res.message==''){
                        var items = res.object;
                        var item = null;
                        Ext.get('tv{/literal}{$tv->id}{literal}').dom.value = Ext.util.JSON.encode(items);
                        this.autoinc = 0;
                        for(i = 0; i <  items.length; i++) {
 		                    item = items[i];
                            if (item.MIGX_id){
                                if (parseInt(item.MIGX_id)  > this.autoinc){
                                    this.autoinc = item.MIGX_id;
                                }
                            }else{
                                item.MIGX_id = this.autoinc +1 ;
                                this.autoinc = item.MIGX_id;                 
                            }	
                            items[i] = item;  
                        } 
        
		                this.getStore().sortInfo = null;
		                this.getStore().loadData(items);                                                    
                    }
                    
                },scope:this}
            }
        });            
        }else{
            var win = Ext.getCmp(this.win_id);
            var field = win.form.form.findField(this.hiddenFieldName);
            if (items.length >0){
               field.setValue(Ext.encode(items)); 
            }
            else{
               field.setValue('');  
            }            
        }
    	return;						 
    }        
});
</script>