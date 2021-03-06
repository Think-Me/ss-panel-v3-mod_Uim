<div class="row">

        <div class="col-lg-6 col-md-6">
            <p class="card-heading">TrimePay 充值</p>
            <div class="form-group form-group-label">
                <label class="floating-label" for="amount">金额</label>
                <input class="form-control" id="amount" type="text" >
            </div>
        </div>
        <div class="col-lg-6 col-md-6">
            <p class="h5 margin-top-sm text-black-hint" id="qrarea"></p>
        </div>
</div>

    <div class="card-action">
        <div class="card-action-btn pull-left">
            <br>
            <button class="btn btn-flat waves-attach" id="btnSubmit" name="type" onclick="pay('Alipay')"><img src="/images/alipay.jpg" width="50px" height="50px" /></button>
            <button class="btn btn-flat waves-attach" id="btnSubmit" name="type" onclick="pay('WEPAY_QR')"><img src="/images/weixin.jpg" width="50px" height="50px" /></button>
        </div>
    </div>

<script>
    var pid = 0;

    $('body').append("<script src=\" \/assets\/public\/js\/jquery.qrcode.min.js \"><\/script>");

    function pay(type){
        if (type==='Alipay'){
            if(/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
                type = 'ALIPAY_WAP';
            } else {
                type = 'ALIPAY_WEB';
            }
        }

        var price = parseFloat($("#amount").val());

        console.log("将要使用 "+ type + " 充值" + price + "元");
        if (isNaN(price)) {
            $("#result").modal();
            $("#msg").html("非法的金额!");
        }
        $('#readytopay').modal();
        $("#readytopay").on('shown.bs.modal', function () {
            $.ajax({
                'url': "/user/payment/purchase",
                'data': {
                    'price': price,
                    'type': type,
                },
                'dataType': 'json',
                'type': "POST",
                success: function (data) {
                    if (data.code == 0) {
                        $("#result").modal();
                        $("#msg").html("正在跳转到支付宝...");
                        console.log(data);
                        if(type == 'ALIPAY_WAP' || type =='ALIPAY_WEB'){
                            window.location.href = data.data;
                        } else {
                            $("#readytopay").modal('hide');
                            $("#qrarea").html('<div class="text-center"><p>使用微信扫描二维码支付.</p><div id="qrcode" style="padding-top:  10px;"></div><p>充值完毕后会自动跳转</p></div>');
                            $("#qrcode").qrcode({
                                render: "canvas",
                                width: 100,
                                height: 100,
                                "text": data.data
                            });

                        }
                    } else {
                        $("#result").modal();
                        $("#msg").html(data.msg);
                        console.log(data);
                    }
                }
            });
        });
    }

</script>