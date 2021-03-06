<script type="text/javascript">

Ext.define('MigxFe.input.migxgridpanel' ,{
    extend: 'Ext.grid.GridPanel',
    alias: 'widget.migxgridpanel',

    initComponent: function() {
        var win = Ext.getCmp(this.win_id);        
        var field = Ext.get(this.valuename);
        var columns = Ext.decode(this.columns_config);
      
        
    var cols=[];
    // add empty pathconfig (source) to array to match number of col in renderimage
    var renderer = null;
	for(i = 0; i <  columns.length; i++) {
        renderer = columns[i]['renderer'];
        if (typeof renderer != 'undefined'){

            //columns[i]['renderer'] = {fn:eval(renderer),scope:this};
            
            columns[i]['renderer'] = function(val, md, rec, row, col, s, v){
                var fn = Ext.bind(eval(renderer),this);
                return fn(val, md, rec, row, col, s, v);
            };
            
            
        }
        cols.push(columns[i]);
    }
        
        this.columns = cols;
        this.callParent(arguments);
        console.log(this.columns);  
        if (field){
            console.log(field.getValue());
        }
        console.log(this);
        
        /*
        this.addMembers({
            meow: function() {
            alert('Meowww...');
        }
        });        
        */
        //var toolbars = this.getDockedItems('toolbar[dock="top"]');
        //console.log(toolbars[0]);
    //this._makeTemplates();
    //this.getStore().pathconfigs=config.pathconfigs;
	this.loadData();
    //this.on('click', this.onClick, this);          
        
    }
    ,renderImageX : function(val, md, rec, row, col, s){
        console.log(rec);
        console.log(val);
        var source = s.pathconfigs[col];
        if (val !== null) {
            if (val.substr(0,4) == 'http'){
                return '{$httpimg}' ;
            }        
            if (val != ''){
                return '{$phpthumbimg}';
            }
            return val;
        }
	}       
    ,renderImage : function(val, md, rec, row, col, s){
/*        
$ctx = '{$ctx}';
$val = "' + val + '";
$httpimg = '<img style="height:60px" src="'.$val.'"/>';

$phpthumb = "'+MODx.config.connectors_url+'system/phpthumb.php?h=60&src='+val+source+'";
$phpthumbimg = '<img src="'.$phpthumb.'" alt="" />';
*/        
        var connector_url = '/connectors/';
        //console.log(rec);
        
        //var source = s.pathconfigs[col];
        var source = '&source=1';
        if (val !== null) {
            if (val.substr(0,4) == 'http'){
                return '{$httpimg}' ;
            }        
            if (val != ''){
                console.log(val);
                return '<img src="'+connector_url+'system/phpthumb.php?h=60&src='+val+source+'" alt="" />';
            }
            return val;
        }
	}   
    ,addTools: function(){
        var toolbars = this.getDockedItems('toolbar[dock="top"]');
        var toolbar = toolbars[0];
        toolbar.add({
            text: '[[%migx.add]]',
		    handler: this.addItem,
            scope: this
        });
    } 
    
	,loadData: function(){
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
			
    }
	,updateData: function(response){
        
        
        items = response.object;
        this.getHiddenField().setValue(Ext.encode(items));         
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
    ,getMenu: function() {
		var n = this.menu.record; 
        var m = [];
        m.push({
            text: '[[%migx.edit]]'
            ,handler: this.update
            ,scope: this
            
        });
        m.push({
            text: '[[%migx.duplicate]]'
            ,handler: this.duplicate
            ,scope: this
        });        
        m.push('-');
        m.push({
            text: '[[%migx.remove]]'
            ,handler: this.remove
            ,scope: this
        });
        
    	return m;
    }
	,addItem: function(btn,e) {
        var s=this.getStore();
		this.loadWin(btn,e,s.getCount(),'a');
	}    
	,update: function(btn,e) {
      this.loadWin(btn,e,this.menu.recordIndex,'u');

    }
	,duplicate: function(btn,e) {
      this.loadWin(btn,e,this.menu.recordIndex,'d');
    }     
	,loadWin: function(btn,e,index,action) {
	   
      //var field = this.getHiddenField();
	    var resource_id = '[[+resource.id]]';
        var co_id = '[[+connected_object_id]]';
        /*
        {/literal}{if $properties.autoResourceFolders == 'true'}{literal}
        if (resource_id == 0){
            alert ('[[%migx.save_resource]]');
            return;
        }
        {/literal}{/if}{literal}        
        */ 
        if (action == 'a'){
           var json='[[+newitem]]';
           var data=Ext.decode(json);
        }else{
		   var s = this.getStore();
           var rec = s.getAt(index)            
           var data = rec.data;
           var json = Ext.encode(rec.raw);
        }      

      var isnew = (action == 'u') ? '0':'1'; 

      var config={
          win_title: 'testtest'      
      };
      
      var params={
          win_id : 'testtest',
          action: 'web/migx/fields',
          configs: this.configs,
          tv_name: this.tv_name,
          record_json: json,
          grid_id: this.getId(),
          isnew: isnew,
          index: index
      };
      
        var win = Ext.getCmp(params.win_id);
        if (!win){
            win=MigxFe.app.createWin(params,config);
        }
        //button.dom.disabled = true;
        if (win.isVisible()) {
            win.close();
        } else {
            win.show(this, function() {
                //button.dom.disabled = false;
            });
        }                
       
       return;

       //old stuff        
        /*
	    var resource_id = '{/literal}{$resource.id}{literal}';
        var co_id = '{/literal}{$connected_object_id}{literal}';
        {/literal}{if $properties.autoResourceFolders == 'true'}{literal}
        if (resource_id == 0){
            alert ('[[%migx.save_resource]]');
            return;
        }
        {/literal}{/if}{literal}        
       
        if (action == 'a'){
           var json='{/literal}{$newitem}{literal}';
           var data=Ext.util.JSON.decode(json);
        }else{
		   var s = this.getStore();
           var rec = s.getAt(index)            
           var data = rec.data;
           var json = Ext.util.JSON.encode(rec.json);
           
        }
        
        var isnew = (action == 'u') ? '0':'1';
		
        var win_xtype = 'modx-window-tv-item-update-{/literal}{$tv->id}{literal}';
		if (this.windows[win_xtype]){
			this.windows[win_xtype].fp.autoLoad.params.tv_id='{/literal}{$tv->id}{literal}';
			this.windows[win_xtype].fp.autoLoad.params.resource_id=resource_id;
            this.windows[win_xtype].fp.autoLoad.params.co_id=co_id;
            this.windows[win_xtype].fp.autoLoad.params.tv_name='{/literal}{$tv->name}{literal}';
            this.windows[win_xtype].fp.autoLoad.params.configs='{/literal}{$properties.configs}{literal}';
		    this.windows[win_xtype].fp.autoLoad.params.itemid=index;
            this.windows[win_xtype].fp.autoLoad.params.record_json=json;
            this.windows[win_xtype].fp.autoLoad.params.autoinc=this.autoinc;
            this.windows[win_xtype].fp.autoLoad.params.isnew=isnew;
			this.windows[win_xtype].grid=this;
            this.windows[win_xtype].action=action;
		}
		this.loadWindow(btn,e,{
            xtype: win_xtype
            ,record: data
			,grid: this
            ,action: action
			,baseParams : {
				record_json:json,
			    action: 'mgr/fields',
				tv_id: '{/literal}{$tv->id}{literal}',
				tv_name: '{/literal}{$tv->name}{literal}',
                configs: '{/literal}{$properties.configs}{literal}',
				'class_key': 'modDocument',
                'wctx':'{/literal}{$myctx}{literal}',
				itemid : index,
                autoinc : this.autoinc,
                isnew : isnew,
                resource_id : resource_id,
                co_id : co_id
			}
        });
        */
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
    ,getHiddenField: function() {
        var win = Ext.getCmp(this.win_id);
        return win.form.form.findField(this.hiddenFieldName);        
        
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
            var field = this.getHiddenField();
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