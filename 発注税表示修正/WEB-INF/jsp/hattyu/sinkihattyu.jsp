<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
	<head>
	<ww:include value="'/headContent.jsp'" />
	<title>発注（請負）新規画面</title>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
	function deleteSinkiHattyu(pForm){
		var len = document.HattyuForm.elements.length;
		var count=0;
		for (i=0; i<len; i++) {
			var strName=document.HattyuForm.elements[i].name;
			var lastStr = strName.substr(strName.length-5,strName.length);
			
			if (lastStr == "Check"){
				if (document.HattyuForm.elements[i].checked == true){	
				    count = 1;
				}
			}
		}			
		if (count == 0){
			alert("削除したい明細を選択してください。" );
		}else{
			if (confirm("削除してよろしいでしょうか？")==true){
				//sxt 20220614 del start
				//document.HattyuForm.action="deleteSinkiHattyu.action";
				//document.HattyuForm.submit();
				//sxt 20220614 del end
				return true;	//sxt 20220614 add
			}
		}
	}
	
	function optionDeleteRow(pForm){
		var len = document.HattyuForm.elements.length;
		var count = 0;
		for (i = 0; i < len; i++) {
			var strName = document.HattyuForm.elements[i].name;
			var lastStr = strName.charAt(strName.length - 4) + strName.charAt(strName.length - 3) + strName.charAt(strName.length - 2) + strName.charAt(strName.length - 1);
			if (lastStr == "box2"){
				if (document.HattyuForm.elements[i].checked==true){
				    count = 1;
					document.HattyuForm.elements[i].value = "1";
				}else{
					document.HattyuForm.elements[i].value= "0";
				}
			}
		}
		if (count == 0){
			alert("削除したい明細を選択してください。" );
		}else{
			if ( confirm("削除してよろしいでしょうか？") ){
				//sxt 20220614 del start
				//document.HattyuForm.action="hattyuOptionDeleteRow.action";
				//document.HattyuForm.submit();
				//sxt 20220614 del end
				return true;	//sxt 20220614 add
			}
		}
	}

	function doCheckEstimate(name) {
			var value = document.HattyuForm.elements[name].checked;
			if(value == true) {
				document.HattyuForm.elements['form.estimate_amount_flg_sinki'].value = "1";
			} else {
				document.HattyuForm.elements['form.estimate_amount_flg_sinki'].value = "0";
			}
		}
	function doCheckTax(name) {
			var value = document.HattyuForm.elements[name].checked;
			if(value == true) {
				document.HattyuForm.elements['form.tax_amount_flg_sinki'].value = "1";
			} else {
				document.HattyuForm.elements['form.tax_amount_flg_sinki'].value = "0";
			}
		}
	
	function doCheckAmount(name) {
			var value = document.HattyuForm.elements[name].checked;
			if(value == true) {
				document.HattyuForm.elements['form.amount_flg_sinki'].value = "1";
			} else {
				document.HattyuForm.elements['form.amount_flg_sinki'].value = "0";
			}
		}
	function priceCalAmount(pForm,index){
	
		var amount =0;
		var price =  document.HattyuForm.elements['form.stockDetailModelList['+index +'].price_per'].value;
		var quantity = document.HattyuForm.elements['form.stockDetailModelList['+index +'].quantity'].value;
		var fraction_processing = "";
		if(document.HattyuForm.elements['form.fraction_processing']!=null){
			fraction_processing = document.HattyuForm.elements['form.fraction_processing'].value;
		}
		
		if(price!="" && checkHan(price)==false){
			return ;
		}
		if(quantity!="" && checkMinHan(quantity)==false){
			return ;
		}
		if(price=="" && quantity==""){
			amount="";
		}else{		
			if(checkNumber(price)==true && checkKingaku(quantity)==true){

				amount = price * quantity;
				if(fraction_processing!=""){
					if(fraction_processing =="02"){
						amount = Math.round(amount);
					}else if(fraction_processing =="01"){
						amount = Math.floor(amount);
					}else if(fraction_processing =="03"){
						if(amount>Math.floor(amount)){
							amount = Math.floor(amount)+1 ;
						}
					}			
				}	
			}
		}
		document.HattyuForm.elements['form.stockDetailModelList['+index +'].amount'].value = amount;	
	}
	function checkNumber(varStr){
		var data;
		var ret;
		for ( var i = 0; i < varStr.length; i++ ) {
			data = varStr.substr( i, 1 );
			ret = data.match(/^\d+$/);
			if ( data != ret ) {
				return false;
			}
		}
	    return true;
	}

	function checkKingaku(varStr){
		
		var testStr = /(^-\d{0,4}\.\d\d?$)|(^-\d{0,4}$)|(^\d{0,4}\.\d\d?$)|(^\d{0,4}$)/;
		return  testStr.test(varStr); 
	}
	function checkMinHan(varStr){
				var testStr = /^-([0-9]+).\d\d?$|^([0-9]+).\d\d?$|-([0-9]+)$|([0-9]+)$/;
				return  testStr.test(varStr); 
			}	
	function checkHan(varStr){
				var testStr = /^([0-9]+)$/;
				return  testStr.test(varStr); 
			}
	
	//sxt 20220614 del start
// 	function calSeikyuyotei(pForm){
		
// 		var message = new Array();
		
// 		var seikyukubun = document.HattyuForm.elements['form.order_div_input_sinki'].value;
// 		if (seikyukubun != '01') {
// 			//message[message.length] = '請求区分は「単月」の場合のみ作成できます。';
// 			alert('請求区分は「単月」の場合のみ作成できます。');
// 			return;
// 		}
		
// 		var kaityusaki = document.HattyuForm.elements['form.out_order_code_sinki'].value;
// 		if (kaityusaki == '') {
// 			message[message.length] = '外注先が入力必須です。';
// 		}
		
// 		var work_start_date = document.HattyuForm.elements['form.work_start_date_year_sinki'].value + document.HattyuForm.elements['form.work_start_date_month_sinki'].value + document.HattyuForm.elements['form.work_start_date_day_sinki'].value
// 		var work_end_date = document.HattyuForm.elements['form.work_end_date_year_sinki'].value + document.HattyuForm.elements['form.work_end_date_month_sinki'].value + document.HattyuForm.elements['form.work_end_date_day_sinki'].value
		
// 		var Expression=/^((((1[0-9]|[2-9]\d)\d{2})(0?[13578]|1[02])(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})(0?[13456789]|1[012])(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})0?2(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))0?229))$/; 
// 		//var Expression=/^(?:(?!0000)[0-9]{4}(?:(?:0[1-9]|1[0-2])(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])(?:29|30)|(?:0[13578]|1[02])31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)0229)$/;
// 		var objExp = new RegExp(Expression);
		
// 		if(!objExp.test(work_start_date)){
// 			message[message.length] = '作業開始日を日付型で入力してください。';
// 		}
		
// 		if(!objExp.test(work_end_date)){
// 			message[message.length] = '作業終了日を日付型で入力してください。';
// 		}
		
// 		if(objExp.test(work_start_date) && objExp.test(work_end_date) && parseInt(work_start_date) > parseInt(work_end_date)){
// 			message[message.length] = '作業期間範囲不正です。';
// 		}
		
// 		//var optionList = document.HattyuForm.elements['form.optionList'];
// 		var size = <ww:property value="form.optionList.size()" />;
// 		for ( var index = 0; index < size; index++ ) {

// 			var orderYear =  document.HattyuForm.elements['form.optionList['+ index +'].orderYear'].value;
// 			var orderMonth =  document.HattyuForm.elements['form.optionList['+ index +'].orderMonth'].value;
// 			var orderDay =  document.HattyuForm.elements['form.optionList['+ index +'].orderDay'].value;
// 			var paymentYear =  document.HattyuForm.elements['form.optionList['+ index +'].paymentYear'].value;
// 			var paymentMonth =  document.HattyuForm.elements['form.optionList['+ index +'].paymentMonth'].value;
// 			var paymentDay =  document.HattyuForm.elements['form.optionList['+ index +'].paymentDay'].value;
//             var order_amount =  document.HattyuForm.elements['form.optionList['+ index +'].order_amount'].value;
			
// 			if (orderYear != '' || orderMonth != '' || orderDay != '' || paymentYear != '' || paymentMonth != '' || paymentDay != '' || order_amount != '') {
// 				message[message.length] = '請求予定日、支払予定日、請求予定金額を全部クリアしてから、もう一度作成してください。';
// 				break;
// 			}
		
