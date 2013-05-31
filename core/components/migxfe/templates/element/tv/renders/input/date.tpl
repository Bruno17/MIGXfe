{
    xtype: 'migx_datetime'
    ,id:'tv[[+tv.id]]-[[+request.win_id]]'
    ,hiddenName:'tv[[+tv.id]]'
    ,width: 400
    ,valuename:'original[[+request.win_id]]-[[+tv.id]]'
    ,dateFormat: '[[+date_format]]'
    ,timeFormat: '[[+time_format]]'
    [[+params.disabledDates:isnot=``:then=`,disabledDates:[[+params.disabledDates]]`:else=``]]
    [[+params.disabledDays:isnot=``:then=`,disabledDays:[[+params.disabledDays]]`:else=``]]
    [[+params.minDateValue:isnot=``:then=`,minDateValue:'[[+params.minDateValue]]'`:else=``]]
    [[+params.maxDateValue:isnot=``:then=`,maxDateValue:'[[+params.maxDateValue]]'`:else=``]]
    [[+params.startDay:isnot=``:then=`,startDay:[[+params.startDay]]`:else=``]]
    [[+params.minTimeValue:isnot=``:then=`,minTimeValue:'[[+params.minTimeValue]]'`:else=``]]
    [[+params.maxTimeValue:isnot=``:then=`,maxTimeValue:'[[+params.maxTimeValue]]'`:else=``]]
    [[+params.timeIncrement:isnot=``:then=`,timeIncrement:[[+params.timeIncrement]]`:else=``]]
    ,dateWidth: 120
    ,timeWidth: 120
    ,allowBlank: [[+params.allowBlank:is=`1`:then=`true`:else=`false`]]
    //,value: '{$tv->value}'
    ,msgTarget: 'under'
    ,fieldLabel:'[[+tv.caption]]'
    ,labelAlign:'top'    
}