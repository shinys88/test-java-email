<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Email Send</title>

    <!-- 부트스트랩 -->
    <link href="${cp}/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- 서비스 스타일 -->
    <link href="${cp}/service/css/style.css" rel="stylesheet">
    <!-- rangeSlider -->
    <link href="${cp}/service/css/ion.rangeSlider.css" rel="stylesheet">

    <!-- IE8 에서 HTML5 요소와 미디어 쿼리를 위한 HTML5 shim 와 Respond.js -->
    <!-- WARNING: Respond.js 는 당신이 file:// 을 통해 페이지를 볼 때는 동작하지 않습니다. -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요합니다) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>

    <!-- include summernote css/js -->
    <link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote.css" rel="stylesheet">
    <script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote.js"></script>

    <!-- Excel -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>

    <style>

        body {
            padding: 0px;
        }

        #add-item {
            display: block;
            background: #eee;
            overflow-y: scroll;
            width: 100%;
            height: 430px;
            padding: 10px;
            padding-top: 0px;
        }

        #add-item input[type=text] {
            background: #ddd;
        }

        #loading {
            display:none;
            background:rgba(255,255,255,0.5);
            width:100%;
            height:100%;
            position:fixed;
            left:0;
            top:0;
            z-index:99999;
        }

        #loading img{
            position:absolute;
            top:50%;
            left:50%;
            margin-left:-20px;
            margin-top:-20px;
            width: 40px;
            height: 40px;
        }

    </style>

</head>
<body role="document">


<div id="test-content" class="container theme-showcase" role="main">
    <div class="page-header">
        <h1 style="display: inline-block; width:49%;">이메일 보내기</h1>
        <h4 style="display: inline-block; text-align: right; width:50%;">보내는 이메일 : ${fromNm}(${from})</h4>
    </div>
    <form action="/mail/send.data" method="post">
        <div class="row">
            <div class="col-sm-8">
                <input id="title" type="text" name="title" class="form-control" placeholder="이메일 제목" required>
                <textarea id="summernote" name="editordata"></textarea>

            </div><!-- /.col-sm-8 -->

            <div class="col-sm-4">

                <div class="form-group">
                    <div class="input-group input-file" name="Fichier1">
                        <span class="input-group-btn">
                        <button class="btn btn-reset btn-danger" type="button">reset</button>
                        </span>
                        <input type="text" class="form-control" placeholder='Choose a file...' "/>
                        <span class="input-group-btn">
                            <button class="btn btn-choose btn-warning" type="button">Excel Import</button>
                        </span>
                    </div>
                </div>

                <div class="input-group control-group after-add-more">
                    <input type="text" id="input-add" class="form-control" placeholder="Enter E-Mail Here"
                           autocomplete="off">
                    <div class="input-group-btn">
                        <button class="btn btn-success add-more" type="button"><i class="glyphicon glyphicon-plus"></i>
                            Add
                        </button>
                    </div>
                </div>

                <div id="add-item" class="input-group control-group">

                </div>

                <div style="margin-top:10px; margin-bottom:20px;">
                    <div id="btn_init" class="btn btn-lg btn-success" style="width:49%;">
                        초기화
                    </div>
                    <div id="btn_email" class="btn btn-lg btn-primary" style="width:49.8%;">
                        메일 보내기
                    </div>
                </div>


                <div id="msg_result">

                </div>

            </div>
        </div>
    </form>
</div>


<!-- Copy Fields -->
<div class="copy hide">
    <div class="control-group input-group" style="margin-top:10px">
        <input type="text" name="addmores" class="form-control" placeholder="Enter E-Mail Here"
               autocomplete="off" readonly>
        <div class="input-group-btn">
            <button class="btn btn-danger remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i> Remove
            </button>
        </div>
    </div>
</div>


<div id="loading">
    <img id="loading_img" src="${cp}/service/img/loading.png">
</div>



<!-- 모든 컴파일된 플러그인을 포함합니다 (아래), 원하지 않는다면 필요한 각각의 파일을 포함하세요 -->
<script src="${cp}/bootstrap/js/bootstrap.min.js"></script>
<!-- DatePicker Add -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.5.0/css/bootstrap-datepicker3.min.css">
<script type='text/javascript'
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.5.0/js/bootstrap-datepicker.min.js"></script>
<script src="${cp}/bootstrap/js/bootstrap-datepicker.kr.js" charset="UTF-8"></script>


