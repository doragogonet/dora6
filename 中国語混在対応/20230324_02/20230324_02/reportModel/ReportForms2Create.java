//sxt 20220518 add
package cn.com.edic.hanbai.report.reportModel;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.nio.charset.Charset;				//sxt 20230323 add
import java.nio.charset.CharsetEncoder;			//sxt 20230323 add

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfBorderDictionary;
import com.lowagie.text.pdf.PdfFormField;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.TextField;
import com.lowagie.text.Font;			//sxt 20230323 add
import com.lowagie.text.pdf.BaseFont;	//sxt 20230323 add

import cn.com.edic.hanbai.common.dao.BeanHandler;
import cn.com.edic.hanbai.common.dao.BeanListHandler;
import cn.com.edic.hanbai.common.dao.QueryRunner;
import cn.com.edic.hanbai.common.dao.ResultSetHandler;
import cn.com.edic.hanbai.common.model.TbCodeModel;
import cn.com.edic.hanbai.common.model.TbMrkSalesModel;
import cn.com.edic.hanbai.common.util.FieldFormatter;
import cn.com.edic.hanbai.common.util.HanbaiConstants;
import cn.com.edic.hanbai.common.util.HannbaiResource;
import cn.com.edic.hanbai.common.validation.ValidatorUtil;
import cn.com.edic.hanbai.mitumori.MitumoriPrintManager;
import cn.com.edic.hanbai.report.util.Const;
import cn.com.edic.hanbai.report.util.ReportFormsFont;

public class ReportForms2Create {

	/* ログ出力ハンドルを取得 */
	public static Logger _logger = Logger.getLogger(MitumoriPrintManager.class.getName());

	//幅の割合
	private final int WIDTH_PERCENTAGE = 100;
	//private final int headerwidths[] = { 3, 9, 2, 5, 5, 5, 5, 3, 6, 9 };	//sxt 20220922 del
	//private final int headerwidths[] = { 3, 9, 5, 2, 5, 5, 5, 3, 6, 9 };	//sxt 20220922 add	//sxt 20221026 del
	private final int headerwidths[] = { 3, 15, 5, 2, 5, 5, 3, 6, 8 };		//sxt 20221026 add
	private final int commonGroundWidths[] = { 19, 1 , 1 , 18 };
	private final int commonGroundNameWidths[] = { 201, 100 };
	private final int commonGroundjiangyingWidths[] = { 19, 1 , 7 , 12 };
	private final int commonGroundZipWidths[] = { 5, 10 , 10 , 10 };
	private final int jianyingwidths[] = { 1, 3, 3, 3 };
	private final int zipwidths[] = { 1 };
	private final int commonGroundLeftWidths[] = { 100 };
	private final int calculateWidths[] = { 27, 3, 70 };
	private final int calculateWidths2[] = { 1, 2 };
	private final int calculateWidths3[] = { 1, 3 };
	private final int calculateWidths4[] = { 4, 96 };
	private final int calculateWidths5[] = { 1, 4 };		//sxt 20220822 add
	private final int calculateWidths6[] = { 18, 3, 44, 36 };	//sxt 20220822 add

	//足し算のWidths
	private final int summationWidths[] = { 4, 13 , 1 , 17 };
	private final int summationWidths3[] = { 6, 11 , 1 , 17 };		//sxt 20220816 add
	//会社インフォメーション幅
//	private final int companyInfoWidths[] = { 15, 2 , 8 , 10 };

	//private final int companyInfoNameWidths[] = { 19, 0 , 1 };
	private final int companyInfoNameWidths[] = { 44, 6 , 50 };

	private final int inkanImageGroundWidths[] = { 31,  18 };	//20200602 add

	private int countname = 0;
	//期待長さ
	private final long LENGTH_LEFT = 100L;
//	private final long LENGTH_RIGHT = 53L;
	private final long LENGTH_RIGHT = 57L;


	//首ページの明細部の最大行数
//	private final int FIRST_PAGE_FIXATION_LENGTH = 40;
//	private final int FIRST_PAGE_HATTYU_LENGTH = 38;
	private final int FIRST_PAGE_FIXATION_LENGTH = 36;
	private final int FIRST_PAGE_HATTYU_LENGTH = 34;

	//次ページの明細部の最大行数
//	private final int NEXT_PAGE_FIXATION_LENGTH = 53;
	private final int NEXT_PAGE_FIXATION_LENGTH = 45;

	//private final int numColumns = 10;		//sxt 20221026 del
	private final int numColumns = 9;			//sxt 20221026 add
	private final int commonGroundNameColumns = 2;
	private final int commonGroundNumColumns = 4;
	private final int commonGroundNumThreeColumns = 3;
	private final int commonGroundNumLeftColumns = 1;
	//字体なら以下を取得する
	private ReportFormsFont reportFormsFont;
	//sxt 20230323 add start
	private BaseFont bfHeiseiMinW3;		//明朝体っぽい字体
	private BaseFont bfHeiseiKakuGoW5;	//ゴシックっぽい字体
	private BaseFont bfSTSongStdLight;	//中文字体
	//sxt 20230323 add end
	
	//見積番号
	private List estimateCode;

	//受注番号
	private List receive_no;

	//発注番号
	private List order_no_print;


	//売上番号
	private List salesCode;


	private int notShow = 0;

//	private int show = 1;

	private final String DIS = "-1";

	Image image = null;

	public QueryRunner qr = new QueryRunner();

	public final String NULL_STR = "　　　　 ";

	public final String NULL_STR2 = "　　　";

	public final String NULL_STR3 = "　　　　";

	public final String NULL_STR4 = "  ";

	public final String NULL_STR5 = "    ";

	public final String NULL_STR6 = "                       ";

	public final String NULL_STR7 = " ";

	public final String NULL_STR8 = "          ";

	private String kigyou_code="";

	public String getKigyou_code() {
		return kigyou_code;
	}

	public void setKigyou_code(String kigyou_code) {
		this.kigyou_code = kigyou_code;
	}

	/**
     * 見積番号を取得しまする<BR>
     * <BR>
     * @return List 見積番号
     */
	public List getEstimateCode() {
		return estimateCode;
	}

    /**
     * 見積番号を設定します<BR>
     * <BR>
     * @param estimateCode 見積番号
     */
	public void setEstimateCode(List estimateCode) {
		this.estimateCode = estimateCode;
	}

	/**
     * 売上番号を取得しまする<BR>
     * <BR>
     * @return List 売上番号
     */
	public List getSalesCode() {
		return salesCode;
	}
	/**
     * 売上番号を設定します<BR>
     * <BR>
     * @param salesCode 売上番号
     */
	public void setSalesCode(List salesCode) {
		this.salesCode = salesCode;
	}
	
	// sxt 20230323 add start
		public static boolean isJapaneseString(String str) { 
			CharsetEncoder encoder = Charset.forName("Shift-JIS").newEncoder(); 
			return encoder.canEncode(str); 
		}
				
		private void init() throws DocumentException, IOException {

			//明朝体っぽい字体なら以下を設定しまする
			if (this.bfHeiseiMinW3 == null) {
				this.bfHeiseiMinW3 = BaseFont.createFont("HeiseiMin-W3", "UniJIS-UCS2-HW-H",false);
			}
			
			//ゴシックっぽい字体なら以下の設定にします
			if (this.bfHeiseiKakuGoW5 == null) {
				this.bfHeiseiKakuGoW5 = BaseFont.createFont("HeiseiKakuGo-W5", "UniJIS-UCS2-H",false);
			}
			
			//中文字体なら以下の設定にします
			if (this.bfSTSongStdLight == null) {
				this.bfSTSongStdLight = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H",false);
			}
		}
		
		/**
		 * 明朝体っぽい字体なら以下を取得する<br>
		 * <br>
		 * param size 	int
		 * @return Font
		 * @throws IOException
		 * @throws DocumentException
		 */
		private Font getHeiseiMinW3Font(int size) throws DocumentException, IOException {
			Font font = new Font(this.bfHeiseiMinW3, size);
			return font;
		}

		/**
		 * ゴシックっぽい字体なら以下の設定にしますを取得する<br>
		 * <br>
		 * param size 	int
		 * @return Font
		 * @throws IOException
		 * @throws DocumentException
		 */
		private Font getHeiseiKakuGoW5Font(int size) throws DocumentException, IOException {
			Font font = new Font(this.bfHeiseiKakuGoW5, size);
			return font;
		}
		
		/**
		 * 中文字体なら以下の設定にしますを取得する<br>
		 * <br>
		 * param size 	int
		 * @return Font
		 * @throws IOException
		 * @throws DocumentException
		 */
		private Font getSTSongStdLightFont(int size) throws DocumentException, IOException{
			Font font = new Font(this.bfSTSongStdLight, size);
			return font;
		}
		
		private Paragraph getParagraph(String txt, int fontSize ) throws DocumentException, IOException {
			Paragraph paragraph = new Paragraph(); 
			
			 for (char c : txt.toCharArray()) {
				 Chunk chuck;
				 //判断字符是否符合日文编码
				 if (isJapaneseString(Character.toString(c))) {
					 chuck = new Chunk(Character.toString(c), this.getHeiseiMinW3Font(fontSize)); 
				 } else {
					 chuck = new Chunk(Character.toString(c), this.getSTSongStdLightFont(fontSize)); 
				 }
				 paragraph.add(chuck);
			 }
			 	
			return paragraph;
		}
		//sxt 20230323 add end

	/**
     * PdfPTableにPdfPTableを設定する<BR>
     * <BR>
     * @param pdfPTable PdfPTable
     */
	private void setPdfPTableAttribute(PdfPTable pdfPTable){
		pdfPTable.setWidthPercentage(WIDTH_PERCENTAGE);
		pdfPTable.getDefaultCell().setPadding(3);
		pdfPTable.getDefaultCell().setBorderWidth(2);
	}

	private void setPdfPTableAttribute2(PdfPTable pdfPTable){
		pdfPTable.getDefaultCell().setPadding(0);
		pdfPTable.getDefaultCell().setBorderWidth(0);
	}

    /**
     * 字体なら以下を取得するを取得します<BR>
     * <BR>
     * @return ReportFormsFont 見積番号
     */
	public ReportFormsFont getReportFormsFont() {
		return this.reportFormsFont = new ReportFormsFont();
	}

	/**
     * 字体なら以下を取得するを設定する<BR>
     * <BR>
     * @param reportFormsFont 字体なら以下を取得する
     */
	public void setReportFormsFont(ReportFormsFont reportFormsFont) {
		this.reportFormsFont = reportFormsFont;
	}

//	/**
//     * PdfPTableを設定する<BR>
//     * <BR>
//     * @param dateValue 御見日期
//     * @exception SQLException
//     * @exception DocumentException
//     * @exception IOException
//     */
//	private PdfPTable captionTable(Image image,String dataValue) throws SQLException,DocumentException, IOException{
//
//		//PdfPTableの作成
//		PdfPTable captionTable = new PdfPTable(3);
//		//PdfPTableにPdfPTableを設定する
//		this.setPdfPTableAttribute(captionTable);
//		PdfPCell imageCell = null;
//		if(image != null){
//			image.scaleAbsolute(Const.REPORT_IMAGE_W,Const.REPORT_IMAGE_H);
//
//			imageCell = new PdfPCell(image);
//		} else {
//
//			imageCell = new PdfPCell();
//		}
//
//		imageCell.setBorderWidth(notShow);
//
//		imageCell.setFixedHeight((float)28);
//
//		PdfPCell title = new PdfPCell(getParagraph(dataValue,16)));
//		title.setHorizontalAlignment(Element.ALIGN_CENTER);
//		title.setBorderWidth(notShow);
//
//		PdfPCell date = new PdfPCell();
//		date.setBorderWidth(notShow);
//		date.setHorizontalAlignment(Element.ALIGN_RIGHT);
//
//		captionTable.addCell(imageCell);
//		captionTable.addCell(title);
//		captionTable.addCell(date);
//
//		return captionTable;
//	}
//	/**
//     * PdfPTableREQUESTを設定する<BR>
//     * <BR>
//     * @param dateValue 御見日期
//     * @exception SQLException
//     * @exception DocumentException
//     * @exception IOException
//     */
//	private PdfPTable captionRequestTable(Image image) throws SQLException,DocumentException, IOException{
//
//		//PdfPTableの作成
//		PdfPTable captionTable = new PdfPTable(3);
//		//PdfPTableにPdfPTableを設定する
//		this.setPdfPTableAttribute(captionTable);
//		PdfPCell imageCell = null;
//		if(image != null){
//			image.scaleAbsolute(Const.REPORT_IMAGE_W,Const.REPORT_IMAGE_H);
//
//			imageCell = new PdfPCell(image);
//		} else {
//
//			imageCell = new PdfPCell();
//		}
//
//		imageCell.setBorderWidth(notShow);
//
//		imageCell.setFixedHeight((float)28);
//
//		PdfPCell title = new PdfPCell(getParagraph(Const.CAPTION_REQUEST,16)));
//		title.setHorizontalAlignment(Element.ALIGN_CENTER);
//		title.setBorderWidth(notShow);
//
//		PdfPCell date = new PdfPCell();
//		date.setBorderWidth(notShow);
//		date.setHorizontalAlignment(Element.ALIGN_RIGHT);
//
//		captionTable.addCell(imageCell);
//		captionTable.addCell(title);
//		captionTable.addCell(date);
//
//		return captionTable;
//
//	}
//	/**
//     * PdfPTableREQUESTを設定する<BR>
//     * <BR>
//     * @param dateValue 御見日期
//     * @exception SQLException
//     * @exception DocumentException
//     * @exception IOException
//     */
//	private PdfPTable captionRequestTwoTable(Image image,String sales_no) throws SQLException,DocumentException, IOException{
//
//		//PdfPTableの作成
//		PdfPTable captionTable = new PdfPTable(3);
//		//PdfPTableにPdfPTableを設定する
//		this.setPdfPTableAttribute(captionTable);
//		PdfPCell imageCell = null;
//		if(image != null){
//			image.scaleAbsolute(Const.REPORT_IMAGE_W,Const.REPORT_IMAGE_H);
//
//			imageCell = new PdfPCell(image);
//		} else {
//
//			imageCell = new PdfPCell();
//		}
//
//		imageCell.setBorderWidth(notShow);
//
//		imageCell.setFixedHeight((float)28);
//
//		PdfPCell title = new PdfPCell(getParagraph("",16)));
//		title.setHorizontalAlignment(Element.ALIGN_CENTER);
//		title.setBorderWidth(notShow);
//
//		PdfPCell date = new PdfPCell(getParagraph(sales_no,11)));
//		date.setBorderWidth(notShow);
//		date.setHorizontalAlignment(Element.ALIGN_LEFT);
//
//		captionTable.addCell(imageCell);
//		captionTable.addCell(title);
//		captionTable.addCell(date);
//
//		return captionTable;
//
//	}

	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue 御見日期
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable captionRequestfanriTable(Image image,PdfPTable fanhaorifuTable) throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
		captionTable.setWidthPercentage(WIDTH_PERCENTAGE);
		captionTable.getDefaultCell().setPadding(3);
		captionTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		PdfPCell imageCell = null;
		if(image != null){
			image.scaleAbsolute(Const.REPORT_IMAGE_W,Const.REPORT_IMAGE_H);

			imageCell = new PdfPCell(image);
		} else {

			imageCell = new PdfPCell();
		}
		PdfPTable fanhaorifu = fanhaorifuTable;
		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph("",16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		fanhaorifu.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		title.setBorderWidth(notShow);

		//PdfPCell date = new PdfPCell(getParagraph(sales_no,11)));
		//date.setBorderWidth(notShow);
		//date.setHorizontalAlignment(Element.ALIGN_LEFT);

		captionTable.addCell(imageCell);
		captionTable.addCell(title);
		captionTable.addCell(fanhaorifu);
//		captionTable.addCell(date);

		return captionTable;


	}

	private PdfPTable captionRequestfanriTable_insi(Image image,PdfPTable fanhaorifuTable) throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
//		this.setPdfPTableAttribute(captionTable);
		captionTable.setWidthPercentage(WIDTH_PERCENTAGE);
		captionTable.getDefaultCell().setPadding(3);
		captionTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		PdfPCell imageCell = null;
		if(image != null){
			image.scaleAbsolute(Const.REPORT_IMAGE_W,Const.REPORT_IMAGE_H);

			imageCell = new PdfPCell(image);
		} else {

			imageCell = new PdfPCell();
		}
		PdfPTable fanhaorifu = fanhaorifuTable;
		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph("",16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		fanhaorifu.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		title.setBorderWidth(notShow);

		//PdfPCell date = new PdfPCell(getParagraph(sales_no,11)));
		//date.setBorderWidth(notShow);
		//date.setHorizontalAlignment(Element.ALIGN_LEFT);

		//2018/12/27 add ↓
		PdfPCell insi = new PdfPCell(getParagraph("印紙",11));
		insi.setBorderWidth(notShow);
		insi.setHorizontalAlignment(Element.ALIGN_CENTER );
		//2018/12/27 add ↑

		//captionTable.addCell(imageCell);	//2018/12/27 del
		captionTable.addCell(insi);		//2018/12/27 add
		captionTable.addCell(title);
		captionTable.addCell(fanhaorifu);
//		captionTable.addCell(date);

		return captionTable;


	}


	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable captionRequestThreeTable() throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(captionTable);
		PdfPCell imageCell = null;

		imageCell = new PdfPCell();

		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph(Const.CAPTION_REQUEST,16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		title.setBorderWidth(notShow);

		PdfPCell date = new PdfPCell();
		date.setBorderWidth(notShow);
		date.setHorizontalAlignment(Element.ALIGN_RIGHT);

		captionTable.addCell(imageCell);
		captionTable.addCell(title);
		captionTable.addCell(date);

		return captionTable;

	}
	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable captionRequestFourTable() throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(captionTable);
		PdfPCell imageCell = null;

		imageCell = new PdfPCell();

		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph(Const.HATTYUTION2,16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		title.setBorderWidth(notShow);

		PdfPCell date = new PdfPCell();
		date.setBorderWidth(notShow);
		date.setHorizontalAlignment(Element.ALIGN_RIGHT);

		captionTable.addCell(imageCell);
		captionTable.addCell(title);
		captionTable.addCell(date);

		return captionTable;

	}
	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable captionRequestFiveTable() throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(captionTable);
		PdfPCell imageCell = null;

		imageCell = new PdfPCell();

		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph(Const.HATTYUTIONTWO,16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		title.setBorderWidth(notShow);

		PdfPCell date = new PdfPCell();
		date.setBorderWidth(notShow);
		date.setHorizontalAlignment(Element.ALIGN_RIGHT);

		captionTable.addCell(imageCell);
		captionTable.addCell(title);
		captionTable.addCell(date);

		return captionTable;

	}
	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable captionRequestSixTable() throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(captionTable);
		PdfPCell imageCell = null;

		imageCell = new PdfPCell();

		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph(Const.CAPTION,16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		title.setBorderWidth(notShow);

		PdfPCell date = new PdfPCell();
		date.setBorderWidth(notShow);
		date.setHorizontalAlignment(Element.ALIGN_RIGHT);

		captionTable.addCell(imageCell);
		captionTable.addCell(title);
		captionTable.addCell(date);

		return captionTable;

	}
//	/**
//     * PdfPTableを設定する<BR>
//     * <BR>
//     * @param titleString String
//     * @param titleValueString String
//     * @param titleDateString String
//     * @param titleDateValueString String
//     * @exception DocumentException
//     * @exception IOException
//     */
//	private PdfPTable reportCommonGroundTable(String titleString,String titleValueString,String titleDateString,String titleDateValueString,int size) throws DocumentException, IOException{
//
//		PdfPTable reportCommonGroundTable = new PdfPTable(numColumns);
//		reportCommonGroundTable.setWidths(new int[]{1,2,1,2,1,1});
//
//		this.setPdfPTableAttribute(reportCommonGroundTable);
//
//		PdfPCell title = new PdfPCell(getParagraph(titleString,10)));
//
//		PdfPCell titleValue = new PdfPCell(getParagraph(titleValueString,size)));
//
//		PdfPCell titleDate = new PdfPCell(getParagraph(titleDateString,11)));
//
//		PdfPCell titleDateValue = new PdfPCell(getParagraph(titleDateValueString,11)));
//
//		title.setBorder(notShow);
//
//		titleValue.setBorder(notShow);
//
//		titleDate.setBorder(notShow);
//
//		titleDateValue.setBorder(notShow);
//		titleDate.setFixedHeight((float)14);
//		reportCommonGroundTable.addCell(title);
//		reportCommonGroundTable.addCell(title);
//		reportCommonGroundTable.addCell(title);
//
//		reportCommonGroundTable.addCell(titleValue);
//
//		reportCommonGroundTable.addCell(titleDate);
//
//		reportCommonGroundTable.addCell(titleDateValue);
//		return reportCommonGroundTable;
//	}
	//leftright
	private PdfPTable reportCommonTable(String titleString,String titleValueString,String titleDateString,String titleDateValueString,int size) throws DocumentException, IOException{

		PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumColumns);
		reportCommonGroundTable.setWidths(commonGroundWidths);


		this.setPdfPTableAttribute(reportCommonGroundTable);

		PdfPCell title = new PdfPCell(getParagraph(titleString,size));

		PdfPCell titleValue = new PdfPCell(getParagraph(titleValueString,size));

		PdfPCell titleDate = new PdfPCell(getParagraph(titleDateString,size));

		PdfPCell titleDateValue = new PdfPCell(getParagraph(titleDateValueString,size));

		title.setBorder(notShow);

		titleValue.setBorder(notShow);

		titleDate.setBorder(notShow);

		titleDateValue.setBorder(notShow);
		titleDate.setFixedHeight(14);
		reportCommonGroundTable.addCell(title);
		reportCommonGroundTable.addCell(titleValue);

		reportCommonGroundTable.addCell(titleDate);

		reportCommonGroundTable.addCell(titleDateValue);
		return reportCommonGroundTable;
	}

	private PdfPTable addInkanImage() throws DocumentException, IOException{
		return this.addInkanImage("",0);
	}

	//20200602 add ↓
	private PdfPTable addInkanImage(String leftText, int fontSize) throws DocumentException, IOException{

		PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNameColumns);
		reportCommonGroundTable.setWidths(inkanImageGroundWidths);

		ReportFormsImageCreateManager reportFormsImageCreate = new ReportFormsImageCreateManager();
		String imageName = null;
		Image imageInkan = null;
		try {
			imageName = reportFormsImageCreate.getInkanFileName();
		} catch (Exception e) {
			e.printStackTrace();
		}
		imageInkan = reportFormsImageCreate.getImage(imageName);

		this.setPdfPTableAttribute(reportCommonGroundTable);

		PdfPCell tableLeft = new PdfPCell(getParagraph(leftText,fontSize));

		PdfPCell imageCell = null;
		if(imageInkan != null){
			imageInkan.scaleAbsolute(190,85);
			imageCell = new PdfPCell(imageInkan);
		} else {

			imageCell = new PdfPCell();
		}
		imageCell.setBorderWidth(notShow);
		//imageCell.setFixedHeight((float)40);

		tableLeft.setBorder(notShow);
		reportCommonGroundTable.addCell(tableLeft);
		reportCommonGroundTable.addCell(imageCell);

		return reportCommonGroundTable;
	}
	//20200602 add ↑

	//jianying
	private PdfPTable reportCommonTwoTable(String titleString,String titleValueString,String titleDateString,PdfPTable titleDateValueTable,int size) throws DocumentException, IOException{

		PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumColumns);
		reportCommonGroundTable.setWidths(commonGroundjiangyingWidths);

		reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
		reportCommonGroundTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		PdfPCell title = new PdfPCell(getParagraph(titleString,9));

		PdfPCell titleValue = new PdfPCell(getParagraph(titleValueString,size));

		PdfPCell titleDate = new PdfPCell(getParagraph(titleDateString,9));

		PdfPTable titleDateValue = titleDateValueTable;

		title.setBorder(notShow);

		titleValue.setBorder(notShow);

		titleDate.setBorder(notShow);

		titleDateValue.getDefaultCell().setBorder(Rectangle.NO_BORDER);

		titleDate.setFixedHeight(14);
		reportCommonGroundTable.addCell(title);
		reportCommonGroundTable.addCell(titleValue);

		reportCommonGroundTable.addCell(titleDate);

		reportCommonGroundTable.addCell(titleDateValue);

		return reportCommonGroundTable;
	}
	private PdfPTable reportCommonNameTable(PdfPTable nameTable,PdfPTable titleDateValueTable) throws DocumentException, IOException{

		PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNameColumns);
		reportCommonGroundTable.setWidths(commonGroundNameWidths);

		reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
		reportCommonGroundTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

		PdfPTable name = nameTable;
		PdfPTable titleDateValue = titleDateValueTable;


		name.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		titleDateValue.getDefaultCell().setBorder(Rectangle.NO_BORDER);

		PdfPCell titleDate = new PdfPCell();
		titleDate.setBorder(notShow);
		titleDate.addElement(titleDateValue);
