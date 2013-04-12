[[+OnResourceTVFormPrerender]]
[[+xtypes]]
<h2>[[+formcaption]]</h2>

<input type="hidden" class="mulititems_grid_item_fields" name="mulititems_grid_item_fields" value="[[+fields]]" />
<input type="hidden" class="tvmigxid" name="tvmigxid" value="[[+migxid]]" />

<div id="modx-window-mi-grid-update-[[+win_id]]-tabs" >

</div>
[[+tabs_jsX]]

[[+OnResourceTVFormRender]]

<br class="clear" />


<script type="text/javascript">
// <![CDATA[

//console.log(MigxFe.app.win);

var win_panel = Ext.create('Ext.form.Panel', {
    id: 'migxdb-panel-object-[[+request.btn_id]]',
    title: '[[+formcaption]]',
    bodyPadding: 5,
    width: '100%',
    url: 'save-form.php',    
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
        id: 'modx-window-mi-grid-update-[[+request.btn_id]]-tabs',
        items: [ [[+innerrows.tab]] ]            
    }]
});

//add form to window
var win = Ext.getCmp('[[+request.win_id]]');
if (win){
   win.add(win_panel);
   win.form = win_panel;
   win.form.on({
       beforeaction: function(){
           var v = win.form.getValues(); 
           console.log(v);
           var object_id = '[[+object.id]]';
           if (win.form.isValid()) {
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
                       item[fields[i].field]=v['tv'+tvid+'[]'] || v['tv'+tvid] || '';							
                   }
                   //we store the item.values to rec.json because perhaps sometimes we can have different fields for each record
               }					
			
               //console.log(item);
            
               Ext.Ajax.request({
                   url: '[[+migxfeconfig.migxConnectorUrl]]'
                   ,params: {
                       HTTP_MODAUTH: '[[+request.HTTP_MODAUTH]]'
                       ,action: 'mgr/migxdb/update'
                       ,data: Ext.JSON.encode(item)
				       ,configs: '[[+request.configs]]'
                       ,resource_id: '[[+request.resource_id]]'
                       ,co_id: '[[+request.co_id]]'
                       ,object_id: object_id
                       //,tv_id: this.baseParams.tv_id
                       ,wctx: '[[+request.wctx]]'
                   }
                   ,listeners: {
                       'success': {fn:this.onSubmitSuccess,scope:this}
                   }
               });
        
           }           
           return false;        
       }
    });
}


// ]]>
</script>