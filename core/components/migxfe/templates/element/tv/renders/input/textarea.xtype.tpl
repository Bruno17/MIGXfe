<script type="text/javascript">
Ext.define('MigxFe.input.textarea' ,{
    extend: 'Ext.form.TextArea',
    alias: 'widget.migx_textarea',

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