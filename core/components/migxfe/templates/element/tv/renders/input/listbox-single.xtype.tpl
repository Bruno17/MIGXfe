<script type="text/javascript">
Ext.define('MigxFe.input.listbox_single' ,{
    extend: 'Ext.form.ComboBox',
    alias: 'widget.listbox_single',

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