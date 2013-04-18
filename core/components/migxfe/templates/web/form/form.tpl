[[+OnResourceTVFormPrerender]]
[[+xtypes]]
<h2>[[+formcaption]]</h2>

<input type="hidden" class="mulititems_grid_item_fields" name="mulititems_grid_item_fields" value="[[+fields]]" />
<input type="hidden" class="tvmigxid" name="tvmigxid" value="[[+migxid]]" />

[[+tabs_jsX]]

[[+OnResourceTVFormRender]]

<br class="clear" />


<script type="text/javascript">
// <![CDATA[

//console.log(MigxFe.app.win);

var win_panel = Ext.create('Ext.form.Panel', {
    id: 'migxdb-panel-object-[[+request.win_id]]',
    title:'[[+formcaption]]',
    bodyPadding: 5,
    width: '100%',
    //url: 'save-form.php',    
    items: [{
        xtype: 'hidden',
        name: 'mulititems_grid_item_fields',
        value: '[[+fields]]',
        margin: '0'
    },{
        xtype: 'hidden',
        name: 'tvmigxid',
        value: '[[+migxid]]',
        margin: '0'
    },{
        xtype:'tabpanel',
        width: '100%',
        height: 400,
        id: 'modx-window-mi-grid-update-[[+request.win_id]]-tabs',
        items: [ [[+innerrows.tab]] ]            
    }]
});

//add form and buttons to window
var win = Ext.getCmp('[[+request.win_id]]');
if (win){
   win.add(win_panel);
   win.addButton({
                    text: '[[%cancel]]',
                    scope: win,
                    handler: function() {
                         this.close(); 
                    }
                });   
   win.addButton({
                    text: '[[%done]]',
                    scope: win,
                    handler: function() {
                        this.form.submit();
                    }
                });
   win.form = win_panel;
   win.form.on({
       beforeaction: function(){
        
           var v = this.getValues(); 
           var tv_type = '[[+tv.type]]';
           var object_id = '[[+object.id]]';
           if (this.isValid()) {
               if (this.action == 'd'){
                   //MODx.fireResourceFormChange();
                   object_id = 'new';     
               }
               if (this.action == 'u'){
                   /*update record*/
               }else{
                   /*append record*/
               }
               
               var fields = Ext.JSON.decode(v['mulititems_grid_item_fields']);
               var item = {};
               var tvid = '';
               if (fields.length>0){
                   for (var i = 0; i < fields.length; i++) {
                       tvid = (fields[i].tv_id);
                       if (v['tv'+tvid+'_prefix']) v['tv'+tvid]=v['tv'+tvid+'_prefix']+v['tv'+tvid];//url-TV support
                       if (typeof(fields[i].field) != 'undefined'){
                           item[fields[i].field]=v['tv'+tvid+'[]'] || v['tv'+tvid] || '';
                       }
                       							
                   }
                   //we store the item.values to rec.json because perhaps sometimes we can have different fields for each record
               }					
			
               //console.log(item);
               
               var params = {
                       HTTP_MODAUTH: '[[+request.HTTP_MODAUTH]]'
                       ,action: 'mgr/migxdb/update'
                       ,data: Ext.JSON.encode(item)
				       ,configs: '[[+request.configs]]'
                       ,resource_id: '[[+request.resource_id]]'
                       ,co_id: '[[+request.co_id]]'
                       ,object_id: object_id
                       //,tv_id: this.baseParams.tv_id
                       ,wctx: '[[+request.wctx]]'
                   };
               if (tv_type == 'migx'){
                   var grid = Ext.getCmp('[[+request.grid_id]]');
                   var field = grid.getHiddenField();
                   params.items = field.getValue();
                   params.index = grid.menu.recordIndex;
                   params.action = 'mgr/migx/migxupdate'
               }    
               
               Ext.Ajax.request({
                   url: '[[+migxfeconfig.migxConnectorUrl]]'
                   ,params: params
                   ,success: function(r){
                       var r = Ext.decode(r.responseText);
                       if (r.success){
                           if (tv_type == 'migx'){
                               grid.updateData(r);
                           }                        
                       }
                   }
                   
               });
        
           }           
           return false;        
       }
    });
}


// ]]>
</script>