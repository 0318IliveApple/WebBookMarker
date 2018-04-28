var temptag = document.getElementsByTagName('link');
var metatag = document.getElementsByTagName('meta');
for (var i = 0; i < metatag.length; i++){
    if (metatag[i].getAttribute('property') == 'og:image'){
        metatag[i].getAttribute('content');
    }
}
var previous = 0;
var num = 0;
var isSizeThere = false;
var subNum = 0;

for (var i = 0; i < temptag.length; i++){
    if (temptag[i].getAttribute('rel') == 'apple-touch-icon-precomposed'){
        let strSizes = temptag[i].getAttribute('sizes');
        if (strSizes != undefined){
            isSizeThere = true;
            let arrSize = strSizes.match(/[0-9]+\.?[0-9]*/g);
            let intSize = parseFloat(arrSize[1]);
            if (i == 0){
                previous = intSize;
            }else if (previous < intSize){
                previous = intSize;
                num = i;
            }
        }else{
            subNum = i;
        }
        
    } else if (temptag[i].getAttribute('rel') == 'apple-touch-icon'){
        
        let strSizes = temptag[i].getAttribute('sizes');
        if (strSizes != undefined){
            isSizeThere = true;
            let arrSize = strSizes.match(/[0-9]+\.?[0-9]*/g);
            let intSize = parseFloat(arrSize[1]);
            if (i == 0){
                previous = intSize;
                isSizeThere = true;
            }else if (previous < intSize){
                previous = intSize;
                num = i;
            }
        }else{
            subNum = i;
        }
        
    }
    
    if (i == temptag.length - 1 && isSizeThere == true){
        temptag[num].getAttribute('href');
    }else if (i == temptag.length - 1 && isSizeThere == false){
        temptag[subNum].getAttribute('href');
    }
    
}