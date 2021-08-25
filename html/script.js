var content = {}
var d = undefined
var transition = {}
addEventListener("message", function(event){
	if (event.data.toggle == true && !transition[event.data.id]) {
        if (content[event.data.id] == undefined) {
            content[event.data.id] = `'<span class="`+event.data.id+`" id="`+event.data.id+`" style="transition: left `+event.data.sleep+`s,top `+event.data.sleep+`s;position: absolute; left:`+event.data.x * 100+`%;top:`+event.data.y * 100+`%;"><div class="me-container"><div class="icon-container"><i style="font-size: 1.4em;" class="fas fa-`+event.data.fa+` fa-3x"></i></div><div class="text-container">`+event.data.label+`</div></div></span>"`
            document.querySelector('.data').insertAdjacentHTML("beforeend", content[event.data.id])
            document.getElementById(event.data.id).addEventListener('transitionrun', function() {
                transition[event.data.id] = true
            });
    
            document.getElementById(event.data.id).addEventListener('transitionend', function() {
                transition[event.data.id] = false
            });
        } else {
		    document.getElementById(event.data.id).style.left = ''+event.data.x * 100+'%';
            document.getElementById(event.data.id).style.top = ''+event.data.y * 100+'%';
        }
        $("#data").show()
    } else if (!event.data.toggle) {
        content[event.data.id] = undefined
        transition[event.data.id] = false
        if (document.getElementById(event.data.id)) {
            document.getElementById(event.data.id).remove()
        }
    }
});