// 		}
		
// 		if(message.length > 0){
// 			alert(message.join('\n'));
// 			return;
// 		}
		
// 		submitAction(pForm,'calculateOrderDate.action')

// 	}
	//sxt 20220614 del end
	
	//sxt 20220614 add start
	function calSeikyuyotei(){
		
		var message = new Array();

		var seikyukubun = document.HattyuForm.elements['form.order_div_input_sinki'].value;
		//sxt 20221008 del start
// 		if (seikyukubun != '01') {
// 			//message[message.length] = '請求区分は「単月」の場合のみ作成できます。';
// 			alert('請求区分は「単月」の場合のみ作成できます。');
// 			return;
// 		}
		//sxt 20221008 del end
		
		var kaityusaki = document.HattyuForm.elements['form.out_order_code_sinki'].value;
		if (kaityusaki == '') {
			message[message.length] = '外注先が入力必須です。';
		}
		
		if (seikyukubun == '01') {		//sxt 20221008 add
			var work_start_date = document.HattyuForm.elements['form.work_start_date_input_sinki'].value.replace(/-/g,"");
			var work_end_date = document.HattyuForm.elements['form.work_end_date_input_sinki'].value.replace(/-/g,"");
			
			if (work_start_date == ""){
				message[message.length] = '作業期間（開始）を入力してください。';
			}
			
			if (work_end_date == ""){
				message[message.length] = '作業期間（終了）を入力してください。';
			}
			
			if(parseInt(work_start_date) > parseInt(work_end_date)){
				message[message.length] = '作業期間範囲不正です。';
			}
		//sxt 20221008 add start
		} else {
			var delivery_date = document.HattyuForm.elements['form.delivery_date_input_sinki'].value.replace(/-/g,"");
			if (delivery_date == ""){
				message[message.length] = '納品予定日を入力してください。';
			}
		}
		//sxt 20221008 add end
				
		//var size = <ww:property value="form.optionList.size()" />;	//sxt 20220722 del
		var size = $("#optionDetailsize").val();						//sxt 20220722 add
		for ( var index = 0; index < size; index++ ) {
			var order_date =  document.HattyuForm.elements['form.optionList['+ index +'].order_date'].value;
			var payment_date =  document.HattyuForm.elements['form.optionList['+ index +'].payment_date'].value;
			var order_amount =  document.HattyuForm.elements['form.optionList['+ index +'].order_amount'].value;

			if (order_date != '' || payment_date != '' || order_amount != '') {
				message[message.length] = '請求予定日、支払予定日、請求予定金額を全部クリアしてから、もう一度作成してください。';
				break;
			}
		}
			
		if(message.length > 0){
			alert(message.join('\n'));
			return false;
		}
		
		return true;

	}
	//sxt 20220614 add end
	
	function clearOptionList() {
		
		/* var size = <ww:property value="form.optionList.size()" />;
		
		for ( var index = 0; index < size; index++ ) {
			document.HattyuForm.elements['form.optionList['+ index +'].orderYear'].value = "";
			document.HattyuForm.elements['form.optionList['+ index +'].orderMonth'].value = "";
			document.HattyuForm.elements['form.optionList['+ index +'].orderDay'].value = "";
			document.HattyuForm.elements['form.optionList['+ index +'].paymentYear'].value = "";
			document.HattyuForm.elements['form.optionList['+ index +'].paymentMonth'].value = "";
			document.HattyuForm.elements['form.optionList['+ index +'].paymentDay'].value = "";
			document.HattyuForm.elements['form.optionList['+ index +'].order_amount'].value = "";
		} */
	}
</script>		
</head>
<body onunload="closeSubWindow();" class="cm-no-transition cm-1-navbar">
<form name="HattyuForm" method="post" class="form-horizontal">
    <header id="cm-header">
<!--       <nav class="cm-navbar cm-navbar-primary"> -->
<!--         <div class="cm-flex"> -->
<!--           <h1>発注処理 -->
<!--             <i class="fa fa-fw fa-angle-double-right"></i>  -->
<!--           </h1> -->
<!--         </div> -->
<%--         <ww:include value="'/header.jsp'"/>	 --%>
<!--       </nav> -->
    </header>
    <!--content-->
    <div id="global">
      <div class="container-fluid">
        <div class="text-center dora-form-title">
          発注（請負）新規画面
          <ww:include value="'/loginName.jsp'"/>
        </div>
        <div class="panel panel-default">
          <div class="panel-body">
          	<ww:include value="'/message.jsp'" />
              
              <!--button-->              
              <div class="form-group">
                <div>
                  <!-- sxt 20220712 del start -->
<!--                   <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshHattyu.action');">戻る</button> -->
                  <!-- sxt 20220712 del end -->
                  <!-- sxt 20220712 add start -->
				  <ww:if test="form.modoruFlg.equals(\"1\")">
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
				  </ww:if>
				  <ww:else> 
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshHattyu.action');">戻る</button>
				  </ww:else>
				  <!-- sxt 20220712 add end -->
				  <!-- sxt 20220721 del start -->
<!--                   <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiHattyu.action');">保存</button> -->
                  <!-- sxt 20220721 del end -->
                  <!-- sxt 20220721 add start -->
				  <ww:if test="form.modoruFlg.equals(\"1\")">
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiHattyuFromProject.action');">保存</button>
				  </ww:if>
				  <ww:else> 
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiHattyu.action');">保存</button>
				  </ww:else>
				  <!-- sxt 20220721 add end -->
                </div>
              </div>
              
              <!--状態区域-->
               <div class="panel-body" style="padding:1.75rem 1rem">
<%--                  <div class="dora-state-zone">契約形態(<ww:property value='form.contract_form_name'/>)</div> --%>  	<!-- sxt 20221008 del -->

				 <!-- sxt 20221008 add start -->
				 <div class="dora-state-zone form-inline ">
				 	<label class="dora-label-right">契約形態</label>
                    <ww:select name="'form.contract_form'"
						       cssClass="'form-control'" 
						       list="form.contractFormList" 
						       listKey="code_id" 
						       listValue="code_value" 
						       value="form.contract_form" >
				    </ww:select>
				 </div>
				 <!-- sxt 20221008 add end -->
				
                 <%-- <div class="dora-state-zone">月次締<ww:property value='form.month_close_flg_name'/></div> --%>		<!-- sxt 20230201 del -->
<%--                  <div class="dora-state-zone">請求区分　<ww:property value='form.order_div_name'/></div> --%>		<!-- sxt 20221008 del -->

				 <!-- sxt 20221008 add start -->
				 <div class="dora-state-zone form-inline ">
				 	<label class="dora-label-right">請求区分</label>
                    <ww:select name="'form.order_div_input_sinki'"
						       cssClass="'form-control'" 
						       list="form.order_div_list_sinki" 
						       listKey="code_id" 
						       listValue="code_value" 
						       value="form.order_div_input_sinki" 
						       onchange="'clearOptionList();'" >
					</ww:select>
				 </div>
				 <!-- sxt 20221008 add end -->
                 
                 <div class="dora-state-zone form-inline ">
                 	<label class="dora-label-right">発注担当者</label>
                    <ww:select name="'form.order_in_code_sinki'"
			              size="'1'" 
					      cssClass="'form-control'" 
					      list="form.order_in_nameForSellist" 
					      listKey="person_in_charge_code" 
					      listValue="person_in_charge_name" 
					      value="form.order_in_code_sinki"  >
			   		</ww:select>
                 </div>
                                    		
               </div>

              <!--参照区域-->
              <div style="padding-top:1rem;">
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">受注参照</a></li>
                </ul>

                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="home" aria-labelledby="home-tab">
                      <div class="form-group form-inline">
                        <label class="dora-label-left">受注番号</label>
                        <!-- sxt 20221010 del start -->
