import initModule from "./game.js";

var Module = {
    preRun: [],
    postRun: [],
    print: (function() {})(),
    canvas: (function() {
        return null;
    })(),
    setStatus: function(text) {},
    totalDependencies: 0,
    monitorRunDependencies: function(left) {}
};

initModule(Module);

let content=""
let position=0;
let command=""
let silent=false;
let ready=false;
let hasupdated=false;

function update_text()
{
    if(hasupdated)
        return;
    document.getElementById("terminal").innerHTML = content+"_";
    window.scrollTo(0, document.body.scrollHeight);
    hasupdated=true;
}

function js_getch()
{
    update_text();
    if(!ready)
        return -1;

    let varlen=command.length;
    if(command=="")
        return -1;
    if(position >= varlen) {
        return -1;
    }
    var ch=command.charCodeAt(position);

    ++position;

    if(ch==10) {    // '\n'
        command="";
        position=0;
        ready=false;
    }

    return ch;
}

function js_waitkey()
{
    update_text();
    let varlen=command.length;
    if(!silent) {
        document.getElementById("terminal").innerHTML = content+
            "<br><i>[Press a key]</i>";
    }
    silent=true;
    
    if(command=="")
        return -1;
    if(position >= varlen) {
        return -1;
    }
    var ch=command.charCodeAt(position);
    command="";
    position=0;
    silent=false;
    ready=false;

    return ch;
}

function js_writech(code)
{
    let c=String.fromCharCode(code);
    if(c=='\n') {
        content += "<br>";
    } else {
        content += c;
    }
    hasupdated=false;
    //update_text();
}

export {js_getch,js_writech,js_waitkey };



function updateContent(keyName)
{
    //console.log(keyName);
    if(keyName ==="Shift") {
        return;
    } else if(keyName ==="Backspace") {
        if(command.length>0) {
            content=content.substr(0, content.length-1);    // review!
            command=command.substr(0, command.length-1);    // review!
            hasupdated=false;
            if(position>=command.length)
                position=command.length-1;
        } else {
            position=0;
        }
        if(position<0)
            position=0;
    } else if(keyName ==="Enter") {
        content += "<br>";
        command += '\n';
        hasupdated=false;
        ready=true;
    } else if(keyName.length>1) {
        // Ignore all control characters.
        return;
    } else {
        keyName=keyName.replace(/[^a-z0-9 ?!,.;:+-]/gi, '');
        
        if(!silent) {
            content += keyName;
            hasupdated=false;
        }
        command += keyName;
    }
    update_text();
}

document.addEventListener(
    "keydown",
    (event) => {
        const keyName = event.key;

        if (event.ctrlKey || event.metaKey) {
            // Even though event.key is not 'Control' (e.g., 'a' is pressed),
            // event.ctrlKey may be true if Ctrl key is pressed at the same
            // time.
            //alert(`Combination of ctrlKey + ${keyName}`);
        } else {
            updateContent(keyName);
            event.preventDefault();

        }
    },
    false,
);

document.addEventListener(
    "keyup",
    (event) => {
        const keyName = event.key;

        // As the user releases the Ctrl key, the key is no longer active,
        // so event.ctrlKey is false.
        if (keyName === "Control") {
          //alert("Control key was released");
        }
    },
    false,
);

document.getElementById("terminal").focus({ focusVisible: true });

