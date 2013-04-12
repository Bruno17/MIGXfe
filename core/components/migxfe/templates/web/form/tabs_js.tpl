<script type="text/javascript">
// <![CDATA[

//console.log(MigxFe.app.win);

var win_tabs = Ext.create('Ext.tab.Panel', {
    width: '100%',
    height: 400,
    //renderTo: 'modx-window-mi-grid-update-[[+win_id]]-tabs',
    items: [ [[+innerrows.tab]] ]
});
//add tabs to window
var win = Ext.getCmp('win-migxfe-test');
if (win){
   win.add(win_tabs);  
}


// ]]>
</script>