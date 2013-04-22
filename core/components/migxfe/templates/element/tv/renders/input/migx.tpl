{
    xtype: 'migxgridpanel',
    store: 	new Ext.data.JsonStore({
        fields : Ext.decode('[[+fields]]')
            
    }), // define the data store in a separate variable	    
    
    /*
    store: Ext.create('Ext.data.Store', {
        storeId:'simpsonsStore',
        fields:['name'],
        data: [ ["Lisa"], ["Bart"], ["Homer"], ["Marge"] ],
        proxy: {
            type: 'memory',
            reader: 'array'
        }
    }),
    */
    columns_config: '[[+columns]]',
    tbar: [],  
    viewConfig: {
        plugins: {
            ptype: 'gridviewdragdrop',
            dragText: 'Drag and drop to reorganize'
            
        },
        
        listeners: {
            "drop": {
                //scope: this,
                fn: function() {
                    var grid = this.panel;
                    grid.collectItems();
                   }
                },
              
            itemcontextmenu: function(view, rec, node, index, event) {
                event.stopEvent(); // stops the default event. i.e. Windows Context Menu
                var grid = this.panel;
                grid.menu = {};
                grid.menu.record = rec;
                grid.menu.recordIndex = index;
                //console.log(grid);
                var gridContextMenu = Ext.create('Ext.menu.Menu', {
                    items: grid.getMenu(view, rec, node, index, event)
                });          
                gridContextMenu.showAt(event.getXY()); // show context menu where user right clicked                       
                return false;
            }                   
        }
    },
    //height: 200,
    width: '100%',
    collapsible: true,
    title: '[[+tv.caption]]',
    hiddenFieldName: 'tv[[+tv.id]]', 
    valuename:'original[[+request.win_id]]-[[+tv.id]]',
    win_id:'[[+request.win_id]]',
    tv_name:'[[+tv.name]]'
},{
        xtype: 'migxValueHidden',
        id:'tv[[+tv.id]]-[[+request.win_id]]',
        name:'tv[[+tv.id]]',      
        margin: '0',
        valuename:'original[[+request.win_id]]-[[+tv.id]]'
        
} 
