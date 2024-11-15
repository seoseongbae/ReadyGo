package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class DeclarationVO {
   private String dclrNo;      //신고번호
   private String dclrTp;      //신고카테고리
   private String dclrCn;      //신고내용
   private String dclrUrl;      //신고URL
   private String dclrDt;      //신고날짜
   private String dclrPrcsSttus;   //신고상태
   private String pstSn;      //게시글번호
   private String mbrId;      //신고당한사람
   private String dclrField;   //게시판인지 댓글인지
   
   private String mbrNm;
   private String mbrEml;
   private String enabled;
}
