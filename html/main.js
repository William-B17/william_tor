let mails = []
let transfers = []

window.addEventListener('message', function (event) {
    mails = []
    transfers = []
    for (i in event.data.mails) {
        mails[i] = { addressto: event.data.mails[i]["addressto"], addressfrom: event.data.mails[i]["addressfrom"], mailmessage: event.data.mails[i]["mailmessage"] };
    }
    for (i in event.data.transfers) {
        transfers[i] = { addressto: event.data.transfers[i]["addressto"], addressfrom: event.data.transfers[i]["addressfrom"], amount: event.data.transfers[i]["amount"], message: event.data.transfers[i]["message"] };
    }
    FCONload(event.data.c, event.data.money)
    getjob(event.data.job)
    darkmailaddress(event.data.darkaddress)
    ChangePage('Home', 'tor')
    if (event.data.status === true) {
        display(true);
    } else {
        display(false);
    }
});

function display(bool) {
    if (bool) {
        $('#container').show();
    } else {
        $('#container').hide();
    };
};

function darkmailaddress(myaddress) {
    document.getElementById('myaddress').innerHTML = `Your Address: ${myaddress}`;
    document.getElementById('myaddress2').innerHTML = `Your Address: ${myaddress}`;
};

function getjob(myjob) {
    document.getElementById('foot').innerHTML = "WG Developments";
    document.getElementById('gunslocked').style.display = "none";
    document.getElementById('gunsunlocked').style.display = "none";
    if (myjob == "hitman" || myjob == "armsdealer") {
        document.getElementById('gunsunlocked').style.display = "block";
    } else {
        document.getElementById('gunslocked').style.display = "block";
    }
};

display(false);

document.onkeyup = function (data) {
    if (data.which == 27) {
        let directory = GetParentResourceName()
        $.post(`https://${directory}/exit`, JSON.stringify({}));
        return;
    };
};

function ExitFUN() {
    let directory = GetParentResourceName()
    $.post(`https://${directory}/exit`, JSON.stringify({}));
    return;
};

function rmcontent(x) {
    var children = document.getElementById(x).children;
    for (var i = 0, len = children.length; i < len; i++) {
        document.getElementById(children[i].id).style.display = "none";
    }
};

function TurnOFF() {
    rmcontent('pages')
    ExitFUN();
};

// urls are just words hashed in sha256 except Home.url

