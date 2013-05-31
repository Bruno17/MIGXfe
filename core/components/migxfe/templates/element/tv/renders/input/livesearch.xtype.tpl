<script type="text/javascript">
Ext.define('MigxFe.input.livesearch' ,{
    extend: 'Ext.form.ComboBox',
    alias: 'widget.livesearch',

    initComponent: function() {
        var win = Ext.getCmp(this.win_id);
        var field = Ext.get(this.valuename);
        this.callParent(arguments);
        if (field){
            this.setRawValue(field.getValue());
        }
               
    }
});
</script>