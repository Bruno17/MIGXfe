Ext.define('Ext.ux.form.field.DateTime', {
    extend:'Ext.form.FieldContainer',
    mixins: {
        field: 'Ext.form.field.Field'
    },
    alias: 'widget.datetimefield',
    layout: 'hbox',
    width: 200,
    height: 50,
    combineErrors: true,
    msgTarget :'under',
    dtSeparator:' ',
    dateValidator:null,
    defaultAutoCreate:{tag:'input', type:'hidden'},
    dtSeparator:' ',
    hiddenFormat:'Y-m-d H:i:s',
    otherToNow:true,
    timePosition:'right', // valid values:'below', 'right'
    timeValidator:null,
    timeWidth:100,
    dateFormat:'Y-m-d',
    timeFormat:'g:i A',
    maxDateValue: '',
    minDateValue: '',
    timeIncrement: 15,
    maxTimeValue: null,
    minTimeValue: null,
    disabledDates: null,    

    dateCfg:{},
    timeCfg:{},

    initComponent: function() {
        // offset time
        if (!this.hasOwnProperty('offset_time') || isNaN(this.offset_time)) {
            this.offset_time = 0;
        }        
        
        var me = this;
        me.buildField();
        me.callParent();
        this.df = this.down('datefield');
        this.tf = this.down('timefield');
        this.hiddenField = this.down('hidden');
        
        this.df.on('change', this.onChange, this);
        this.tf.on('change', this.onChange, this);
        
        me.initField();
    },
    
    onChange: function(){
        this.hiddenField.setValue(this.getSubmitData());
    },

    //@private
    buildField: function(){
        this.items = [
            Ext.apply({
                xtype: 'datefield',
                format: 'Y-m-d',
                width: 100,
                flex: 2
                
            },this.dateCfg),
            Ext.apply({
                xtype: 'timefield',
                format: 'H:i',
                width: 80,
                flex: 2
            },this.timeCfg),
            Ext.apply({
                xtype: 'hidden',
                name: this.hiddenName,
                width: 0
            })
        ]
    }
    
    /**
     * @private initializes internal dateValue
     */
    ,initDateValue:function() {
        this.dateValue = this.otherToNow ? new Date() : new Date(1970, 0, 1, 0, 0, 0);
    }    

    ,getValue: function() {
        var value,date = this.df.getSubmitValue(),time = this.tf.getSubmitValue();
        if(date){
            if(time){
                var format = this.getFormat()
                value = Ext.Date.parse(date + ' ' + time,format)
            }else{
                value = this.df.getValue()
            }
        }
        return value
    }
    /**
     * @private Sets the value of DateField
     */
    ,setDate:function(date) {
        if (date && this.offset_time != 0) {
            date = date.add(Date.MINUTE, 60 * new Number(this.offset_time));
        }
        this.df.setValue(date);
    } // eo function setDate
    // }}}
    // {{{
    /**
     * @private Sets the value of TimeField
     */
    ,setTime:function(date) {
        if (date && this.offset_time != 0) {
            date = date.add(Date.MINUTE, 60 * new Number(this.offset_time));
        }
        this.tf.setValue(date);
    } // eo function setTime    
    /**
     * @private Updates all of Date, Time and Hidden
     */
    ,updateValue:function() {

        this.updateDate();
        this.updateTime();
        this.updateHidden();

        return;
    } // eo function updateValue
    /**
     * @private Updates the date part
     */
    ,updateDate:function() {

        var d = this.df.getValue();
        if(d) {
            if(!(this.dateValue instanceof Date)) {
                this.initDateValue();
                if(!this.tf.getValue()) {
                    this.setTime(this.dateValue);
                }
            }
            this.dateValue.setMonth(0); // because of leap years
            this.dateValue.setFullYear(d.getFullYear());
            this.dateValue.setMonth(d.getMonth(), d.getDate());
//            this.dateValue.setDate(d.getDate());
        }
        else {
            this.dateValue = '';
            this.setTime('');
        }
    } // eo function updateDate
    /**
     * @private
     * Updates the time part
     */
    ,updateTime:function() {
        var t = this.tf.getValue();
        if(t && !(t instanceof Date)) {
            t = Ext.Date.parse(t, this.tf.format);
        }
        if(t && !this.df.getValue()) {
            this.initDateValue();
            this.setDate(this.dateValue);
        }
        if(this.dateValue instanceof Date) {
            if(t) {
                this.dateValue.setHours(t.getHours());
                this.dateValue.setMinutes(t.getMinutes());
                this.dateValue.setSeconds(t.getSeconds());
            }
            else {
                this.dateValue.setHours(0);
                this.dateValue.setMinutes(0);
                this.dateValue.setSeconds(0);
            }
        }
    } // eo function updateTime
    /**
     * @private Updates the underlying hidden field value
     */
    ,updateHidden:function() {
        if(this.isRendered) {
            var value = '';
            if (this.dateValue instanceof Date) {
                value = this.dateValue.add(Date.MINUTE, 0 - 60 * new Number(this.offset_time)).format(this.hiddenFormat);
            }
            this.hiddenField.setValue(value);
        }
    }                
   /**
     * @param {Mixed} val Value to set
     * Sets the value of this field
     */
    ,setValue:function(val) {
        
        if(!val && true === this.emptyToNow) {
            this.setValue(new Date());
            return;
        }
        else if(!val) {
            this.setDate('');
            this.setTime('');
            this.updateValue();
            return;
        }
        if ('number' === typeof val) {
          val = new Date(val);
        }
        else if('string' === typeof val && this.hiddenFormat) {
            val = Ext.Date.parse(val, this.hiddenFormat);
        }
        val = val ? val : new Date(1970, 0 ,1, 0, 0, 0);
        var da;
        if(val instanceof Date) {
            this.setDate(val);
            this.setTime(val);
            this.dateValue = new Date(Ext.isIE ? val.getTime() : val);
        }
        else {
            da = val.split(this.dtSeparator);
            this.setDate(da[0]);
            if(da[1]) {
                if(da[2]) {
                    // add am/pm part back to time
                    da[1] += da[2];
                }
                this.setTime(da[1]);
            }
        }
        this.updateValue();
    }, // eo function setValue    

    getSubmitData: function(){
        var value = this.getValue()
        var format = this.getFormat()
        return value ? Ext.Date.format(value, format) : null;
    },

    getFormat: function(){
        return (this.df.submitFormat || this.df.format) + " " + (this.tf.submitFormat || this.tf.format)
    }
})