function ChangePage(page, appname, hitmanname) {
    var app = document.getElementById(page);
    var appsetting = {
        "tor": {
            "Home": {
                "color": "#1c1b22",
                "url": "Search with DuckDuckGo or enter address"
            },
            "OnionLinks": {
                "color": "white",
                "url": "3229fba3608189986fc4fdc6d91e19a0134ab2fc188e4435ef83bf0a62166719.onion"
            },
            "DarkMail": {
                "color": "#1f2224",
                "url": "d83365468ef4a2d007a96bacc9207c7161c48aa4db27720a032167cd27c3fdd3.onion"
            },
            "Hack & Break": {
                "color": "#1f2224",
                "url": "8a4d7f241132d15af77b4f9e47f2196ce8c51657bc83c1e9433c73ba1ae78b90.onion"
            },
            "EuroGuns": {
                "color": "#1f2224",
                "url": "80466eaad8933d5866081806b9b2a397f89bd6eac6ad38ede95cd496bf187ab6.onion"
            },
            "HitmenForHire": {
                "color": "#1f2224",
                "url": "3dcc0c045cae7863a63df38dc5624b1b8732c80b3358636901f93126f2c6c766.onion"
            },
            "FCDesk": {
                "color": "#1f2224",
                "url": "112c940594c5626297c72820ee8551bd9df1583063017ff5fb3399569d41219d.onion"
            },
            "Get Crypto": {
                "color": "#1f2224",
                "url": "183c19fa91e23f95aa7d2fadb63eb9f7fe69a68aff208fda0856b1c810115b4e.onion"
            },
            "DarkMail | Write": {
                "color": "#1f2224",
                "url": "d83365468ef4a2d007a96bacc9207c7161c48aa4db27720a032167cd27c3fdd3.onion"
            },
            "FCTrans": {
                "color": "#1f2224",
                "url": "ebe67e24057d60b07e24c4be0c2bc4968011c81ec88bbbbccee0c7ec274545c3.onion"  
            }
        },
        "hitmanindex": {
            "Hitmen": {
                "color": "#1f2224",
                "url": "3dcc0c045cae7863a63df38dc5624b1b8732c80b3358636901f93126f2c6c766.onion/hitmen"
            },
            "HitmanResume": {
                "color": "#1f2224",
                "url": "3dcc0c045cae7863a63df38dc5624b1b8732c80b3358636901f93126f2c6c766.onion/resume"
            }
        },
        "EuroGuns": {
            "Special Guns": {
                "color": "#1f2224",
                "url": "80466eaad8933d586606b9b2a397f89bd6eac6ad38ede95cd496bf187ab6.onion/special"
            },
            "Ammo": {
                "color": "#1f2224",
                "url": "80466eaad8933d586606b9b2a397f89bd6eac6ad38ede95cd496bf187ab6.onion/ammo"
            },
            "Guns": {
                "color": "#1f2224",
                "url": "80466eaad8933d586606b9b2a397f89bd6eac6ad38ede95cd496bf187ab6.onion/guns"
            }
        }

    };
    var hitmaninfo = {
        "Will": {
            "address": "be56e95.wgaddress",
            "weapons": "Pistols/Automatic-Rifles/Smoke-Grenades/Rocket Launcher, Shotguns.",
            "himg": "./img/michael.png",
            "hclients": 195,
            "uclients": 5,
            "clients": 200,
            "hitmandiscription": "He tends to bring the biggest gun and a lot of ammo to feed it. Breaking down his movement, style and technique, it is obvious that “Will“ is ex-military. It is likely he was special forces, and, based on overheard conversation, possibly even a former Navy SEAL.",
        },
        "Thor": {
            "address": "be56e95.wgaddress",
            "weapons": "Knife",
            "himg": "./img/trevor.png",
            "hclients": 45,
            "uclients": 5,
            "clients": 50,
            "hitmandiscription": "A true enigma. We have no intel on this guy, and his habit of communicating through an 80’s model dictaphone means we don’t even have a voice. All we really know is that he is dangerously psychotic - a sociopath. His profile is to get close and cause as much traumatic damage as possible with high damage melee weapons."
        },
        "Vald": {
            "address": "be56e95.wgaddress",
            "weapons": "Pistol",
            "himg": "./img/franklin.png",
            "hclients": 4,
            "uclients": 0,
            "clients": 4,
            "hitmandiscription": "Very little is known about this character, but he seems to bear much potentiel."
        }
    }
    rmcontent('pages')
    document.getElementById('torloaderi').style.display = "block";
    document.getElementById('torapp').style.background = "#1c1b22";
    setTimeout(() => {
        if (hitmanname == undefined) {

        } else {
            document.getElementById('address').innerHTML = hitmaninfo[hitmanname]['address'];
            document.getElementById('weapons').innerHTML = hitmaninfo[hitmanname]['weapons'];
            document.getElementById('himg').src = hitmaninfo[hitmanname]['himg'];
            document.getElementById('hitmandiscription').innerHTML = hitmaninfo[hitmanname]['hitmandiscription'];
            document.getElementById('hclients').innerHTML = hitmaninfo[hitmanname]['hclients'];
            document.getElementById('uclients').innerHTML = hitmaninfo[hitmanname]['uclients'];
            document.getElementById('clients').innerHTML = hitmaninfo[hitmanname]['clients'];
            document.getElementById('contactbutton').id = hitmaninfo[hitmanname]['address'];
        }
        document.getElementById('torloaderi').style.display = "none";
        document.getElementById('tabname').innerHTML = page;
        document.getElementById('taburl').value = appsetting[appname][page]['url'];
        document.getElementById('torapp').style.background = appsetting[appname][page]['color'];
        app.style.display = "block";
    }, ((Math.floor(Math.random() * 10)) * 100)+100);
};

