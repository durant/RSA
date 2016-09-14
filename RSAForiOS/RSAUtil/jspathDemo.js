defineClass('weixindress.GLDataTrackHelper',{

},{
getZhuanShiPrice:function(price)
    {
        console.log('asdfawe;fij')
        if (parseInt(price.toJS()) >= 79)
        {
            return "0"
        }
        else
        {
            return "6"
        }
    },
    
getNoZhuanShiPrice:function(price)
    {
        console.log('asdfawe;fijsdafasd')
        if (parseInt(price.toJS()) >= 99)
        {
            return "0"
        }
        else
        {
            return "6"
        }
    },
    
getDefaultAvoidPostage:function()
    {
        return "99"
    }
})

defineClass('weixindress.GoodLocalNetworkManager',{
            },
            {
            
            escapteStrings:function()
            {
            require('weixindress.GoodLocalNetworkManager').setMaxReloadCount(0);
            console.log('max replace ');
            return self.ORIGescapteStrings();
            }
        });
defineClass('UIControl',{
            isOpenRepeatFilter:function() {
            console.log('isOpenRepeatFilter ========== ');

            
            return false;
            }
        },
{
});