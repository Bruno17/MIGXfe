{
    xtype: 'grid',
    store: Ext.create('Ext.data.Store', {
    storeId:'simpsonsStore',
    fields:['name'],
    data: [ ["Lisa"], ["Bart"], ["Homer"], ["Marge"] ],
    proxy: {
        type: 'memory',
        reader: 'array'
    }
    }),
    columns: [
        {header: 'Name',  dataIndex: 'name', flex: true}
    ],
    viewConfig: {
        plugins: {
            ptype: 'gridviewdragdrop',
            dragText: 'Drag and drop to reorganize'
        }
    },
    height: 200,
    width: '100%',
}  