<script type="text/javascript">
Ext.define('MigxFe.input.textbox' ,{
    extend: 'Ext.form.Text',
    alias: 'widget.migx_textbox',

    initComponent: function() {
        var win = Ext.getCmp(this.win_id);
        var field = Ext.get(this.valuename);
        this.callParent(arguments);
        if (field){
            this.setValue(field.getValue());
        }
        
    }
});
</script>