<%--                         <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=6&form.receive_no=<ww:property  value="form.receive_no_sinki" />')"> --%>
<%--                         	<ww:property  value="form.receive_no_sinki" /> --%>
<!--                         </label> -->
                        <!-- sxt 20221010 del end -->
                        
                        <!-- sxt 20221010 add start -->
						<ww:if test="form.jyutyuShurui.equals(\"2\")">
							<label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=6&hattyuShurui=<ww:property value="form.shurui"/>&form.receive_no=<ww:property value="form.receive_no_sinki"/>')">
	                        	<ww:property  value="form.receive_no_sinki" />
	                        </label>
						</ww:if>
						<ww:else>
							<label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo2.action?form.pageFlg=6&hattyuShurui=<ww:property value="form.shurui"/>&form.receive_no=<ww:property value="form.receive_no_sinki"/>')">
	                        	<ww:property  value="form.receive_no_sinki" />
	                        </label>
						</ww:else>
						<!-- sxt 20221010 add end -->

                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">得意先</label>
                        <label class="dora-label-normal"><ww:property  value="form.customer_code_sinki" />　<ww:property value="form.customer_name_sinki" /></label>
                        <ww:hidden name ="'form.fraction_processing'" />
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">件名 </label>
                        <label class="dora-label-normal"><ww:property value="form.receive_name1_sinki" />　<ww:property value="form.receive_name2_sinki" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">作業期間 </label>
                        <label class="dora-label-normal"><ww:property value="form.work_start_date_sinki" />　～　<ww:property value="form.work_end_date_sinki" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">受注額 </label>
                        <label class="dora-label-normal">￥<ww:property value="form.receive_amount"/>円</label>
                        <label class="dora-label-right">発注残 </label>
                        <label class="dora-label-normal">￥<ww:property value="form.order_zan"/>円</label>
                      </div>
                    </div>
                  </div>
                </div>               
              </div>

              <!--ヘッダー-->
              <div>
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#header" id="header-tab" role="tab" data-toggle="tab" aria-controls="header" aria-expanded="true">発注ヘッダー</a></li>                     
                </ul>
                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="header" aria-labelledby="header-tab">
                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">発注番号</label>
                        <input type="text" name="form.order_no_sinki" value="<ww:property value='form.order_no_sinki'/>" maxlength="25" class="form-control" placeholder="発注番号">
                        <label class="dora-label-right-require">発注日付</label>
                        <input type="date" name="form.order_date_sinki" value="<ww:property value='form.order_date_sinki'/>" class="form-control">
                      
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">外注先</label>
                        <input type="hidden" id="out_order_code_old">		
                        <input type="text" name="form.out_order_code_sinki" id="out_order_code" value="<ww:property value='form.out_order_code_sinki'/>" maxlength="8" class="form-control " placeholder="外注先コード">
                        <input type="text" name="form.out_order_name_sinki" id="out_order_name" value="<ww:property value='form.out_order_name_sinki'/>" class="form-control" style="width:40rem;" readonly>
              			<input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initGaityuusakiGuide.action?form.fieldName_code=form.out_order_code_sinki&form.fieldName_name=form.out_order_name_sinki&form.processing=form.processing','外注先参照',670,770)" />
			  			<ww:hidden name="'form.processing'"> </ww:hidden>

                        <label class="dora-label-right-require">外注お見積番号 </label>
                        <input type="text" name="form.out_estimate_no_sinki" value="<ww:property value='form.out_estimate_no_sinki'/>" maxlength="20"  class="form-control" placeholder="外注お見積番号 ">
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">件名</label>
                        <input type="text" name="form.order_name1_input_sinki" value="<ww:property value='form.order_name1_input_sinki'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名１">
                        <input type="text" name="form.order_name2_input_sinki" value="<ww:property value='form.order_name2_input_sinki'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名２">
                      </div>

					  <!-- sxt 20221008 del start -->
<!--                       <div class="form-group form-inline"> -->
                      	
<!--                         <label class="dora-label-left">契約形態</label> -->
<%--                         <ww:select name="'form.contract_form'" --%>
<%-- 							       cssClass="'form-control'"  --%>
<%-- 							       list="form.contractFormList"  --%>
<%-- 							       listKey="code_id"  --%>
<%-- 							       listValue="code_value"  --%>
<%-- 							       value="form.contract_form" > --%>
<%-- 					    </ww:select> --%>

<!--                         <label class="dora-label-right">納品状態</label> -->
<%--                         <ww:select name="'form.delivery_status_input_sinki'" --%>
<%-- 							       cssClass="'form-control'"  --%>
<%-- 							       list="form.delivery_status_sinki"  --%>
<%-- 							       listKey="code_id"  --%>
<%-- 							       listValue="code_value"  --%>
<%-- 							       value="form.delivery_status_input_sinki" > --%>
<%-- 						</ww:select> --%>

