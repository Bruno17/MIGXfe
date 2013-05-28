           win.addButton({
                    text: '[[%cancel]]',
                    scope: win,
                    handler: function() {
                         this.close(); 
                    }
                });   
           win.addButton({
                    text: '[[%done]]',
                    scope: win,
                    handler: function() {
                        this.form.submit();
                    }
                });   