package com.send;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.*;

@Controller
@RequestMapping("/mail")
public class SendController {


    final String HOST = "smtp.naver.com";
    final String USERNAME = "userId";
    final String PASSWORD = "userPw";
    final int PORT = 465;

    //메일 내용
    String from = "Email";   //보내는 사람의 메일주소
    String fromNm = "Name";             //보내는 사람의 이름


    @RequestMapping("")
    public String mail(Model model){
        model.addAttribute("from", from);
        model.addAttribute("fromNm", fromNm);
        return "send/mail";
    }


//    메일 보내기
    @RequestMapping("/send.data")
    public String sendMail(Model model,
                           @RequestParam("addmores") List<String> userList,
                           @RequestParam("title") String title,
                           @RequestParam("editordata") String getContent){

        List<Map<String,String>> successList = new ArrayList<>();
        List<Map<String,String>> failedList = new ArrayList<>();

        for(String reUser : userList) {

            Map<String, String> resultMap = new HashMap<>();

            resultMap.put(reUser,"fail");

            Properties props = System.getProperties();  //정보를 담기 위한 객체 생성

            //SMTP 서버 정보 설정
            props.put("mail.smtp.host", HOST);
            props.put("mail.smtp.prot", PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.trust", HOST);

            //Session 생성
            Session session = Session.getDefaultInstance(props, new Authenticator() {
                String un = USERNAME;
                String pw = PASSWORD;

                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(un, pw);
                }
            });
            session.setDebug(true); //for debug

            Message mimeMessage = new MimeMessage(session);
//        List<InternetAddress> ia = new ArrayList<>();

            try {
//            ia.add(new InternetAddress("sys0130@naver.com"));
//            ia.add(new InternetAddress("sinyusu129@gmail.com"));
//            InternetAddress[] ia2 = ia.toArray(new InternetAddress[ia.size()]);
                mimeMessage.setFrom(new InternetAddress(from,fromNm,"UTF-8")); //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요.
//            mimeMessage.setRecipients(Message.RecipientType.TO, ia2); //수신자셋팅
                mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(reUser)); //수신자셋팅
                // .TO 외에 .CC(참조) .BCC(숨은참조) 도 있음
                mimeMessage.setSubject(title);    //제목셋팅
//            mimeMessage.setText(body);          //내용셋팅
                mimeMessage.setContent(getContent, "text/html; charset=utf-8");

//                mimeMessage.setHeader("X-Mailer", "KOSCOM Mail Client");
//                mimeMessage.setHeader("X-MSMail-Priority", "Normal");
//                mimeMessage.setHeader("X-Priority", "3");
//                mimeMessage.setHeader("Disposition-Notification-To", from);

                Transport.send(mimeMessage);


                resultMap.put(reUser,"success");
                successList.add(resultMap);
            } catch (Exception e) {
                e.printStackTrace();
                resultMap.put(reUser,"failed");
                failedList.add(resultMap);
            }

        }

        model.addAttribute("successList", successList);
        model.addAttribute("failedList", failedList);

        return "jsonView";
    }

}