//		titleDate.setFixedHeight((float)14);
		reportCommonGroundTable.addCell(name);

		reportCommonGroundTable.addCell(titleDate);

		return reportCommonGroundTable;
	}
	//listleft
	private PdfPTable reportCommonLeftTable(String titleString,int size) throws DocumentException, IOException{

		PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumLeftColumns);
		reportCommonGroundTable.setWidths(commonGroundLeftWidths);

		reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
		reportCommonGroundTable.getDefaultCell().setPadding(1);
		reportCommonGroundTable.getDefaultCell().setBorderWidth(2);

		PdfPCell title = new PdfPCell(getParagraph(titleString,size));

		title.setBorder(notShow);

		reportCommonGroundTable.addCell(title);

		return reportCommonGroundTable;
	}

	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable calculateTitleTable() throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(1);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(captionTable);

		PdfPCell title = new PdfPCell(getParagraph("支払いおよび精算条件",9));
		title.setHorizontalAlignment(Element.ALIGN_LEFT);
		title.setBorderWidth(notShow);

		captionTable.addCell(title);

		return captionTable;

	}

	/**
    * PdfPTableREQUESTを設定する<BR>
    * <BR>
    * @param remark String
    * @exception SQLException
    * @exception DocumentException
    * @exception IOException
    */
	private PdfPTable remarkTable(String remark) throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable commonTable = new PdfPTable(2);
		commonTable.setWidths(calculateWidths4);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(commonTable);

		//PdfPCell title = new PdfPCell(getParagraph("特記事項",10)));	//sxt 20220901 del
		PdfPCell title = new PdfPCell(getParagraph("特記事項",9));		//sxt 20220901 add
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		title.setVerticalAlignment(Element.ALIGN_CENTER);

		//PdfPCell content = new PdfPCell(getParagraph(remark,10)));	//sxt 20220901 del
		PdfPCell content = new PdfPCell(getParagraph(remark,9));		//sxt 20220901 add

		//sxt 20220901 add start
		content.setLeading(10f, 0);
//		content.setPaddingBottom(2f);
		content.setPaddingTop(2f);
		//sxt 20220901 add end

		commonTable.addCell(title);
		commonTable.addCell(content);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(4);
		commonTable.setWidths(calculateWidths6);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute2(commonTable);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		commonTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

		String payment_method = estimateContentCreate.getEstimateContentModel().getPayment_method();	//sxt 20220915 add

		commonTable.addCell(this.calculateLeftTable(estimateContentCreate));
		commonTable.addCell(this.emptyTable());
		if (payment_method.equals("1")) {	//sxt 20220915 add
			commonTable.addCell(this.calculateRightTable(estimateContentCreate));
		//sxt 20220915 add start
		} else {
			commonTable.addCell(this.emptyTable());
		}
		//sxt 20220915 add end
		commonTable.addCell(this.emptyTable());

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(4);
		commonTable.setWidths(calculateWidths6);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute2(commonTable);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		commonTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

		String payment_method = hattyuContentCreate.getHattyuContentModel().getPayment_method();	//sxt 20220915 add

		commonTable.addCell(this.calculateLeftTable(hattyuContentCreate));
		commonTable.addCell(this.emptyTable());
		if (payment_method.equals("1")) {	//sxt 20220915 add
			commonTable.addCell(this.calculateRightTable(hattyuContentCreate));
			//sxt 20220915 add start
		} else {
			commonTable.addCell(this.emptyTable());
		}
		//sxt 20220915 add end
		commonTable.addCell(this.emptyTable());

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateLeftTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		commonTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		this.setPdfPTableAttribute2(commonTable);

		PdfPCell cellBottom = new PdfPCell();
		cellBottom.setBorder(notShow);
		cellBottom.setPadding(0);
		cellBottom.addElement(this.calculateLeftBottomTable(estimateContentCreate));

		String payment_method = estimateContentCreate.getEstimateContentModel().getPayment_method();	//sxt 20220915 add

		if (payment_method.equals("1")) {	//sxt 20220915 add
			commonTable.addCell(this.calculateLeftTopTable(estimateContentCreate));
			//sxt 20220915 add start
		} else {
			commonTable.addCell(this.emptyTable());
		}
		//sxt 20220915 add end
		commonTable.addCell(this.emptyTable());
		commonTable.addCell(this.emptyTable());
		commonTable.addCell(cellBottom);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateLeftTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		commonTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		this.setPdfPTableAttribute2(commonTable);

		PdfPCell cellBottom = new PdfPCell();
		cellBottom.setBorder(notShow);
		cellBottom.setPadding(0);
		cellBottom.addElement(this.calculateLeftBottomTable(hattyuContentCreate));

		String payment_method = hattyuContentCreate.getHattyuContentModel().getPayment_method();	//sxt 20220915 add
		if (payment_method.equals("1")) {	//sxt 20220915 add
			commonTable.addCell(this.calculateLeftTopTable(hattyuContentCreate));
			//sxt 20220915 add start
		} else {
			commonTable.addCell(this.emptyTable());
		}
		//sxt 20220915 add end
		commonTable.addCell(this.emptyTable());
		commonTable.addCell(this.emptyTable());
		commonTable.addCell(cellBottom);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateLeftTopTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);
		//this.setPdfPTableAttribute(commonTable);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);

		String workTime = estimateContentCreate.getEstimateContentModel().getWork_time_from() + NULL_STR4 + "～"+ NULL_STR4 + estimateContentCreate.getEstimateContentModel().getWork_time_to();
		PdfPCell cell1 = new PdfPCell(getParagraph("月間作業基準時間",8));
		PdfPCell cell2 = new PdfPCell(getParagraph(workTime,8));

		commonTable.addCell(cell1);
		commonTable.addCell(cell2);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateLeftTopTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);
		//this.setPdfPTableAttribute(commonTable);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);

		String workTime = hattyuContentCreate.getHattyuContentModel().getWork_time_from() + NULL_STR4 + "～"+ NULL_STR4 + hattyuContentCreate.getHattyuContentModel().getWork_time_to();
		PdfPCell cell1 = new PdfPCell(getParagraph("月間作業基準時間",8));
		PdfPCell cell2 = new PdfPCell(getParagraph(workTime,8));

		commonTable.addCell(cell1);
		commonTable.addCell(cell2);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateLeftBottomTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(2);
		commonTable.setWidths(calculateWidths2);
		this.setPdfPTableAttribute2(commonTable);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		String payment_condition1 = estimateContentCreate.getEstimateContentModel().getPayment_condition1();
		PdfPCell cell1 = new PdfPCell(getParagraph("検収日",8));
		PdfPCell cell2 = new PdfPCell(getParagraph(payment_condition1,8));

		String payment_condition2 = estimateContentCreate.getEstimateContentModel().getPayment_condition2();
		PdfPCell cell3 = new PdfPCell(getParagraph("支払日",8));
		PdfPCell cell4 = new PdfPCell(getParagraph(payment_condition2,8));

		cell1.setFixedHeight(17);
		cell2.setFixedHeight(17);
		cell3.setFixedHeight(17);
		cell4.setFixedHeight(17);

		commonTable.addCell(cell1);
		commonTable.addCell(cell2);
		commonTable.addCell(cell3);
		commonTable.addCell(cell4);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateLeftBottomTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(2);
		commonTable.setWidths(calculateWidths2);
		this.setPdfPTableAttribute2(commonTable);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		String payment_condition1 = hattyuContentCreate.getHattyuContentModel().getPayment_condition1();
		PdfPCell cell1 = new PdfPCell(getParagraph("検収日",8));
		PdfPCell cell2 = new PdfPCell(getParagraph(payment_condition1,8));

		String payment_condition2 = hattyuContentCreate.getHattyuContentModel().getPayment_condition2();
		PdfPCell cell3 = new PdfPCell(getParagraph("支払日",8));
		PdfPCell cell4 = new PdfPCell(getParagraph(payment_condition2,8));

		cell1.setFixedHeight(17);
		cell2.setFixedHeight(17);
		cell3.setFixedHeight(17);
		cell4.setFixedHeight(17);

		commonTable.addCell(cell1);
		commonTable.addCell(cell2);
		commonTable.addCell(cell3);
		commonTable.addCell(cell4);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateRightTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		commonTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		this.setPdfPTableAttribute2(commonTable);

		commonTable.addCell(this.calculateRightTopTable(estimateContentCreate));
		commonTable.addCell(this.calculateRightBottomTable(estimateContentCreate));

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateRightTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);
		commonTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		this.setPdfPTableAttribute2(commonTable);

		commonTable.addCell(this.calculateRightTopTable(hattyuContentCreate));
		commonTable.addCell(this.calculateRightBottomTable(hattyuContentCreate));

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateRightTopTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);
		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);

		//String content = "月間作業基準時間外の精算方法       " + "時間精算単位:" + estimateContentCreate.getEstimateContentModel().getTime_unit();	//sxt 20221031 del
		String content = "月間作業基準時間外の精算方法    " + "精算単位:" + estimateContentCreate.getEstimateContentModel().getTime_unit();			//sxt 20221031 add
		
		PdfPCell cell1 = new PdfPCell(getParagraph(content,8));
		commonTable.addCell(cell1);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateRightTopTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(1);
		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);

		//String content = "月間作業基準時間外の精算方法       ";	//sxt 20221031 del
		String content = "月間作業基準時間外の精算方法    " + "精算単位:" + hattyuContentCreate.getHattyuContentModel().getTime_unit();			//sxt 20221031 add
		PdfPCell cell1 = new PdfPCell(getParagraph(content,8));
		commonTable.addCell(cell1);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateRightBottomTable(EstimateContentCreateManager estimateContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(2);
		commonTable.setWidths(calculateWidths3);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);

		//sxt 20221031 del start
//		String moreText = estimateContentCreate.getEstimateContentModel().getWork_time_to() + " 時間を超えた時間数を超過時間とする。" + "\n"
//							+ "精算方式：    超過時間単価 × 超過時間"+ "\n"
//							+ "超過時間単価：  月額単価 ÷ " + estimateContentCreate.getEstimateContentModel().getWork_time_to();
		//sxt 20221031 del end
		
		//sxt 20221031 add start
		String moreText = estimateContentCreate.getEstimateContentModel().getWork_time_to() + " 時間を超えた時間数を超過時間とする。" + "\n"
							+ "超過単価：  月額単価 ÷ " + estimateContentCreate.getEstimateContentModel().getWork_time_to()+ "\n"
							+ "精算方式：  超過単価 × 超過時間";
		//sxt 20221031 add end

		PdfPCell cell1 = new PdfPCell(getParagraph("超過時間精算",8));
		cell1.setLeading(10f, 0);
		cell1.setPaddingBottom(3f);
		cell1.setPaddingTop(0);

		PdfPCell cell2 = new PdfPCell(getParagraph(moreText,8));
		cell2.setLeading(10f, 0);
		cell2.setPaddingBottom(3f);
		cell2.setPaddingTop(0);

		commonTable.addCell(cell1);
		commonTable.addCell(cell2);

		//sxt 20221031 del start
//		String lessText = estimateContentCreate.getEstimateContentModel().getWork_time_from() + " 時間に満たない時間数を減額時間とする。" + "\n"
//							+ "精算方式：    減額時間単価 × 減額時間"+ "\n"
//							+ "減額時間単価：  月額単価 ÷ " + estimateContentCreate.getEstimateContentModel().getWork_time_from();
//		PdfPCell cell3 = new PdfPCell(getParagraph("減額時間精算",8)));
		//sxt 20221031 del end
		
		//sxt 20221031 add start
		String lessText = estimateContentCreate.getEstimateContentModel().getWork_time_from() + " 時間に満たない時間数を減額時間とする。" + "\n"
				+ "控除単価：  月額単価 ÷ " + estimateContentCreate.getEstimateContentModel().getWork_time_from()+ "\n"
				+ "精算方式：  控除単価 × 控除時間";	
		PdfPCell cell3 = new PdfPCell(getParagraph("控除時間精算",8));
		//sxt 20221031 add end

		cell3.setLeading(10f, 0);
		cell3.setPaddingBottom(3f);
		cell3.setPaddingTop(0);

		PdfPCell cell4 = new PdfPCell(getParagraph(lessText,8));
		cell4.setLeading(10f, 0);
		cell4.setPaddingBottom(3f);
		cell4.setPaddingTop(0);

		commonTable.addCell(cell3);
		commonTable.addCell(cell4);

		return commonTable;
	}

	/**
	 * PdfPTableを設定する<BR>
     * <BR>
     * @param estimateContentCreate EstimateContentCreateManager
     * @exception DocumentException
     * @exception IOException
	 */
	private PdfPTable calculateRightBottomTable(HattyuContentCreateManager hattyuContentCreate) throws DocumentException, IOException{

		PdfPTable commonTable = new PdfPTable(2);
		commonTable.setWidths(calculateWidths3);

		commonTable.setWidthPercentage(WIDTH_PERCENTAGE);

		//sxt 20221031 del start
//		String moreText = hattyuContentCreate.getHattyuContentModel().getWork_time_to() + " 時間を超えた時間数を超過時間とする。" + "\n"
//							+ "精算方式：    超過時間単価 × 超過時間"+ "\n"
//							+ "超過時間単価：  月額単価 ÷ " + hattyuContentCreate.getHattyuContentModel().getWork_time_to();
		//sxt 20221031 del end
		//sxt 20221031 add start
		String moreText = hattyuContentCreate.getHattyuContentModel().getWork_time_to() + " 時間を超えた時間数を超過時間とする。" + "\n"
							+ "超過単価：  月額単価 ÷ " + hattyuContentCreate.getHattyuContentModel().getWork_time_to()+ "\n"
							+ "精算方式：  超過単価 × 超過時間";			
		//sxt 20221031 add end
		
		PdfPCell cell1 = new PdfPCell(getParagraph("超過時間精算",8));
		cell1.setLeading(10f, 0);
		cell1.setPaddingBottom(3f);
		cell1.setPaddingTop(0);

		PdfPCell cell2 = new PdfPCell(getParagraph(moreText,8));
		cell2.setLeading(10f, 0);
		cell2.setPaddingBottom(3f);
		cell2.setPaddingTop(0);

		commonTable.addCell(cell1);
		commonTable.addCell(cell2);

		//sxt 20221031 del start
//		String lessText = hattyuContentCreate.getHattyuContentModel().getWork_time_from() + " 時間に満たない時間数を減額時間とする。" + "\n"
//							+ "精算方式：    減額時間単価 × 減額時間"+ "\n"
//							+ "減額時間単価：  月額単価 ÷ " + hattyuContentCreate.getHattyuContentModel().getWork_time_from();
//		PdfPCell cell3 = new PdfPCell(getParagraph("減額時間精算",8)));
		//sxt 20221031 del end
		
		//sxt 20221031 add start
		String lessText = hattyuContentCreate.getHattyuContentModel().getWork_time_from() + " 時間に満たない時間数を減額時間とする。" + "\n"
				+ "控除単価：  月額単価 ÷ " + hattyuContentCreate.getHattyuContentModel().getWork_time_from()+ "\n"
				+ "精算方式：  控除単価 × 控除時間";
		PdfPCell cell3 = new PdfPCell(getParagraph("控除時間精算",8));
		//sxt 20221031 add end

		cell3.setLeading(10f, 0);
		cell3.setPaddingBottom(3f);
		cell3.setPaddingTop(0);

		PdfPCell cell4 = new PdfPCell(getParagraph(lessText,8));
		cell4.setLeading(10f, 0);
		cell4.setPaddingBottom(3f);
		cell4.setPaddingTop(0);

		commonTable.addCell(cell3);
		commonTable.addCell(cell4);

		return commonTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param companyNameString String
     * @param infoString String
     * @param companyTitleString String
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable companyInfoTable(String companyNameString,String infoString,int countname) throws DocumentException, IOException{

		PdfPTable companyInfoTable = new PdfPTable(commonGroundNumThreeColumns);
		companyInfoTable.setWidths(companyInfoNameWidths);

		this.setPdfPTableAttribute(companyInfoTable);

		int currentLength = 0;
		for( int i=0;i<companyNameString.length();i++ ){
			char c = companyNameString.charAt(i);
			//半角は一桁で採算する。
			if(ValidatorUtil.isHanChar(c)){
				currentLength += 1;
			}else{
			//全角は二桁で採算する。
				currentLength += 2;
			}
		}

		int count = currentLength / 2;

		int index = currentLength %2;

		if(index!=0){
			count = count + 1 ;
		}

		PdfPCell companyName = new PdfPCell(getParagraph(companyNameString,12));
		PdfPCell info = new PdfPCell(getParagraph(infoString,12));

		PdfPCell companyTitle = new PdfPCell();
		companyName.setBorder(notShow);
		companyName.setFixedHeight(17);

		info.setBorder(notShow);

		companyTitle.setBorder(notShow);

		companyName.setHorizontalAlignment(Element.ALIGN_TOP);
		info.setHorizontalAlignment(Element.ALIGN_TOP);

		companyName.setBorderWidthBottom(0.5f);
		info.setBorderWidthBottom(0.5f);

		companyInfoTable.addCell(companyName);
		companyInfoTable.addCell(info);
		//companyInfoTable.addCell(nullCell);
		companyInfoTable.addCell(companyTitle);

		return companyInfoTable;
	}
	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue String
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable summationRquestTable(String dateValue)throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable summationTable = new PdfPTable(commonGroundNumColumns);
		summationTable.setWidths(summationWidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(summationTable);

		PdfPCell title = new PdfPCell(getParagraph(Const.REQUEST_TOTAL,13));

		PdfPCell titleValue = new PdfPCell(getParagraph(dateValue,13));

		PdfPCell titleDate = new PdfPCell();
		//PdfPCellの作成
		PdfPCell titleDateValue = new PdfPCell();
		title.setBorder(notShow);
		titleValue.setBorder(notShow);
		titleDate.setBorder(notShow);

		title.setFixedHeight(17);

		titleDateValue.setBorder(notShow);
		title.setBorderWidthBottom(1);
		titleValue.setBorderWidthBottom(1);

		titleValue.setVerticalAlignment(Element.ALIGN_TOP);
		titleValue.setHorizontalAlignment(Element.ALIGN_RIGHT);

		summationTable.addCell(title);
		summationTable.addCell(titleValue);
		summationTable.addCell(titleDate);
		summationTable.addCell(titleDateValue);

		return summationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param dateValue String
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable summationTable(String dateValue)throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable summationTable = new PdfPTable(commonGroundNumColumns);
		summationTable.setWidths(summationWidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(summationTable);

		PdfPCell title = new PdfPCell(getParagraph(Const.ESTIMATE_TOTAL,14));

		//sxt 20220816 add start
		//請求金額と数値の空いている空白を4半角文字固定にする
		dateValue = "    " + dateValue;
		//sxt 20220816 add end

		PdfPCell titleValue = new PdfPCell(getParagraph(dateValue,14));

		PdfPCell titleDate = new PdfPCell();
		//PdfPCellの作成
		PdfPCell titleDateValue = new PdfPCell();
		title.setBorder(notShow);
		titleValue.setBorder(notShow);
		titleDate.setBorder(notShow);

		title.setFixedHeight(14);

		titleDateValue.setBorder(notShow);
		title.setBorderWidthBottom(1);
		titleValue.setBorderWidthBottom(1);

		titleValue.setVerticalAlignment(Element.ALIGN_TOP);
		//titleValue.setHorizontalAlignment(Element.ALIGN_RIGHT);	//sxt 20220816 del

		summationTable.addCell(title);
		summationTable.addCell(titleValue);
		summationTable.addCell(titleDate);
		summationTable.addCell(titleDateValue);

		return summationTable;
	}

	private PdfPTable summationJyutyuTable(String dateValue)throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable summationTable = new PdfPTable(commonGroundNumColumns);
		summationTable.setWidths(summationWidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(summationTable);

		PdfPCell title = new PdfPCell(getParagraph(Const.RECEIVED_TOTAL,14));

		PdfPCell titleValue = new PdfPCell(getParagraph(dateValue,14));

		PdfPCell titleDate = new PdfPCell();
		//PdfPCellの作成
		PdfPCell titleDateValue = new PdfPCell();
		title.setBorder(notShow);
		titleValue.setBorder(notShow);
		titleDate.setBorder(notShow);

		title.setFixedHeight(14);

		titleDateValue.setBorder(notShow);
		title.setBorderWidthBottom(1);
		titleValue.setBorderWidthBottom(1);

		titleValue.setVerticalAlignment(Element.ALIGN_TOP);
		titleValue.setHorizontalAlignment(Element.ALIGN_RIGHT);

		summationTable.addCell(title);
		summationTable.addCell(titleValue);
		summationTable.addCell(titleDate);
		summationTable.addCell(titleDateValue);

		return summationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param dateValue String
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable summationHattyuTable(String dateValue,boolean order_received_flg)throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable summationTable = new PdfPTable(commonGroundNumColumns);
		//summationTable.setWidths(summationWidths);	//sxt 20220816 del
		summationTable.setWidths(summationWidths3);		//sxt 20220816 add
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(summationTable);

		String total_title = "";
		if(order_received_flg){
			total_title = Const.ORDER_TOTAL;
		}else{
			total_title = Const.RECEIVED_TOTAL;
		}
		PdfPCell title = new PdfPCell(getParagraph(total_title,13));


		PdfPCell titleValue = new PdfPCell(getParagraph(dateValue,13));

		PdfPCell titleDate = new PdfPCell();
		//PdfPCellの作成
		PdfPCell titleDateValue = new PdfPCell();
		title.setBorder(notShow);
		titleValue.setBorder(notShow);
		titleDate.setBorder(notShow);

		title.setFixedHeight(17);

		titleDateValue.setBorder(notShow);
		title.setBorderWidthBottom(1);
		titleValue.setBorderWidthBottom(1);

		titleValue.setVerticalAlignment(Element.ALIGN_TOP);
		//titleValue.setHorizontalAlignment(Element.ALIGN_RIGHT);	//sxt 20220816 del

		summationTable.addCell(title);
		summationTable.addCell(titleValue);
		summationTable.addCell(titleDate);
		summationTable.addCell(titleDateValue);

		return summationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable dataHeadTable() throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable dataHeadTable = new PdfPTable(numColumns);
		dataHeadTable.setWidths(headerwidths);
		//PdfPCellの作成
		//番号
		PdfPCell noCell = new PdfPCell(getParagraph(Const.NUM,9));
		//技術者名
		PdfPCell contentCell = new PdfPCell(getParagraph(Const.ENGINEER_NAME,9));
		//人月時間区分
		PdfPCell timeKbnCell = new PdfPCell(getParagraph("",9));
		//単価
		PdfPCell priceCell = new PdfPCell(getParagraph(Const.PRICE,9));
		//超過単価
		PdfPCell morePriceCell = new PdfPCell(getParagraph(Const.MORE_PRICE,9));
		//減額単価
		PdfPCell lessPriceCell = new PdfPCell(getParagraph(Const.LESS_PRICE,9));
		//sxt 20221026 del start
//		//そのた（交通費など）
//		PdfPCell otherPriceCell = new PdfPCell(getParagraph(Const.OTHER_PRICE,9)));
		//sxt 20221026 del end
		//工数
		PdfPCell amountCell = new PdfPCell(getParagraph(Const.NUMBER2,9));
		//金額
		PdfPCell countCell = new PdfPCell(getParagraph(Const.AMOUNT,9));
		//備考
		PdfPCell bikoCell = new PdfPCell(getParagraph(Const.BIKO,9));

		this.setPdfPTableAttribute(dataHeadTable);

		noCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		contentCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		contentCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		timeKbnCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		timeKbnCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		priceCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		priceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		morePriceCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		morePriceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		lessPriceCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		lessPriceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		//otherPriceCell.setVerticalAlignment(Element.ALIGN_MIDDLE);		//sxt 20221026 del
		//otherPriceCell.setHorizontalAlignment(Element.ALIGN_CENTER);		//sxt 20221026 del
		amountCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		amountCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		countCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		countCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		bikoCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		bikoCell.setHorizontalAlignment(Element.ALIGN_CENTER);

		contentCell.setBorderWidthLeft(-1.0f);
		timeKbnCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);
		morePriceCell.setBorderWidthLeft(-1.0f);
		lessPriceCell.setBorderWidthLeft(-1.0f);
		//otherPriceCell.setBorderWidthLeft(-1.0f);			//sxt 20221026 del
		amountCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		bikoCell.setBorderWidthLeft(-1.0f);

		noCell.setBorderWidthBottom(-1.0f);
		contentCell.setBorderWidthBottom(-1.0f);
		timeKbnCell.setBorderWidthBottom(-1.0f);
		priceCell.setBorderWidthBottom(-1.0f);
		morePriceCell.setBorderWidthBottom(-1.0f);
		lessPriceCell.setBorderWidthBottom(-1.0f);
		//otherPriceCell.setBorderWidthBottom(-1.0f);		//sxt 20221026 del
		amountCell.setBorderWidthBottom(-1.0f);
		countCell.setBorderWidthBottom(-1.0f);
		bikoCell.setBorderWidthBottom(-1.0f);

		noCell.setFixedHeight(28);

		//行を添加する
		dataHeadTable.addCell(noCell);
		dataHeadTable.addCell(contentCell);
		//sxt 20220922 del start
//		dataHeadTable.addCell(timeKbnCell);
//		dataHeadTable.addCell(priceCell);
		//sxt 20220922 del end
		//sxt 20220922 add start
		dataHeadTable.addCell(priceCell);
		dataHeadTable.addCell(timeKbnCell);
		//sxt 20220922 add end
		dataHeadTable.addCell(morePriceCell);
		dataHeadTable.addCell(lessPriceCell);
		//dataHeadTable.addCell(otherPriceCell);		//sxt 20221026 del
		dataHeadTable.addCell(amountCell);
		dataHeadTable.addCell(countCell);
		dataHeadTable.addCell(bikoCell);

		return dataHeadTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable dataHeadTable(boolean flg) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable dataHeadTable = new PdfPTable(numColumns);
		dataHeadTable.setWidths(headerwidths);
		//PdfPCellの作成
		PdfPCell noCell = new PdfPCell(getParagraph(Const.NUM,11));
		PdfPCell contentCell = new PdfPCell(getParagraph(Const.CONTENT_NE,11));
		PdfPCell amountCell = new PdfPCell(getParagraph(Const.NUMBER,11));
		PdfPCell unitsCell = new PdfPCell(getParagraph(Const.UNIT,11));
		PdfPCell priceCell = new PdfPCell(getParagraph(Const.PRICE,11));
		PdfPCell countCell = new PdfPCell(getParagraph(Const.AMOUNT,11));

		this.setPdfPTableAttribute(dataHeadTable);

		noCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		contentCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		contentCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		amountCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		amountCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		unitsCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		unitsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		priceCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		priceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		countCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		countCell.setHorizontalAlignment(Element.ALIGN_CENTER);

		contentCell.setBorderWidthLeft(-1.0f);
		//noCell.setBorderWidthRight(-1.0f);
		amountCell.setBorderWidthLeft(-1.0f);
		unitsCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);

		noCell.setFixedHeight(28);

		//行を添加する
		dataHeadTable.addCell(noCell);
		dataHeadTable.addCell(contentCell);
		dataHeadTable.addCell(priceCell);
		dataHeadTable.addCell(amountCell);
		dataHeadTable.addCell(unitsCell);
		dataHeadTable.addCell(countCell);

		return dataHeadTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable jianYingTable() throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable dataHeadTable = new PdfPTable(commonGroundNumColumns);
		dataHeadTable.setWidths(jianyingwidths);
		//PdfPCellの作成
		PdfPCell noCell = new PdfPCell(getParagraph(Const.JIANGYING,11));
		PdfPCell contentCell = new PdfPCell(getParagraph("",11));
		PdfPCell amountCell = new PdfPCell(getParagraph("",11));
		PdfPCell unitsCell = new PdfPCell(getParagraph("",11));

		this.setPdfPTableAttribute(dataHeadTable);

		noCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		contentCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		contentCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		amountCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		amountCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		unitsCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		unitsCell.setHorizontalAlignment(Element.ALIGN_CENTER);

		noCell.setFixedHeight(48);

		//行を添加する
		dataHeadTable.addCell(noCell);
		dataHeadTable.addCell(contentCell);
		dataHeadTable.addCell(amountCell);
		dataHeadTable.addCell(unitsCell);


		return dataHeadTable;
	}
	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable fanhaorifuTable(String sales_no,String request_date) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable dataHeadTable = new PdfPTable(1);

		dataHeadTable.setWidthPercentage(WIDTH_PERCENTAGE);
		dataHeadTable.getDefaultCell().setPadding(3);
		dataHeadTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		//PdfPCellの作成
		PdfPCell noCell = new PdfPCell(getParagraph(sales_no,11));
		PdfPCell contentCell = new PdfPCell(getParagraph(request_date,11));