<script type="text/javascript">

    $('#summernote').summernote({
        placeholder: '이메일 내용',
        tabsize: 1,
        height: 470,
        lang: 'ko-KR'
    });

    $("#fileInput").on('change', function () {  // 값이 변경되면
        if (window.FileReader) {  // modern browser
            var filename = $(this)[0].files[0].name;
        } else {  // old IE
            var filename = $(this).val().split('/').pop().split('\\').pop();  // 파일명만 추출
        }
        // 추출한 파일명 삽입
        $("#userfile").val(filename);
    });

    $("body").on("click", ".remove", function () {
        $(this).closest(".control-group").remove();
        // .parents(".control-group").remove();
        addSize();
    });

    function addAction(inputTxt) {
        if (inputTxt == null) {
            inputTxt = $(".after-add-more .form-control").val();
        }

        if (inputTxt == "") {
            return;
        }

        var html = $(".copy").html();
        $("#add-item").prepend(html);
        // $(".after-add-more").after(html);

        $("#add-item .control-group").eq(0).find(".form-control").val(inputTxt);
        $(".after-add-more .form-control").val("");

        addSize();

    }

    function addSize() {
        var size = $("#add-item .control-group").length;
        $("#btn_email").html("메일 보내기 ( " + size + "명 )")
    }


    $(".add-more").click(function () {
        addAction();
    });

    $("#input-add").keydown(function (e) {
        if (e.keyCode == 13) {
            addAction();
            e.preventDefault();
        }
    });

    $("#title").keydown(function (event) {
        if (event.keyCode === 13) {
            event.preventDefault();
        }
        ;
    });


    //파일첨부 디자인
    bs_input_file();

    function bs_input_file() {
        $(".input-file").before(
            function () {

                if (!$(this).prev().hasClass('input-ghost')) {
                    var element = $("<input type='file' class='input-ghost' onchange='excelExport(event)' style='visibility:hidden; height:0'>");

                    element.attr("name", $(this).attr("name"));
                    element.change(function () {
                        element.next(element).find('input').val((element.val()).split('\\').pop());
                    });
                    $(this).find("button.btn-choose").click(function () {
                        element.click();
                    });
                    $(this).find("button.btn-reset").click(function () {
                        element.val(null);
                        $(this).parents(".input-file").find('input').val('');
                    });
                    $(this).find('input').css("cursor", "pointer");
                    $(this).find('input').mousedown(function () {
                        $(this).parents('.input-file').prev().click();
                        return false;
                    });
                    return element;
                }
            }
        );
    }


    $("#btn_init").click(function () {
        location.reload();
    });

    $("#btn_email").click(function () {

        if($("#add-item .control-group").length === 0){
            alert("수신자를 추가해주세요.");
            return;
        }

        if($("#title").val() === ""){
            alert("제목을 입력해주세요.");
            return;
        }

        if($("#summernote").val() === ""){
            alert("내용을 입력해주세요.");
            return;

        }

        $("#loading").css("display","block");
        $("#loading").show();
        var angle = 0;

        var loading_rotate = setInterval(function(){
            angle-=10;
            $("#loading img").css('-webkit-transform','rotate('+angle+'deg)');
            $("#loading img").css('transform','rotate('+angle+'deg)');
        },40);


        $.ajax({
            url: 'mail/send.data',
            type: 'post',
            data: $('form').serialize(),
            success: function (data) {
                clearInterval(loading_rotate);
                $("#loading").css("display","none");

                $("#msg_result").html("");

                if (data.failedList.length > 0) {

                    var result_txt = `
                            <div class="alert alert-danger" role="alert">
                                <strong>메일 발송 실패!</strong>
                         `;

                    for (var i = 0; i < data.failedList.length; i++) {
                        var keys = Object.keys(data.failedList[i]);
                        result_txt += "<br>" + keys[0] + " : " + data.failedList[i][keys[0]];
                    }

                    result_txt += "</div>";

                    $("#msg_result").append(result_txt);
                }

                if (data.successList.length > 0) {


                    var result_txt = `
                            <div class="alert alert-success" role="alert">
                                <strong>메일 발송 완료!</strong>
                        `;

                    for (var i = 0; i < data.successList.length; i++) {
                        var keys = Object.keys(data.successList[i]);
                        result_txt += "<br>" + keys[0] + " : " + data.successList[i][keys[0]];
                    }

                    result_txt += "</div>";


                    $("#msg_result").append(result_txt);

                }


            }
        });
    });


    //==== Excel ====

    function excelExport(event) {
        excelExportCommon(event, handleExcelDataAll);
    }

    function excelExportCommon(event, callback) {
        var input = event.target;
        var reader = new FileReader();
        reader.onload = function () {
            var fileData = reader.result;
            var wb = XLSX.read(fileData, {type: 'binary'});
            var sheetNameList = wb.SheetNames; // 시트 이름 목록 가져오기
            var firstSheetName = sheetNameList[0]; // 첫번째 시트명
            var firstSheet = wb.Sheets[firstSheetName]; // 첫번째 시트
            callback(firstSheet);
        };
        reader.readAsBinaryString(input.files[0]);
    }

    function handleExcelDataAll(sheet) {
        // handleExcelDataHeader(sheet); // header 정보
        handleExcelDataJson(sheet); // json 형태
        // handleExcelDataCsv(sheet); // csv 형태
        // handleExcelDataHtml(sheet); // html 형태
    }

    function handleExcelDataJson(sheet) {
        // $("#displayExcelJson").html(JSON.stringify(XLSX.utils.sheet_to_json (sheet)));
        console.log(JSON.stringify(XLSX.utils.sheet_to_json(sheet)));
        console.log(XLSX.utils.sheet_to_json(sheet));
        var xls_json = XLSX.utils.sheet_to_json(sheet);

        for (var i = 0; i < xls_json.length; i++) {
            addAction(xls_json[i]['이메일']);
        }

    }


</script>


</body>

</html>