$('#transfer').click(function () {
    let directory = GetParentResourceName()
    $.post(`https://${directory}/transfer`, JSON.stringify({
        to: $('#fcval').val(),
        amountt: $('#fcamt').val(),
        message: $('#fcmsg').val()
    }));
    $('#fcval').val('');
    $('#fcamt').val('');
    $('#fcmsg').val('');
});

$('#exchangebtn').click(function () {
    let directory = GetParentResourceName()
    $.post(`https://${directory}/exchange`, JSON.stringify({
        amountt: $('#gcidolla').val(),
    }));
    $('#gcidolla').val('');
});

function contact(x) {
    var person = document.getElementsByClassName(x).id;
};

function calcfc(x) {
    y = x / 169165
    return y
};

function gccalc() {
    inputval = document.getElementById('gcidolla').value;
    if (isNaN(inputval)) {
        console.log(`${inputval} is not a number <br/>`);
    } else {
        amount = calcfc(inputval)
        finalamount = (amount / 100) * 90
        document.getElementById('gcifc').innerHTML = `(FC): ${finalamount.toString().slice(0, 9)}`;
    }
};

function FCONload(crypto, money) {

    document.getElementById('tabname2').innerHTML = `Your FC balance: ${crypto.toString().slice(0, 9)} *`;
    if (!isNaN(money)) { document.getElementById('getbankbalance').innerHTML = `${(money).toString()} $`; }
    document.getElementById('getfcuserbalance').innerHTML = `${(crypto).toString()} FC`;
    document.getElementById('fcuserbalance').innerHTML = `${crypto.toString()} FC`;

    var prices = {
        "hitfc1": 25000,
        "hitfc2": 15000,
        "hitfc3": 10000,
        "hitfc4": 17500
    }

    for (let key in prices) {
        document.getElementById(key).innerHTML = prices[key];
    }
    for (let key in prices) {
        z = calcfc(prices[key])
        document.getElementById(`${key}2`).innerHTML = (z.toString()).slice(0, 5);
    }
    document.getElementById('fcexc').innerHTML;
};

function ButSTUFF(item, typex) {
    let directory = GetParentResourceName()
    $.post(`https://${directory}/buy`, JSON.stringify({
        item: item,
        typex: typex
    }))
};

function LoadFirstMail() {
    if(mails[0] == undefined) {
        console.log("faill");
    } else {
        document.getElementById('mailaddress').innerHTML = mails[0]['addressfrom'];
        document.getElementById('mailcontent').innerHTML = mails[0]['mailmessage'];
    }
};

function ChangeMail() {
    if (mails.length > 1) {
        mails.push(mails[0]);
        mails.shift(0);
        LoadFirstMail()
    }
};

function DeleteMail() {
    let directory = GetParentResourceName()
    if (mails.length > 1) {
        mails.shift(0);
        $.post(`https://${directory}/deletemail`, JSON.stringify({  
            addressto: mails[0]['addressto'],
            addressfrom: mails[0]['addressfrom'],
            mailmessage: mails[0]['mailmessage']
        }))
        LoadFirstMail()
    } else {
        document.getElementById('mailaddress').innerHTML = " NO MAILS";
        document.getElementById('mailcontent').innerHTML = " NO MAILS";
    }
};

$('#writebtn').click(function () {
    let directory = GetParentResourceName()
    $.post(`https://${directory}/writemail`, JSON.stringify({
        address: document.getElementById('writemailaddress').value,
        message: document.getElementById('writemailmessage').value
    }));
    $('#writemailaddress').val('');
    $('#writemailmessage').val('');
});

function SetMailWriteVals(address,message) {
    document.getElementById('writemailaddress').value = address;
    document.getElementById('writemailmessage').value = message;
};

function getalltransfers() {
    var table = document.getElementById("fctranstable");
    for(i in transfers) {
        var row = table.insertRow(i);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        cell1.innerHTML = transfers[i]['addressfrom'];
        cell2.innerHTML = transfers[i]['message'];
        cell3.innerHTML = transfers[i]['amount'];
    }
}