<!--                         <label class="dora-label-right">請求区分</label> -->
<%--                         <ww:select name="'form.order_div_input_sinki'" --%>
<%-- 							       cssClass="'form-control'"  --%>
<%-- 							       list="form.order_div_list_sinki"  --%>
<%-- 							       listKey="code_id"  --%>
<%-- 							       listValue="code_value"  --%>
<%-- 							       value="form.order_div_input_sinki"  --%>
<%-- 							       onchange="'clearOptionList();'" > --%>
<%-- 						</ww:select>	     --%>
<!--                       </div> -->
                      <!-- sxt 20221008 del end -->

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">作業期間</label>
                        <input type="date" name="form.work_start_date_input_sinki" value="<ww:property value='form.work_start_date_input_sinki'/>" class="form-control">
                        <label>～</label>  
                        <input type="date" name="form.work_end_date_input_sinki" value="<ww:property value='form.work_end_date_input_sinki'/>" class="form-control">
                                                  
                        <label class="dora-label-right-require">消費税率(%)</label>
						<input type="number" name="form.consume_tax_rate_sinki" value="<ww:property value='form.consume_tax_rate_sinki'/>" class="form-control" style="width: 8rem;" placeholder="税率(%)"  
								oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
						
						<!-- sxt 20221008 add start -->		
						<label class="dora-label-right">納品状態</label>
                        <ww:select name="'form.delivery_status_input_sinki'"
							       cssClass="'form-control'" 
							       list="form.delivery_status_sinki" 
							       listKey="code_id" 
							       listValue="code_value" 
							       value="form.delivery_status_input_sinki" >
						</ww:select>
						<!-- sxt 20221008 add end -->	
                      </div>

                      <div class="form-group form-inline">
                        <label class=" dora-label-left">支払条件</label>
                        <label class="dora-label-normal">検収日</label>  
                        <input type="text" name="form.payment_condition1_input_sinki" value="<ww:property value='form.payment_condition1_input_sinki'/>" id="payment_condition1" maxlength="60" class="form-control" style="width:12rem;" readonly>
  
                        <label class="dora-label-normal" style=" padding-left:3rem;">支払日</label>  
                        <input type="text" name="form.payment_condition2_input_sinki" value="<ww:property value='form.payment_condition2_input_sinki'/>" id="payment_condition2" maxlength="60" class="form-control" style="width:12rem;">

                        <label class="dora-label-right">納品予定日</label>
                        <input type="hidden" name="form.delivery_date_sinki" value="<ww:property value='form.delivery_date_sinki'/>">
                        <input type="date" name="form.delivery_date_input_sinki" value="<ww:property value='form.delivery_date_input_sinki'/>" class="form-control">
                      </div>
                    </div>
                  </div>
                </div>        
              </div>

              <!--明細-->
              <div>
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab" aria-controls="detail" aria-expanded="true">発注明細</a></li>
                </ul>

                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="detail" aria-labelledby="detail-tab">
                      <table class="table table-bordered">
                        <thead>
                          <tr>
                            <td class="text-center" rowspan="2" style="width:4.5rem;">行</td>
                            <td class="text-center" rowspan="2" colspan="2" style="width:20rem;">作業内容</td>
                            <td class="text-center" rowspan="2" style="width:18rem;">単価</td>
                            <td class="text-center" rowspan="2" style="width:14rem;">数量</td>
                            <td class="text-center" style="width:18rem;">単位</td>
                            <td class="text-center" style="width:18rem;" rowspan="2">金額</td>
                            <td class="text-center" rowspan="2" style="width:2rem;"></td>
                          </tr>
                          <tr>
                            <td class="text-center" nowrap>税区分</td>
                            <ww:hidden name="'detailsize'" id="detailsize" value="form.stockDetailModelList.size()"></ww:hidden>
                          </tr>
                        </thead>
                        
                        <tbody id="tbAddPart">
                        <%int temp = 0 ;%>
						<ww:iterator value="form.stockDetailModelList" status="rows" id="model">
                          <tr>
                            <td class="text-center" rowspan="2">
                              <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].row_number" 
									value='<ww:property value="form.stockDetailModelList[#rows.index].row_number"/>' class="form-control text-right"
									oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center" rowspan="2">
                              <ww:hidden name="'form.stockDetailModelList['+#rows.index+'].task_code'" />
				  			  <ww:textarea name="'form.stockDetailModelList['+#rows.index+'].task_content'" value="task_content" cssClass="'control'" rows="3"></ww:textarea>
                            </td>
                            <td class="text-center" rowspan="2" style="width:6rem;">
                              <input type="button" value="参照" class="btn btn-primary dora-tabel-button" onclick="openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList[<%=temp%>].task_code&form.fieldName_name=form.stockDetailModelList[<%=temp%>].task_content','作業内容参照',670,600)">
                            </td>
                            <td class="text-center">
	                            <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].price_per" 
										value="<ww:property value='form.stockDetailModelList[#rows.index].price_per'/>" class="form-control text-right"
										oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center" >
                              <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].quantity" 
									value="<ww:property value='form.stockDetailModelList[#rows.index].quantity'/>" class="form-control text-right"
									oninput="maxNumberLength(8)" onkeypress="return integerAndDecimal()" onchange="decimalLength(8,3)"/> 
                            </td>
                            <td class="text-center">
	                            <ww:select size="1" name="'form.stockDetailModelList['+#rows.index+'].unit_name_input'" 
									   cssClass="'form-control'" 
									   list="form.unit_name_list" 
									   listKey="code_id" 
									   listValue="code_value" 
									   value="unit_name_input" 
									   headerKey="''"
									   headerValue="'選択してください'"
								>
								</ww:select>
                            </td>
                            <td class="text-center">
	                            <input type="number" name="form.stockDetailModelList[<ww:property value='#rows.index'/>].amount" 
										value="<ww:property value='form.stockDetailModelList[#rows.index].amount'/>" class="form-control text-right"
										oninput="maxNumberLength(13)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center"  rowspan="2">
                              <ww:checkbox  name="'form.stockDetailModelList['+#rows.index+'].isCheck'" fieldValue="'1'"></ww:checkbox>
                            </td>
                          </tr>
                          <tr>
                            <td class="text-center" ></td>
                            <td class="text-center" ></td>
                            <td class="text-center" >
	                            <ww:select size="1" name="'form.stockDetailModelList['+#rows.index+'].tax_div_input'" 
										   cssClass="'form-control'" 
										   list="form.tax_div_list" 
										   listKey="code_id" 
										   listValue="code_value" 
										   value="tax_div_input" 
										   headerKey="''"
										   headerValue="''"								   
								>
								</ww:select>
                            </td>
                            <td class="text-center" >
                               
                            </td>
                          </tr>
                          <% temp = temp +1 ;%>
                          </ww:iterator>
                        </tbody>
                        <tfoot>
                          <tr>
                            <td class="text-center" colspan="3"  rowspan="4"></td>
                            <!-- <td class="text-center" colspan="2">合 計</td> --><!-- sxt 20230508 del -->
                            <!-- sxt 20230508 add start -->
                            <td colspan="2">
	                      		<div class="checkbox" style="padding-left: 12rem;">
									<label>
										<ww:if test="form.estimate_amount_flg_sinki.equals(\"1\")">
											<ww:checkbox name="'form.estimate_amount_flg_chk'" fieldValue="form.estimate_amount_flg_sinki" value="1" onclick="'doCheckEstimate(this.name);'"></ww:checkbox>
										</ww:if>
										<ww:else>
											<ww:checkbox name="'form.estimate_amount_flg_chk'" fieldValue="form.estimate_amount_flg_sinki" value="0" onclick="'doCheckEstimate(this.name);'"></ww:checkbox>
										</ww:else>
										合 計
									</label>
								</div>
                            </td>
                            <!-- sxt 20230508 add end -->
                            <td class="text-right" colspan="2">
                            	<label id="estimate_amount_sinki"><ww:property value="form.estimate_amount_sinki"/></label>
                            </td>
                            <td rowspan="4"></td>
                          </tr>
                          <tr>
                            <!-- <td class="text-center" colspan="2">消 費 税</td> --><!-- sxt 20230508 del -->
                            <!-- sxt 20230508 add start -->
                            <td colspan="2">
                            	<div class="checkbox" style="padding-left: 12rem;">
									<label>
										<ww:if test="form.tax_amount_flg_sinki.equals(\"1\")">
											<ww:checkbox name="'form.tax_amount_flg_chk'" fieldValue="form.tax_amount_flg_sinki" value="1" onclick="'doCheckTax(this.name)'"></ww:checkbox>
										</ww:if>
										<ww:else>
											<ww:checkbox name="'form.tax_amount_flg_chk'" fieldValue="form.tax_amount_flg_sinki" value="0" onclick="'doCheckTax(this.name)'"></ww:checkbox>
										</ww:else>
										消 費 税
									</label>
								</div>
                            </td>
                            <!-- sxt 20230508 add end -->
                            <td class="text-right" nowrap colspan="2">
                            	<label id="tax_amount_sinki"><ww:property value="form.tax_amount_sinki"/></label>
                            </td>
                          </tr>
                          <tr>
                            <!-- <td class="text-center" colspan="2">税込合計</td> --><!-- sxt 20230508 del -->
                            <!-- sxt 20230508 add start -->
                            <td colspan="2">
                            	<div class="checkbox" style="padding-left: 12rem;">
									<label>
										<ww:if test="form.amount_flg_sinki.equals(\"1\")">
											<ww:checkbox name="'form.amount_flg_chk'" fieldValue="form.amount_flg_sinki" value="1" onclick="'doCheckAmount(this.name)'"></ww:checkbox>
										</ww:if>
										<ww:else>
											<ww:checkbox name="'form.amount_flg_chk'" fieldValue="form.amount_flg_sinki" value="0" onclick="'doCheckAmount(this.name)'"></ww:checkbox>
										</ww:else>
										税込合計
									</label>
								</div>
                            </td>
                            <!-- sxt 20230508 add end -->
                            <td class="text-right" nowrap colspan="2">
                            	<label id="amount_sinki"><ww:property value="form.amount_sinki"/></label>
                            </td>
                          </tr>
                        </tfoot>
                      </table>
                      <div class="form-group" style="margin-bottom:1rem;">
                        <div>
                          <button type="button" class="btn btn-primary" id="addRow">明細行追加</button>
						  <button type="button" class="btn btn-primary" id="deleteRow">明細削除</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!--請求予定-->
              <div>
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                  <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab" aria-controls="detail" aria-expanded="true">発注請求予定</a></li>
                </ul>
                <div class="panel panel-default">
                  <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade active in panel-body" id="detail" aria-labelledby="detail-tab">

                      <table class="table table-bordered" style="width:65rem;">
                        <thead>
                          <tr>
                            <td class="text-center" style="width:5rem;">枝番</td>
                            <td class="text-center" style="width:16rem;">請求予定日</td>
                            <td class="text-center" style="width:16rem;">支払予定日</td>
                            <td class="text-center" style="width:16rem;">請求予定金額</td>
                            <td class="text-center" style="width:4rem;" ></td>
                            <ww:hidden name="'optionDetailsize'" id="optionDetailsize" value="form.optionList.size()"></ww:hidden>
                          </tr>
                        </thead>
                        <tbody id="tbOpthion">
                          <%int ss = 0; %>
                          <ww:iterator value="form.optionList" status="rows">
                          <tr>
                          	<ww:hidden name="'form.optionList['+#rows.index+'].sales_no'" value="sales_no"> </ww:hidden>
				        	<ww:hidden name="'form.optionList['+#rows.index+'].reg_id'" value="reg_id"> </ww:hidden>
				        	<ww:hidden name="'form.optionList['+#rows.index+'].reg_name'" value="reg_name"> </ww:hidden>
				        	<ww:hidden name="'form.optionList['+#rows.index+'].reg_date'" value="reg_date"> </ww:hidden>

							<td class="text-center" >
                              <input type="number" name="form.optionList[<ww:property value='#rows.index'/>].row_number" 
									value='<ww:property value="form.optionList[#rows.index].row_number"/>' class="form-control text-right"
									oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center"  >
                              <input type="date" name="form.optionList[<ww:property value='#rows.index'/>].order_date" 
									value='<ww:property value="form.optionList[#rows.index].order_date"/>' class="form-control"/>
                            </td>
                            <td class="text-center"  >
                              <input type="date" name="form.optionList[<ww:property value='#rows.index'/>].payment_date" 
									value='<ww:property value="form.optionList[#rows.index].payment_date"/>' class="form-control"/>
                            </td>
               
                            <td class="text-center" >
                              <input type="number" name="form.optionList[<ww:property value='#rows.index'/>].order_amount" 
									value="<ww:property value='form.optionList[#rows.index].order_amount'/>" class="form-control text-right"
									oninput="maxNumberLength(13)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center" style="vertical-align:middle;">
                              <ww:checkbox name="'form.optionList['+#rows.index+'].checkbox2'" fieldValue="'checkbox'" ></ww:checkbox>
                            </td>		        	
                            
                          </tr>
						  <%  ss++; %>
                          </ww:iterator>
                        </tbody>
                      </table>
                      <div class="form-group form-inline">           
                        <button type="button" class="btn btn-primary" id="optionAddRow">明細行追加</button>
                  		<button type="button" class="btn btn-primary" id="optionDeleteRow">明細削除</button>
                        <button type="button" class="btn btn-primary" id="calSeikyuyotei">請求予定作成</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!---->
              <div class="row" style="margin:1rem 0 0 0.25rem">
                <div>
                  <label for="state">備考（最大長度１２５０漢字）</label>
                  <textarea name="form.remark" class="form-control" rows="5" placeholder="備考"><ww:property value='form.remark'/></textarea>
                </div>
              </div>
              <div class="row" style="margin:1rem 0 0 0.25rem">
                <div>           
                  <label>社内メモ（最大長度１２５０漢字）</label>
                  <textarea name="form.memo" class="form-control" rows="5" placeholder="社内メモ"><ww:property value='form.memo'/></textarea>
                </div>
              </div>
  
              <div class="form-group"  style="margin-top:1.25rem">
                <div>
                  <!-- sxt 20220712 del start -->
