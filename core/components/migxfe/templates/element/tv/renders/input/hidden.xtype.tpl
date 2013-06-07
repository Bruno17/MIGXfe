<script type="text/javascript">
Ext.define('MigxFe.input.hidden' ,{
    extend: 'Ext.form.Hidden',
    alias: 'widget.migx_hidden',

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