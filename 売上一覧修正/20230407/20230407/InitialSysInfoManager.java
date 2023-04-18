package cn.com.edic.hanbai.sysinfo;

import org.apache.log4j.Logger;

import com.opensymphony.webwork.config.Configuration;

import cn.com.edic.hanbai.common.model.TbMrkSysinfoModel;
import cn.com.edic.hanbai.common.util.FieldFormatter;
import cn.com.edic.hanbai.common.util.HanbaiConstants;

/**
 * <p>
 * 基本情報初期化管理クラス。
 * </p>
 * @author songruolei
 */
public class InitialSysInfoManager extends SysInfoManager {

	/* このマネージャクラスを呼び出すアクションクラス */
	public InitialSysInfoAction action = null;

	/* ログ出力ハンドルを取得 */
    public static Logger _logger = Logger.getLogger( InitialSysInfoManager.class.getName() );

    /**
	 * <p>
	 * コンストラクタ。<br>
	 * </p>
	 * @param _action InitialSysInfoAction
	 */
	public InitialSysInfoManager( InitialSysInfoAction _action ){
		super();
		this.action = _action;
	}

	/**
	 * <p>
	 * 全ての業務処理を行なうメソッド。
	 * </p>
	 * @return String　処理の結果として文字列を返す。
	 * @throws Exception
	 */
	@Override
	@SuppressWarnings("unchecked")
	public String process() throws Exception {

		//メッセージをクリアする。
		this.action.getForm().setMsg("");

		//基本情報テーブルから検索。
		TbMrkSysinfoModel ret = this.selectAll(conn,this.KIGYOUID);

		this.action.getForm().setKigyou_code(ret.getKigyou_code());
		this.action.getForm().setCompany_name(ret.getCompany_name());
		this.action.getForm().setCompany_english_name(ret.getCompany_english_name());
		this.action.getForm().setManager(ret.getManager());
		this.action.getForm().setPhone1(ret.getPhone1());
		this.action.getForm().setPhone2(ret.getPhone2());
		this.action.getForm().setPhone3(ret.getPhone3());
		this.action.getForm().setFax(ret.getFax());
		this.action.getForm().setZip_code(ret.getZip_code());
		this.action.getForm().setTax_rates(ret.getTax_rates());
		this.action.getForm().setMail_address(ret.getMail_address());
		int index = ret.getHome_page().indexOf("http://");
		if(index==-1){
			this.action.getForm().setHome_page(ret.getHome_page());
			this.action.getForm().setLinkflg("0");
		}else{
			this.action.getForm().setHome_page(ret.getHome_page());
			this.action.getForm().setLinkflg("1");
		}
		//this.action.getForm().setHome_page(ret.getHome_page());

		this.action.getForm().setAddress(ret.getAddress());
		this.action.getForm().setYear_period_start(FieldFormatter.formatDate(ret.getYear_period_start()));
		this.action.getForm().setYear_period_end(FieldFormatter.formatDate(ret.getYear_period_end()));
		this.action.getForm().setCompany_sign_info(Configuration.getString(HanbaiConstants.UPLOAD_LOGO_PATH) + "/"+this.KIGYOUID+"/" +ret.getCompany_sign());

		this.action.getForm().setCompany_image_code_input(Configuration.getString(HanbaiConstants.UPLOAD_LOGO_PATH) + "/"+this.KIGYOUID+"/"+ret.getCompany_image_code());
		this.action.getForm().setRequest_to_name_flg(ret.getRequest_to_name_flg());
		this.action.getForm().setOrder_to_name_flg(ret.getOrder_to_name_flg());
		this.action.getForm().setEstimate_to_name_flg(ret.getEstimate_to_name_flg());
//		this.action.getForm().setBank_no(ret.getBank_no().replaceAll("\n", "<BR>"));	//sxt 20221028 del
		this.action.getForm().setBank_no(ret.getBank_no());								//sxt 20221028 add
		this.action.getForm().setCompany_sign(ret.getCompany_sign());
		this.action.getForm().setCompany_image_code(ret.getCompany_image_code());
		this.action.getForm().setApproval(ret.getApproval());
		this.action.getForm().setApproval_org(ret.getApproval());
		this.action.getForm().setCompany_unique_code(ret.getCompany_unique_code());

		this.action.getForm().setInkan_file_name_input(Configuration.getString(HanbaiConstants.UPLOAD_LOGO_PATH) + "/"+this.KIGYOUID+"/"+ret.getInkan_file_name());	//20200602 add
		this.action.getForm().setInkan_file_name(ret.getInkan_file_name());	//20200602 add

		//sxt 20220727 add start
		this.action.getForm().setWork_time_from(ret.getWork_time_from());
		this.action.getForm().setWork_time_to(ret.getWork_time_to());
		//this.action.getForm().setRemark(ret.getRemark().replaceAll("\n", "<BR>"));	//sxt 20221028 del
		this.action.getForm().setRemark(ret.getRemark());								//sxt 20221028 add
		//sxt 20220727 add end

		//sxt 20220906 add start
		this.action.getForm().setLogin_number(ret.getLogin_number());
		//this.action.getForm().setRemark2(ret.getRemark2().replaceAll("\n", "<BR>"));	//sxt 20221028 del
		//this.action.getForm().setRemark3(ret.getRemark3().replaceAll("\n", "<BR>"));	//sxt 20221028 del
		this.action.getForm().setRemark2(ret.getRemark2());								//sxt 20221028 add
		this.action.getForm().setRemark3(ret.getRemark3());								//sxt 20221028 add
		//sxt 20220906 add end

        return SUCCESS;
	}
}