<!--                   <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshHattyu.action');">戻る</button> -->
                  <!-- sxt 20220712 del end -->
                  <!-- sxt 20220712 add start -->
				  <ww:if test="form.modoruFlg.equals(\"1\")">
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
				  </ww:if>
				  <ww:else> 
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshHattyu.action');">戻る</button>
				  </ww:else>
				  <!-- sxt 20220712 add end -->
                  <!-- sxt 20220721 del start -->
<!--                   <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiHattyu.action');">保存</button> -->
                  <!-- sxt 20220721 del end -->
                  <!-- sxt 20220721 add start -->
				  <ww:if test="form.modoruFlg.equals(\"1\")">
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiHattyuFromProject.action');">保存</button>
				  </ww:if>
				  <ww:else> 
				    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveSinkiHattyu.action');">保存</button>
				  </ww:else>
				  <!-- sxt 20220721 add end -->
                </div>
              </div>
              <!-- sxt 20230508 add start -->
              <ww:hidden name="'form.estimate_amount_flg_sinki'" > </ww:hidden>
			  <ww:hidden name="'form.tax_amount_flg_sinki'"> </ww:hidden>
			  <ww:hidden name="'form.amount_flg_sinki'"> </ww:hidden>
			  <!-- sxt 20230508 add end -->
          </div>
        </div>
      </div>
      <ww:include value="'/footer.jsp'" />
    </div>
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
	<script language="JavaScript">
		$(document).ready(function(){
			
			//合計金額計算
			calculateTotal();
			
			//明細部のイベント绑定
			bingDetailEvent();
						
			//明細行追加
			$("#addRow").click(function(){
				
				$.ajax({
			        type: "POST",  
			        url: "addSinkiHattyu.action",
			        error: function (error) {  

			        },
			        success: function (data) {  	        	      
			        	addRow();
			        	
			        	//明細部のイベント绑定
						bingDetailEvent();
			        }
			    });			
			});
			
						
			//明細削除
			$("#deleteRow").click(function(){
				
				if (deleteSinkiHattyu()) {
					$.ajax({
				        type: "POST",  
				        dataType:"html",
				        url: "deleteSinkiHattyu.action",
				        data: $('form').serialize(),
				        error: function (error) {  

				        },
				        success: function (data) {  	
					        	
				        	$("input[name$='isCheck']:checked").each(function() { 	
				        		
				        		var obj,start,end;
								
								// 获取checkbox所在行的顺序
								var n = $(this).parents("tr").index(); 
								
								obj = $(this).prop("name");
								//获取索引值
								start = obj.indexOf("[");
								end = obj.indexOf("]");
								
								//当前index
								var curIndex = parseInt(obj.substr(start+1,end-start-1));
								
								// 画面的一行实际上是有2行<tr>组成的，所有要删除2行tr
								removeRow(n);
								removeRow(n);
								
								var maxRowNuber;	//最大行番号
								var maxIndex;		//最大index

								$("input[name^='form.stockDetailModelList'][name$='row_number']").each(function() {
									//获取当前元素的name
									maxRowNuber = parseInt($(this).val());
									
									obj = $(this).prop("name");
									//获取索引值
									start = obj.indexOf("[");
									end = obj.indexOf("]");
									maxIndex = parseInt(obj.substr(start+1,end-start-1));
								
								});
															
								appendRow(maxIndex+1,maxRowNuber+1); 
								
								reSetRowIndex(curIndex);
								
								//明細部のイベント绑定
								bingDetailEvent();

				        	});
				        	
				        	//sxt 20220815 add start
				        	//合計金額計算
							calculateTotal();
							//sxt 20220815 add end
				        }
				    });
				}
				
			});
						
			//請求予定明細行追加
			$("#optionAddRow").click(function(){
				
				$.ajax({
			        type: "POST",  
			        url: "hattyuOptionAddRow.action",
			        error: function (error) {  

			        },
			        success: function (data) {  
			        	addOpthionRow();
			        }
			    });			
			});

			//明細削除
			$("#optionDeleteRow").click(function(){
				
				if (optionDeleteRow()) {
					$.ajax({
				        type: "POST",  
				        dataType: "html",
				        url: "hattyuOptionDeleteRow.action",
				        data: $('form').serialize(),
				        error: function (error) {  

				        },
				        success: function (data) {  	
					        	
				        	$("input[name$='checkbox2']:checked").each(function() { 	
				        		
				        		var obj,start,end;
								
								// 获取checkbox所在行的顺序
								var n = $(this).parents("tr").index(); 
								
								obj = $(this).prop("name");
								//获取索引值
								start = obj.indexOf("[");
								end = obj.indexOf("]");
								
								//当前index
								var curIndex = parseInt(obj.substr(start+1,end-start-1));
								
								// 删除行tr
								removeOptionRow(n);
								
								var maxRowNuber;	//最大行番号
								var maxIndex;		//最大index

								$("input[name^='form.optionList'][name$='row_number']").each(function() {
									//获取当前元素的name
									maxRowNuber = parseInt($(this).val());
									
									obj = $(this).prop("name");
									//获取索引值
									start = obj.indexOf("[");
									end = obj.indexOf("]");
									maxIndex = parseInt(obj.substr(start+1,end-start-1));
								
								});
															
								//appendOptionRow(maxIndex+1,maxRowNuber+1); 
								
								reSetOptionRowIndex(curIndex);
								
								//sxt 20220815 add start
								//重新设定請求予定的行数
								var size = parseInt($("#optionDetailsize").val());
					        	$("#optionDetailsize").val(size-1);
					        	//sxt 20220815 add end

				        	});
				        }
				    });
				}
				
			});
			
		    $("#out_order_code").blur(function(){
		    	var code = $("#out_order_code").val();
		    	var codeOld = $("#out_order_code_old").val();
		    	if (code != codeOld) {
				    $.ajax({
				        type: "POST",  
				        url: "getGaityusakiList.action",
				        data: {id:code},
				        error: function (request) {  
				        	//外注先担当名をクリアする
				            $("#out_order_name").val("");
				        },
				        success: function (data) {  
				        	//外注先の退避値をセット
				        	$("#out_order_code_old").val(code);

				        	if (data == ""){
				        		//外注先名をクリアする
					            $("#out_order_name").val("");
				        	} else {
				        		//得意先端数処理をセットする
					            $("input[name='form.processing'").val(JSON.parse(data).fraction_processing);	
				        		
					        	//得意先当名をセットする
					            $("#out_order_name").val(JSON.parse(data).out_order_name);	        	
					        						        	
					        	//検収日をセット（当月＋取引先・締日）
// 					        	if (!$("#payment_condition1").val()){
					        		if (JSON.parse(data).balance_date =="99"){
					        			$("#payment_condition1").val("当月末日");
					        		} else {
					        			$("#payment_condition1").val("当月"+JSON.parse(data).balance_date.replace(/\b(0+)/gi,"") + "日");
					        		}
					        		
// 					        	}
					        	
					        	//支払日をセット（取引先・入金月区分＋入金日）
// 					        	if (!$("#payment_condition2").val()){
					        		if (JSON.parse(data).payment_date == "99"){
					        			$("#payment_condition2").val(JSON.parse(data).paymentmonth_condition + "末日");
					        		} else {
					        			$("#payment_condition2").val(JSON.parse(data).paymentmonth_condition + JSON.parse(data).payment_date.replace(/\b(0+)/gi,"") + "日");
					        		}
					        		
// 					        	}
								
				        	}
				        }
				    });
		    	}

		  	});

			$("#calSeikyuyotei").click(function(){
				doCalSeikyuyotei();			    
		  	}); 
		});
		
		//明細部のイベント绑定
		function bingDetailEvent(){
			/* 明細部単価blurイベント*/
			$("input[name$='price_per']").blur(function(){
						
				//获取当前元素的name
				var x = $(this).prop("name");
				//获取当前索引
				var index = getCurIndex(x);
				
				//sxt 20230528 add start
				setTaxDivInput(index);
				//sxt 20230508 add end
				
				//金額計算
				calculateAmount(index);
			});
			
			/* 明細部数量blurイベント*/
			$("input[name$='quantity']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				//获取当前索引
				var index = getCurIndex(x);
				
				//sxt 20230528 add start
				setTaxDivInput(index);
				//sxt 20230508 add end
				
				//金額計算
				calculateAmount(index);
			});
			
			$("select[name$='tax_div_input']").change(function(){
				//合計金額計算
				calculateTotal();
			});
		}
		
		function addRow(){
			var size = parseInt($("#detailsize").val());
			
			if (size == 90) {
				return false;
			}
			
			//最大行番号を取得する
			var maxRowNumber = parseInt($("input[name='form.stockDetailModelList[" + (size-1) +"].row_number'").val());
								
			//新しい５行を追加
			for (var i = 0; i < 5; i++) {
										
				appendRow(i+size,i+maxRowNumber+1); 
			}
			
			$("#detailsize").val(5+size);
		}
		
		function appendRow(n,rowNumber){
			//1行目をコピー
			var tr0 = $("#tbAddPart tr").eq(0).clone();
			
			//获得当前行第1个TD值
			var col0 = tr0.find("td:eq(0)"); 
			//获得当前TD的input标签 【行】
			var row_number = col0.find("input");
			//设置input标签name
			row_number.attr("name","form.stockDetailModelList[" + n + "].row_number");
			//设置input标签value
			//row_number.attr("value",rowNumber); 
			row_number.val(rowNumber);
			
			//获得当前行第2个TD值 
			var col1 = tr0.find("td:eq(1)"); 
			//获得当前TD的input标签 【作業内容】
			var task_code = col1.find("input");
			task_code.attr("name","form.stockDetailModelList[" + n + "].task_code");
			task_code.attr("value",""); 
			task_code.val("");
			
			var task_content = col1.find("textarea");
			task_content.attr("name","form.stockDetailModelList[" + n + "].task_content");
			task_content.attr("value",""); 
			task_content.val("");
			
			//获得当前行第3个TD值 
			var col2 = tr0.find("td:eq(2)"); 
			//获得当前TD的input标签 【参照】
			var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList[" + n + "].task_code&form.fieldName_name=form.stockDetailModelList[" + n+ "].task_content','作業内容参照',670,600)";
			var sanshoButton = col2.find("input");
			sanshoButton.attr("onclick",clickContent);
			sanshoButton.attr("name","button[" + n + "]");
			
			//获得当前行第4个TD值 
			var col3 = tr0.find("td:eq(3)"); 
			//获得当前TD的input标签 【単価】
			var price_per = col3.find("input");
			price_per.attr("name","form.stockDetailModelList[" + n + "].price_per");
			price_per.attr("value",""); 
			price_per.val("");

			//获得当前行第5个TD值 
			var col4 = tr0.find("td:eq(4)"); 
			//获得当前TD的input标签 【数量】
			var quantity = col4.find("input");
			quantity.attr("name","form.stockDetailModelList[" + n + "].quantity");
			quantity.attr("value",""); 
			quantity.val("");
			
			//获得当前行第6个TD值 
			var col5 = tr0.find("td:eq(5)"); 
			//获得当前TD的input标签 【単位】
			var unit_name_input = col5.find("select");
			unit_name_input.attr("name","form.stockDetailModelList[" + n + "].unit_name_input");
			unit_name_input.attr("value",""); 
			unit_name_input.val("");
			
			//获得当前行第7个TD值 
			var col6 = tr0.find("td:eq(6)"); 
			//获得当前TD的input标签 【単位】
			var amount = col6.find("input");
			amount.attr("name","form.stockDetailModelList[" + n + "].amount");
			amount.attr("value",""); 
			amount.val("");
			
			//获得当前行第8个TD值 
			var col7 = tr0.find("td:eq(7)"); 
			//获得当前TD的input标签  【checkbox】
			var checkbox = col7.find("input");
			checkbox.attr("name","form.stockDetailModelList[" + n + "].isCheck");
			checkbox.attr("value","0"); 
			checkbox.prop('checked',false)
			
			//1行目を追加
			tr0.appendTo("#tbAddPart");
			 
			//2行目をコピー
			var tr1 = $("#tbAddPart tr").eq(1).clone();
			
			//获得当前行第3个TD值 
			var tr1col2 = tr1.find("td:eq(2)"); 
			//获得当前TD的input标签 【税区分】
			var tax_div_input = tr1col2.find("select");
			tax_div_input.attr("name","form.stockDetailModelList[" + n + "].tax_div_input");
			tax_div_input.attr("value",""); 
			tax_div_input.val("");
			
			//获得当前行第4个TD值 
			var tr1col3 = tr1.find("td:eq(3)"); 
			//获得当前TD的input标签 【税区分】
			var org_price = tr1col3.find("input");
			org_price.attr("name","form.stockDetailModelList[" + n + "].org_price");
			org_price.attr("value",""); 
			org_price.val("");
			
			//2行目を追加
			tr1.appendTo("#tbAddPart");

		}

		function reSetRowIndex(curIndex){

			var obj,start,end,index;
			$("input[name^='form.stockDetailModelList'][name$='row_number']").each(function() {
				//获取当前元素的name
				rowNuber = parseInt($(this).val());
				
				input = $(this).prop("name");
				//获取索引值
				start = input.indexOf("[");
				end = input.indexOf("]");
				index = parseInt(input.substr(start+1,end-start-1));
						
				if (index > curIndex){

					$("input[name='form.stockDetailModelList[" + index +"].row_number'").attr("name","form.stockDetailModelList[" + (index-1) + "].row_number");
					$("input[name='form.stockDetailModelList[" + index +"].task_code'").attr("name","form.stockDetailModelList[" + (index-1) + "].task_code");
					$("textarea[name='form.stockDetailModelList[" + index +"].task_content'").attr("name","form.stockDetailModelList[" + (index-1) + "].task_content");
					
					var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList[" + (index-1) + "].task_code&form.fieldName_name=form.stockDetailModelList[" + (index-1) + "].task_content','作業内容参照',670,600)";		
					$("input[name='button[" + index +"]'").attr("onclick",clickContent);
					$("input[name='button[" + index +"]'").attr("name","button[" + (index-1) + "]");
						
					$("input[name='form.stockDetailModelList[" + index +"].price_per'").attr("name","form.stockDetailModelList[" + (index-1) + "].price_per");
					$("input[name='form.stockDetailModelList[" + index +"].quantity'").attr("name","form.stockDetailModelList[" + (index-1) + "].quantity");
					$("select[name='form.stockDetailModelList[" + index +"].unit_name_input'").attr("name","form.stockDetailModelList[" + (index-1) + "].unit_name_input");
					$("input[name='form.stockDetailModelList[" + index +"].amount'").attr("name","form.stockDetailModelList[" + (index-1) + "].amount");
					$("input[name='form.stockDetailModelList[" + index +"].isCheck'").attr("name","form.stockDetailModelList[" + (index-1) + "].isCheck");
					$("select[name='form.stockDetailModelList[" + index +"].tax_div_input'").attr("name","form.stockDetailModelList[" + (index-1) + "].tax_div_input");
					$("input[name='form.stockDetailModelList[" + index +"].org_price'").attr("name","form.stockDetailModelList[" + (index-1) + "].org_price");
				}
				
			});	
		}
		
		function removeRow(n){			
			$("#tbAddPart tr").eq(n).remove();
		}
		
		function addOpthionRow(){
			var size = parseInt($("#optionDetailsize").val());
				
			//if (size == 90 || size == 0) {	//sxt 20221003 del
			if (size == 90) {					//sxt 20221003 add
				return false;
			}
			
			//最大行番号を取得する
			var maxRowNumber = parseInt($("input[name='form.optionList[" + (size-1) +"].row_number'").val());
			
			//sxt 20220916 del start
			//新しい10行を追加
//				for (var i = 0; i < 10; i++) {

//					appendOptionRow(i+size,i+maxRowNumber+1); 
//				}
			
//				$("#optionDetailsize").val(10+size);
			//sxt 20220916 del end
			
			//sxt 20220916 add start
			//新しい1行を追加
			//sxt 20220930 del start
// 			for (var i = 0; i < 1; i++) {

// 				appendOptionRow(i+size,i+maxRowNumber+1); 
// 			}
			//sxt 20220930 del end
			
			//sxt 20220930 add start
			if (size==0){
				//0行的场合，追加行
				appendOptionRow2();
			} else {
				appendOptionRow(size,maxRowNumber+1); 
			}
			//sxt 20220930 add end
			
			$("#optionDetailsize").val(1+size);
			//sxt 20220916 add end
		}
		
		//sxt 20220930 add start
		function appendOptionRow2(){
			var trHtml = "";
			trHtml += `<tr>`;
			trHtml += `<ww:hidden name="'form.optionList[0].sales_no'" value="sales_no"> </ww:hidden>`;
			trHtml += `<ww:hidden name="'form.optionList[0].reg_id'" value="reg_id"> </ww:hidden>`;
			trHtml += `<ww:hidden name="'form.optionList[0].reg_name'" value="reg_name"> </ww:hidden>`;
			trHtml += `<ww:hidden name="'form.optionList[0].reg_date'" value="reg_date"> </ww:hidden>`;
			trHtml += `<td class="text-center" >`;
			trHtml += `  <input type="number" name="form.optionList[0].row_number" value='1' class="form-control text-right"`;
			trHtml += `      oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>`;
			trHtml += `</td>`;
			trHtml += `<td class="text-center"  >`;
			trHtml += `  <input type="date" name="form.optionList[0].order_date" class="form-control"/>`;
			trHtml += `</td>`;
			trHtml += `<td class="text-center" >`;
			trHtml += `  <input type="date" name="form.optionList[0].payment_date" class="form-control"/>`;
			trHtml += `</td>`;
			trHtml += `<td class="text-center" >`;
			trHtml += `  <input type="number" name="form.optionList[0].order_amount" class="form-control text-right"`;
			trHtml += `    oninput="maxNumberLength(13)" onKeypress="return integerOnly()"/>`;
			trHtml += `</td>`;
			trHtml += `<td class="text-center" style="vertical-align:middle;">`;
			trHtml += `  <ww:checkbox name="'form.optionList[0].checkbox2'" fieldValue="'checkbox'" ></ww:checkbox>`;
			trHtml += `</td>`;
			trHtml += `</tr>`;
			$("#tbOpthion").append(trHtml);
		}
		//sxt 20220930 add end
		
		function appendOptionRow(n,rowNumber){
			//1行目をコピー
			var tr0 = $("#tbOpthion tr").eq(0).clone();
			
			//获得当前行第1个TD值
			var col0 = tr0.find("td:eq(0)"); 
			//获得当前TD的input标签 【行】
			var row_number = col0.find("input");
			//设置input标签name
			row_number.attr("name","form.optionList[" + n + "].row_number");
			//设置input标签value
			//row_number.attr("value",rowNumber); 
			row_number.val(rowNumber);
			
			//获得当前行第2个TD值 
			var col1 = tr0.find("td:eq(1)"); 
			//获得当前TD的input标签 【請求予定日】
			var order_date = col1.find("input");
			order_date.attr("name","form.optionList[" + n + "].order_date");
			order_date.attr("value",""); 
			order_date.val("");
							
			//获得当前行第3个TD值 
			var col2 = tr0.find("td:eq(2)"); 
			//获得当前TD的input标签 【支払予定日】
			var payment_date = col2.find("input");
			payment_date.attr("name","form.optionList[" + n + "].payment_date");
			payment_date.attr("value",""); 
			payment_date.val("");
			
			//获得当前行第4个TD值 
			var col3 = tr0.find("td:eq(3)"); 
			//获得当前TD的input标签 【請求予定金額】
			var order_amount = col3.find("input");
			order_amount.attr("name","form.optionList[" + n + "].order_amount");
			order_amount.attr("value",""); 
			order_amount.val("");
			
			//获得当前行第5个TD值 
			var col4 = tr0.find("td:eq(4)"); 
			//获得当前TD的input标签  【checkbox】
			var checkbox2 = col4.find("input");
			checkbox2.attr("name","form.optionList[" + n + "].checkbox2");
			checkbox2.attr("value","0"); 
			checkbox2.prop('checked',false)
			
			//隐藏列
			var sales_no = tr0.find("input[name$='sales_no']");
			sales_no.attr("name","form.optionList[" + n + "].sales_no");
			sales_no.attr("value",""); 
			sales_no.val("");
			
			var reg_id = tr0.find("input[name$='reg_id']");
			reg_id.attr("name","form.optionList[" + n + "].reg_id");
			reg_id.attr("value",""); 
			reg_id.val("");
			
			var reg_name = tr0.find("input[name$='reg_name']");
			reg_name.attr("name","form.optionList[" + n + "].reg_name");
			reg_name.attr("value",""); 
			reg_name.val("");
			
			var reg_date = tr0.find("input[name$='reg_date']");
			reg_date.attr("name","form.optionList[" + n + "].reg_date");
			reg_date.attr("value",""); 
			reg_date.val("");
							
			//1行目を追加
			tr0.appendTo("#tbOpthion");
			 
		}
		
		function reSetOptionRowIndex(curIndex){
			var obj,start,end,index;
			$("input[name^='form.optionList'][name$='row_number']").each(function() {
				//获取当前元素的name
				rowNuber = parseInt($(this).val());
				
				input = $(this).prop("name");
				//获取索引值
				start = input.indexOf("[");
				end = input.indexOf("]");
				index = parseInt(input.substr(start+1,end-start-1));
				
				if (index>=curIndex){

					$("input[name='form.optionList[" + index +"].row_number'").attr("name","form.optionList[" + (index-1) + "].row_number");
					$("input[name='form.optionList[" + index +"].order_date'").attr("name","form.optionList[" + (index-1) + "].order_date");
					$("input[name='form.optionList[" + index +"].payment_date'").attr("name","form.optionList[" + (index-1) + "].payment_date");
					$("input[name='form.optionList[" + index +"].order_amount'").attr("name","form.optionList[" + (index-1) + "].order_amount");
					$("input[name='form.optionList[" + index +"].checkbox2'").attr("name","form.optionList[" + (index-1) + "].checkbox2");
					$("input[name='form.optionList[" + index +"].sales_no'").attr("name","form.optionList[" + (index-1) + "].sales_no");
					$("input[name='form.optionList[" + index +"].reg_id'").attr("name","form.optionList[" + (index-1) + "].reg_id");
					$("input[name='form.optionList[" + index +"].reg_name'").attr("name","form.optionList[" + (index-1) + "].reg_name");
					$("input[name='form.optionList[" + index +"].reg_date'").attr("name","form.optionList[" + (index-1) + "].reg_date");
					
					//sxt 20220815 add start
					$("input[name='form.optionList[" + (index-1) +"].row_number'").val(index);
					//sxt 20220815 add end
				}
				
			});	
		}
		
		function removeOptionRow(n){			
			$("#tbOpthion tr").eq(n).remove();
		}
		
		function doCalSeikyuyotei(){	
			if (calSeikyuyotei()){
				ajaxSeikyuyotei();
			}	
		}
		
		//获取当前索引
		function getCurIndex(x){
			//获取索引值
			var start = x.indexOf("[");
			var end = x.indexOf("]");
			return  parseInt(x.substr(start+1,end-start-1));
		}
		
		//sxt 20230508 add start
		function setTaxDivInput( index ) {
			var tax_div = $("select[name='form.stockDetailModelList[" + index +"].tax_div_input'").val();
			
			//明細税区分未选择的场合，初期値は外税を設定
			if (!tax_div) $("select[name='form.stockDetailModelList[" + index +"].tax_div_input'").val("02");
	
		}
		//sxt 20230508 add end
		
		function calculateAmount( index ) {
			//金額
			var amount;
			
			//単価
			var price = 0;
			if ($("input[name='form.stockDetailModelList[" + index +"].price_per'").val()){
				price = parseFloat($("input[name='form.stockDetailModelList[" + index +"].price_per'").val());
			}
			
			//数量
			var quantity = 0;
			if ($("input[name='form.stockDetailModelList[" + index +"].quantity'").val()){
				quantity = parseFloat($("input[name='form.stockDetailModelList[" + index +"].quantity'").val());
			}
			
			//金額
			amount = price * quantity;
			
			//端数処理
			amount = doProcessing(amount);
	
			if (amount != 0) {
				$("input[name='form.stockDetailModelList[" + index +"].amount'").val(amount);	
			} else {
				$("input[name='form.stockDetailModelList[" + index +"].amount'").val("");	
			}
			
			//合計金額計算
			calculateTotal();
		}
		
		//端数処理
		function doProcessing( amount ) {
			//端数処理
			var processing = $("input[name='form.fraction_processing'").val();

			//01=切り捨て、02=四捨五入、03=切り上げ
			switch (processing) {
			case "01":
				amount = Math.floor(amount);
				break;
			case "02":
				amount = Math.round(amount);
				break;
			case "03":
				amount = Math.ceil(amount);
				break;
			}
			
			return amount;
		}
		function doSomething(){

		}
		
		function ajaxSeikyuyotei(){
			var out_order_code = $('input[name="form.out_order_code_sinki"]').val();
			var order_div = $('select[name="form.order_div_input_sinki"]').val();
			var work_start_date = $('input[name="form.work_start_date_input_sinki"]').val();
			var work_end_date = $('input[name="form.work_end_date_input_sinki"]').val();
			var delivery_date = $('input[name="form.delivery_date_input_sinki"]').val();	//sxt 20221008 add
			
			$.ajax({
		        type: "POST",  
		        url: "calculateOrderDate.action",
		        //sxt 20221008 del start
// 		        data: {out_order_code:out_order_code,
// 		        		order_div:order_div,
// 		        		work_start_date:work_start_date,
// 		        		work_end_date:work_end_date},
		        //sxt 20221008 del end
		        //sxt 20221008 add start
        		data: {out_order_code:out_order_code,
		        		order_div:order_div,
		        		work_start_date:work_start_date,
		        		work_end_date:work_end_date,
		        		delivery_date:delivery_date},
		        //sxt 20221008 add end
		        error: function (request) {  
					alert("error");
		        },
		        success: function (data) {  
		        	
		        	//清空tbody
		        	$("#tbOpthion").html("");
			        	
		        	var list = JSON.parse(data);

					for (var index = 0;index<list.length;index++){
						var trHtml =`
		                   <tr>
                       		 <ww:hidden name="'form.optionList[${ index }].sales_no'"> </ww:hidden>
				        	 <ww:hidden name="'form.optionList[${ index }].reg_id'"> </ww:hidden>
				        	 <ww:hidden name="'form.optionList[${ index }].reg_name'"> </ww:hidden>
				        	 <ww:hidden name="'form.optionList[${ index }].reg_date'"> </ww:hidden>
					        	
	                         <td class="text-center" >
	                           <input type="number" name="form.optionList[${ index }].row_number" 
										value='${ index + 1 }' class="form-control text-right"
										oninput="maxNumberLength(2)" onKeypress="return integerOnly()" />
	                         </td>
	                         <td class="text-center"  >
	                           <input type="date" name="form.optionList[${ index }].order_date" 
										value='${ list[index].order_date }' class="form-control"/>
	                         </td>
	                         <td class="text-center" >
	                           <input type="date" name="form.optionList[${ index }].payment_date" 
										value='${ list[index].payment_date }' class="form-control"/>
	                         </td>
	                         <td class="text-center" >
	                           <input type="number" name="form.optionList[${ index }].order_amount" class="form-control text-right"
	                        	   		oninput="maxNumberLength(13)" onKeypress="return integerOnly()" />
	                         </td>
	                         <td class="text-center" style="vertical-align:middle;">
	                           <ww:checkbox name="'form.optionList[${ index }].checkbox2'" fieldValue="'checkbox'" ></ww:checkbox>
	                         </td>
	                       </tr>`;
					 	$("#tbOpthion").append(trHtml);  
	                       
					}

		        	//重新设定請求予定的行数
		        	$("#optionDetailsize").val(list.length);
		        			        	
		        }
		    });
		}
		
		//合計金額計算
		function calculateTotal(){
			
			//画面.消費税率
			var tax_rate = $("input[name='form.consume_tax_rate_sinki'").val();
			
			//内税金額合計
			var innerProfit = 0;
			//外税金額合計
			var outterProfit = 0;
			//非課税等の金額合計
			var otherProfit = 0;
			//消費税率＝画面.消費税率/100
			var profit = parseFloat(tax_rate) / 100; 
						
			//内税税抜金額
			var innerNoProfit = 0;
			//外税税抜金額
			var outterNoProfit = 0;
			//非課税等の税抜金額
			var otherNoProfit = 0;
			
			var detailsize =  parseInt($("#detailsize").val());
						
			for (var i = 0; i < detailsize; i++) {
				
				//明細金額
				var amountDetail = 0;
				if ($("input[name='form.stockDetailModelList[" + i +"].amount'").val()) {
					amountDetail = parseInt($("input[name='form.stockDetailModelList[" + i +"].amount'").val());
				} 
				
				//明細税区分
				var tax_div = $("select[name='form.stockDetailModelList[" + i +"].tax_div_input'").val();
					
				//明細税区分未选择的场合，按外税（02）计算
				if (!tax_div) tax_div = "02";
				
				if (tax_div == "01") {
					//内税金額合計：税区分が内税の明細行の金額合計
					innerProfit += amountDetail;
				} else if (tax_div == "02") {
					//外税金額合計：税区分が外税の明細行の金額合計
					outterProfit += amountDetail;
				} else {
					//非課税等の金額合計：税区分が外税と内税以外の明細行の金額合計
					otherProfit += amountDetail;
				}
			}
			
			//内税消費税合計
			var innerTaxProfit = 0;
			//外税消費税合計
			var outterTaxProfit = 0;
			//非課税消費税合計
			var otherTaxProfit = 0;
						
			//内税消費税合計：内税金額合計/(1+消費税率)×消費税率 端数処理は「切り捨て」です。
			innerTaxProfit = Math.floor(innerProfit * profit / (1 + profit));
			
			//外税消費税合計：外税金額合計×消費税率 端数処理は得意先マスタ.端数処理です。
			outterTaxProfit = doProcessing(outterProfit * profit);
			
			//消費税合計
			var tax_amount = innerTaxProfit + outterTaxProfit + otherTaxProfit;		
			
// 			if(tax_amount < -999999999999||tax_amount > 999999999999){
// 				alert("消費税がオーバーです。");
// 			}
			
			//内税税抜金額：内税金額合計 - 内税消費税合計 
			innerNoProfit = innerProfit - innerTaxProfit;
			//外税税抜金額：外税金額合計
			outterNoProfit = outterProfit;
			//非課税等の税抜金額：非課税等の金額合計
			otherNoProfit = otherProfit;
			//合計
			var amount = innerNoProfit + outterNoProfit + otherNoProfit;
			
// 			if(amount < -999999999999||amount > 999999999999){
// 				alert("合計がオーバーです。");
// 			}else{
// 				$("#estimate_amount_sinki").text("￥" + amount.toLocaleString());
// 				$("#tax_amount_sinki").text("￥" + tax_amount.toLocaleString());
// 				$("#amount_sinki").text("￥" + (amount + tax_amount).toLocaleString());				
// 			}	
			
			$("#estimate_amount_sinki").text("￥" + amount.toLocaleString());
			$("#tax_amount_sinki").text("￥" + tax_amount.toLocaleString());
			$("#amount_sinki").text("￥" + (amount + tax_amount).toLocaleString());	
		}
	</script>
</html>
