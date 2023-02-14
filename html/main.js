    window.addEventListener('message', function (event) {
        FCONload(event.data.c)

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

    display(false);

    document.onkeyup = function (data) {
        if (data.which == 27) {
            let directory = GetParentResourceName()
            $.post('https://' + directory + '/exit', JSON.stringify({}));
            return;
        };
    };

    function ExitFUN() {
        let directory = GetParentResourceName()
        $.post('https://' + directory + '/exit', JSON.stringify({}));
        return;
    };

    function rmcontent(x) {
        var children = document.getElementById(x).children;
        for (var i = 0, len = children.length; i < len; i++) {
            document.getElementById(children[i].id).style.display = "none";
        }
    }

    function TurnOFF() {
        rmcontent('pages')
        ExitFUN();
    }

    // urls are just words hashed in sha256 except Home.url

    function ChangePage(page,appname,hitmanname) {
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
                    "color": "white",
                    "url": "d83365468ef4a2d007a96bacc9207c7161c48aa4db27720a032167cd27c3fdd3.onion"
                },
                "hacking": {
                    "color": "white",
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
                "Products": {
                    "color": "#1f2224",
                    "url": "80466eaad8933d5866081806b9b2a397f89bd6eac6ad38ede95cd496bf187ab6.onion/p"
                }
            }
            
        };
        var hitmaninfo = {
            "Will": {
                "pnumber": "+45 12 34 56 78",
                "weapons": "Pistols/Automatic-Rifles/Smoke-Grenades/Rocket Launcher, Shotguns.",
                "himg": "./img/michael.png",
                "hclients": 195,
                "uclients": 5,
                "clients": 200,
                "hitmandiscription": "He tends to bring the biggest gun and a lot of ammo to feed it. Breaking down his movement, style and technique, it is obvious that “Will“ is ex-military. It is likely he was special forces, and, based on overheard conversation, possibly even a former Navy SEAL."
            },
            "Thor": {
                "pnumber": "+45 12 34 56 78",
                "weapons": "Knife",
                "himg": "./img/trevor.png",
                "hclients": 45,
                "uclients": 5,
                "clients": 50,
                "hitmandiscription": "A true enigma. We have no intel on this guy, and his habit of communicating through an 80’s model dictaphone means we don’t even have a voice. All we really know is that he is dangerously psychotic - a sociopath. His profile is to get close and cause as much traumatic damage as possible with high damage melee weapons."
            },
            "Vald": {
                "pnumber": "+45 12 34 56 78",
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
        setTimeout(()=> {
            if(hitmanname == undefined){
                
            } else {
                document.getElementById('pnumber').innerHTML = hitmaninfo[hitmanname]['pnumber'];
                document.getElementById('weapons').innerHTML = hitmaninfo[hitmanname]['weapons'];
                document.getElementById('himg').src = hitmaninfo[hitmanname]['himg'];
                document.getElementById('hitmandiscription').innerHTML = hitmaninfo[hitmanname]['hitmandiscription'];
                document.getElementById('hclients').innerHTML = hitmaninfo[hitmanname]['hclients'];
                document.getElementById('uclients').innerHTML = hitmaninfo[hitmanname]['uclients'];
                document.getElementById('clients').innerHTML = hitmaninfo[hitmanname]['clients'];
                document.getElementsByClassName('contactbutton').id = hitmanname;
            }
            document.getElementById('torloaderi').style.display = "none";
            document.getElementById('tabname').innerHTML = page;
            document.getElementById('taburl').value = appsetting[appname][page]['url'];
            document.getElementById('torapp').style.background = appsetting[appname][page]['color'];
            app.style.display = "block";
        }
        ,1);
    };

    $('#transfer').click(function (e) {
        let directory = GetParentResourceName()
        $.post('https://' + directory + '/transfer', JSON.stringify({
            to: $('#fcval').val(),
            amountt: $('#fcamt').val(),
            message: $('#fcmsg').val()
        }));
        $('#fcamt').val('');
    });

    function contact(x) {
        var person = document.getElementsByClassName(x).id;
        
    };

    function calcfc(x) {
        y = x/169165
        return y
    }

    function FCONload(crypto) {

        fcexchange = document.getElementById('tabname2').innerHTML = "Your FC balance: " + crypto.toString();

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
            document.getElementById(key+"2").innerHTML = (z.toString()).slice(0,5);
        }
        fcexchange = document.getElementById('fcexc').innerHTML;
    }

    function ButSTUFF(item,price) {
        let directory = GetParentResourceName()
        $.post('https://' + directory + '/buy', JSON.stringify({
            item:item,
            price:price
        }))
    };
//function BackButton() {
//    const usefullpages = [];
//    var pages = document.getElementById('pages').children;
//    for (var i = 0, len = pages.length; i < len; i++) {
//        usefullpages.push(pages[i].id);
//    }
//    usefullpages.splice(0, 2);
//    for (var i of usefullpages) {
//        if(document.getElementById(i).style.display=="block") {
//            ChangePage('OnionLinks','tor')
//        }
//    }
//};