<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Title</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        :root {
            --padding: 60px;
        }
        .box {
            position: relative;
            margin: 50px auto;
            width: 400px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: var(--padding);
            background-color: #c4dfff;
            border-radius: 7px;
        }
        .box input,
        .box button {
            padding: 15px;
            font-size: 1.2em;
            border: none;
        }
        .box input {
            margin-bottom: 25px;
        }
        .box button {
            background-color: #ffebe0;
            color: #547fb2;
            border-radius: 4px;
        }
        div {
            position: absolute;
            font-size: 1em;
            font-weight: bold;
        }
        #idCheckResult {
            top: 9%;
        }
        #emCheckResult{
            top: 28%;
        }

    </style>
</head>
<body>
<form id="joinform" class="box" action="join.do" method="post" onsubmit="return validateForm(this);">
    <div id="idCheckResult"></div>
    <input type="text" onkeyup="checkId()" placeholder="ID" name="id" id="id" minlength="4" maxlength="10" required>
    <input type="email" placeholder="Email" onkeyup="checkEm()" name="email" id=email />
    <div id="emCheckResult"></div>
    <input type="password" onkeyup="checkPw()" placeholder="Password" name="pw" id="pw" minlength="4" maxlength="10" required/>
    <div id="pwCheckResult"></div>
    <button name="submit">Sign Up</button>
</form>

<script type="text/javascript">
    const elInputId = document.querySelector('#id');
    const elInputPw = document.querySelector('#pw');
    const elInputEm = document.querySelector('#email');
    // 아이디 유효성 검사
    function joinId(str) {
        return /^[A-Za-z0-9][A-Za-z0-9]*$/.test(str);
    }

    function joinEmail(asValue) {
        return /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i.test(asValue);
    }

    function checkEm() {
        const emCk = document.getElementById("emCheckResult");
        if(joinEmail(elInputEm.value) === true) {
            emCk.innerText = "사용 가능한 이메일입니다.";
            emCk.style.color = "green";
        } else if(joinEmail(elInputEm.value) === false) {
        emCk.innerText = "이메일 형식을 확인해주세요.";
        emCk.style.color = "red";
        }
    }

    // 비밀번호 조건
    function checkPw() {
        const pwCk = document.getElementById("pwCheckResult");
        if(elInputPw.value.length >= 4) {
            pwCk.innerText = "사용 가능한 비밀번호입니다.";
            pwCk.style.color = "green";
        } else if(elInputPw.value.length < 4) {
            pwCk.innerText = "4~10글자, 영어와 숫자로 입력해주세요.";
            pwCk.style.color = "red";
        }
    }
    // 아이디 중복 확인
    function checkId() {
        var id = document.getElementById("id").value; // 입력된 아이디 가져오기

        // 서버로 중복 확인 요청을 보냅니다.
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/member1/checkId.do", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var result = xhr.responseText; // 서버에서 받은 결과 (true 또는 false)
                var resultDiv = document.getElementById("idCheckResult");

                if(elInputId.value.length >= 4){
                    if(joinId(elInputId.value) === true ) {
                        if (result === "true") {
                            resultDiv.innerHTML = "사용 가능한 아이디입니다.";
                            resultDiv.style.color = "green";
                        } else if ( result === "false") {
                            resultDiv.innerHTML = "이미 사용 중인 아이디입니다.";
                            resultDiv.style.color = "red";
                        }
                    } else  {
                        resultDiv.innerHTML = "영어와 숫자로 입력해주세요.";
                        resultDiv.style.color = "red";
                    }
                } else {
                    resultDiv.innerHTML = "4~10글자, 영어와 숫자로 입력하세요."
                    resultDiv.style.color = "red";
                }
            }
        }
        // 서버로 아이디를 전송합니다.
        var data = "id=" + encodeURIComponent(id);
        xhr.send(data);
    }

    // 비밀번호 해시화
    const myForm = document.getElementById('joinform');
    myForm.addEventListener('submit', async function (event) {
        console.log("1");
        event.preventDefault(); // 기본 제출 동작을 막음
        await validateForm(this); // this는 현재 폼을 가리킴
        HTMLFormElement.prototype.submit.call(myForm)
    })
    async function validateForm(form) {
        if(!joinId(elInputId.value)) {
            alert("아이디를 다시 입력해주세요");
            elInputId.focus();
            return joinId(str); // 아이디가 유효하지 않으면 submit 방지
        }
        if(!joinEmail(elInputEm.value)){
            alert("이메일을 다시 입력해주세요.");
            elInputEm.focus();
            return joinEmail(asValue);
        }
        // 비밀번호 해시화
        const hashedPw = await sha256(form.pw.value);
        form.pw.value = hashedPw;
    }
    async function sha256(str) {
        return crypto.subtle.digest('SHA-256', new TextEncoder().encode(str))
            .then(buffer => Array.prototype.map.call(new Uint8Array(buffer), x => ('00' + x.toString(16)).slice(-2)).join(''));
    }
</script>
</body>
</html>
