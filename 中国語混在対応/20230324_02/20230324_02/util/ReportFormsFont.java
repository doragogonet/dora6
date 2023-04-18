package cn.com.edic.hanbai.report.util;

import java.io.IOException;

import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.pdf.BaseFont;

public class ReportFormsFont {
	
	//sxt 20230323 del start

//	/**
//	 * 明朝体っぽい字体なら以下を取得する <br>
//	 * <br>
//	 * @return  BaseFont
//	 * @throws IOException
//	 * @throws DocumentException
//	 */
//	private BaseFont createHeiseiMinW3Font() throws DocumentException, IOException{
//
//		//明朝体っぽい字体なら以下を設定しまする
//		BaseFont bf = BaseFont.createFont("HeiseiMin-W3", "UniJIS-UCS2-HW-H",false);
//		return bf;
//	}
//
//	/**
//	 * ゴシックっぽい字体なら以下の設定にします<br>
//	 * <br>
//	 * @return BaseFont
//	 * @throws IOException
//	 * @throws DocumentException
//	 */
//	private BaseFont createHeiseiKakuGoW5Font() throws DocumentException, IOException{
//
//		//ゴシックっぽい字体なら以下の設定にします
//		BaseFont bf = BaseFont.createFont("HeiseiKakuGo-W5", "UniJIS-UCS2-H",false);
//		return bf;
//	}

//	/**
//	 * 明朝体っぽい字体なら以下を取得する<br>
//	 * <br>
//	 * param size 	int
//	 * @return Font
//	 * @throws IOException
//	 * @throws DocumentException
//	 */
//	public Font getHeiseiMinW3Font(int size) throws DocumentException, IOException {
//
//		Font font = new Font(createHeiseiMinW3Font(), size);
//		return font;
//	}

//	/**
//	 * ゴシックっぽい字体なら以下の設定にしますを取得する<br>
//	 * <br>
//	 * param size 	int
//	 * @return Font
//	 * @throws IOException
//	 * @throws DocumentException
//	 */
//	public Font getHeiseiKakuGoW5FontFont(int size) throws DocumentException, IOException{
//
//		Font font = new Font(createHeiseiKakuGoW5Font(), size);
//		return font;
//	}
	
	//sxt 20230323 del end

	/**
	 * ゴシックっぽい字体なら以下の設定にしますを取得する<br>
	 * <br>
	 * param wb 	HSSFWorkbook
	 * param size 	int
	 * @return HSSFFont
	 */
//	public static HSSFFont getHSSFFont(HSSFWorkbook wb,int size){
//		HSSFFont f = wb.createFont();
//	    f.setFontHeightInPoints((short) size);
//		return f;
//	}
}