//		this.setPdfPTableAttribute(dataHeadTable);

		noCell.setVerticalAlignment(Element.ALIGN_LEFT);
		noCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		noCell.setBorder(Rectangle.NO_BORDER);
		contentCell.setVerticalAlignment(Element.ALIGN_LEFT);
		contentCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		contentCell.setBorder(Rectangle.NO_BORDER);
		noCell.setFixedHeight(15);

		//行を添加する
		dataHeadTable.addCell(noCell);
		dataHeadTable.addCell(contentCell);

		return dataHeadTable;
	}
	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable rightTable(String companyName,String zip_code) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable dataHeadTable = new PdfPTable(1);

		dataHeadTable.setWidthPercentage(WIDTH_PERCENTAGE);
		dataHeadTable.getDefaultCell().setPadding(3);
		dataHeadTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
		//PdfPCellの作成
		PdfPCell noCell = new PdfPCell(getParagraph(companyName,9));
		PdfPCell contentCell = new PdfPCell(getParagraph(zip_code,9));
//		PdfPCell amountCell = new PdfPCell(getParagraph(address,9)));

//		this.setPdfPTableAttribute(dataHeadTable);

		noCell.setVerticalAlignment(Element.ALIGN_LEFT);
		noCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		noCell.setBorder(Rectangle.NO_BORDER);
		contentCell.setVerticalAlignment(Element.ALIGN_LEFT);
		contentCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		contentCell.setBorder(Rectangle.NO_BORDER);
//		amountCell.setVerticalAlignment(Element.ALIGN_LEFT);
//		amountCell.setHorizontalAlignment(Element.ALIGN_LEFT);
//		amountCell.setBorder(Rectangle.NO_BORDER);
		noCell.setFixedHeight(14);

		//行を添加する
		dataHeadTable.addCell(noCell);
		dataHeadTable.addCell(contentCell);
//		dataHeadTable.addCell(amountCell);

		return dataHeadTable;
	}
//	/**
//     * PdfPTableを設定する<BR>
//     * <BR>
//     * @exception DocumentException
//     * @exception IOException
//     */
//	private PdfPTable fanhaorifu() throws DocumentException, IOException{
//		//PdfPTableの作成
//		PdfPTable dataHeadTable = new PdfPTable(commonGroundNumColumns);
//		dataHeadTable.setWidths(jianyingwidths);
//		//PdfPCellの作成
//		PdfPCell noCell = new PdfPCell(getParagraph(Const.JIANGYING,11)));
//		PdfPCell contentCell = new PdfPCell(getParagraph("",11)));
//		PdfPCell amountCell = new PdfPCell(getParagraph("",11)));
//		PdfPCell unitsCell = new PdfPCell(getParagraph("",11)));
//
//		this.setPdfPTableAttribute(dataHeadTable);
//
//		noCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
//		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
//		contentCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
//		contentCell.setHorizontalAlignment(Element.ALIGN_CENTER);
//		amountCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
//		amountCell.setHorizontalAlignment(Element.ALIGN_CENTER);
//		unitsCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
//		unitsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
//
//		noCell.setFixedHeight((float)48);
//
//		//行を添加する
//		dataHeadTable.addCell(noCell);
//		dataHeadTable.addCell(contentCell);
//		dataHeadTable.addCell(amountCell);
//		dataHeadTable.addCell(unitsCell);
//
//
//		return dataHeadTable;
//	}
//
	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param number String
     * @param content String
     * @param time_kbn String
     * @param price String
     * @param more_price String
     * @param less_price String
     * @param other_price String
     * @param quantity String
     * @param amount String
     * @param biko String
     * @param isBottomDisplay boolean
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable circulationTable_new(String number,String content, String time_kbn,String price,
											String more_price,String less_price,String other_price,String quantity,
											String amount,String biko,boolean isBottomDisplay) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable circulationTable = new PdfPTable(numColumns);

		circulationTable.setWidths(headerwidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(circulationTable);

		PdfPCell noCell = new PdfPCell(getParagraph(number,9));
		PdfPCell contentCell = new PdfPCell(getParagraph(content,9));
		PdfPCell timeKbnCell = new PdfPCell(getParagraph(time_kbn,9));
		PdfPCell priceCell = new PdfPCell(getParagraph(price,9));
		PdfPCell morePriceCell = new PdfPCell(getParagraph(more_price,9));
		PdfPCell lessPriceCell = new PdfPCell(getParagraph(less_price,9));
		//PdfPCell otherPriceCell = new PdfPCell(getParagraph(other_price,9)));	//sxt 20221026 del
		PdfPCell amountCell = new PdfPCell(getParagraph(quantity,9));
		PdfPCell countCell = new PdfPCell(getParagraph(amount,9));
		PdfPCell bikoCell = new PdfPCell(getParagraph(biko,9));

		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(17);
		timeKbnCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		timeKbnCell.setFixedHeight(17);
		priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		priceCell.setFixedHeight(17);
		morePriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		morePriceCell.setFixedHeight(17);
		lessPriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		lessPriceCell.setFixedHeight(17);
		//otherPriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);		//sxt 20221026 del
		//otherPriceCell.setFixedHeight(17);								//sxt 20221026 del
		amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		amountCell.setFixedHeight(17);
		countCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		countCell.setFixedHeight(17);

		if(isBottomDisplay){
			noCell.setBorderWidthTop(0);
			contentCell.setBorderWidthTop(0);
			timeKbnCell.setBorderWidthTop(0);
			priceCell.setBorderWidthTop(0);
			morePriceCell.setBorderWidthTop(0);
			lessPriceCell.setBorderWidthTop(0);
			//otherPriceCell.setBorderWidthTop(0);		//sxt 20221026 del
			amountCell.setBorderWidthTop(0);
			countCell.setBorderWidthTop(0);
			bikoCell.setBorderWidthTop(0);
		}else{
			noCell.setBorderWidthBottom(0);
			noCell.setBorderWidthTop(0);
			contentCell.setBorderWidthBottom(0);
			contentCell.setBorderWidthTop(0);
			timeKbnCell.setBorderWidthBottom(0);
			timeKbnCell.setBorderWidthTop(0);
			priceCell.setBorderWidthBottom(0);
			priceCell.setBorderWidthTop(0);
			morePriceCell.setBorderWidthBottom(0);
			morePriceCell.setBorderWidthTop(0);
			lessPriceCell.setBorderWidthBottom(0);
			lessPriceCell.setBorderWidthTop(0);
			//otherPriceCell.setBorderWidthBottom(0);		//sxt 20221026 del
			//otherPriceCell.setBorderWidthTop(0);			//sxt 20221026 del
			amountCell.setBorderWidthBottom(0);
			amountCell.setBorderWidthTop(0);
			countCell.setBorderWidthBottom(0);
			countCell.setBorderWidthTop(0);
			bikoCell.setBorderWidthBottom(0);
			bikoCell.setBorderWidthTop(0);
		}

		contentCell.setBorderWidthLeft(-1.0f);
		timeKbnCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);
		morePriceCell.setBorderWidthLeft(-1.0f);
		lessPriceCell.setBorderWidthLeft(-1.0f);
		//otherPriceCell.setBorderWidthLeft(-1.0f);		//sxt 20221026 del
		amountCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		bikoCell.setBorderWidthLeft(-1.0f);

		circulationTable.addCell(noCell);
		circulationTable.addCell(contentCell);
		//sxt 20220922 del start
//		circulationTable.addCell(timeKbnCell);
//		circulationTable.addCell(priceCell);
		//sxt 20220922 del end
		//sxt 20220922 add start
		circulationTable.addCell(priceCell);
		circulationTable.addCell(timeKbnCell);
		//sxt 20220922 add end
		circulationTable.addCell(morePriceCell);
		circulationTable.addCell(lessPriceCell);
		//circulationTable.addCell(otherPriceCell);		//sxt 20221026 del
		circulationTable.addCell(amountCell);
		circulationTable.addCell(countCell);
		circulationTable.addCell(bikoCell);

		return circulationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param number String
     * @param content String
     * @param time_kbn String
     * @param price String
     * @param more_price String
     * @param less_price String
     * @param other_price String
     * @param quantity String
     * @param amount String
     * @param biko String
     * @param isBottomDisplay boolean
     * @exception DocumentException
     * @exception IOException
     */

	private PdfPTable circulationTable_next(String number,String content, String time_kbn,String price,
											String more_price,String less_price,String other_price,String quantity,
											String amount,String biko,boolean isBottomDisplay) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable circulationTable = new PdfPTable(numColumns);

		circulationTable.setWidths(headerwidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(circulationTable);

		PdfPCell noCell = new PdfPCell(getParagraph(number,9));
		PdfPCell contentCell = new PdfPCell(getParagraph(content,9));
		PdfPCell timeKbnCell = new PdfPCell(getParagraph(time_kbn,9));
		PdfPCell priceCell = new PdfPCell(getParagraph(price,9));
		PdfPCell morePriceCell = new PdfPCell(getParagraph(more_price,9));
		PdfPCell lessPriceCell = new PdfPCell(getParagraph(less_price,9));
		//PdfPCell otherPriceCell = new PdfPCell(getParagraph(other_price,9)));	//sxt 20221026 del
		PdfPCell amountCell = new PdfPCell(getParagraph(quantity,9));
		PdfPCell countCell = new PdfPCell(getParagraph(amount,9));
		PdfPCell bikoCell = new PdfPCell(getParagraph(biko,9));

		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(17);
		timeKbnCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		timeKbnCell.setFixedHeight(17);
		priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		priceCell.setFixedHeight(17);
		morePriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		morePriceCell.setFixedHeight(17);
		lessPriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		lessPriceCell.setFixedHeight(17);
		//otherPriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);		//sxt 20221026 del
		//otherPriceCell.setFixedHeight(17);								//sxt 20221026 del
		amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		amountCell.setFixedHeight(17);
		countCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		countCell.setFixedHeight(17);

		if (!isBottomDisplay){
			noCell.setBorderWidthBottom(0);
			contentCell.setBorderWidthBottom(0);
			timeKbnCell.setBorderWidthBottom(0);
			priceCell.setBorderWidthBottom(0);
			morePriceCell.setBorderWidthBottom(0);
			lessPriceCell.setBorderWidthBottom(0);
			//otherPriceCell.setBorderWidthBottom(0);		//sxt 20221026 del
			amountCell.setBorderWidthBottom(0);
			countCell.setBorderWidthBottom(0);
			bikoCell.setBorderWidthBottom(0);
		}

		contentCell.setBorderWidthLeft(-1.0f);
		timeKbnCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);
		morePriceCell.setBorderWidthLeft(-1.0f);
		lessPriceCell.setBorderWidthLeft(-1.0f);
		//otherPriceCell.setBorderWidthLeft(-1.0f);		//sxt 20221026 del
		amountCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		bikoCell.setBorderWidthLeft(-1.0f);

		circulationTable.addCell(noCell);
		circulationTable.addCell(contentCell);
		//sxt 20220922 del start
//		circulationTable.addCell(timeKbnCell);
//		circulationTable.addCell(priceCell);
		//sxt 20220922 del end
		//sxt 20220922 add start
		circulationTable.addCell(priceCell);
		circulationTable.addCell(timeKbnCell);
		//sxt 20220922 add end
		circulationTable.addCell(morePriceCell);
		circulationTable.addCell(lessPriceCell);
		//circulationTable.addCell(otherPriceCell);		//sxt 20221026 del
		circulationTable.addCell(amountCell);
		circulationTable.addCell(countCell);
		circulationTable.addCell(bikoCell);

		return circulationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param number String
     * @param content String
     * @param time_kbn String
     * @param price String
     * @param more_price String
     * @param less_price String
     * @param other_price String
     * @param quantity String
     * @param amount String
     * @param biko String
     * @param isBottomDisplay boolean
     * @exception DocumentException
     * @exception IOException
     */

	private PdfPTable circulationTable(String number,String content, String time_kbn,String price,
										String more_price,String less_price,String other_price,String quantity,
										String amount,String biko,boolean isBottomDisplay) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable circulationTable = new PdfPTable(numColumns);

		circulationTable.setWidths(headerwidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(circulationTable);

		PdfPCell noCell = new PdfPCell(getParagraph(number,9));
		PdfPCell contentCell = new PdfPCell(getParagraph(content,9));
		PdfPCell timeKbnCell = new PdfPCell(getParagraph(time_kbn,9));
		PdfPCell priceCell = new PdfPCell(getParagraph(price,9));
		PdfPCell morePriceCell = new PdfPCell(getParagraph(more_price,9));
		PdfPCell lessPriceCell = new PdfPCell(getParagraph(less_price,9));
		//PdfPCell otherPriceCell = new PdfPCell(getParagraph(other_price,9)));		//sxt 20221026 del
		PdfPCell amountCell = new PdfPCell(getParagraph(quantity,9));
		PdfPCell countCell = new PdfPCell(getParagraph(amount,9));
		PdfPCell bikoCell = new PdfPCell(getParagraph(biko,9));

		if (!isBottomDisplay){
			noCell.setBorderWidthBottom(notShow);
			contentCell.setBorderWidthBottom(notShow);
			timeKbnCell.setBorderWidthBottom(notShow);
			priceCell.setBorderWidthBottom(notShow);
			morePriceCell.setBorderWidthBottom(notShow);
			lessPriceCell.setBorderWidthBottom(notShow);
			//otherPriceCell.setBorderWidthBottom(notShow);		//sxt 20221026 del
			amountCell.setBorderWidthBottom(notShow);
			countCell.setBorderWidthBottom(notShow);
			bikoCell.setBorderWidthBottom(notShow);
		}

		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(17);
		timeKbnCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		timeKbnCell.setFixedHeight(17);
		priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		priceCell.setFixedHeight(17);
		morePriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		morePriceCell.setFixedHeight(17);
		lessPriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		lessPriceCell.setFixedHeight(17);
		//otherPriceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);		//sxt 20221026 del
		//otherPriceCell.setFixedHeight(17);								//sxt 20221026 del
		amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		amountCell.setFixedHeight(17);
		countCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		countCell.setFixedHeight(17);

		contentCell.setBorderWidthLeft(-1.0f);
		timeKbnCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);
		morePriceCell.setBorderWidthLeft(-1.0f);
		lessPriceCell.setBorderWidthLeft(-1.0f);
		//otherPriceCell.setBorderWidthLeft(-1.0f);			//sxt 20221026 del
		amountCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		bikoCell.setBorderWidthLeft(-1.0f);

		circulationTable.addCell(noCell);
		circulationTable.addCell(contentCell);
		//sxt 20220922 del start
//		circulationTable.addCell(timeKbnCell);
//		circulationTable.addCell(priceCell);
		//sxt 20220922 del end
		//sxt 20220922 add start
		circulationTable.addCell(priceCell);
		circulationTable.addCell(timeKbnCell);
		//sxt 20220922 add end
		circulationTable.addCell(morePriceCell);
		circulationTable.addCell(lessPriceCell);
		//circulationTable.addCell(otherPriceCell);			//sxt 20221026 del
		circulationTable.addCell(amountCell);
		circulationTable.addCell(countCell);
		circulationTable.addCell(bikoCell);

		return circulationTable;
	}
	//**********************************************************************↓↓↓↓↓↓↓

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param number String
     * @param content String
     * @param quantity String
     * @param units String
     * @param price String
     * @param amount String
     * @param isBottomDisplay boolean
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable circulationTable_new(String number,String content,String price,String quantity,String units,String amount,boolean isBottomDisplay) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable circulationTable = new PdfPTable(6);


		circulationTable.setWidths(headerwidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(circulationTable);
		PdfPCell noCell = new PdfPCell(getParagraph(number,11));

		PdfPCell contentCell = new PdfPCell(getParagraph(content,11));

		PdfPCell amountCell = new PdfPCell(getParagraph(quantity,11));

		PdfPCell unitsCell = new PdfPCell(getParagraph(units,11));

		PdfPCell priceCell = new PdfPCell(getParagraph(price,11));

		PdfPCell countCell = new PdfPCell(getParagraph(amount,11));

		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(17);
		amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		amountCell.setFixedHeight(17);
		//unitsCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		unitsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		unitsCell.setFixedHeight(17);
		priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		priceCell.setFixedHeight(17);
		countCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		countCell.setFixedHeight(17);

		if(isBottomDisplay){
			amountCell.setBorderWidthTop(0);
			unitsCell.setBorderWidthTop(0);
			priceCell.setBorderWidthTop(0);
			countCell.setBorderWidthTop(0);
			contentCell.setBorderWidthTop(0);
			noCell.setBorderWidthTop(0);
		}else{
			amountCell.setBorderWidthBottom(0);
			amountCell.setBorderWidthTop(0);
			unitsCell.setBorderWidthBottom(0);
			unitsCell.setBorderWidthTop(0);
			priceCell.setBorderWidthBottom(0);
			priceCell.setBorderWidthTop(0);
			countCell.setBorderWidthBottom(0);
			countCell.setBorderWidthTop(0);
			contentCell.setBorderWidthBottom(0);
			contentCell.setBorderWidthTop(0);
			noCell.setBorderWidthBottom(0);
			noCell.setBorderWidthTop(0);
		}

		contentCell.setBorderWidthLeft(-1.0f);
		amountCell.setBorderWidthLeft(-1.0f);
		unitsCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);

		circulationTable.addCell(noCell);
		circulationTable.addCell(contentCell);
		circulationTable.addCell(priceCell);
		circulationTable.addCell(amountCell);
		circulationTable.addCell(unitsCell);
		circulationTable.addCell(countCell);

		return circulationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param number String
     * @param content String
     * @param quantity String
     * @param units String
     * @param price String
     * @param amount String
     * @param isBottomDisplay boolean
     * @exception DocumentException
     * @exception IOException
     */

	private PdfPTable circulationTable_next(String number,String content,String price,String quantity,String units,String amount,boolean isBottomDisplay) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable circulationTable = new PdfPTable(6);


		circulationTable.setWidths(headerwidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(circulationTable);
		PdfPCell noCell = new PdfPCell(getParagraph(number,11));

		PdfPCell contentCell = new PdfPCell(getParagraph(content,11));

		PdfPCell amountCell = new PdfPCell(getParagraph(quantity,11));

		PdfPCell unitsCell = new PdfPCell(getParagraph(units,11));

		PdfPCell priceCell = new PdfPCell(getParagraph(price,11));

		PdfPCell countCell = new PdfPCell(getParagraph(amount,11));

		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(17);
		amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		amountCell.setFixedHeight(17);
		//unitsCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		unitsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		unitsCell.setFixedHeight(17);
		priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		priceCell.setFixedHeight(17);
		countCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		countCell.setFixedHeight(17);
		if (!isBottomDisplay){
			amountCell.setBorderWidthBottom(0);
			unitsCell.setBorderWidthBottom(0);
			priceCell.setBorderWidthBottom(0);
			countCell.setBorderWidthBottom(0);
			contentCell.setBorderWidthBottom(0);
			noCell.setBorderWidthBottom(0);
		}

		contentCell.setBorderWidthLeft(-1.0f);
		amountCell.setBorderWidthLeft(-1.0f);
		unitsCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);

		circulationTable.addCell(noCell);
		circulationTable.addCell(contentCell);
		circulationTable.addCell(priceCell);
		circulationTable.addCell(amountCell);
		circulationTable.addCell(unitsCell);
		circulationTable.addCell(countCell);

		return circulationTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param number String
     * @param content String
     * @param quantity String
     * @param units String
     * @param price String
     * @param amount String
     * @param isBottomDisplay boolean
     * @exception DocumentException
     * @exception IOException
     */

	private PdfPTable circulationTable(String number,String content,String price,String quantity,String units,String amount,boolean isBottomDisplay) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable circulationTable = new PdfPTable(6);


		circulationTable.setWidths(headerwidths);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(circulationTable);
		PdfPCell noCell = new PdfPCell(getParagraph(number,11));

		PdfPCell contentCell = new PdfPCell(getParagraph(content,11));

		PdfPCell amountCell = new PdfPCell(getParagraph(quantity,11));

		PdfPCell unitsCell = new PdfPCell(getParagraph(units,11));

		PdfPCell priceCell = new PdfPCell(getParagraph(price,11));

		PdfPCell countCell = new PdfPCell(getParagraph(amount,11));

