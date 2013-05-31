<script type="text/javascript">
Ext.define('MigxFe.input.date' ,{
    extend: 'Ext.ux.form.field.DateTime'
    ,alias: 'widget.migx_datetime'

    ,initComponent: function() {
        var win = Ext.getCmp(this.win_id);
        var field = Ext.get(this.valuename);
        this.callParent(arguments);
        if (field){
            this.setValue(field.getValue());
        }
    } 
});
</script>