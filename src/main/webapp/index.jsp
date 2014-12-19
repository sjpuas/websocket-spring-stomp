<!DOCTYPE html>
<html>
<head>
    <title>Chat</title>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet">


    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
    <script src="//cdn.jsdelivr.net/sockjs/0.3.4/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <style>
        .contentDiv {
            width: 100%;
            height: 400px;
            border-color: #dddddd;
            border-width: thin;
            border-style: solid;
            border-radius: 4px;
            display: block;
            padding: 5px;
            overflow: auto;
        }

        .rigthDiv {
            width: 100%;
            height: 200px;
            border-color: #dddddd;
            border-width: thin;
            border-style: solid;
            border-radius: 4px;
            display: block;
            padding: 5px;
            overflow: auto;
        }

        .username {
            font-weight: bold;
            color: #555599;
        }

        .channel-selected {
            background: greenyellow;
        }

    </style>

</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-xs-9">
            <h1>Chat room</h1>
        </div>

    </div>
    <div class="row">
        <div class="col-xs-9">
            <div><h3>Chat</h3></div>
            <div class="contentDiv" id="chatBox">
                <!--           <div><span class="username">hsilomedus : </span><span>whass uuup?</span></div> -->
            </div>
        </div>
        <div class="col-xs-3">
            <div><h3>Channels</h3></div>
            <div class="rigthDiv" id="channelsBox">
                <div data-channel="news" class="username">News</div>
                <div data-channel="weather" class="username">Weather</div>
            </div>
            <div><h3>Users</h3></div>
            <div class="rigthDiv" id="nicknamesBox">
                <!--           <div class="username">hsilomedus</div> -->
            </div>
        </div>

    </div>
    <div class="row" style="margin-top:10px;">
        <div class="col-xs-7"><input type="text" id="txtMessage" class="form-control"
                                     placeholder="Type your message here."/></div>
        <div class="col-xs-2">
            <button id="btnSend" class="btn btn-primary" style="width:100%;">Send</button>
        </div>
    </div>
</div>

<div class="modal fade" id="login_modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Enter your nickname</h4>
            </div>
            <div class="modal-body">
                <div>Please enter your desired nickname:</div>
                <div style="margin-top:5px;"><input type="text" id="nickname" class="form-control" style="width:200px;"
                                                    placeholder="Nickname..."/></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btnLogin">Login</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    var stompClient = null;
    var connected = false;
    var subscription = null;

    var $channels = $("#channelsBox");
    var $users = $("#nicknamesBox");
    var $chat = $("#chatBox");
    var $message = $("#txtMessage");

    $("[data-channel]").on('click', function () {
        $("[data-channel]").removeClass("channel-selected");
        var channel = $(this).data("channel");
        if (stompClient && connected) {
            if (subscription) {
                subscription.unsubscribe();
            }
            $(this).addClass("channel-selected");
            subscription = stompClient.subscribe('/topic/' + channel, function (message) {
                showMessage(JSON.parse(message.body));
            });
        }
    });


    function connect() {
        var socket = new SockJS("http://" + document.domain + ":8080/websocket-spring/chat", undefined, {debug: false});
        stompClient = Stomp.over(socket);
        stompClient.debug = null;
        stompClient.connect({}, function () {
            connected = true;
        });
    }

    function disconnect() {
        stompClient.disconnect();
        connected = false;
        console.log("Disconnected");
    }

    function sendMessage() {
        var message = $message.val();
        var channel = $(".channel-selected").data("channel");
        if (channel) {
            stompClient.send("/app/" + channel, {}, JSON.stringify({'message': message}));
        }
    }

    function showMessage(json) {
        var d = document.createElement('div');
        var suser = document.createElement('span');
        var smessage = document.createElement('span');

        $(suser).addClass("username").text(json.nickname + " : ").appendTo($(d));
        $(smessage).text(json.message).appendTo($(d));
        $(d).appendTo($chat);
        $chat.scrollTop($chat[0].scrollHeight);

    }

    $message.keyup(function (e) {
        if (e.keyCode == 13) {
            sendMessage();
        }
    });
    $("#btnSend").click(function () {
        sendMessage();
    });

    connect();


</script>

</body>
</html>