//.setBorderWidthRight(notShow);
//		contentCell.setBorderWidthRight(notShow);
//		amountCell.setBorderWidthRight(notShow);
//
//		priceCell.setBorderWidthRight(notShow);
//		countCell.setBorderWidthLeft(notShow);
//
		if (!isBottomDisplay){
			noCell.setBorderWidthBottom(notShow);
			contentCell.setBorderWidthBottom(notShow);
			amountCell.setBorderWidthBottom(notShow);
			unitsCell.setBorderWidthBottom(notShow);
			priceCell.setBorderWidthBottom(notShow);
			countCell.setBorderWidthBottom(notShow);
		}

		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(17);

		amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		amountCell.setFixedHeight(17);

		//unitsCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		unitsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		unitsCell.setFixedHeight(17);

		priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		priceCell.setFixedHeight(17);

		countCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		countCell.setFixedHeight(17);

		//noCell.setBorderWidthLeft(-1.0f);
		contentCell.setBorderWidthLeft(-1.0f);
		amountCell.setBorderWidthLeft(-1.0f);
		unitsCell.setBorderWidthLeft(-1.0f);
		countCell.setBorderWidthLeft(-1.0f);
		priceCell.setBorderWidthLeft(-1.0f);

		circulationTable.addCell(noCell);
		circulationTable.addCell(contentCell);
		circulationTable.addCell(priceCell);
		circulationTable.addCell(amountCell);
		circulationTable.addCell(unitsCell);
		circulationTable.addCell(countCell);

		return circulationTable;
	}
	//**********************************************************************↑↑↑↑↑↑↑

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     */
	private PdfPTable emptyTable(){
		//PdfPTableの作成
		PdfPTable emptyTable = new PdfPTable(1);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(emptyTable);
		//PdfPCellの作成
		PdfPCell cell = new PdfPCell();
		cell.setBorderWidth(notShow);
		//行を添加する
		emptyTable.addCell(cell);
		return emptyTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable inputDateTable(String remark) throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable inputDateTable = new PdfPTable(1);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(inputDateTable);
		//PdfPCell overcell = new PdfPCell(getParagraph(remark,10)));	//sxt 20220901 del
		PdfPCell overcell = new PdfPCell(getParagraph(remark,9));		//sxt 20220901 add
		overcell.setBorderWidth(notShow);
		overcell.setFixedHeight(14);
		overcell.setHorizontalAlignment(Element.ALIGN_LEFT);
		overcell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		inputDateTable.addCell(overcell);
		return inputDateTable;
	}

	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param value String
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable inputTable(String value,String dataValue, boolean underLineFlg) throws DocumentException, IOException{
		PdfPTable inputTable = new PdfPTable(commonGroundNumColumns);
		//inputTable.setWidths(new int[] {6,20,5,10});		//sxt 20220831 del
		inputTable.setWidths(new int[] {6,20,6,10});		//sxt 20220831 add

		this.setPdfPTableAttribute(inputTable);

		PdfPCell title = new PdfPCell(getParagraph("",11));

		PdfPCell titleValue = new PdfPCell(getParagraph("",11));

		PdfPCell titleDate = new PdfPCell(getParagraph(value,11));

		PdfPCell titleDateValue = new PdfPCell(getParagraph(dataValue,11));

		title.setBorder(notShow);

		titleValue.setBorder(notShow);

		titleDate.setBorder(notShow);

		titleDateValue.setBorder(notShow);

		titleDate.setFixedHeight(14);

		titleDateValue.setHorizontalAlignment(Element.ALIGN_RIGHT);
		if(underLineFlg){
			titleDate.setBorderWidthBottom(0.5f);
			titleDateValue.setBorderWidthBottom(0.5f);
		}

		inputTable.addCell(title);
		inputTable.addCell(titleValue);
		inputTable.addCell(titleDate);
		inputTable.addCell(titleDateValue);


		return inputTable;
	}
	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @param value String
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable inputNewTable(String value,String dataValue) throws DocumentException, IOException{
		PdfPTable inputTable = new PdfPTable(commonGroundNumColumns);
		inputTable.setWidths(new int[] {6,20,10,50});


		this.setPdfPTableAttribute(inputTable);

		PdfPCell title = new PdfPCell(getParagraph("",11));

		PdfPCell titleValue = new PdfPCell(getParagraph("",11));

		PdfPCell titleDate = new PdfPCell(getParagraph(value,11));

		PdfPCell titleDateValue = new PdfPCell(getParagraph(dataValue,11));

		title.setBorder(notShow);

		titleValue.setBorder(notShow);

		titleDate.setBorder(notShow);

		titleDateValue.setBorder(notShow);

		titleDate.setFixedHeight(14);

		titleDateValue.setHorizontalAlignment(Element.ALIGN_CENTER);
		titleDate.setBorderWidthBottom(1);
		titleDateValue.setBorderWidthBottom(1);

		inputTable.addCell(title);
		inputTable.addCell(titleValue);
		inputTable.addCell(titleDate);
		inputTable.addCell(titleDateValue);


		return inputTable;
	}
	/**
     * PDF OutputRequestStreamt を設定します<BR>
     * <BR>
     * @param buffer ByteArrayOutputStream
	 * @throws Exception
     */
	public void documenOutputRequestStreamtCreate(ByteArrayOutputStream buffer,Connection conn) throws Exception{

		this.init();		//sxt 20230323 add
		
		Document document = new Document(PageSize.A4,30, 30, 30, 30);
		//pdfwriterを取得します
		PdfWriter write = PdfWriter.getInstance( document, buffer );
		//Documentの開ける
		document.open();
		List list = new ArrayList();
		try {
			list = getRequestReportCommonGroundModelList(conn);

		} catch (Exception e1) {

		}
		ReportCommonGroundModel reportCommonGroundModel = null;

		for (Object element : list) {

			document.newPage();

			reportCommonGroundModel = (ReportCommonGroundModel)element;

			List tampList = reportCommonGroundModel.getCirculationDateList();

			CustomerNameCreateManager customerNameCreate = reportCommonGroundModel.getCustomerNameCreate();

			SalesContentCreateManager salesContentCreate = reportCommonGroundModel.getSalesContentCreate();

			ContactMeansCreateManager contactMeansCreate = reportCommonGroundModel.getContactMeansCreate();

			ReportFormsImageCreateManager reportFormsImageCreate = new ReportFormsImageCreateManager();
			String imageName = null;
			try {
				imageName = reportFormsImageCreate.getImageName();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(image == null){
				image = reportFormsImageCreate.getImage(imageName);
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			//表を添加する
			String sales_no = Const.REQUEST_CODE + "  " + salesContentCreate.getSalesContentModel().getSales_no();
			String request_date = "";
			if(StringUtils.isEmpty(salesContentCreate.getSalesContentModel().getRequest_date())){
				request_date = null;
			}else{
				request_date = Const.REQUEST_DATE + "  " + salesContentCreate.getSalesContentModel().getRequest_date();
			}

			document.add(captionRequestfanriTable(image,fanhaorifuTable(sales_no,request_date)));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			String salesno = salesContentCreate.getSalesContentModel().getSales_no();

			String month_close_flg = this.selMonthCloseFlg(conn,salesno);

			if(month_close_flg.equals("1")){
				document.add(captionRequestThreeTable());
			}else if(month_close_flg.equals("2")){
				document.add(captionRequestThreeTableForAgain());
			}
			//CompanyName
			//String companyName = contactMeansCreate.getCompanyName();
			String companyName = NULL_STR8 + contactMeansCreate.getCompanyName();
			//zip_code
			//String zip_code = "〒" + contactMeansCreate.getZip_code();
			String zip_code = NULL_STR8 + "〒" + contactMeansCreate.getZip_code();

			document.add(reportCommonTable("","","","",9));
			//表を添加する
			countname = 3;
			//得意先を出力する
			/*if(StringUtils.isEmpty(customerNameCreate.getCall_name())){
//				document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name()," ",countname),rightTable(companyName,zip_code,address)));
				//document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name(),"御中",countname),rightTable("","")));
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),"御中",countname));

			}else{
//				document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname),rightTable(companyName,zip_code,address)));
				//document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname),rightTable("","")));
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname));
			}*/
			//請求先を出力する
			if(StringUtils.isEmpty(customerNameCreate.getRequest_callname())){
				document.add(companyInfoTable(customerNameCreate.getRequest_name(),"御中",countname));

			}else{
				document.add(companyInfoTable(customerNameCreate.getRequest_name(),customerNameCreate.getRequest_callname(),countname));
			}
			countname = 0;
			//del 20070130
			//document.add(reportCommonNameTable(rightTable("",""),rightTable(companyName,zip_code)));
			//住所
			String address = contactMeansCreate.getAddress();
			//TEL
			//String tel = Const.TEL + NULL_STR + contactMeansCreate.getCompanyTel();
			String tel = NULL_STR8 + Const.TEL + NULL_STR + contactMeansCreate.getCompanyTel();
			//FAX
			//String fax = Const.FAX + NULL_STR + contactMeansCreate.getCompanyFax();
			String fax = NULL_STR8 + Const.FAX + NULL_STR + contactMeansCreate.getCompanyFax();
			//担当者
			//String sales_in_name = Const.PERSON_IN_CHARGE + NULL_STR2 + salesContentCreate.getSalesContentModel().getSales_in_name();
			String sales_in_name = NULL_STR8 + Const.PERSON_IN_CHARGE + NULL_STR2 + salesContentCreate.getSalesContentModel().getSales_in_name();
			//銀行口座
//			String bank_no = contactMeansCreate.getBank_no();
			//件名１
			String sales_name1 = salesContentCreate.getSalesContentModel().getSales_name1();
			//件名２
			String sales_name2 = salesContentCreate.getSalesContentModel().getSales_name2();
			//件名３
			String sales_name3 = salesContentCreate.getSalesContentModel().getSales_name3();
			//御社発注番号
			String order_no = Const.ORDER_NO + NULL_STR4 + salesContentCreate.getSalesContentModel().getOrder_code_from_cst();
			//作業期間
			String workDate ;
			if(StringUtils.isEmpty(salesContentCreate.getSalesContentModel().getWork_start_date())&&StringUtils.isEmpty(salesContentCreate.getSalesContentModel().getWork_end_date())){
				workDate = Const.WORK_DATE + NULL_STR2 + salesContentCreate.getSalesContentModel().getWork_start_date()  + salesContentCreate.getSalesContentModel().getWork_end_date();
			}else{
				workDate = Const.WORK_DATE + NULL_STR2 + salesContentCreate.getSalesContentModel().getWork_start_date() + "～" + salesContentCreate.getSalesContentModel().getWork_end_date();
			}

			//文字列を指定された長さで件名１を切り離す
			List<String> listLeft = new ArrayList<>(),listRight = new ArrayList<>();
			List<String> salesName1List = FieldFormatter.divideSring(sales_name1, LENGTH_LEFT);
			for (int j = 0; j < salesName1List.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.ESTIMATE_NAME + NULL_STR2 + salesName1List.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + salesName1List.get(j);
				}
				salesName1List.set(j, tempStr);
			}
			//リストに件名１を添加する
			listLeft.addAll(salesName1List);
			//文字列を指定された長さで件名２を切り離す
			if (!("").equals(sales_name2)) {
				List<String> salesName2List = FieldFormatter.divideSring(sales_name2, LENGTH_LEFT);
				for (int j = 0; j < salesName2List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + salesName2List.get(j);
					salesName2List.set(j, tempStr);
				}
				//リストに件名２を添加する
				listLeft.addAll(salesName2List);
			}
			//文字列を指定された長さで件名３を切り離す
			if (!("").equals(sales_name3)) {
				List<String> salesName3List = FieldFormatter.divideSring(sales_name3, LENGTH_LEFT);
				for (int j = 0; j < salesName3List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + salesName3List.get(j);
					salesName3List.set(j, tempStr);
				}
				//リストに件名３を添加する
				listLeft.addAll(salesName3List);
			}
			//御社発注番号を添加する
			listLeft.add(order_no);
			//リストに作業期間を添加する
			listLeft.add(workDate);
			//add 20070130


			//20200602 del ↓
			//listRight.add("");
			//listRight.add(companyName);
			//listRight.add(zip_code);
			//20200602 del ↑

			//文字列を指定された長さで住所を切り離す
			//List<String> addressList = FieldFormatter.divideSring(address, LENGTH_RIGHT);
			List<String> addressList = FieldFormatter.divideSring(address, 32L);
			for(int j=0; j<addressList.size();j++){
				String tempStr = NULL_STR8 + addressList.get(j);
				addressList.set(j, tempStr);
			}

			////リストに住所を添加する			//20200602 del
			//listRight.addAll(addressList);	//20200602 del

			//リストにTELを添加する
			listRight.add(tel);
			//リストにFAXを添加する
			listRight.add(fax);
			//リストに担当者を添加する
			listRight.add(sales_in_name);
			//文字列を指定された長さで銀行口座を切り離す
//			List<String> banknoList = FieldFormatter.divideSring(bank_no, LENGTH_RIGHT);
//			for (int j = 0; j < banknoList.size(); j++) {
//				String tempStr = "";
//				if (j == 0) {
//					tempStr = Const.BANK_NO + NULL_STR5 + banknoList.get(j);
//				} else {
//					tempStr = NULL_STR3 + NULL_STR2 + banknoList.get(j);
//				}
//				banknoList.set(j, tempStr);
//			}
//			//リストに銀行口座を添加する
//			listRight.addAll(banknoList);


//			//表を添加する
//			int index = 0;
//			for (int k = 0; k < listLeft.size(); k++) {
//			 	if (index < listRight.size()) {
//			 		document.add(reportCommonTable(listLeft.get(k),"","",listRight.get(k),9));
//			 		index++;
//			 	} else if(index == listRight.size()){
//			 				document.add(reportCommonTable(listLeft.get(k),"","","",9));
//			 				index++;
//			 			}
//					 	if(index == listRight.size()+1){
//					 		document.add(reportCommonTwoTable(listLeft.get(k),"","",jianYingTable(),9));
//					 		index++;
//					 	}
//					 	if(index > listRight.size()+1){
//			 				document.add(reportCommonTable(listLeft.get(k),"","","",9));
//			 				index++;
//			 			}
//
//			}

			//20200602 add ↓
			//印鑑イメージを追加
			PdfPTable imageTable = addInkanImage();
			if (imageTable != null) {
				document.add(imageTable);
			}
			//20200602 add ↑

			//表を添加する
			int index = 0;
			for (String element2 : listRight) {
		 		document.add(reportCommonTable("","","",element2,11));
			}
			for (int j = listRight.size();j<listRight.size()+listLeft.size();j++ ){
				if (index < listLeft.size()) {
//				document.add(reportCommonLeftTable(listLeft.get(index),"","","",9));
					document.add(reportCommonLeftTable(listLeft.get(index),11));
					index++;
				}
			}
//			while(true) {
//				if (index >= listRight.size()) {
//					break;
//				}
//				document.add(reportCommonTable("","","",listRight.get(index),9));
//				index++;
//			}
			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			if (!DIS.equals(reportCommonGroundModel.getReportReckonModel(salesContentCreate).getSummationFour())) {
				document.add(summationRquestTable(reportCommonGroundModel.getReportReckonModel(salesContentCreate).getSummationFour()));
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			if (tampList != null && tampList.size() > 0) {

				String summation_two =reportCommonGroundModel.getReportReckonModel(salesContentCreate).getSummationTwo();
				String summation_three = reportCommonGroundModel.getReportReckonModel(salesContentCreate).getSummationThree();
				String summation_one = reportCommonGroundModel.getReportReckonModel(salesContentCreate).getSummationOne();
				int amountLength = 0;
				if(!DIS.equals(summation_two)) amountLength++;
				if(!DIS.equals(summation_three)) amountLength++;
				if(!DIS.equals(summation_one)) amountLength++;

				int maxLine = 0;

//				if (listLeft.size() > listRight.size()) {
					maxLine = this.FIRST_PAGE_FIXATION_LENGTH - listLeft.size()-listRight.size() ;
//				} else {
//					maxLine = this.FIRST_PAGE_FIXATION_LENGTH - listRight.size();
//				}

				List<ReportCirculationDateModel> pList = new ArrayList<>();
				ReportCirculationDateModel model = null;
				for (Object element2 : tampList) {
					model = (ReportCirculationDateModel)element2;
					String content = model.getTask_content();
					if (StringUtils.isEmpty(content)) {
						pList.add(model);
					} else {
						List<String> contentList = FieldFormatter.divideSring(content, 200L);
						for (int q = 0; q < contentList.size(); q++) {
							if (q == 0) {
								model.setTask_content(contentList.get(q));
								pList.add(model);
							} else {
								ReportCirculationDateModel modelInternal = new ReportCirculationDateModel();
								modelInternal.setTask_content(contentList.get(q));
								modelInternal.setAmount("NULL");
								pList.add(modelInternal);
							}
						}
					}
				}
				tampList = pList;
				document.add(dataHeadTable());
				ReportCirculationDateModel reportCirculationDateModel = null;
				int number = 1;

				for(int k = 0;k < tampList.size();k++) {
					reportCirculationDateModel = (ReportCirculationDateModel) tampList.get(k);

					if (k != 0 && !"NULL".equals(reportCirculationDateModel.getAmount())) {
						number++;
					}
					String numberValue = "";
					if ("NULL".equals(reportCirculationDateModel.getAmount())) {
						reportCirculationDateModel.setAmount("");
						numberValue = "";
					} else {
						numberValue = String.valueOf(number);
					}

					String price = "";
					String amount = "";
					String unit = "";
					String quantity = "";
					String taskContent = "";
					taskContent = reportCirculationDateModel.getTask_content();
					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
						price = reportCirculationDateModel.getPrice_per();
					}
					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
						quantity = reportCirculationDateModel.getQuantity();
					}
					if(reportCirculationDateModel.getCode_value() != null){
						unit = reportCirculationDateModel.getCode_value();
					}
					if(reportCirculationDateModel.getAmount() != null) {
						amount = reportCirculationDateModel.getAmount();
					}
					boolean isDisplay = false;
					maxLine--;
					if (maxLine == 0 || k == (tampList.size() - 1)) {
						isDisplay = true;
					}
					document.add(this.circulationTable(numberValue,taskContent,price,quantity,unit,amount,isDisplay));

					if (maxLine == 0) {
					 	document.newPage();
					 	if (k == (tampList.size() - 1)) {
					 		document.add(this.inputTable("","",false));
					 		//表を添加する
							if(!DIS.equals(summation_two)) {
								document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
							}
							//表を添加する
							if (!DIS.equals(summation_three)){
								//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
								//sxt 20220831 add start
								String rateTitle = Const.SUMMATION_TWO + "（" + salesContentCreate.getSalesContentModel().getConsume_tax_rate() + "%）";
								//_logger.info("rateTitle****");
								//_logger.info(rateTitle);
								document.add(this.inputTable(rateTitle,summation_three,true));
								//sxt 20220831 add end
							}
							//表を添加する
							if (!DIS.equals(summation_one)){
								document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
							}
					 	} else {
					 		maxLine = this.NEXT_PAGE_FIXATION_LENGTH;
					 		document.add(dataHeadTable());
					 	}
					} else if (k == (tampList.size() - 1)) {
					 	if (maxLine < amountLength) {
					 		document.newPage();
					 	}
					 	document.add(this.inputTable("","",false));
					 	//表を添加する
						if(!DIS.equals(summation_two)) {
							document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
						}
						//表を添加する
						if (!DIS.equals(summation_three)){
							//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
							//sxt 20220831 add start
							String rateTitle = Const.SUMMATION_TWO + "（" + salesContentCreate.getSalesContentModel().getConsume_tax_rate() + "%）";
							//_logger.info("rateTitle****");
							//_logger.info(rateTitle);
							document.add(this.inputTable(rateTitle,summation_three,true));
							//sxt 20220831 add end
						}
						//表を添加する
						if (!DIS.equals(summation_one)){
							document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
						}
					}
				}


				document.add(this.emptyTable());
				document.add(this.emptyTable());
			}
			//御入金予定日
			if(StringUtils.isNotEmpty(salesContentCreate.getSalesContentModel().getInput_pre_date())){
				String input_pre_date = salesContentCreate.getSalesContentModel().getInput_pre_date().substring(0,4)+"年"
				+salesContentCreate.getSalesContentModel().getInput_pre_date().substring(5,7)+"月"
				+salesContentCreate.getSalesContentModel().getInput_pre_date().substring(8,10)+"日";

				//String date = Const.INPUT_PRE_DATE + NULL_STR4 + input_pre_date + "です。";
				String date = Const.INPUT_PRE_DATE + NULL_STR4 + input_pre_date;
				document.add(this.emptyTable());
				document.add(reportCommonTable(date,"","","",9));
				document.add(this.emptyTable());
				document.add(this.emptyTable());
			}


			//備考
			String remark = salesContentCreate.getSalesContentModel().getRemark();

			//備考が空白以外の場合
			if ( !StringUtils.isEmpty( remark ) ) {

				//空白行を追加する。
				document.add(this.emptyTable());
				document.add(this.emptyTable());

				//備考を”\r\n”又は”\n”で分割する。
				String remarkTemp = salesContentCreate.getSalesContentModel().getRemark().replaceAll("\r\n", "\n");
				String remarkArray[] = remarkTemp.split("\n");

				//分割した備考配列をループする。
				for ( int k = 0; k < remarkArray.length; k++ ) {

					if ( k > 0 ) {
						document.add(this.emptyTable());
					}

					//List<String> remarkList = FieldFormatter.divideSring(remarkArray[ k ], 105);		//sxt 20220901 del
					List<String> remarkList = FieldFormatter.divideSring(remarkArray[ k ], 118);		//sxt 20220901 add

					for (String element2 : remarkList) {
						document.add(this.inputDateTable( element2 ) );
					}

				}
			}
			document.add(reportCommonTable("","","","",9));
			document.add(reportCommonTable("","","","",9));
			document.add(reportCommonTable("","","","",9));
			document.add(reportCommonTable("","","","",9));
			document.add(reportCommonTwoTable("","","",jianYingTable(),9));
			//document.add(this.inputDateTable(salesContentCreate.getSalesContentModel().getRemark()));
//			List<String> remarkList = FieldFormatter.divideSring(salesContentCreate.getSalesContentModel().getRemark(), 105);
//			for (int k = 0; k < remarkList.size(); k++) {
//				String str = remarkList.get(k);
//				if (str.indexOf("\r\n") != -1) {
//					document.add(this.inputDateTable(str.substring(0,str.indexOf("\r\n") + 1)));
//					document.add(this.inputDateTable(str.substring(str.indexOf("\r\n"))));
//				} else if (str.indexOf("\n") != -1) {
//					document.add(this.inputDateTable(str.substring(0,str.indexOf("\n") + 1)));
//					document.add(this.inputDateTable(str.substring(str.indexOf("\n"))));
//				}else {
//					document.add(this.inputDateTable(remarkList.get(k)));
//				}
//			}
		}

		//documentの閉鎖する
		document.close();
	}

	/**
     * ReportCommonGroundBeanListを取得します<BR>
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getRequestReportCommonGroundModelList(Connection conn) throws Exception{

		List reportCommonGroundModelList = new ArrayList();
		ReportCommonGroundModel reportCommonGroundModel = null;
		CustomerNameCreateManager customerNameCreate = null;
		SalesContentCreateManager salesContentCreate= null;

		ContactMeansCreateManager contactMeansCreate = new ContactMeansCreateManager();

		contactMeansCreate.excute(conn,this.kigyou_code);

		for(int i = 0;i<this.salesCode.size();i++){

			reportCommonGroundModel = new ReportCommonGroundModel();

			customerNameCreate = new CustomerNameCreateManager();

			salesContentCreate = new SalesContentCreateManager();

			String sales_code = (String) salesCode.get(i);

			reportCommonGroundModel.setCirculationDateList(
					getMTKReportCirculationRequestDateBeanList( sales_code,conn) );

			reportCommonGroundModel.setCustomerCode(sales_code);
			//得意先を取得する
			customerNameCreate.requestExecute(sales_code ,conn,this.kigyou_code);
			//請求先を取得する
			customerNameCreate.requestExecute1(sales_code ,conn,this.kigyou_code);
			salesContentCreate.execute(sales_code,conn,this.kigyou_code);

			reportCommonGroundModel.setCustomerNameCreate(customerNameCreate);

			reportCommonGroundModel.setSalesContentCreate(salesContentCreate);

			reportCommonGroundModel.setContactMeansCreate(contactMeansCreate);

			reportCommonGroundModelList.add(reportCommonGroundModel);
		}
		return  reportCommonGroundModelList;
	}

    /**
     * PDF OutputStreamt を設定します<BR>
     * <BR>
     * @param buffer ByteArrayOutputStream
     */
	public void documenOutputStreamtCreate(ByteArrayOutputStream buffer,Connection conn) throws DocumentException, SQLException, IOException {

		this.init();		//sxt 20230323 add
		
		Document document = new Document(PageSize.A4,30, 30, 15, 30);
		//pdfwriterを取得します
		PdfWriter.getInstance( document, buffer );
		//Documentの開ける
		document.open();

		List list = new ArrayList();
		try {
			list = getReportCommonGroundModelList(conn);
		} catch (Exception e1) {

		}
		ReportCommonGroundModel reportCommonGroundModel = null;
		for (Object element : list) {

			reportCommonGroundModel = (ReportCommonGroundModel)element;

			List tampList = reportCommonGroundModel.getCirculationDateList();

			CustomerNameCreateManager customerNameCreate = reportCommonGroundModel.getCustomerNameCreate();

			EstimateContentCreateManager estimateContentCreate = reportCommonGroundModel.getEstimateContentCreate();

			ContactMeansCreateManager contactMeansCreate = reportCommonGroundModel.getContactMeansCreate();

			ReportFormsImageCreateManager reportFormsImageCreate = new ReportFormsImageCreateManager();
			String imageName = null;
			try {
				imageName = reportFormsImageCreate.getImageName();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(image == null){
				image = reportFormsImageCreate.getImage(imageName);
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			//表を添加する
			String sales_no = Const.ESTIMATE_CODE + "  " + estimateContentCreate.getEstimateContentModel().getEstimate_no();

			String request_date = "";
			if(StringUtils.isEmpty(estimateContentCreate.getEstimateContentModel().getEstimate_date())){
				request_date = null;
			}else{
				request_date = Const.ESTIMATE_DATE + "  " + estimateContentCreate.getEstimateContentModel().getEstimate_date();
			}

			document.add(captionRequestfanriTable(image,fanhaorifuTable(sales_no,request_date)));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			document.add(captionRequestSixTable());

			//CompanyName
			String companyName = NULL_STR8 + contactMeansCreate.getCompanyName();

			//zip_code
			String zip_code = NULL_STR8 + "〒" + contactMeansCreate.getZip_code();

			document.add(reportCommonTable("","","","",9));
			//表を添加する
			countname = 3;
			if(StringUtils.isEmpty(customerNameCreate.getCall_name())){
				//会社名
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),"御中",countname));

			}else{
				//会社名
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname));
			}

			//印鑑イメージを追加
			//「ご依頼の件につき、下記のように御見積り申し上げます。」を追加
			//PdfPTable imageTable = addInkanImage(Const.MITSUMORI_ADD1,11);		//sxt 20220928 del
			PdfPTable imageTable = addInkanImage("",11);							//sxt 20220928 add
			if (imageTable != null) {
				document.add(imageTable);
			}

			countname = 0;

			//TEL
			String tel = NULL_STR8 + Const.TEL + NULL_STR + contactMeansCreate.getCompanyTel();
			//FAX
			String fax = NULL_STR8 + Const.FAX + NULL_STR + contactMeansCreate.getCompanyFax();
			//担当者
			String estimate_in_name = NULL_STR8 + Const.PERSON_IN_CHARGE + NULL_STR2 + estimateContentCreate.getEstimateContentModel().getEstimate_in_name();
			//住所
			String address = contactMeansCreate.getAddress();
			//件名１
			String estimate_name1 = estimateContentCreate.getEstimateContentModel().getEstimate_name1();
			//件名２
			String estimate_name2 = estimateContentCreate.getEstimateContentModel().getEstimate_name2();
			//件名３
			String estimate_name3 = estimateContentCreate.getEstimateContentModel().getEstimate_name3();
			//支払条件
			String paymentCondition = estimateContentCreate.getEstimateContentModel().getPayment_condition();
			//契約形態コード
			String contract_form_id = estimateContentCreate.getEstimateContentModel().getContract_form();
			//契約形態の値
			String contract_form_value = "";
			if (contract_form_id != null) {
				TbCodeModel codeNameModel = this.getSelectCodeName(conn, HanbaiConstants.M0033,
												estimateContentCreate.getEstimateContentModel().getContract_form(),kigyou_code);
				if (codeNameModel != null) {
					contract_form_value = codeNameModel.getCode_value();
				}

			}
			//作業場所
			String workPlace = Const.WORK_PLACE + NULL_STR2 + estimateContentCreate.getEstimateContentModel().getDelivery_place();

			//見積有効期限
			String estimateTerm = Const.ESTIMATE_TERM + NULL_STR4 + estimateContentCreate.getEstimateContentModel().getEstimate_term();

			//作業期間
			String workDate = Const.WORK_DATE + NULL_STR2 + estimateContentCreate.getEstimateContentModel().getWork_start_date() + "～" + estimateContentCreate.getEstimateContentModel().getWork_end_date();
			//文字列を指定された長さで件名１を切り離す
			List<String> listLeft = new ArrayList<>(),listRight = new ArrayList<>();
			List<String> estimateName1List = FieldFormatter.divideSring(estimate_name1, LENGTH_LEFT);
			for (int j = 0; j < estimateName1List.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.ESTIMATE_NAME + NULL_STR2 + estimateName1List.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + estimateName1List.get(j);
				}
				estimateName1List.set(j, tempStr);
			}

			//リストに件名１を添加する
			listLeft.addAll(estimateName1List);
			//文字列を指定された長さで件名２を切り離す
			if (!("").equals(estimate_name2)) {
				List<String> estimateName2List = FieldFormatter.divideSring(estimate_name2, LENGTH_LEFT);
				for (int j = 0; j < estimateName2List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + estimateName2List.get(j);
					estimateName2List.set(j, tempStr);
				}
				//リストに件名２を添加する
				listLeft.addAll(estimateName2List);
			}
			//文字列を指定された長さで件名３を切り離す
			if (!("").equals(estimate_name3)) {
				List<String> estimateName3List = FieldFormatter.divideSring(estimate_name3, LENGTH_LEFT);
				for (int j = 0; j < estimateName3List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + estimateName3List.get(j);
					estimateName3List.set(j, tempStr);
				}
				//リストに件名３を添加する
				listLeft.addAll(estimateName3List);
			}

			//リストに作業期間を添加する
			listLeft.add(workDate);

			//リストに作業場所を添加する
			listLeft.add(workPlace);

			//契約形態
			listLeft.add(Const.CONTRACT_FORM + NULL_STR2 + contract_form_value);

			//リストに見積有効期限を添加する
			//listLeft.add(estimateTerm);	//sxt 20220928 del

			//文字列を指定された長さで住所を切り離す
			List<String> addressList = FieldFormatter.divideSring(address, 32L);
			for(int j=0; j<addressList.size();j++){
				String tempStr = NULL_STR8 + addressList.get(j);
				addressList.set(j, tempStr);
			}

			//リストにTELを添加する
			listRight.add(tel);
			//リストにFAXを添加する
			listRight.add(fax);
			//リストに担当者を添加する
			listRight.add(estimate_in_name);

			//表を添加する
			int index = 0;
			for (String element2 : listRight) {
		 		document.add(reportCommonTable("","","",element2,11));
			}

			document.add(reportCommonTable("","","","",9));

			PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumLeftColumns);
			reportCommonGroundTable.setWidths(commonGroundLeftWidths);

			reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
			reportCommonGroundTable.getDefaultCell().setPadding(1);
			reportCommonGroundTable.getDefaultCell().setBorderWidth(2);

			for (int j = listRight.size();j<listRight.size()+listLeft.size();j++ ){
				if (index < listLeft.size()) {
					PdfPCell title = new PdfPCell(getParagraph(listLeft.get(index),11));
					title.setBorder(notShow);
					reportCommonGroundTable.addCell(title);
					index++;
				}
			}

			document.add(reportCommonNameTable(reportCommonGroundTable, jianYingTable()));

			//表を添加する
			document.add(this.emptyTable());
			document.add(reportCommonTable("","","","",9));

			if (!DIS.equals(reportCommonGroundModel.getReportReckonModel(estimateContentCreate).getSummationFour())) {
				document.add(summationTable(reportCommonGroundModel.getReportReckonModel(estimateContentCreate).getSummationFour()));
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			int linesum = 17 ;

//			if (listLeft.size() > listRight.size()) {
//				linesum = linesum + listLeft.size();
//			}else{
//				linesum = linesum + listRight.size();
//			}
			linesum = linesum + listLeft.size() + listRight.size();
			if (!DIS.equals(reportCommonGroundModel.getReportReckonModel(estimateContentCreate).getSummationFour())) {
				linesum = linesum + 1 ;
			}
			if(tampList!=null && tampList.size()>0){
				linesum = linesum + tampList.size() ;
			}

			if (tampList != null && tampList.size() > 0) {

				String summation_two =reportCommonGroundModel.getReportReckonModel(estimateContentCreate).getSummationTwo();
				String summation_three = reportCommonGroundModel.getReportReckonModel(estimateContentCreate).getSummationThree();
				String summation_one = reportCommonGroundModel.getReportReckonModel(estimateContentCreate).getSummationOne();
				int amountLength = 0;
				if(!DIS.equals(summation_two)) amountLength++;
				if(!DIS.equals(summation_three)) amountLength++;
				if(!DIS.equals(summation_one)) amountLength++;

				int maxLine = 0;

//				if (listLeft.size() > listRight.size()) {
					maxLine = this.FIRST_PAGE_FIXATION_LENGTH - listLeft.size() - listRight.size() - 2;
//				} else {
//					maxLine = this.FIRST_PAGE_FIXATION_LENGTH - listRight.size();
//				}

				//---------------
				//  明細部
				//---------------
				List<ReportCirculationDateModel> pList = new ArrayList<>();
				ReportCirculationDateModel model = null;
				for (Object element2 : tampList) {
					model = (ReportCirculationDateModel)element2;
					//備考
					String content = model.getBiko();

					if (StringUtils.isEmpty(content)) {
						pList.add(model);
					} else {

						//備考を”\r\n”又は”\n”で分割する。
						content = content.replaceAll("\r\n", "\n");
						String contentkArray[] = content.split("\n");

						//分割した備考配列をループする。
						for ( int k = 0; k < contentkArray.length; k++ ) {

							List<String> contentList = FieldFormatter.divideSring(contentkArray[ k ], 40L);

							for (int q = 0; q < contentList.size(); q++) {
								if (k == 0 && q == 0) {
									model.setBiko(contentList.get(q));
									pList.add(model);
								} else {
									ReportCirculationDateModel modelInternal = new ReportCirculationDateModel();
									modelInternal.setBiko(contentList.get(q));
									modelInternal.setAmount("NULL");
									pList.add(modelInternal);
								}
							}
						}

					}
				}

				tampList = pList;
				//明細部のタイトル
				document.add(dataHeadTable());
				ReportCirculationDateModel reportCirculationDateModel = null;
				ReportCirculationDateModel nextModel = new ReportCirculationDateModel();
				int number = 1;

				for(int k = 0;k < tampList.size();k++) {

					reportCirculationDateModel = (ReportCirculationDateModel) tampList.get(k);

					if( k+1 < tampList.size()){
						nextModel = (ReportCirculationDateModel) tampList.get(k+1);
					}

					if (k != 0 && !"NULL".equals(reportCirculationDateModel.getAmount())) {
						number++;
					}
					String numberValue = "";
					if ("NULL".equals(reportCirculationDateModel.getAmount())) {
						reportCirculationDateModel.setAmount("");
						numberValue = "";
					} else {
						numberValue = String.valueOf(number);
					}

					String taskContent = "";	//技術者名
					String time_kbn = "";		//人月時間区分
					String price = "";			//単価
					String more_price = "";		//超過単価
					String less_price = "";		//減額単価
					String other_price = "";	//そのた（交通費など）
					String quantity = "";		//工数
					String amount = "";			//金額
					String biko = "";			//備考
					String unit = "";

					//技術者名
					taskContent = reportCirculationDateModel.getTask_content();
					//人月時間区分
					time_kbn = reportCirculationDateModel.getTime_kbn_name();
					//単価
					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
						price = reportCirculationDateModel.getPrice_per();
					}
					//超過単価
					if(reportCirculationDateModel.getMore_price() != null && !reportCirculationDateModel.getMore_price().equals("")){
						more_price = reportCirculationDateModel.getMore_price();
					}
					//減額単価
					if(reportCirculationDateModel.getLess_price() != null && !reportCirculationDateModel.getLess_price().equals("")){
						less_price = reportCirculationDateModel.getLess_price();
					}
					//そのた（交通費など）
					if(reportCirculationDateModel.getOther_price() != null && !reportCirculationDateModel.getOther_price().equals("")){
						other_price  = reportCirculationDateModel.getOther_price();
					}
					//工数
					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
						quantity = reportCirculationDateModel.getQuantity();
					}
					//金額
					if(reportCirculationDateModel.getAmount() != null) {
						amount = reportCirculationDateModel.getAmount();
					}
					//備考
					biko = reportCirculationDateModel.getBiko();

					if(reportCirculationDateModel.getCode_value() != null){
						unit = reportCirculationDateModel.getCode_value();
					}
					boolean isDisplay = false;
					maxLine--;
					if (maxLine == 0 || k == (tampList.size() - 1)) {
						isDisplay = true;
					}

					if (numberValue.equals("")){
						document.add(this.circulationTable_new(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
					}else{
						//次明細は同じです
						if ("NULL".equals(nextModel.getAmount())){
							document.add(this.circulationTable_next(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
						//次明細は違いです
						}else{
							document.add(this.circulationTable(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
						}
					}

					//合計
					if (maxLine == 0) {
					 	document.newPage();
					 	if (k == (tampList.size() - 1)) {
					 		//表を添加する
							if(!DIS.equals(summation_two)) {
								document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
								linesum = linesum + 1 ;
							}
							//表を添加する
							if (!DIS.equals(summation_three)){
								//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));	//sxt 20220831 del
								//sxt 20220831 add start
								String rateTitle = Const.SUMMATION_TWO + "（" + estimateContentCreate.getEstimateContentModel().getTax_rate() + "%）";
								//_logger.info("rateTitle mitsu1***");
								//_logger.info(rateTitle);
								document.add(this.inputTable(rateTitle,summation_three,true));
								//sxt 20220831 add end
								linesum = linesum + 1 ;
							}
							//表を添加する
							if (!DIS.equals(summation_one)){
								document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
								linesum = linesum + 1 ;
							}
					 	} else {
					 		maxLine = this.NEXT_PAGE_FIXATION_LENGTH;
//add by liuyujia 2007/03/27
					 		if ("NULL".equals(nextModel.getAmount())){
					 			boolean flg = true;
					 			document.add(dataHeadTable(flg));
					 		}else{
					 			document.add(dataHeadTable());
					 		}
//add
					 	}
					} else if (k == (tampList.size() - 1)) {
					 	if (maxLine < amountLength) {
					 		document.newPage();
					 	}
					 	document.add(this.inputTable("","",false));
					 	//表を添加する
						if(!DIS.equals(summation_two)) {
							document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
							linesum = linesum + 2 ;
						}
						//表を添加する
						if (!DIS.equals(summation_three)){
							//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
							//sxt 20220831 add start
							String rateTitle = Const.SUMMATION_TWO + "（" + estimateContentCreate.getEstimateContentModel().getTax_rate() + "%）";
							//_logger.info("rateTitle mitsu2***");
							//_logger.info(rateTitle);
							document.add(this.inputTable(rateTitle,summation_three,true));
							//sxt 20220831 add end
							linesum = linesum + 1 ;
						}
						//表を添加する
						if (!DIS.equals(summation_one)){
							document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
							linesum = linesum + 1 ;
						}
					}
				}

				document.add(this.emptyTable());
				document.add(this.emptyTable());
			}


			//sxt 20220915 add start
			String payment_method = estimateContentCreate.getEstimateContentModel().getPayment_method();
			//sxt 20220915 add end
			//------------------------------
			// 月間作業基準時間外の精算方法
			//------------------------------
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			if (payment_method.equals("1")) {
				document.add(this.calculateTitleTable());
			}	//sxt 20220915 add
			document.add(this.calculateTable(estimateContentCreate));

			//備考
			String remark = estimateContentCreate.getEstimateContentModel().getRemark();

			//備考が空白以外の場合
			if ( !StringUtils.isEmpty( remark ) ) {
				//空白行を追加する。
				document.add(reportCommonTable("","","","",9));
				document.add(reportCommonTable("","","","",9));

				document.add(this.remarkTable(remark));
			}

		}

		//documentの閉鎖する
		document.close();
	}

	/**
     * PDF OutputStreamt を設定します<BR>
     * <BR>
     * @param buffer ByteArrayOutputStream
     */
	public void documenJyutyuOutputStreamtCreate(ByteArrayOutputStream buffer,Connection conn) throws DocumentException, SQLException, IOException{

		this.init();		//sxt 20230323 add
		
		Document document = new Document(PageSize.A4,30, 30, 15, 30);
		//pdfwriterを取得します
		PdfWriter.getInstance( document, buffer );
		//Documentの開ける
		document.open();

		List list = new ArrayList();
		try {
			list = getJyutyuReportCommonGroundModelList(conn);
		} catch (Exception e1) {

		}
		ReportCommonGroundModel reportCommonGroundModel = null;
		for (Object element : list) {

			reportCommonGroundModel = (ReportCommonGroundModel)element;

			List tampList = reportCommonGroundModel.getCirculationDateList();

			CustomerNameCreateManager customerNameCreate = reportCommonGroundModel.getCustomerNameCreate();

			ReceiveContentCreateManager receiveContentCreate = reportCommonGroundModel.getReceiveContentCreate();

			ContactMeansCreateManager contactMeansCreate = reportCommonGroundModel.getContactMeansCreate();

			ReportFormsImageCreateManager reportFormsImageCreate = new ReportFormsImageCreateManager();
			//LOG
			String imageName = null;
			try {
				imageName = reportFormsImageCreate.getImageName();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(image == null){
				image = reportFormsImageCreate.getImage(imageName);
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			//表を添加する
			String sales_no = Const.RECEIVED_NO + "  " + receiveContentCreate.getReceiveContentModel().getReceive_no();

			String request_date = "";
			if(StringUtils.isEmpty(receiveContentCreate.getReceiveContentModel().getReceive_date())){
				request_date = null;
			}else{
				request_date = Const.RECEIVED_DATE + "  " + receiveContentCreate.getReceiveContentModel().getReceive_date();
			}

			document.add(captionRequestfanriTable(image,fanhaorifuTable(sales_no,request_date)));
			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			document.add(captionRequestFourTable());

			//CompanyName
			String companyName = NULL_STR8 + contactMeansCreate.getCompanyName();
			//zip_code
			String zip_code = NULL_STR8 + "〒" + contactMeansCreate.getZip_code();

			document.add(reportCommonTable("","","","",9));
			//表を添加する
			countname = 3;
			//得意先名
			if(StringUtils.isEmpty(customerNameCreate.getCall_name())){
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),"御中",countname));

			}else{
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname));
			}

			countname = 0;

			//TEL
			String tel = NULL_STR8 + Const.TEL + NULL_STR + contactMeansCreate.getCompanyTel();
			//FAX
			String fax = NULL_STR8 + Const.FAX + NULL_STR + contactMeansCreate.getCompanyFax();
			//担当者
			String receive_in_name = NULL_STR8 + Const.PERSON_IN_CHARGE + NULL_STR2 + receiveContentCreate.getReceiveContentModel().getReceive_in_name();
			//住所
			String address = contactMeansCreate.getAddress();
			//件名１
			String receive_name1 = receiveContentCreate.getReceiveContentModel().getReceive_name1();
			//件名２
			String receive_name2 = receiveContentCreate.getReceiveContentModel().getReceive_name2();
			//件名３
			String receive_name3 = receiveContentCreate.getReceiveContentModel().getReceive_name3();
			//支払条件
			String paymentCondition = receiveContentCreate.getReceiveContentModel().getPayment_condition();
			//作業期間
			String workDate = Const.WORK_DATE + NULL_STR2 + receiveContentCreate.getReceiveContentModel().getWork_start_date() + "～" + receiveContentCreate.getReceiveContentModel().getWork_end_date();
			//契約形態コード
			String contract_form_id = receiveContentCreate.getReceiveContentModel().getContract_form();
			//契約形態の値
			String contract_form_value = "";
			if (contract_form_id != null) {
				TbCodeModel codeNameModel = this.getSelectCodeName(conn, HanbaiConstants.M0033,
									receiveContentCreate.getReceiveContentModel().getContract_form(),kigyou_code);
				if (codeNameModel != null) {
					contract_form_value = codeNameModel.getCode_value();
				}

			}
			//文字列を指定された長さで件名１を切り離す
			List<String> listLeft = new ArrayList<>(),listRight = new ArrayList<>();
			List<String> receiveName1List = FieldFormatter.divideSring(receive_name1, LENGTH_LEFT);
			for (int j = 0; j < receiveName1List.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.ESTIMATE_NAME + NULL_STR2 + receiveName1List.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + receiveName1List.get(j);
				}
				receiveName1List.set(j, tempStr);
			}
			//リストに件名１を添加する
			listLeft.addAll(receiveName1List);
			//文字列を指定された長さで件名２を切り離す
			if (!("").equals(receive_name2)) {
				List<String> receiveName2List = FieldFormatter.divideSring(receive_name2, LENGTH_LEFT);
				for (int j = 0; j < receiveName2List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + receiveName2List.get(j);
					receiveName2List.set(j, tempStr);
				}
				//リストに件名２を添加する
				listLeft.addAll(receiveName2List);
			}
			//文字列を指定された長さで件名３を切り離す
			if (!("").equals(receive_name3)) {
				List<String> receiveName3List = FieldFormatter.divideSring(receive_name3, LENGTH_LEFT);
				for (int j = 0; j < receiveName3List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + receiveName3List.get(j);
					receiveName3List.set(j, tempStr);
				}
				//リストに件名３を添加する
				listLeft.addAll(receiveName3List);
			}
			//文字列を指定された長さで支払条件を切り離す
			List<String> paymentConditionList = FieldFormatter.divideSring(paymentCondition, LENGTH_LEFT);
			for (int j = 0; j < paymentConditionList.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.PAYMENT_CONDITION + NULL_STR2 + paymentConditionList.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + paymentConditionList.get(j);
				}
				paymentConditionList.set(j, tempStr);
			}
			if (paymentConditionList.size() == 0) {
				paymentConditionList.add(Const.PAYMENT_CONDITION);
			}

			//リストに支払条件を添加する
			listLeft.addAll(paymentConditionList);
			//リストに作業期間を添加する
			listLeft.add(workDate);
			//契約形態行追加
			listLeft.add(Const.CONTRACT_FORM + NULL_STR2 + contract_form_value);

			//add 20070130
			listRight.add("");
			listRight.add(companyName);
			listRight.add(zip_code);

			//文字列を指定された長さで住所を切り離す
			List<String> addressList = FieldFormatter.divideSring(address, 32L);
			for(int j=0; j<addressList.size();j++){
				String tempStr = NULL_STR8 + addressList.get(j);
				addressList.set(j, tempStr);
			}
			//リストに住所を添加する
			listRight.addAll(addressList);
			//リストにTELを添加する
			listRight.add(tel);
			//リストにFAXを添加する
			listRight.add(fax);
			//リストに担当者を添加する
			listRight.add(receive_in_name);

			//表を添加する
			int index = 0;
			for (String element2 : listRight) {
		 		document.add(reportCommonTable("","","",element2,11));
			}
			document.add(reportCommonTable("","","","",9));

			PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumLeftColumns);
			reportCommonGroundTable.setWidths(commonGroundLeftWidths);

			reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
			reportCommonGroundTable.getDefaultCell().setPadding(1);
			reportCommonGroundTable.getDefaultCell().setBorderWidth(2);

			for (int j = listRight.size();j<listRight.size()+listLeft.size();j++ ){
				if (index < listLeft.size()) {
					PdfPCell title = new PdfPCell(getParagraph(listLeft.get(index),11));
					title.setBorder(notShow);
					reportCommonGroundTable.addCell(title);
					index++;
				}
			}

			document.add(reportCommonNameTable(reportCommonGroundTable,jianYingTable()));

			//表を添加する
			document.add(this.emptyTable());
			document.add(reportCommonTable("","","","",9));

			if (!DIS.equals(reportCommonGroundModel.getJyutyuReportReckonModel(receiveContentCreate).getSummationFour())) {
				document.add(summationJyutyuTable(reportCommonGroundModel.getJyutyuReportReckonModel(receiveContentCreate).getSummationFour()));
			}

			document.add(inputDateTable(Const.JYUTYUSAI));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			int linesum = 17 ;

			linesum = linesum + listLeft.size() + listRight.size();
			if (!DIS.equals(reportCommonGroundModel.getJyutyuReportReckonModel(receiveContentCreate).getSummationFour())) {
				linesum = linesum + 1 ;
			}
			if(tampList!=null && tampList.size()>0){
				linesum = linesum + tampList.size() ;
			}

			if (tampList != null && tampList.size() > 0) {

				String summation_two =reportCommonGroundModel.getJyutyuReportReckonModel(receiveContentCreate).getSummationTwo();
				String summation_three = reportCommonGroundModel.getJyutyuReportReckonModel(receiveContentCreate).getSummationThree();
				String summation_one = reportCommonGroundModel.getJyutyuReportReckonModel(receiveContentCreate).getSummationOne();
				int amountLength = 0;
				if(!DIS.equals(summation_two)) amountLength++;
				if(!DIS.equals(summation_three)) amountLength++;
				if(!DIS.equals(summation_one)) amountLength++;

				int maxLine = 0;

				maxLine = this.FIRST_PAGE_FIXATION_LENGTH - listLeft.size() - listRight.size() - 2;

				List<ReportCirculationDateModel> pList = new ArrayList<>();
				ReportCirculationDateModel model = null;
				for (Object element2 : tampList) {
					model = (ReportCirculationDateModel)element2;
					String content = model.getTask_content();

					if (StringUtils.isEmpty(content)) {
						pList.add(model);
					} else {
						//作業内容を”\r\n”又は”\n”で分割する。
						content = content.replaceAll("\r\n", "\n");
						String contentkArray[] = content.split("\n");

						//分割した備考配列をループする。
						for ( int k = 0; k < contentkArray.length; k++ ) {

							List<String> contentList = FieldFormatter.divideSring(contentkArray[ k ], 40L);

							for (int q = 0; q < contentList.size(); q++) {
								if (k == 0 && q == 0) {
									model.setTask_content(contentList.get(q));
									pList.add(model);
								} else {
									ReportCirculationDateModel modelInternal = new ReportCirculationDateModel();
									modelInternal.setTask_content(contentList.get(q));
									modelInternal.setAmount("NULL");
									pList.add(modelInternal);
								}
							}
						}

					}
				}

				tampList = pList;
				document.add(dataHeadTable());
				ReportCirculationDateModel reportCirculationDateModel = null;
				ReportCirculationDateModel nextModel = new ReportCirculationDateModel();
				int number = 1;

				for(int k = 0;k < tampList.size();k++) {
					reportCirculationDateModel = (ReportCirculationDateModel) tampList.get(k);

					if( k+1 < tampList.size()){
						nextModel = (ReportCirculationDateModel) tampList.get(k+1);
					}

					if (k != 0 && !"NULL".equals(reportCirculationDateModel.getAmount())) {
						number++;
					}
					String numberValue = "";
					if ("NULL".equals(reportCirculationDateModel.getAmount())) {
						reportCirculationDateModel.setAmount("");
						numberValue = "";
					} else {
						numberValue = String.valueOf(number);
					}

					String price = "";
					String amount = "";
					String unit = "";
					String quantity = "";
					String taskContent = "";
					taskContent = reportCirculationDateModel.getTask_content();
					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
						price = reportCirculationDateModel.getPrice_per();
					}
					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
						quantity = reportCirculationDateModel.getQuantity();
					}
					if(reportCirculationDateModel.getCode_value() != null){
						unit = reportCirculationDateModel.getCode_value();
					}
					if(reportCirculationDateModel.getAmount() != null) {
						amount = reportCirculationDateModel.getAmount();
					}
					boolean isDisplay = false;
					maxLine--;
					if (maxLine == 0 || k == (tampList.size() - 1)) {
						isDisplay = true;
					}

					if (numberValue.equals("")){
						document.add(this.circulationTable_new(numberValue,taskContent,price,quantity,unit,amount,isDisplay));

					}else{
						//次明細は同じです
						if ("NULL".equals(nextModel.getAmount())){
							document.add(this.circulationTable_next(numberValue,taskContent,price,quantity,unit,amount,isDisplay));
						//次明細は違いです
						}else{
							document.add(this.circulationTable(numberValue,taskContent,price,quantity,unit,amount,isDisplay));
						}
					}

					if (maxLine == 0) {
					 	document.newPage();
					 	if (k == (tampList.size() - 1)) {
					 		//表を添加する
							if(!DIS.equals(summation_two)) {
								document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
								linesum = linesum + 1 ;
							}
							//表を添加する
							if (!DIS.equals(summation_three)){
								//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
								document.add(this.inputTable(Const.SUMMATION_TWO + "（" + receiveContentCreate.getReceiveContentModel().getTax_rate() + "%）",summation_three,true));	//sxt 20220831 add
								linesum = linesum + 1 ;
							}
							//表を添加する
							if (!DIS.equals(summation_one)){
								document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
								linesum = linesum + 1 ;
							}
					 	} else {
					 		maxLine = this.NEXT_PAGE_FIXATION_LENGTH;

					 		if ("NULL".equals(nextModel.getAmount())){
					 			boolean flg = true;
					 			document.add(dataHeadTable(flg));
					 		}else{
					 			document.add(dataHeadTable());
					 		}

					 	}
					} else if (k == (tampList.size() - 1)) {
					 	if (maxLine < amountLength) {
					 		document.newPage();
					 	}
					 	document.add(this.inputTable("","",false));
					 	//表を添加する
						if(!DIS.equals(summation_two)) {
							document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
							linesum = linesum + 2 ;
						}
						//表を添加する
						if (!DIS.equals(summation_three)){
							//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
							document.add(this.inputTable(Const.SUMMATION_TWO + "（" + receiveContentCreate.getReceiveContentModel().getTax_rate() + "%）",summation_three,true));	//sxt 20220831 add
							linesum = linesum + 1 ;
						}
						//表を添加する
						if (!DIS.equals(summation_one)){
							document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
							linesum = linesum + 1 ;
						}
					}

				}

				document.add(this.emptyTable());
				document.add(this.emptyTable());
			}

			//備考
			String remark = receiveContentCreate.getReceiveContentModel().getRemark();

			//備考が空白以外の場合
			if ( !StringUtils.isEmpty( remark ) ) {

				//空白行を追加する。
				document.add(reportCommonTable("","","","",9));
				document.add(reportCommonTable("","","","",9));

				//備考を”\r\n”又は”\n”で分割する。
				String remarkTemp = receiveContentCreate.getReceiveContentModel().getRemark().replaceAll("\r\n", "\n");
				String remarkArray[] = remarkTemp.split("\n");

				//分割した備考配列をループする。
				for ( int k = 0; k < remarkArray.length; k++ ) {

					if ( k > 0 ) {
						document.add(this.emptyTable());
						linesum = linesum + 1;
					}

					//List<String> remarkList = FieldFormatter.divideSring(remarkArray[ k ], 105);		//sxt 20220901 del
					List<String> remarkList = FieldFormatter.divideSring(remarkArray[ k ], 118);		//sxt 20220901 add

					for (String element2 : remarkList) {
						document.add(this.inputDateTable( element2 ) );
						linesum = linesum + 1;
					}

				}
			}
			int addline = (linesum + 11) % 54 ;
			if(addline == 0){

			}else{
				if(addline < 11){
					int emptyline = 48 + (11 - addline);
					for(int k = 0; k < emptyline; k++){
						document.add(reportCommonTable("","","","",9));
					}
				}if(addline >= 11){
					int otheremptyline = 54 - addline;
					for(int k = 0; k < otheremptyline; k++){
						document.add(reportCommonTable("","","","",9));
					}
				}
			}

			//document.add(reportCommonLeftTable(Const.MITUMORI_SUMMARY,9));
			//document.add(this.emptyTable());
			//document.add(this.emptyTable());
			//String dateblank = NULL_STR6 + "年" + NULL_STR2 + "月" + NULL_STR2 + "日";

			//document.add(reportCommonTable("","","",dateblank,9));

			//document.add(this.emptyTable());
			//document.add(this.emptyTable());
			//document.add(this.emptyTable());

			//document.add(this.inputNewTable(Const.NAME,"                  印"));

		}
		document.add(reportCommonTable("","","","",9));
		//document.add(reportCommonLeftTable(Const.MOTUMORI,9));
		//documentの閉鎖する
		document.close();
	}

    /**
     * PDF OutputStreamt を設定します<BR>
     * <BR>
     * @param buffer ByteArrayOutputStream
     */
	public void documenHattyuOutputStreamtCreate(Document document,PdfWriter writer,Connection conn) throws DocumentException, SQLException, IOException{

		this.init();		//sxt 20230323 add
		
		List list = new ArrayList();
		try {
			list = getHattyuReportCommonGroundModelList(conn,kigyou_code);
		} catch (Exception e1) {

		}
		ReportCommonGroundModel reportCommonGroundModel = null;
		for (Object element : list) {

			reportCommonGroundModel = (ReportCommonGroundModel)element;

			List tampList = reportCommonGroundModel.getCirculationDateList();

			CustomerNameCreateManager customerNameCreate = reportCommonGroundModel.getCustomerNameCreate();

			HattyuContentCreateManager hattyuContentCreate = reportCommonGroundModel.getHattyuContentCreate();

			ContactMeansCreateManager contactMeansCreate = reportCommonGroundModel.getContactMeansCreate();

			ReportFormsImageCreateManager reportFormsImageCreate = new ReportFormsImageCreateManager();
			String imageName = null;
			try {
				imageName = reportFormsImageCreate.getImageName();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(image == null){
				image = reportFormsImageCreate.getImage(imageName);
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			//表を添加する
			String sales_no = Const.RECEIVED_NO;
			String request_date = Const.RECEIVED_DATE + "       " + Const.PRINT_DATE;

			reportCommonZipTable(writer,"","","",zipTable(),9);
			document.add(captionRequestfanriTable_insi(null, fanhaorifuTable(sales_no,request_date)));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			document.add(captionRequestFourTable());

			//CompanyName
			String companyName = "会社名";
			//zip_code
			String zip_code = "〒" ;

			document.add(reportCommonTable("","","","",9));
			//表を添加する
			countname = 3;
			if(customerNameCreate.getCustomer_name() == null){
				customerNameCreate.setCustomer_name("");
			}

			//TEL
			String tel = Const.TEL ;
			//FAX
			String fax = Const.FAX ;
//			//担当者
//			String sales_in_name = Const.PERSON_IN_CHARGE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getOrder_in_name();
//			//住所
			String address = "住　所";
			//customerNameCreate.getCustomer_name

			document.add(this.emptyTable());
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			document.add(companyInfoTable(contactMeansCreate.getCompanyName(),"殿",countname));
			countname = 0;

			String customer_name = customerNameCreate.getCustomer_name();
			//住所
			address = customerNameCreate.getAddress1();

			//件名１
			String order_name1 = hattyuContentCreate.getHattyuContentModel().getOrder_name1();
			//件名２
			String order_name2 = hattyuContentCreate.getHattyuContentModel().getOrder_name2();
			//件名３
//			String order_name3 = hattyuContentCreate.getHattyuContentModel().getOrder_name3();
			//支払条件
			String paymentCondition = hattyuContentCreate.getHattyuContentModel().getPayment_condition();
			//請求区分
			String order_div =  Const.ORDER_DIV + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getOrder_div();
			//作業期間
			String workDate ;
			if(StringUtils.isEmpty(hattyuContentCreate.getHattyuContentModel().getWork_start_date())&&StringUtils.isEmpty(hattyuContentCreate.getHattyuContentModel().getWork_end_date())){
				workDate = Const.WORK_DATE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getWork_start_date()  + hattyuContentCreate.getHattyuContentModel().getWork_end_date();
			}else{
				workDate = Const.WORK_DATE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getWork_start_date() + "～" + hattyuContentCreate.getHattyuContentModel().getWork_end_date();
			}
			//契約形態コード
			String contract_form_id = hattyuContentCreate.getHattyuContentModel().getContract_form();
			//契約形態の値
			String contract_form_value = "";
			if (contract_form_id != null) {
				TbCodeModel codeNameModel = this.getSelectCodeName(conn, HanbaiConstants.M0033,
						hattyuContentCreate.getHattyuContentModel().getContract_form(),kigyou_code);
				if (codeNameModel != null) {
					contract_form_value = codeNameModel.getCode_value();
				}
			}
			//御社見積番号
			//String out_estimate_no = Const.OUT_ESTIMATE_NO + NULL_STR4 + hattyuContentCreate.getHattyuContentModel().getOut_estimate_no();
			//御社発注番号
			String order_no = Const.ORDER_NO + NULL_STR4 + hattyuContentCreate.getHattyuContentModel().getOrder_no();

			//文字列を指定された長さで件名１を切り離す
			List<String> listLeft = new ArrayList<>(),listRight = new ArrayList<>();
			List<String> orderName1List = FieldFormatter.divideSring(order_name1, LENGTH_LEFT);
			for (int j = 0; j < orderName1List.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.ESTIMATE_NAME + NULL_STR2 + orderName1List.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + orderName1List.get(j);
				}
				orderName1List.set(j, tempStr);
			}
			//リストに件名１を添加する
			listLeft.addAll(orderName1List);
			//文字列を指定された長さで件名２を切り離す
			if (order_name2!=null && !("").equals(order_name2)) {
				List<String> orderName2List = FieldFormatter.divideSring(order_name2, LENGTH_LEFT);
				for (int j = 0; j < orderName2List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + orderName2List.get(j);
					orderName2List.set(j, tempStr);
				}
				//リストに件名２を添加する
				listLeft.addAll(orderName2List);
			}
			//文字列を指定された長さで支払条件を切り離す
			List<String> paymentConditionList = FieldFormatter.divideSring(paymentCondition, LENGTH_LEFT);
			for (int j = 0; j < paymentConditionList.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.PAYMENT_CONDITION + NULL_STR2 + paymentConditionList.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + paymentConditionList.get(j);
				}
				paymentConditionList.set(j, tempStr);
			}
			if (paymentConditionList.size() == 0) {
				paymentConditionList.add(Const.PAYMENT_CONDITION);
			}
			//リストに支払条件を添加する
			//listLeft.addAll(paymentConditionList);	//sxt 20220617 del

			//請求区分を添加する
			//listLeft.add(order_div);
			//契約形態
			listLeft.add(Const.CONTRACT_FORM + NULL_STR2 + contract_form_value);
			//リストに作業期間を添加する
			listLeft.add(workDate);
			//御社見積番号を添加する
//			listLeft.add(out_estimate_no);
			//御社発注番号を添加する
			listLeft.add(order_no);
//			listRight.add(customer_name);

			List<String> addressList = FieldFormatter.divideSring(address, 44L);
			listRight.addAll(addressList);
			List<String> customernameList = FieldFormatter.divideSring(customer_name, 44L);
			listRight.addAll(customernameList);
			for (int j = 1; j <= 4 - (addressList.size() + customernameList.size()); j++) {
				listRight.add(" ");
			}

			//listRight.add(" ");
			//listRight.add(" ");
			listRight.add(" 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　         印");
			reportCommonInfo(writer,"","","",zipTable(),9);

			//表を添加する
			int index = 0;
			for (String element2 : listRight) {
		 		document.add(reportCommonTable("","","",element2,11));
			}
			for (int j = listRight.size();j<listRight.size()+listLeft.size();j++ ){
				if (index < listLeft.size()) {
//				document.add(reportCommonLeftTable(listLeft.get(index),"","","",9));
					document.add(reportCommonLeftTable(listLeft.get(index),11));
					index++;
				}
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			if (!DIS.equals(reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationFour())) {
				document.add(summationHattyuTable(reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationFour(),false));
			}

			document.add(inputDateTable(Const.RECEIVEDSAI));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			//document.add(dataHeadTable());
			if (tampList != null && tampList.size() > 0) {

				String summation_two =reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationTwo();
				String summation_three = reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationThree();
				String summation_one = reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationOne();
				int amountLength = 0;
				if(!DIS.equals(summation_two)) amountLength++;
				if(!DIS.equals(summation_three)) amountLength++;
				if(!DIS.equals(summation_one)) amountLength++;

				int maxLine = 0;
				maxLine = this.FIRST_PAGE_HATTYU_LENGTH - listLeft.size() - listRight.size();

				//---------------
				//  明細部
				//---------------
				List<ReportCirculationDateModel> pList = new ArrayList<>();
				ReportCirculationDateModel model = null;
				for (Object element2 : tampList) {
					model = (ReportCirculationDateModel)element2;
					String content = model.getTask_content();
					if (StringUtils.isEmpty(content)) {
						pList.add(model);
					} else {
						List<String> contentList = FieldFormatter.divideSring(content, 200L);
						for (int q = 0; q < contentList.size(); q++) {
							if (q == 0) {
								model.setTask_content(contentList.get(q));
								pList.add(model);
							} else {
								ReportCirculationDateModel modelInternal = new ReportCirculationDateModel();
								modelInternal.setTask_content(contentList.get(q));
								modelInternal.setAmount("NULL");
								pList.add(modelInternal);
							}
						}
					}
				}
				tampList = pList;
				//明細部のタイトル
				document.add(dataHeadTable());
				ReportCirculationDateModel reportCirculationDateModel = null;
				ReportCirculationDateModel nextModel = new ReportCirculationDateModel();
				int number = 1;

				for(int k = 0;k < tampList.size();k++) {
					reportCirculationDateModel = (ReportCirculationDateModel) tampList.get(k);

					if (k != 0 && !"NULL".equals(reportCirculationDateModel.getAmount())) {
						number++;
					}
					String numberValue = "";
					if ("NULL".equals(reportCirculationDateModel.getAmount())) {
						reportCirculationDateModel.setAmount("");
						numberValue = "";
					} else {
						numberValue = String.valueOf(number);
					}

//					String price = "";
//					String amount = "";
//					String unit = "";
//					String quantity = "";
//					String taskContent = "";
//					taskContent = reportCirculationDateModel.getTask_content();
//					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
//						price = reportCirculationDateModel.getPrice_per();
//					}
//					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
//						quantity = reportCirculationDateModel.getQuantity();
//					}
//					if(reportCirculationDateModel.getCode_value() != null){
//						unit = reportCirculationDateModel.getCode_value();
//					}
//					if(reportCirculationDateModel.getAmount() != null) {
//						amount = reportCirculationDateModel.getAmount();
//					}
//					boolean isDisplay = false;
//					maxLine--;
//					if (maxLine == 0 || k == (tampList.size() - 1)) {
//						isDisplay = true;
//					}
//					document.add(this.circulationTable(numberValue,taskContent,price,quantity,unit,amount,isDisplay));

					String taskContent = "";	//技術者名
					String time_kbn = "";		//人月時間区分
					String price = "";			//単価
					String more_price = "";		//超過単価
					String less_price = "";		//減額単価
					String other_price = "";	//そのた（交通費など）
					String quantity = "";		//工数
					String amount = "";			//金額
					String biko = "";			//備考
					String unit = "";

					//技術者名
					taskContent = reportCirculationDateModel.getTask_content();
					//人月時間区分
					time_kbn = reportCirculationDateModel.getTime_kbn_name();
					//単価
					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
						price = reportCirculationDateModel.getPrice_per();
					}

					//超過単価
					if(reportCirculationDateModel.getMore_price() != null && !reportCirculationDateModel.getMore_price().equals("")){
						more_price = reportCirculationDateModel.getMore_price();
					}
					//減額単価
					if(reportCirculationDateModel.getLess_price() != null && !reportCirculationDateModel.getLess_price().equals("")){
						less_price = reportCirculationDateModel.getLess_price();
					}
					//そのた（交通費など）
					if(reportCirculationDateModel.getOther_price() != null && !reportCirculationDateModel.getOther_price().equals("")){
						other_price  = reportCirculationDateModel.getOther_price();
					}
					//工数
					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
						quantity = reportCirculationDateModel.getQuantity();
					}
					//金額
					if(reportCirculationDateModel.getAmount() != null) {
						amount = reportCirculationDateModel.getAmount();
					}
					//備考
					biko = reportCirculationDateModel.getBiko();

					if(reportCirculationDateModel.getCode_value() != null){
						unit = reportCirculationDateModel.getCode_value();
					}
					boolean isDisplay = false;
					maxLine--;
					if (maxLine == 0 || k == (tampList.size() - 1)) {
						isDisplay = true;
					}

					if (numberValue.equals("")){
						document.add(this.circulationTable_new(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
					}else{
						//次明細は同じです
						if ("NULL".equals(nextModel.getAmount())){
							document.add(this.circulationTable_next(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
						//次明細は違いです
						}else{
							document.add(this.circulationTable(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
						}
					}

					if (maxLine == 0) {
					 	document.newPage();
					 	if (k == (tampList.size() - 1)) {
					 		document.add(this.inputTable("","",false));
					 		//表を添加する
							if(!DIS.equals(summation_two)) {
								document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
							}
							//表を添加する
							if (!DIS.equals(summation_three)){
								//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));	//sxt 20220831 del
								document.add(this.inputTable(Const.SUMMATION_TWO + "（" + hattyuContentCreate.getHattyuContentModel().getConsume_tax_rate() + "%）",summation_three,true));
							}
							//表を添加する
							if (!DIS.equals(summation_one)){
								document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
							}
					 	} else {
					 		maxLine = this.NEXT_PAGE_FIXATION_LENGTH;
					 		document.add(dataHeadTable());
					 	}
					} else if (k == (tampList.size() - 1)) {
					 	if (maxLine < amountLength) {
					 		document.newPage();
					 	}
					 	document.add(this.inputTable("","",false));
					 	//表を添加する
						if(!DIS.equals(summation_two)) {
							document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
						}
						//表を添加する
						if (!DIS.equals(summation_three)){
							//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));	//sxt 20220831 del
							document.add(this.inputTable(Const.SUMMATION_TWO + "（" + hattyuContentCreate.getHattyuContentModel().getConsume_tax_rate() + "%）",summation_three,true));
						}
						//表を添加する
						if (!DIS.equals(summation_one)){
							document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
						}
					}
				}

				document.add(this.emptyTable());
				document.add(this.emptyTable());
			}

			//sxt 20220915 add start
			String payment_method = hattyuContentCreate.getHattyuContentModel().getPayment_method();
			//sxt 20220915 add end
			//------------------------------
			// 月間作業基準時間外の精算方法
			//------------------------------
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			if (payment_method.equals("1")) {	//sxt 20220915 add
				document.add(this.calculateTitleTable());
			}	//sxt 20220915 add
			document.add(this.calculateTable(hattyuContentCreate));

			//備考
//			String remark = hattyuContentCreate.getHattyuContentModel().getRemark();
//
//			//備考が空白以外の場合
//			if ( !StringUtils.isEmpty( remark ) ) {
//
//				//空白行を追加する。
//				document.add(this.emptyTable());
//				document.add(this.emptyTable());
//
//				//備考を”\r\n”又は”\n”で分割する。
//				String remarkTemp = hattyuContentCreate.getHattyuContentModel().getRemark().replaceAll("\r\n", "\n");
//				String remarkArray[] = remarkTemp.split("\n");
//
//				//分割した備考配列をループする。
//				for ( int k = 0; k < remarkArray.length; k++ ) {
//
//					if ( k > 0 ) {
//						document.add(this.emptyTable());
//					}
//
//					List<String> remarkList = FieldFormatter.divideSring(remarkArray[ k ], 105);
//
//					for ( int m = 0; m < remarkList.size(); m++ ) {
//						document.add(this.inputDateTable( remarkList.get( m ) ) );
//					}
//
//				}
//			}
//
//			document.add(reportCommonTable("","","","",9));
//			document.add(reportCommonTable("","","","",9));
//			document.add(reportCommonTable("","","","",9));
//			document.add(reportCommonTable("","","","",9));

			//備考
			String remark = hattyuContentCreate.getHattyuContentModel().getRemark();

			//備考が空白以外の場合
			if ( !StringUtils.isEmpty( remark ) ) {
				//空白行を追加する。
				document.add(reportCommonTable("","","","",9));
				document.add(reportCommonTable("","","","",9));

				document.add(this.remarkTable(remark));
			}

		}

	}
	   /**
     * PDF OutputStreamt を設定します<BR>
     * <BR>
     * @param buffer ByteArrayOutputStream
     */
	public void documenHattyuOutputStreamtCreatetwo(ByteArrayOutputStream buffer,Connection conn) throws DocumentException, SQLException, IOException{
		this.init();		//sxt 20230323 add
		
		Document document = new Document(PageSize.A4,30, 30, 30, 30);
		//pdfwriterを取得します
		PdfWriter writer = PdfWriter.getInstance( document, buffer );
		//Documentの開ける
		document.open();

		List list = new ArrayList();
		try {
			list = getHattyuReportCommonGroundModelList(conn,kigyou_code);
		} catch (Exception e1) {

		}
		ReportCommonGroundModel reportCommonGroundModel = null;
		for (Object element : list) {

			reportCommonGroundModel = (ReportCommonGroundModel)element;

			List tampList = reportCommonGroundModel.getCirculationDateList();

			CustomerNameCreateManager customerNameCreate = reportCommonGroundModel.getCustomerNameCreate();

			HattyuContentCreateManager hattyuContentCreate = reportCommonGroundModel.getHattyuContentCreate();

			ContactMeansCreateManager contactMeansCreate = reportCommonGroundModel.getContactMeansCreate();

			ReportFormsImageCreateManager reportFormsImageCreate = new ReportFormsImageCreateManager();
			String imageName = null;
			try {
				imageName = reportFormsImageCreate.getImageName();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(image == null){
				image = reportFormsImageCreate.getImage(imageName);
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			//表を添加する
			String sales_no = Const.HATTYUORDER_NO + "  " + hattyuContentCreate.getHattyuContentModel().getOrder_no();

			String request_date = "";
			if(StringUtils.isEmpty(hattyuContentCreate.getHattyuContentModel().getOrder_date())){
				request_date = null;
			}else{
				request_date = Const.ORDER_DATE + "  " + hattyuContentCreate.getHattyuContentModel().getOrder_date();
			}

			document.add(captionRequestfanriTable(image,fanhaorifuTable(sales_no,request_date)));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			document.add(captionRequestFiveTable());

			//CompanyName
			//String companyName = contactMeansCreate.getCompanyName();
			String companyName = NULL_STR8 + contactMeansCreate.getCompanyName();
			//zip_code
			//String zip_code = "〒" + contactMeansCreate.getZip_code();
			String zip_code =  NULL_STR8 + "〒" + contactMeansCreate.getZip_code();

			document.add(reportCommonTable("","","","",9));
			//表を添加する
			countname = 3;
			if(customerNameCreate.getCustomer_name() == null){
				customerNameCreate.setCustomer_name("");
			}
			if(StringUtils.isEmpty(customerNameCreate.getCall_name())){
//				document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name()," ",countname),rightTable(companyName,zip_code,address)));
				//document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name(),"御中",countname),rightTable("","")));
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),"御中",countname));

			}else{
//				document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname),rightTable(companyName,zip_code,address)));
				//document.add(reportCommonNameTable(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname),rightTable("","")));
				document.add(companyInfoTable(customerNameCreate.getCustomer_name(),customerNameCreate.getCall_name(),countname));
			}
			countname = 0;
			//del 20070130
			//document.add(reportCommonNameTable(rightTable("",""),rightTable(companyName,zip_code)));

			//TEL
			//String tel = Const.TEL + NULL_STR + contactMeansCreate.getCompanyTel();
			String tel = NULL_STR8 + Const.TEL + NULL_STR + contactMeansCreate.getCompanyTel();
			//FAX
			//String fax = Const.FAX + NULL_STR + contactMeansCreate.getCompanyFax();
			String fax = NULL_STR8 + Const.FAX + NULL_STR + contactMeansCreate.getCompanyFax();
			//担当者
			//String sales_in_name = Const.PERSON_IN_CHARGE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getOrder_in_name();
			String sales_in_name = NULL_STR8 + Const.PERSON_IN_CHARGE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getOrder_in_name();
			//住所
			String address = contactMeansCreate.getAddress();
			//件名１
			String order_name1 = hattyuContentCreate.getHattyuContentModel().getOrder_name1();
			//件名２
			String order_name2 = hattyuContentCreate.getHattyuContentModel().getOrder_name2();
			//件名３
//			String order_name3 = hattyuContentCreate.getHattyuContentModel().getOrder_name3();
			//支払条件
			String paymentCondition = hattyuContentCreate.getHattyuContentModel().getPayment_condition();
			//請求区分
			String order_div =  Const.ORDER_DIV + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getOrder_div();
			//作業期間
			String workDate ;
			if(StringUtils.isEmpty(hattyuContentCreate.getHattyuContentModel().getWork_start_date())&&StringUtils.isEmpty(hattyuContentCreate.getHattyuContentModel().getWork_end_date())){
				workDate = Const.WORK_DATE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getWork_start_date()  + hattyuContentCreate.getHattyuContentModel().getWork_end_date();
			}else{
				workDate = Const.WORK_DATE + NULL_STR2 + hattyuContentCreate.getHattyuContentModel().getWork_start_date() + "～" + hattyuContentCreate.getHattyuContentModel().getWork_end_date();
			}
			//契約形態コード
			String contract_form_id = hattyuContentCreate.getHattyuContentModel().getContract_form();
			//契約形態の値
			String contract_form_value = "";
			if (contract_form_id != null) {
				TbCodeModel codeNameModel = this.getSelectCodeName(conn, HanbaiConstants.M0033,
						hattyuContentCreate.getHattyuContentModel().getContract_form(),kigyou_code);
				if (codeNameModel != null) {
					contract_form_value = codeNameModel.getCode_value();
				}

			}
			//御社見積番号
			String out_estimate_no = Const.OUT_ESTIMATE_NO + NULL_STR4 + hattyuContentCreate.getHattyuContentModel().getOut_estimate_no();


			//文字列を指定された長さで件名１を切り離す
			List<String> listLeft = new ArrayList<>(),listRight = new ArrayList<>();
			List<String> orderName1List = FieldFormatter.divideSring(order_name1, LENGTH_LEFT);
			for (int j = 0; j < orderName1List.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.ESTIMATE_NAME + NULL_STR2 + orderName1List.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + orderName1List.get(j);
				}
				orderName1List.set(j, tempStr);
			}
			//リストに件名１を添加する
			listLeft.addAll(orderName1List);
			//文字列を指定された長さで件名２を切り離す
			if (order_name2!=null && !("").equals(order_name2)) {
				List<String> orderName2List = FieldFormatter.divideSring(order_name2, LENGTH_LEFT);
				for (int j = 0; j < orderName2List.size(); j++) {
					String tempStr = NULL_STR3 + NULL_STR2 + orderName2List.get(j);
					orderName2List.set(j, tempStr);
				}
				//リストに件名２を添加する
				listLeft.addAll(orderName2List);
			}
			//文字列を指定された長さで支払条件を切り離す
			List<String> paymentConditionList = FieldFormatter.divideSring(paymentCondition, LENGTH_LEFT);
			for (int j = 0; j < paymentConditionList.size(); j++) {
				String tempStr = "";
				if (j == 0) {
					tempStr = Const.PAYMENT_CONDITION + NULL_STR2 + paymentConditionList.get(j);
				} else {
					tempStr = NULL_STR3 + NULL_STR2 + paymentConditionList.get(j);
				}
				paymentConditionList.set(j, tempStr);
			}
			if (paymentConditionList.size() == 0) {
				paymentConditionList.add(Const.PAYMENT_CONDITION);
			}
			//リストに支払条件を添加する
			//listLeft.addAll(paymentConditionList);	//sxt 20220617 del

			//請求区分を添加する
			//listLeft.add(order_div);
			//契約形態
			listLeft.add(Const.CONTRACT_FORM + NULL_STR2 + contract_form_value);
			//リストに作業期間を添加する
			listLeft.add(workDate);
			//御社見積番号を添加する
			listLeft.add(out_estimate_no);
//			add 20070130

			//文字列を指定された長さで住所を切り離す
			//List<String> addressList = FieldFormatter.divideSring(address, LENGTH_RIGHT);
			List<String> addressList = FieldFormatter.divideSring(address, 32);
			for(int j=0; j<addressList.size();j++){
				String tempStr = NULL_STR8 + addressList.get(j);
				addressList.set(j, tempStr);
			}


			//リストにTELを添加する
			listRight.add(tel);
			//リストにFAXを添加する
			listRight.add(fax);
			//リストに担当者を添加する
			listRight.add(sales_in_name);

			//印鑑イメージを追加
			PdfPTable imageTable = addInkanImage();
			if (imageTable != null) {
				document.add(imageTable);
			}

			//表を添加する
			int index = 0;
			for (String element2 : listRight) {
		 		document.add(reportCommonTable("","","",element2,11));
			}
			for (int j = listRight.size();j<listRight.size()+listLeft.size();j++ ){
				if (index < listLeft.size()) {
//				document.add(reportCommonLeftTable(listLeft.get(index),"","","",9));
					document.add(reportCommonLeftTable(listLeft.get(index),11));
					index++;
				}
			}

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());

			if (!DIS.equals(reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationFour())) {
				document.add(summationHattyuTable(reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationFour(),true));
			}

			document.add(inputDateTable(Const.ORDERSAI));

			//表を添加する
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			//document.add(dataHeadTable());
			if (tampList != null && tampList.size() > 0) {

				String summation_two =reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationTwo();
				String summation_three = reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationThree();
				String summation_one = reportCommonGroundModel.getHattyuReportReckonModel(hattyuContentCreate).getSummationOne();
				int amountLength = 0;
				if(!DIS.equals(summation_two)) amountLength++;
				if(!DIS.equals(summation_three)) amountLength++;
				if(!DIS.equals(summation_one)) amountLength++;

				int maxLine = 0;
				maxLine = this.FIRST_PAGE_HATTYU_LENGTH - listLeft.size() - listRight.size();

				//---------------
				//  明細部
				//---------------
				List<ReportCirculationDateModel> pList = new ArrayList<>();
				ReportCirculationDateModel model = null;
				for (Object element2 : tampList) {
					model = (ReportCirculationDateModel)element2;
					String content = model.getTask_content();
					if (StringUtils.isEmpty(content)) {
						pList.add(model);
					} else {
						List<String> contentList = FieldFormatter.divideSring(content, 200L);
						for (int q = 0; q < contentList.size(); q++) {
							if (q == 0) {
								model.setTask_content(contentList.get(q));
								pList.add(model);
							} else {
								ReportCirculationDateModel modelInternal = new ReportCirculationDateModel();
								modelInternal.setTask_content(contentList.get(q));
								modelInternal.setAmount("NULL");
								pList.add(modelInternal);
							}
						}
					}
				}
				tampList = pList;

				//明細部のタイトル
				document.add(dataHeadTable());
				ReportCirculationDateModel reportCirculationDateModel = null;
				ReportCirculationDateModel nextModel = new ReportCirculationDateModel();

				int number = 1;

				for(int k = 0;k < tampList.size();k++) {
					reportCirculationDateModel = (ReportCirculationDateModel) tampList.get(k);

					if (k != 0 && !"NULL".equals(reportCirculationDateModel.getAmount())) {
						number++;
					}
					String numberValue = "";
					if ("NULL".equals(reportCirculationDateModel.getAmount())) {
						reportCirculationDateModel.setAmount("");
						numberValue = "";
					} else {
						numberValue = String.valueOf(number);
					}

//					String price = "";
//					String amount = "";
//					String unit = "";
//					String quantity = "";
//					String taskContent = "";
//					taskContent = reportCirculationDateModel.getTask_content();
//					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
//						price = reportCirculationDateModel.getPrice_per();
//					}
//					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
//						quantity = reportCirculationDateModel.getQuantity();
//					}
//					if(reportCirculationDateModel.getCode_value() != null){
//						unit = reportCirculationDateModel.getCode_value();
//					}
//					if(reportCirculationDateModel.getAmount() != null) {
//						amount = reportCirculationDateModel.getAmount();
//					}
//					boolean isDisplay = false;
//					maxLine--;
//					if (maxLine == 0 || k == (tampList.size() - 1)) {
//						isDisplay = true;
//					}
//					document.add(this.circulationTable(numberValue,taskContent,price,quantity,unit,amount,isDisplay));

					String taskContent = "";	//技術者名
					String time_kbn = "";		//人月時間区分
					String price = "";			//単価
					String more_price = "";		//超過単価
					String less_price = "";		//減額単価
					String other_price = "";	//そのた（交通費など）
					String quantity = "";		//工数
					String amount = "";			//金額
					String biko = "";			//備考
					String unit = "";

					//技術者名
					taskContent = reportCirculationDateModel.getTask_content();
					//人月時間区分
					time_kbn = reportCirculationDateModel.getTime_kbn_name();
					//単価
					if(reportCirculationDateModel.getPrice_per() != null && !reportCirculationDateModel.getPrice_per().equals("")){
						price = reportCirculationDateModel.getPrice_per();
					}

					//超過単価
					if(reportCirculationDateModel.getMore_price() != null && !reportCirculationDateModel.getMore_price().equals("")){
						more_price = reportCirculationDateModel.getMore_price();
					}
					//減額単価
					if(reportCirculationDateModel.getLess_price() != null && !reportCirculationDateModel.getLess_price().equals("")){
						less_price = reportCirculationDateModel.getLess_price();
					}
					//そのた（交通費など）
					if(reportCirculationDateModel.getOther_price() != null && !reportCirculationDateModel.getOther_price().equals("")){
						other_price  = reportCirculationDateModel.getOther_price();
					}
					//工数
					if(reportCirculationDateModel.getQuantity() != null && !reportCirculationDateModel.getQuantity().equals("") ){
						quantity = reportCirculationDateModel.getQuantity();
					}
					//金額
					if(reportCirculationDateModel.getAmount() != null) {
						amount = reportCirculationDateModel.getAmount();
					}
					//備考
					biko = reportCirculationDateModel.getBiko();

					if(reportCirculationDateModel.getCode_value() != null){
						unit = reportCirculationDateModel.getCode_value();
					}
					boolean isDisplay = false;
					maxLine--;
					if (maxLine == 0 || k == (tampList.size() - 1)) {
						isDisplay = true;
					}

					if (numberValue.equals("")){
						document.add(this.circulationTable_new(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
					}else{
						//次明細は同じです
						if ("NULL".equals(nextModel.getAmount())){
							document.add(this.circulationTable_next(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
						//次明細は違いです
						}else{
							document.add(this.circulationTable(numberValue,taskContent,time_kbn,price,more_price,less_price,other_price,quantity,amount,biko,isDisplay));
						}
					}

					if (maxLine == 0) {
					 	document.newPage();
					 	if (k == (tampList.size() - 1)) {
					 		document.add(this.inputTable("","",false));
					 		//表を添加する
							if(!DIS.equals(summation_two)) {
								document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
							}
							//表を添加する
							if (!DIS.equals(summation_three)){
								//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
								document.add(this.inputTable(Const.SUMMATION_TWO + "（" + hattyuContentCreate.getHattyuContentModel().getConsume_tax_rate() + "%）",summation_three,true));		//sxt 20220831 add
							}
							//表を添加する
							if (!DIS.equals(summation_one)){
								document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
							}
					 	} else {
					 		maxLine = this.NEXT_PAGE_FIXATION_LENGTH;
					 		document.add(dataHeadTable());
					 	}
					} else if (k == (tampList.size() - 1)) {
					 	if (maxLine < amountLength) {
					 		document.newPage();
					 	}
					 	document.add(this.inputTable("","",false));
					 	//表を添加する
						if(!DIS.equals(summation_two)) {
							document.add(this.inputTable(Const.SUMMATION_ONE,summation_two,true));
						}
						//表を添加する
						if (!DIS.equals(summation_three)){
							//document.add(this.inputTable(Const.SUMMATION_TWO,summation_three,true));		//sxt 20220831 del
							document.add(this.inputTable(Const.SUMMATION_TWO + "（" + hattyuContentCreate.getHattyuContentModel().getConsume_tax_rate() + "%）",summation_three,true));		//sxt 20220831 add
						}
						//表を添加する
						if (!DIS.equals(summation_one)){
							document.add(this.inputTable(Const.SUMMATION_THREE,summation_one,true));
						}
					}
				}

				document.add(this.emptyTable());
				document.add(this.emptyTable());
			}

			//sxt 20220915 add start
			String payment_method = hattyuContentCreate.getHattyuContentModel().getPayment_method();
			//sxt 20220915 add end

			//------------------------------
			// 月間作業基準時間外の精算方法
			//------------------------------
			document.add(this.emptyTable());
			document.add(this.emptyTable());
			if (payment_method.equals("1")) {	//sxt 20220915 add
				document.add(this.calculateTitleTable());
			} //sxt 20220915 add
			document.add(this.calculateTable(hattyuContentCreate));

//			//備考
//			String remark = hattyuContentCreate.getHattyuContentModel().getRemark();
//
//			//備考が空白以外の場合
//			if ( !StringUtils.isEmpty( remark ) ) {
//
//				//空白行を追加する。
//				document.add(this.emptyTable());
//				document.add(this.emptyTable());
//
//				//備考を”\r\n”又は”\n”で分割する。
//				String remarkTemp = hattyuContentCreate.getHattyuContentModel().getRemark().replaceAll("\r\n", "\n");
//				String remarkArray[] = remarkTemp.split("\n");
//
//				//分割した備考配列をループする。
//				for ( int k = 0; k < remarkArray.length; k++ ) {
//
//					if ( k > 0 ) {
//						document.add(this.emptyTable());
//					}
//
//					List<String> remarkList = FieldFormatter.divideSring(remarkArray[ k ], 105);
//
//					for ( int m = 0; m < remarkList.size(); m++ ) {
//						document.add(this.inputDateTable( remarkList.get( m ) ) );
//					}
//
//				}
//			}

			//備考
			String remark = hattyuContentCreate.getHattyuContentModel().getRemark();

			//備考が空白以外の場合
			if ( !StringUtils.isEmpty( remark ) ) {
				//空白行を追加する。
				document.add(reportCommonTable("","","","",9));
				document.add(reportCommonTable("","","","",9));

				document.add(this.remarkTable(remark));
			}

//			document.add(reportCommonTable("","","","",9));
//			document.add(reportCommonTable("","","","",9));
//			document.add(reportCommonTable("","","","",9));
			document.add(reportCommonTable("","","","",9));
			document.add(reportCommonTwoTable("","","",jianYingTable(),9));
		}

		document.newPage();
		documenHattyuOutputStreamtCreate(document,writer,conn);

		document.close();

	}

	/**
     * ReportCommonGroundBeanListを取得します<BR>
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getHattyuReportCommonGroundModelList(Connection conn,String kigyou_code) throws Exception{

		List reportCommonGroundModelList = new ArrayList();
		ReportCommonGroundModel reportCommonGroundModel = null;
		CustomerNameCreateManager customerNameCreate = null;
		HattyuContentCreateManager hattyuContentCreate = null;

		ContactMeansCreateManager contactMeansCreate = new ContactMeansCreateManager();

		contactMeansCreate.excute(conn,this.kigyou_code);

		for(int i = 0;i<this.order_no_print.size();i++){

			reportCommonGroundModel = new ReportCommonGroundModel();

			customerNameCreate = new CustomerNameCreateManager();

			hattyuContentCreate = new HattyuContentCreateManager();

			String order_code = (String) order_no_print.get(i);

			reportCommonGroundModel.setCirculationDateList(
					getMTKHattyuReportCirculationDateBeanList( order_code,conn,kigyou_code) );

			reportCommonGroundModel.setOrderCode(order_code);

			customerNameCreate.executeHattyu(order_code ,conn,kigyou_code);

			hattyuContentCreate.execute(order_code,conn,kigyou_code);

			reportCommonGroundModel.setCustomerNameCreate(customerNameCreate);

			reportCommonGroundModel.setHattyuContentCreate(hattyuContentCreate);

			reportCommonGroundModel.setContactMeansCreate(contactMeansCreate);

			reportCommonGroundModelList.add(reportCommonGroundModel);
		}
		return  reportCommonGroundModelList;
	}


    /**
     * MTKReportCirculationDateMapListを取得します<BR>
     * @param estimateCode 発注番号
     * @exception DBアクセス処理失敗
     *  @return List
     */
	private List getMTKHattyuReportCirculationDateMapList(String orderCode,Connection conn) throws Exception{
		HannbaiResource resource = new HannbaiResource();
 	    String sql = resource.getSql( HanbaiConstants.REPORT_SQL_006);
 	    ResultSetHandler resultSetHandler = new BeanListHandler(ReportCirculationDateModel.class);
 	    Object rs = qr.query( conn, sql, new String[] {orderCode,this.kigyou_code},resultSetHandler );
 	    List ret = (ArrayList)rs;
 	    if (ret == null) {
 		   ret = new ArrayList();
 	    }
	    return ret;
	}

    /**
     * ReportCommonGroundBeanListを取得します<BR>
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getReportCommonGroundModelList(Connection conn) throws Exception{

		List reportCommonGroundModelList = new ArrayList();
		ReportCommonGroundModel reportCommonGroundModel = null;
		CustomerNameCreateManager customerNameCreate = null;
		EstimateContentCreateManager estimateContentCreate = null;

		ContactMeansCreateManager contactMeansCreate = new ContactMeansCreateManager();

		contactMeansCreate.excute(conn,this.kigyou_code);

		for(int i = 0;i<this.estimateCode.size();i++){

			reportCommonGroundModel = new ReportCommonGroundModel();

			customerNameCreate = new CustomerNameCreateManager();

			estimateContentCreate = new EstimateContentCreateManager();

			String estimate_code = (String) estimateCode.get(i);

			reportCommonGroundModel.setCirculationDateList(
					getMTKReportCirculationDateBeanList( estimate_code,conn) );

			reportCommonGroundModel.setCustomerCode(estimate_code);

			customerNameCreate.execute(estimate_code ,conn,this.kigyou_code);

			estimateContentCreate.execute(estimate_code,conn,this.kigyou_code);

			reportCommonGroundModel.setCustomerNameCreate(customerNameCreate);

			reportCommonGroundModel.setEstimateContentCreate(estimateContentCreate);

			reportCommonGroundModel.setContactMeansCreate(contactMeansCreate);

			reportCommonGroundModelList.add(reportCommonGroundModel);
		}

		return  reportCommonGroundModelList;
	}

	/**
     * ReportCommonGroundBeanListを取得します<BR>
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getJyutyuReportCommonGroundModelList(Connection conn) throws Exception{

		List reportCommonGroundModelList = new ArrayList();
		ReportCommonGroundModel reportCommonGroundModel = null;
		CustomerNameCreateManager customerNameCreate = null;
		ReceiveContentCreateManager receiveContentCreate = null;

		ContactMeansCreateManager contactMeansCreate = new ContactMeansCreateManager();

		contactMeansCreate.excute(conn,this.kigyou_code);

		for(int i = 0;i<this.receive_no.size();i++){

			reportCommonGroundModel = new ReportCommonGroundModel();

			customerNameCreate = new CustomerNameCreateManager();

			receiveContentCreate = new ReceiveContentCreateManager();

			String receive_code = (String) receive_no.get(i);

			reportCommonGroundModel.setCirculationDateList(
					getMTKJyutyuReportCirculationDateBeanList( receive_code,conn) );

			reportCommonGroundModel.setCustomerCode(receive_code);

			customerNameCreate.executeJyutyu(receive_code ,conn,this.kigyou_code);

			receiveContentCreate.execute(receive_code,conn,this.kigyou_code);

			reportCommonGroundModel.setCustomerNameCreate(customerNameCreate);

			reportCommonGroundModel.setReceiveContentCreate(receiveContentCreate);

			reportCommonGroundModel.setContactMeansCreate(contactMeansCreate);

			reportCommonGroundModelList.add(reportCommonGroundModel);
		}
		return  reportCommonGroundModelList;
	}

    /**
     * MTKReportCirculationDateMapListを取得します<BR>
     * @param estimateCode 見積番号
     * @exception DBアクセス処理失敗
     *  @return List
     */
	private List getMTKReportCirculationDateMapList(String estimateCode,Connection conn) throws Exception{
		HannbaiResource resource = new HannbaiResource();
 	    String sql = resource.getSql( HanbaiConstants.REPORT_SQL_003);
 	    ResultSetHandler resultSetHandler = new BeanListHandler(ReportCirculationDateModel.class);
 	    Object rs = qr.query( conn, sql, new String[] {estimateCode,this.kigyou_code},resultSetHandler );
 	    List ret = (ArrayList)rs;
 	    if (ret == null) {
 		   ret = new ArrayList();
 	    }
	    return ret;
	}

	/**
     * MTKJyutyuReportCirculationDateMapListを取得します<BR>
     * @param receiveCode 受注番号
     * @exception DBアクセス処理失敗
     *  @return List
     */
	private List getMTKJyutyuReportCirculationDateMapList(String receiveCode,Connection conn) throws Exception{
		HannbaiResource resource = new HannbaiResource();
 	    String sql = resource.getSql( HanbaiConstants.REPORT_SQL_008);
 	    ResultSetHandler resultSetHandler = new BeanListHandler(ReportCirculationDateModel.class);
 	    Object rs = qr.query( conn, sql, new String[] {receiveCode,this.kigyou_code},resultSetHandler );
 	    List ret = (ArrayList)rs;
 	    if (ret == null) {
 		   ret = new ArrayList();
 	    }
	    return ret;
	}

	/**
     * getMTKReportCirculationRequestDateMapListを取得します<BR>
     * @param salesCode 売上番号
     * @exception DBアクセス処理失敗
     *  @return List
     */
	private List getMTKReportCirculationRequestDateMapList(String salesCode,Connection conn) throws Exception{
		HannbaiResource resource = new HannbaiResource();
 	    String sql = resource.getSql( HanbaiConstants.REPORT_SQL_005);
 	    ResultSetHandler resultSetHandler = new BeanListHandler(ReportCirculationDateModel.class);
 	    Object rs = qr.query( conn, sql, new String[] {salesCode,this.kigyou_code},resultSetHandler );
 	    List ret = (ArrayList)rs;
 	    if (ret == null) {
 		   ret = new ArrayList();
 	    }
	    return ret;
	}


    /**
     * MTKHattyuReportCirculationDateBeanListを取得します<BR>
     * @param estimateCode 見積番号
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getMTKReportCirculationDateBeanList(String estimateCode,Connection conn) throws Exception{

		List retList = this.getMTKReportCirculationDateMapList(estimateCode,conn);
		ReportCirculationDateModel reportCirculationDateModel = null;
		List reportList = new ArrayList();
		for (int i = 0; i < retList.size();i++){

			reportCirculationDateModel = new ReportCirculationDateModel();
			ReportCirculationDateModel ret = (ReportCirculationDateModel)retList.get(i);

			//reportCirculationDateModel.setTask_content(ret.getTask_content());	//sxt 20220822 del
			//sxt 20220822 add start
			if (ret.getPrint_name()==null || ret.getPrint_name().equals("")) {
				reportCirculationDateModel.setTask_content(ret.getTask_content());
			} else {
				reportCirculationDateModel.setTask_content(ret.getPrint_name());
			}
			//sxt 20220822 add end

			if (ret.getTime_kbn_name() == null) {
				reportCirculationDateModel.setTime_kbn_name("");
			} else {
				reportCirculationDateModel.setTime_kbn_name(ret.getTime_kbn_name());
			}

			if (ret.getPrice_per() == null) {
				reportCirculationDateModel.setPrice_per("");
			} else {
				reportCirculationDateModel.setPrice_per(FieldFormatter.formatDigitFourToken(ret.getPrice_per()));
			}

			if (ret.getMore_price() == null) {
				reportCirculationDateModel.setMore_price("");
			} else {
				reportCirculationDateModel.setMore_price(FieldFormatter.formatDigitFourToken(ret.getMore_price()));
			}

			if (ret.getLess_price() == null) {
				reportCirculationDateModel.setLess_price("");
			} else {
				reportCirculationDateModel.setLess_price(FieldFormatter.formatDigitFourToken(ret.getLess_price()));
			}

			if (ret.getOther_price() == null) {
				reportCirculationDateModel.setOther_price("");
			} else {
				reportCirculationDateModel.setOther_price(FieldFormatter.formatDigitFourToken(ret.getOther_price()));
			}

			if (ret.getQuantity() == null) {
				reportCirculationDateModel.setQuantity("");
			} else {
				reportCirculationDateModel.setQuantity(FieldFormatter.formatDigitFourToken(ret.getQuantity()));
			}

			if (ret.getAmount() == null) {
				reportCirculationDateModel.setAmount("");
			} else {
				reportCirculationDateModel.setAmount(FieldFormatter.formatDigitFourToken(ret.getAmount()));
			}

			if (ret.getCode_value() == null) {
				reportCirculationDateModel.setCode_value("");
			} else {
				reportCirculationDateModel.setCode_value(ret.getCode_value());
			}

			reportCirculationDateModel.setBiko(ret.getBiko());

			reportList.add(reportCirculationDateModel);
		}

		List tempList = new ArrayList();
		ReportCirculationDateModel reportCirculationBean = null;
		for(int i= 0;i< reportList.size();i++){
			reportCirculationBean = (ReportCirculationDateModel)reportList.get(i);
			tempList.add(reportCirculationBean);
		}
		//_logger.info("44-4444");
		return tempList;
	}

	/**
     * MTKJyutyuReportCirculationDateBeanListを取得します<BR>
     * @param receiveCode 受注番号
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getMTKJyutyuReportCirculationDateBeanList(String receiveCode,Connection conn) throws Exception{

		List retList = this.getMTKJyutyuReportCirculationDateMapList(receiveCode,conn);
		ReportCirculationDateModel reportCirculationDateModel = null;
		List reportList = new ArrayList();
		for (int i = 0; i < retList.size();i++){

			reportCirculationDateModel = new ReportCirculationDateModel();
			ReportCirculationDateModel ret = (ReportCirculationDateModel)retList.get(i);
			reportCirculationDateModel.setTask_content(ret.getTask_content());

			if (ret.getPrice_per() == null) {
				reportCirculationDateModel.setPrice_per("");
			} else {
				reportCirculationDateModel.setPrice_per(FieldFormatter.formatDigitFourToken(ret.getPrice_per()));
			}

			if (ret.getQuantity() == null) {
				reportCirculationDateModel.setQuantity("");
			} else {
				reportCirculationDateModel.setQuantity(FieldFormatter.formatDigitFourToken(ret.getQuantity()));
			}

			if (ret.getCode_value() == null) {
				reportCirculationDateModel.setCode_value("");
			} else {
				reportCirculationDateModel.setCode_value(ret.getCode_value());
			}


			if (ret.getAmount() == null) {
				reportCirculationDateModel.setAmount("");
			} else {
				reportCirculationDateModel.setAmount(FieldFormatter.formatDigitFourToken(ret.getAmount()));
			}
			reportList.add(reportCirculationDateModel);
		}

		List tempList = new ArrayList();
		ReportCirculationDateModel reportCirculationBean = null;
		for(int i= 0;i< reportList.size();i++){
			reportCirculationBean = (ReportCirculationDateModel)reportList.get(i);
			tempList.add(reportCirculationBean);
		}
		return tempList;
	}

    /**
     * MTKHattyuReportCirculationDateBeanListを取得します<BR>
     * @param estimateCode 発注番号
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getMTKHattyuReportCirculationDateBeanList(String orderCode,Connection conn,String kigyou_code) throws Exception{

		List retList = this.getMTKHattyuReportCirculationDateMapList(orderCode,conn);
		ReportCirculationDateModel reportCirculationDateModel = null;
		List reportList = new ArrayList();
		for (int i = 0; i < retList.size();i++){

			reportCirculationDateModel = new ReportCirculationDateModel();
			ReportCirculationDateModel ret = (ReportCirculationDateModel)retList.get(i);
			reportCirculationDateModel.setTask_content(ret.getTask_content());

			if (ret.getPrice_per() == null) {
				reportCirculationDateModel.setPrice_per("");
			} else {
				reportCirculationDateModel.setPrice_per(FieldFormatter.formatDigitFourToken(ret.getPrice_per()));
			}

			if (ret.getQuantity() == null) {
				reportCirculationDateModel.setQuantity("");
			} else {
				reportCirculationDateModel.setQuantity(FieldFormatter.formatDigitFourToken(ret.getQuantity()));
			}

			if (ret.getUnit_name() == null) {
				reportCirculationDateModel.setCode_value("");
			} else {
				TbCodeModel codeNameModel = this.getSelectCodeName(conn, HanbaiConstants.M0018, ret.getUnit_name(),kigyou_code);
				if(codeNameModel!=null){
					reportCirculationDateModel.setCode_value(codeNameModel.getCode_value());
				}else{
					reportCirculationDateModel.setCode_value("");
				}
			}


			if (ret.getAmount() == null) {
				reportCirculationDateModel.setAmount("");
			} else {
				reportCirculationDateModel.setAmount(FieldFormatter.formatDigitFourToken(ret.getAmount()));
			}

			//sxt 20220616 add start
			//人月時間区分
			if (ret.getTime_kbn_name() == null) {
				reportCirculationDateModel.setTime_kbn_name("");
			} else {
				reportCirculationDateModel.setTime_kbn_name(ret.getTime_kbn_name());
			}

			//超過単価
			if (ret.getMore_price() == null) {
				reportCirculationDateModel.setMore_price("");
			} else {
				reportCirculationDateModel.setMore_price(FieldFormatter.formatDigitFourToken(ret.getMore_price()));
			}

			//減額単価
			if (ret.getLess_price() == null) {
				reportCirculationDateModel.setLess_price("");
			} else {
				reportCirculationDateModel.setLess_price(FieldFormatter.formatDigitFourToken(ret.getLess_price()));
			}

			//そのた（交通費など）
			if (ret.getOther_price() == null) {
				reportCirculationDateModel.setOther_price("");
			} else {
				reportCirculationDateModel.setOther_price(FieldFormatter.formatDigitFourToken(ret.getOther_price()));
			}

			//備考
			if (ret.getBiko() == null) {
				reportCirculationDateModel.setBiko("");
			} else {
				reportCirculationDateModel.setBiko(ret.getBiko());
			}
			//sxt 20220616 add end
			reportList.add(reportCirculationDateModel);
		}

		List tempList = new ArrayList();
		ReportCirculationDateModel reportCirculationBean = null;
		for(int i= 0;i< reportList.size();i++){
			reportCirculationBean = (ReportCirculationDateModel)reportList.get(i);
			tempList.add(reportCirculationBean);
		}
		return tempList;
	}

	public List getReceive_no() {
		return receive_no;
	}

	public void setReceive_no(List receive_no) {
		this.receive_no = receive_no;
	}

	public List getOrder_no_print() {
		return order_no_print;
	}

	public void setOrder_no_print(List order_no_print) {
		this.order_no_print = order_no_print;
	}
	/**
     * MTKReportCirculationRequestDateBeanListを取得します?<BR>
     * @param salesCode 売上番号
     * @exception DBアクセス処理失敗
     *  @return List list
     */
	@SuppressWarnings("unchecked")
	private List getMTKReportCirculationRequestDateBeanList(String salesCode,Connection conn) throws Exception{

		List retList = this.getMTKReportCirculationRequestDateMapList(salesCode,conn);
		ReportCirculationDateModel reportCirculationDateModel = null;
		List reportList = new ArrayList();
		for (int i = 0; i < retList.size();i++){

			reportCirculationDateModel = new ReportCirculationDateModel();
			ReportCirculationDateModel ret = (ReportCirculationDateModel)retList.get(i);
			reportCirculationDateModel.setTask_content(ret.getTask_content());

			if (ret.getPrice_per() == null) {
				reportCirculationDateModel.setPrice_per("");
			} else {
				reportCirculationDateModel.setPrice_per(FieldFormatter.formatDigitFourToken(ret.getPrice_per()));
			}

			if (ret.getQuantity() == null) {
				reportCirculationDateModel.setQuantity("");
			} else {
				reportCirculationDateModel.setQuantity(FieldFormatter.formatDigitFourToken(ret.getQuantity()));
			}

			if (ret.getCode_value() == null) {
				reportCirculationDateModel.setCode_value("");
			} else {
				reportCirculationDateModel.setCode_value(ret.getCode_value());
			}


			if (ret.getAmount() == null) {
				reportCirculationDateModel.setAmount("");
			} else {
				reportCirculationDateModel.setAmount(FieldFormatter.formatDigitFourToken(ret.getAmount()));
			}
			reportList.add(reportCirculationDateModel);
		}

		List tempList = new ArrayList();
		ReportCirculationDateModel reportCirculationBean = null;
		for(int i= 0;i< reportList.size();i++){
			reportCirculationBean = (ReportCirculationDateModel)reportList.get(i);
			tempList.add(reportCirculationBean);
		}
		return tempList;
	}

	/**
	 * <p>
	 * 売上番号存在性チェック。
	 * </p>
	 *
	 * @param  sales_no String
	 * @throws Exception
	 * @return isAviable boolean
	 */
	private String selMonthCloseFlg(Connection conn,String sales_no) throws Exception {
		String sql = "select * from tb_mrk_sales where sales_no='" + sales_no + "' and kigyou_code=?";
    	ResultSetHandler resultSetHandler = new BeanHandler(TbMrkSalesModel.class);
    	Object rs = qr.query( conn, sql,this.kigyou_code, resultSetHandler );
    	TbMrkSalesModel model = (TbMrkSalesModel)rs;
    	return model.getMonth_close_flg();
	}
	/**
     * PdfPTableREQUESTを設定する<BR>
     * <BR>
     * @param dateValue
     * @exception SQLException
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable captionRequestThreeTableForAgain() throws SQLException,DocumentException, IOException{

		//PdfPTableの作成
		PdfPTable captionTable = new PdfPTable(3);
		//PdfPTableにPdfPTableを設定する
		this.setPdfPTableAttribute(captionTable);
		PdfPCell imageCell = null;

		imageCell = new PdfPCell();

		imageCell.setBorderWidth(notShow);

		imageCell.setFixedHeight(28);

		PdfPCell title = new PdfPCell(getParagraph(Const.CAPTION_REQUEST_AGAIN,16));
		title.setHorizontalAlignment(Element.ALIGN_CENTER);
		title.setBorderWidth(notShow);

		PdfPCell date = new PdfPCell();
		date.setBorderWidth(notShow);
		date.setHorizontalAlignment(Element.ALIGN_RIGHT);

		captionTable.addCell(imageCell);
		captionTable.addCell(title);
		captionTable.addCell(date);

		return captionTable;

	}
	/**
	 * <p>
	 * コードマスタから「コードID,コードNAME」取得。
	 * </p>
	 * @param conn Connection
	 * @param codeDivId String コード区分
	 * @param codeId    String コード
	 * @throws Exception
	 * @return String
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	public TbCodeModel getSelectCodeName( Connection conn, String codeDivId, String codeId,String kigyou_code) throws SQLException {
		String sql = "select code_id,code_value from tb_code where code_div_id='" + codeDivId + "' and code_id='" + codeId + "' and kigyou_code=? order by code_id";
		ResultSetHandler resultSetHandler = new BeanHandler(TbCodeModel.class);
		Object rs = qr.query( conn, sql,kigyou_code, resultSetHandler );
		TbCodeModel ret = (TbCodeModel)rs;
		return ret;
	}
//ADD by liuyujia 2007/04/26
	/**
     * PdfPTableを設定する<BR>
     * <BR>
     * @exception DocumentException
     * @exception IOException
     */
	private PdfPTable zipTable() throws DocumentException, IOException{
		//PdfPTableの作成
		PdfPTable dataHeadTable = new PdfPTable(commonGroundNumLeftColumns);
		dataHeadTable.setWidths(zipwidths);
		//PdfPCellの作成
		PdfPCell noCell = new PdfPCell(getParagraph("",11));

		this.setPdfPTableAttribute(dataHeadTable);

		noCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		noCell.setHorizontalAlignment(Element.ALIGN_CENTER);
		noCell.setFixedHeight(48);
//		noCell.setBorder(15);
		//行を添加する
		dataHeadTable.addCell(noCell);

		return dataHeadTable;
	}
	//ADD

//ADD by liuyujia 2007/04/26-------------
	private void reportCommonZipTable(PdfWriter writer,String titleString,String titleValueString,String titleDateString,PdfPTable titleDateValueTable,int size) throws DocumentException, IOException{

			PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumColumns);
			reportCommonGroundTable.setWidths(commonGroundZipWidths);

			/*reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
			reportCommonGroundTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

			PdfPTable titleDateValue = titleDateValueTable;

			PdfPCell title = new PdfPCell(getParagraph(titleString,9)));

			PdfPCell titleValue = new PdfPCell(getParagraph(titleValueString,size)));

			PdfPCell titleDate = new PdfPCell(getParagraph(titleDateString,9)));

			title.setBorder(notShow);

			titleValue.setBorder(notShow);

			titleDate.setBorder(notShow);

			titleDateValue.getDefaultCell().setBorder(Rectangle.NO_BORDER);

			titleDate.setFixedHeight((float)14);
			reportCommonGroundTable.addCell(titleDateValue);

			reportCommonGroundTable.addCell(title);
			reportCommonGroundTable.addCell(titleValue);
			reportCommonGroundTable.addCell(titleDate);*/

			TextField tf = new TextField(writer, new Rectangle(90, 765, 90 + 55, 765 + 55), "seal");
            tf.setBorderWidth(1);
            tf.setBorderColor(Color.BLACK);
            tf.setBorderStyle(PdfBorderDictionary.STYLE_DASHED);
            PdfFormField field = tf.getTextField();
            writer.addAnnotation(field);

			//return reportCommonGroundTable;
		}
//	add---------------------------------------------

//	ADD by liuyujia 2007/05/10-------------
	private void reportCommonInfo(PdfWriter writer,String titleString,String titleValueString,String titleDateString,PdfPTable titleDateValueTable,int size) throws DocumentException, IOException{

			PdfPTable reportCommonGroundTable = new PdfPTable(commonGroundNumColumns);
			reportCommonGroundTable.setWidths(commonGroundZipWidths);

			/*reportCommonGroundTable.setWidthPercentage(WIDTH_PERCENTAGE);
			reportCommonGroundTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

			PdfPTable titleDateValue = titleDateValueTable;

			PdfPCell title = new PdfPCell(getParagraph(titleString,9)));

			PdfPCell titleValue = new PdfPCell(getParagraph(titleValueString,size)));

			PdfPCell titleDate = new PdfPCell(getParagraph(titleDateString,9)));

			title.setBorder(notShow);

			titleValue.setBorder(notShow);

			titleDate.setBorder(notShow);

			titleDateValue.getDefaultCell().setBorder(Rectangle.NO_BORDER);

			titleDate.setFixedHeight((float)14);
			reportCommonGroundTable.addCell(titleDateValue);

			reportCommonGroundTable.addCell(title);
			reportCommonGroundTable.addCell(titleValue);
			reportCommonGroundTable.addCell(titleDate);*/

			//2013/04/29 fanglei del
			//TextField tf = new TextField(writer, new Rectangle(310, 570, 310 + 250, 570 + 80), "info");
			//2013/04/29 fanglei add
			TextField tf = new TextField(writer, new Rectangle(517, 574, 517 + 43, 574 + 43), "info");
            tf.setBorderWidth(1);
            tf.setBorderColor(Color.BLACK);
            tf.setBorderStyle(PdfBorderDictionary.STYLE_DASHED);
            PdfFormField field = tf.getTextField();
            writer.addAnnotation(field);

			//return reportCommonGroundTable;
		}
//	add---------------------------------------------

}