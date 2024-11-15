package kr.or.ddit.service_DO;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.FileDetailVO;

public interface NoticeService {
	
	//등록
	public String admRegist();
	
	//등록Post
	public int admRegistPost(BoardVO boardVO);
	
	// 목록
	public List<BoardVO> admList(Map<String, Object> map);

	// 페이지 전체 수
	public int getTotal();
	
	//상세
	public BoardVO admDetail(String pstSn);

	//조회수
	public void InqCnt(String pstSn);

	//수정사이트
	public String update(String pstSn);
	
	// 삭제
	public int deletePost(String pstSn);

	// 수정할때 게시글 데이터가져오기
	public BoardVO getPostDetails(String pstSn);

	// 수정완료
	public int updatePost(BoardVO boardVO);

	public List<FileDetailVO> getFileDetailsByPstSn(String pstSn);

}
