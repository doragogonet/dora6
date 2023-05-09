<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
	<head>
	<ww:include value="'/headContent.jsp'" />
	<title>発注（常駐）修正画面</title>
	<style>
		.flex {
			display: flex;
		}

		.flex-left {
			flex-basis: 36rem;
		}

		.flex-right {
			flex-basis: auto;
		}

		.table>thead>tr>td {
			padding: 0.25rem 0 0.25rem 0;
			vertical-align: top;
			font-weight: bold;
		}

		.table>tbody>tr>td {
			padding: 0.125rem;
			vertical-align: top;
		}
		
		.table > tbody > tr > td input[type=number]:disabled,
		.table > tbody > tr > td input[type=text]:disabled,
		.table > tbody > tr > td input[type=date]:disabled,
		.table > tbody > tr > td select:disabled,
		.table > tbody > tr > td textarea:disabled {
		  width: 100%;
		  border-style: none;    /* 去除边框 */
		  box-shadow: none;      /* 去除阴影 */
		  background-color: #d7d8da
		  /* background-color: #d9edf7;  */
		}
	</style>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
	function deleteUpdateMeisaiHattyu(pForm){
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
				//document.HattyuForm.action="deleteUpdateMeisaiHattyu.action";
				//document.HattyuForm.submit();
				//sxt 20220614 del end
				return true;	//sxt 20220614 add
			}
		}
	}
	
	function doCheckEstimate(name) {
			var value = document.HattyuForm.elements[name].checked;
			if(value == true) {
				document.HattyuForm.elements['form.estimate_amount_flg_update'].value = "1";
			} else {
				document.HattyuForm.elements['form.estimate_amount_flg_update'].value = "0";
			}
		}
	function doCheckTax(name) {
			var value = document.HattyuForm.elements[name].checked;
			if(value == true) {
				document.HattyuForm.elements['form.tax_amount_flg_update'].value = "1";
			} else {
				document.HattyuForm.elements['form.tax_amount_flg_update'].value = "0";
			}
		}
	function doCheckAmount(name) {
			var value = document.HattyuForm.elements[name].checked;
			if(value == true) {
				document.HattyuForm.elements['form.amount_flg_update'].value = "1";
			} else {
				document.HattyuForm.elements['form.amount_flg_update'].value = "0";
			}
		}
	function priceCalAmount(pForm,index){
	
		var amount =0;
		var price =  document.HattyuForm.elements['form.stockDetailModelList_update['+index +'].price_per'].value;
		var quantity = document.HattyuForm.elements['form.stockDetailModelList_update['+index +'].quantity'].value;
		var fraction_processing = "";
		if(document.HattyuForm.elements['form.fraction_processing_update']!=null){
			fraction_processing = document.HattyuForm.elements['form.fraction_processing_update'].value;
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
		document.HattyuForm.elements['form.stockDetailModelList_update['+index +'].amount'].value = amount;	
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
	function deleteUpdateHattyu(pForm){
		if (confirm("削除してよろしいでしょうか？")==true){
			document.HattyuForm.action="deleteUpdateHattyu2.action";
			document.HattyuForm.submit();
		}
	}
	function deleteUpdateHattyuTOP(pForm){
		if (confirm("削除してよろしいでしょうか？")==true){
			document.HattyuForm.action="deleteUpdateHattyuTOP2.action";
			document.HattyuForm.submit();
		}
	}
	//sxt 20220721 add start
	function deleteUpdateHattyuFromProject(pForm){
		if (confirm("削除してよろしいでしょうか？")==true){
			document.HattyuForm.action="deleteUpdateHattyu2FromProject.action";
			document.HattyuForm.submit();
		}
	}
	function deleteUpdateHattyuTOPFromProject(pForm){
		if (confirm("削除してよろしいでしょうか？")==true){
			document.HattyuForm.action="deleteUpdateHattyuTOP2FromProject.action";
			document.HattyuForm.submit();
		}
	}
	//sxt 20220721 add end
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
		
// 		var seikyukubun = document.HattyuForm.elements['form.order_div_input_update'].value;
// 		if (seikyukubun != '01') {
// 			//message[message.length] = '請求区分は「単月」の場合のみ作成できます。';
// 			alert('請求区分は「単月」の場合のみ作成できます。');
// 			return;
// 		}
		
// 		var kaityusaki = document.HattyuForm.elements['form.out_order_code_update'].value;
// 		if (kaityusaki == '') {
// 			message[message.length] = '外注先が入力必須です。';
// 		}
		
// 		var work_start_date = document.HattyuForm.elements['form.work_start_date_year_update'].value + document.HattyuForm.elements['form.work_start_date_month_update'].value + document.HattyuForm.elements['form.work_start_date_day_update'].value
// 		var work_end_date = document.HattyuForm.elements['form.work_end_date_year_update'].value + document.HattyuForm.elements['form.work_end_date_month_update'].value + document.HattyuForm.elements['form.work_end_date_day_update'].value
		
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
// 			var order_amount =  document.HattyuForm.elements['form.optionList['+ index +'].order_amount'].value;
			
// 			if (orderYear != '' || orderMonth != '' || orderDay != '' || paymentYear != '' || paymentMonth != '' || paymentDay != '' || order_amount != '') {
// 				message[message.length] = '請求予定日、支払予定日、請求予定金額を全部クリアしてから、もう一度作成してください。';
// 				break;
// 			}
// 		}
		
// 		if(message.length > 0){
// 			alert(message.join('\n'));
// 			return;
// 		}
		
// 		submitAction(pForm,'calculateEditOrderDate.action')

// 	}
	//sxt 20220614 del end
	
	//sxt 20220614 add start
	function calSeikyuyotei(){
		
		var message = new Array();

		var seikyukubun = document.HattyuForm.elements['form.order_div_input_update'].value;
		//sxt 20221008 del start
// 		if (seikyukubun != '01') {
// 			//message[message.length] = '請求区分は「単月」の場合のみ作成できます。';
// 			alert('請求区分は「単月」の場合のみ作成できます。');
// 			return;
// 		}
		//sxt 20221008 del end
		
		var kaityusaki = document.HattyuForm.elements['form.out_order_code_update'].value;
		if (kaityusaki == '') {
			message[message.length] = '外注先が入力必須です。';
		}
				
		if (seikyukubun == '01') {		//sxt 20221008 add
			var work_start_date = document.HattyuForm.elements['form.work_start_date_input_update'].value.replace(/-/g,"");
			var work_end_date = document.HattyuForm.elements['form.work_end_date_input_update'].value.replace(/-/g,"");
			
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
			var delivery_date = document.HattyuForm.elements['form.delivery_date_input_update'].value.replace(/-/g,"");
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
				//document.HattyuForm.action="hattyuOptionEditDeleteRow.action";
				//document.HattyuForm.submit();
				//sxt 20220614 del end
				return true;	//sxt 20220614 add
			}
		}
	}
	
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
		}*/
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
          発注（常駐）修正画面
          <ww:include value="'/loginName.jsp'"/>           
        </div>
        <div class="panel panel-default">
          <div class="panel-body">
          	<ww:include value="'/message.jsp'" />
              
              <!--button-->              
              <div class="form-group">
                <div>
                	<ww:if test="form.msgId=='top'">
                		<!-- sxt 20220712 del start -->
<!--                 		<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSaveTop.action');">戻る</button> -->
                		<!-- sxt 20220712 del end -->
                		<!-- sxt 20220712 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSaveTop.action');">戻る</button>
						</ww:else>
						<!-- sxt 20220712 add end -->
						<!-- sxt 20220721 del start -->
<!--                   		<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyuTop2.action');">保存</button> -->
<%--                   		<ww:if test="form.stock_count==1"> --%>
<!-- 							<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuTOP(this.form);">削除</button> -->
<%-- 						</ww:if> --%>
						<!-- sxt 20220721 del end -->
						<!-- sxt 20220721 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyuTop2FromProject.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuTOPFromProject(this.form);">削除</button>
							</ww:if>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyuTop2.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuTOP(this.form);">削除</button>
							</ww:if>
						</ww:else>
						<!-- sxt 20220721 add end -->
                	</ww:if>
					<ww:else>
						<!-- sxt 20220712 del start -->
<!-- 						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshHattyu.action');">戻る</button> -->
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
<!--                   		<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyu2.action');">保存</button> -->
<%--                   		<ww:if test="form.stock_count==1"> --%>
<!-- 							<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyu(this.form);">削除</button> -->
<%-- 						</ww:if> --%>
						<!-- sxt 20220721 del end -->
						<!-- sxt 20220721 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyu2FromProject.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuFromProject(this.form);">削除</button>
							</ww:if>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyu2.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyu(this.form);">削除</button>
							</ww:if>
						</ww:else>
						<ww:if test="form.approval_div_code_update.equals('03')">
							<button type="button" class="btn btn-primary dora-sm-button"
								onclick="openWindowResizable('hattyuPrint2.action?form.receive_no=<ww:property value='form.receive_no_update'/>&form.order_no_print=<ww:property value='form.order_no_update'/>','御発注書印刷',800,600);">印刷</button>
						</ww:if>
						<!-- sxt 20220721 add end -->
					</ww:else>
                </div>
              </div>
              
              <!--状態区域-->
              <div class="panel-body" style="padding:1.75rem 1rem">
<%--                 <div class="dora-state-zone">契約形態(<ww:property value='form.contract_form_name'/>)</div> --%>		<!-- sxt 20221008 del -->
				<!-- sxt 20221008 add start -->
				<div class="dora-state-zone form-inline">
					<label class="dora-label-left">契約形態</label>
	                <ww:select name="'form.contract_form'"
						       cssClass="'form-control'" 
						       list="form.contractFormList" 
						       listKey="code_id" 
						       listValue="code_value" 
						       value="form.contract_form" >
				    </ww:select>
				</div>
			    <!-- sxt 20221008 add end -->
                <%-- <div class="dora-state-zone">月次締<ww:property value='form.month_close_flg_name'/></div> --%>	<!-- sxt 20230201 del -->
<%--                 <div class="dora-state-zone">請求区分　<ww:property value='form.order_div_name'/></div> --%>		<!-- sxt 20221008 del -->
				<!-- sxt 20221008 add start -->
				 <div class="dora-state-zone">請求区分　単月</div>
				 <ww:hidden name="'form.order_div_input_update'" value="'01'"></ww:hidden>
				 <!-- sxt 20221008 add end -->
                
                <div class="dora-state-zone form-inline">
                	<label class="dora-label-right">発注担当者</label>
                    <ww:select name="'form.order_in_code_update'"
			              size="'1'" 
					      cssClass="'form-control'" 
					      list="form.order_in_nameForSellist" 
					      listKey="person_in_charge_code" 
					      listValue="person_in_charge_name" 
					      value="form.order_in_code_update"  >
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
<%--                         <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo2.action?form.pageFlg=7&form.receive_no=<ww:property  value="form.receive_no_update" />')"> --%>
<%--                         	<ww:property  value="form.receive_no_update" /> --%>
<!--                         </label> -->
                        <!-- sxt 20221010 del end -->
                        
                        <!-- sxt 20221010 add start -->
						<ww:if test="form.jyutyuShurui.equals(\"2\")">
	                        <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=7&hattyuShurui=<ww:property value="form.shurui"/>&form.receive_no=<ww:property  value="form.receive_no_update" />')">
	                        	<ww:property  value="form.receive_no_update" />
	                        </label>
						</ww:if>
						<ww:else>
	                        <label class="dora-label-normal btn-link" onclick="hrefHaveParamAction('jyutyuInfo2.action?form.pageFlg=7&hattyuShurui=<ww:property value="form.shurui"/>&form.receive_no=<ww:property  value="form.receive_no_update" />')">
	                        	<ww:property  value="form.receive_no_update" />
	                        </label>
						</ww:else>
						<!-- sxt 20221010 add end -->
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">得意先</label>
                        <label class="dora-label-normal"><ww:property  value="form.customer_code_update" />　<ww:property value="form.customer_name_update" /></label>
                        <ww:hidden name ="'form.fraction_processing_update'"/>	
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">件名 </label>
                        <label class="dora-label-normal"><ww:property value="form.receive_name1_update" />　<ww:property value="form.receive_name2_update" /></label>
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left">作業期間 </label>
                        <label class="dora-label-normal"><ww:property value="form.work_start_date_update" />　～　<ww:property value="form.work_end_date_update" /></label>
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
                        <label class="dora-label-left">発注番号</label>
                        <ww:property value="form.order_no_update" />
                        <label class="dora-label-right-require">発注日付</label>
                        <input type="date" name="form.order_date_update" value="<ww:property value='form.order_date_update'/>" class="form-control">
                        
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">外注先</label>
                        <input type="hidden" id="out_order_code_old">		
                        <input type="text" name="form.out_order_code_update" id="out_order_code" value="<ww:property value='form.out_order_code_update'/>" maxlength="8" class="form-control " placeholder="外注先コード">
                        <input type="text" name="form.out_order_name_update" id="out_order_name" value="<ww:property value='form.out_order_name_update'/>" class="form-control" style="width:40rem;" readonly>
              			<input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initGaityuusakiGuide.action?form.fieldName_code=form.out_order_code_update&form.fieldName_name=form.out_order_name_update&form.processing=form.processing','外注先参照',670,770)" />
			  			<ww:hidden name="'form.processing'"> </ww:hidden>

                        <label class="dora-label-right-require">外注お見積番号 </label>
                        <input type="text" name="form.out_estimate_no_update" value="<ww:property value='form.out_estimate_no_update'/>" maxlength="20"  class="form-control" placeholder="外注お見積番号 ">
                      </div>

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">件名</label>
                        <input type="text" name="form.order_name1_input_update" value="<ww:property value='form.order_name1_input_update'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名１">
                        <input type="text" name="form.order_name2_input_update" value="<ww:property value='form.order_name2_input_update'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名２">
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
<%--                         <ww:select name="'form.delivery_status_input_update'" --%>
<%-- 							       cssClass="'form-control'"  --%>
<%-- 							       list="form.delivery_status_update"  --%>
<%-- 							       listKey="code_id"  --%>
<%-- 							       listValue="code_value"  --%>
<%-- 							       value="form.delivery_status_input_update" > --%>
<%-- 						</ww:select> --%>

<!--                         <label class="dora-label-right">請求区分</label> -->
<!-- 							単月 -->
<%-- 							<ww:hidden name="'form.order_div_input_update'" value="'01'"></ww:hidden>	<!-- sxt 20220930 add --> --%>
<!--                       </div> -->
                      <!-- sxt 20221008 del end -->

                      <div class="form-group form-inline">
                        <label class="dora-label-left-require">作業期間</label>
                        <input type="date" name="form.work_start_date_input_update" value="<ww:property value='form.work_start_date_input_update'/>" class="form-control">
                        <label>～</label>  
                        <input type="date" name="form.work_end_date_input_update" value="<ww:property value='form.work_end_date_input_update'/>" class="form-control">
                        
                        <label class="dora-label-right-require">消費税率(%)</label>
						<input type="number" name="form.consume_tax_rate_update" value="<ww:property value='form.consume_tax_rate_update'/>" class="form-control" style="width: 8rem;" placeholder="税率(%)"  
								oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
						
						<!-- sxt 20221008 add start -->		
						<label class="dora-label-right">納品状態</label>
                        <ww:select name="'form.delivery_status_input_update'"
							       cssClass="'form-control'" 
							       list="form.delivery_status_update" 
							       listKey="code_id" 
							       listValue="code_value" 
							       value="form.delivery_status_input_update" >
						</ww:select>
						<!-- sxt 20221008 add end -->		
                      </div>

                      <div class="form-group form-inline">
                        <label class=" dora-label-left">支払条件</label>
                        <label class="dora-label-normal">検収日</label>  
                        <input type="text" name="form.payment_condition1_update" value="<ww:property value='form.payment_condition1_update'/>" id="payment_condition1" maxlength="60" class="form-control" style="width:12rem;" readonly>
  
                        <label class="dora-label-normal" style=" padding-left:3rem;">支払日</label>  
                        <input type="text" name="form.payment_condition2_update" value="<ww:property value='form.payment_condition2_update'/>" id="payment_condition2" maxlength="60" class="form-control" style="width:12rem;">

                        <label class="dora-label-right">納品予定日</label>
                        <input type="hidden" name="form.delivery_date_update" value="<ww:property value='form.delivery_date_update'/>">
                        <input type="date" name="form.delivery_date_input_update" value="<ww:property value='form.delivery_date_input_update'/>" class="form-control">
                      </div>
                      
                      <div class="form-group flex" style="padding-top:1rem;">
						<div class="flex-left" style="padding-left:0.625rem;">
							<label for="estimate_date">精算方法</label>
							<!-- sxt 20220914 add start -->
							<ww:if test="form.payment_method.equals(\"1\")">
								<ww:checkbox name="'form.payment_method_chk'" fieldValue="'form.payment_method'" value="1"></ww:checkbox>
							</ww:if>
							<ww:else>
								<ww:checkbox name="'form.payment_method_chk'" fieldValue="'form.payment_method'" value="0"></ww:checkbox>
							</ww:else>
							<!-- sxt 20220914 add end -->
							
							<table class="table table-bordered" id="payment_method1">
								<tr>
									<td colspan="3" class="text-center">月間作業基準時間（H）</td>
								</tr>
								<tr>
									<td style="border-right-width:0px;">
										<input type="number" id="work_time_from" name="form.work_time_from" value="<ww:property value='form.work_time_from'/>" class="form-control"
											placeholder="月間作業基準時間開始"  oninput="maxNumberLength(4)" onKeypress="return integerOnly()"/>
									</td>
									<td class="text-center"
										style="vertical-align:middle;border-left-width: 0px;border-right-width:0px;">
										～</td>
									<td style="border-left-width:0px;">
										<input type="number" id="work_time_to" name="form.work_time_to" value="<ww:property value='form.work_time_to'/>" class="form-control"
											placeholder="月間作業基準時間終了" oninput="maxNumberLength(4)" onKeypress="return integerOnly()"/>
									</td>
								</tr>
								<!-- sxt 20220922 del start -->
<!-- 								<tr> -->
<!-- 									<td colspan="3" class="text-center">月標準時間（H）</td> -->
<!-- 								</tr> -->
<!-- 								<tr> -->
<!-- 									<td colspan="3"> -->
<%-- 										<input type="number" id="standard_time" name="form.standard_time" value="<ww:property value='form.standard_time'/>" class="form-control"  --%>
<!-- 											placeholder="月標準時間" oninput="if(value.length>4)value=value.slice(0,4)"> -->
<!-- 									</td> -->
<!-- 								</tr> -->
								<!-- sxt 20220922 del end -->
							</table>
						</div>
						<div class="flex-right" style="padding-left:2rem;">
							<label for="estimate_date">　</label>
							<table class="table table-bordered" id="payment_method2">
								<tbody>
									<tr>
										<!-- sxt 20221031 del start -->
<!-- 										<td colspan="2" -->
<!-- 											style="width: 15rem;vertical-align:middle;">　</td> -->
										<!-- sxt 20221031 del end -->
										<!-- sxt 20221031 add start -->	
										<td class="text-center"
											style="width: 15rem;vertical-align:middle;">精算単位
										</td>
										<td>
									    	<input type="text" name="form.time_unit" value="<ww:property value='form.time_unit'/>" maxlength="20" class="form-control" placeholder="精算単位">
										</td>
										<!-- sxt 20221031 add end -->
									</tr>
									<tr>
										<td class="text-center" style="border-bottom:0;">
											<div class="checkbox">
												<label>
													超過時間精算：
												</label>
											</div>
										</td>
										<td style="border:0;padding: 0.5rem 0.5rem 0 0.5rem;">
											<input type="text" id="work_time_to1" class="form-control text-right"  value="<ww:property value='form.work_time_to'/>"
												style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
											時間を超えた時間数を超過時間とする。
										</td>
									</tr>
									<tr>
										<td style="border-top:0;border-bottom:0;"></td>
										<td style="border:0;padding: 0 0.5rem 0.75rem 0.5rem;">
											超過単価：月額単価<span
												style="font:1rem Verdana,Arial,Tahoma;"> ÷ </span>
											<input type="text" id="work_time_to2" class="form-control text-right" value="<ww:property value='form.work_time_to'/>"
												style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
											時間
										</td>
									</tr>
									<tr>
										<td style="border-top:0;border-bottom:0;"></td>
										<td style="border:0;padding: 0 0.5rem 0.5rem 0.5rem;">
											精算方式：超過単価<span
												style="font:1rem Verdana,Arial,Tahoma;"> ×
											</span>超過時間
										</td>
									</tr>
									
									<tr>
										<td class="text-center" style="border-bottom:0;">
											<div class="checkbox">
												<label>
													控除時間精算：
												</label>
											</div>
										</td>
										<td style="border-bottom:0;padding: 0.5rem 0.5rem 0 0.5rem;">
											<input type="text" id="work_time_from1" class="form-control text-right" value="<ww:property value='form.work_time_from'/>"
												style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
											時間に満たない時間数を控除時間とする。
										</td>
									</tr>
									<tr>
										<td style="border-top:0;border-bottom:0;"></td>
										<td style="border:0;padding: 0 0.5rem 0.75rem 0.5rem;">
											控除単価：月額単価<span
												style="font:1rem Verdana,Arial,Tahoma;"> ÷ </span>
											<input type="text" id="work_time_from2" class="form-control text-right"  value="<ww:property value='form.work_time_from'/>"
												style="height:1rem;width:6rem;display:inline;background-color:#fff" readonly>
											時間
										</td>
									</tr>
									<tr>
										<td style="border-top:0;border-bottom:0;"></td>
										<td style="border:0;padding: 0 0.5rem 0.5rem 0.5rem;">
											精算方式：控除単価<span
												style="font:1rem Verdana,Arial,Tahoma;"> ×
											</span>控除時間
										</td>
									</tr>
									
								</tbody>

							</table>
						</div>
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
							<td class="text-center" style="width:4.5rem;" rowspan="2">行</td>
							<!-- <td class="text-center" style="width:40rem;" rowspan="2">内容</td> -->	<!-- sxt 20230117 del -->
							<td class="text-center" style="width:40rem;" rowspan="2">作業者</td>			<!-- sxt 20230117 add -->
							<td class="text-center" style="width:8rem;" rowspan="2"></td>
							<td class="text-center" style="width:15rem;" rowspan="2">単価（円）</td>
							<td class="text-center" style="width:15rem;" rowspan="2">超過単価（円）</td>
							<td class="text-center" style="width:15rem;" rowspan="2">控除単価（円）</td>
<!-- 							<td class="text-center" style="width:10rem;" rowspan="2">そのた（円）</td> -->	<!-- sxt 20221024 del -->
							<td class="text-center" style="width:10rem;">工数</td>
							<td class="text-center" style="width:15rem;" rowspan="2">金額（円）</td>
							<td class="text-center" style="width:45rem;" rowspan="2">備考</td>
<!-- 							<td class="text-center" style="width:5rem;" rowspan="2">削除</td> -->
                          </tr>
                          <ww:hidden name="'detailsize'" id="detailsize" value="form.stockDetailModelList_update.size()"></ww:hidden>
                        </thead>
                        
                        <tbody id="tbAddPart">
                        <%int temp = 0 ;%>
						<ww:iterator value="form.stockDetailModelList_update" status="rows" id="model">
                          <tr>
                            <td class="text-center" rowspan="2" style="width:4.25rem;" nowrap>
                              <input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].row_number" 
									value='<ww:property value="form.stockDetailModelList_update[#rows.index].row_number"/>' class="form-control text-right"
									oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
                            </td>
                            <td class="text-center" style="border-bottom: none;">
                              <div class="flex">
				  			    <ww:hidden name="'form.stockDetailModelList_update['+#rows.index+'].task_code'" value="form.stockDetailModelList_update[#rows.index].task_code" />
<%-- 				  			    <ww:hidden name="'form.stockDetailModelList_update['+#rows.index+'].task_code_old'" /> --%>
				  			    
                              	<input type="text" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].task_content" 
										value='<ww:property value="form.stockDetailModelList_update[#rows.index].task_content"/>'  class="form-control" />
<%--                                 <input type="button" value="参照" class="btn btn-primary dora-tabel-button" onclick="openWindowWithScrollbarGuide('initialSagyousyaGuide.action?form.fieldName_code=form.stockDetailModelList_update[<%=temp%>].task_code&form.fieldName_name=form.stockDetailModelList_update[<%=temp%>].task_content&form.company_name=form.stockDetailModelList_update[<%=temp%>].company_name&form.sagyousya_flg=2','技術者参照',670,600)">			 --%>
                              		<input type="button" value="参照" class="btn btn-primary dora-tabel-button" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].btn" />
                              </div>
                              
                            </td>
                            <td rowspan="2" class="text-center" style="width:6.75rem;" nowrap>
                              <ww:select name="'form.stockDetailModelList_update['+#rows.index+'].time_kbn'"
								       cssClass="'form-control'"
								       list="form.timeKbnList" 
								       listKey="code_id" 
								       listValue="code_value" 
								       value="time_kbn"
								       headerKey="''"
								       headerValue="''">
						    	</ww:select>
                            </td>
                            <td rowspan="2" class="text-center">
                            	<!-- sxt 20221024 add start -->
								<ww:if test="time_kbn.equals('')">
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].price_per" 
											value="<ww:property value='form.stockDetailModelList_update[#rows.index].price_per'/>" class="form-control text-right"
											readonly style="background-color:#fff"/>
								</ww:if>
								<ww:else>
								<!-- sxt 20221024 add end -->
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].price_per" 
											value="<ww:property value='form.stockDetailModelList_update[#rows.index].price_per'/>" class="form-control text-right"
											oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
								</ww:else>	<!-- sxt 20221024 add -->
                            </td>
                            <ww:if test="time_kbn.equals('01')">
                            	<td rowspan="2" class="text-center">
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].more_price" 
										value="<ww:property value='form.stockDetailModelList_update[#rows.index].more_price'/>" class="form-control text-right"
										oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
								</td>
								<td rowspan="2" class="text-center">
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].less_price" 
										value="<ww:property value='form.stockDetailModelList_update[#rows.index].less_price'/>" class="form-control text-right"
										oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
								</td>
                            </ww:if>
							<ww:else>
								<td rowspan="2" class="text-center">
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].more_price" 
										value="<ww:property value='form.stockDetailModelList_update[#rows.index].more_price'/>" class="form-control text-right"
										readonly style="background-color:#fff" />
								</td>
								<td rowspan="2" class="text-center">
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].less_price" 
										value="<ww:property value='form.stockDetailModelList_update[#rows.index].less_price'/>" class="form-control text-right"
										readonly style="background-color:#fff" />
								</td>
							</ww:else>
                            
                            <!-- sxt 20221024 del start -->	
<!-- 							<td rowspan="2"> -->
<%--                               <input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].other_price"  --%>
<%-- 									value="<ww:property value='form.stockDetailModelList_update[#rows.index].other_price'/>" class="form-control text-right" --%>
<!-- 									oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/> -->
<!--                             </td> -->
                            <!-- sxt 20221024 del end -->
                            <td rowspan="2">
                            	<!-- sxt 20221024 add start -->
                            	<input type="hidden" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].other_price" 
									value="<ww:property value='form.stockDetailModelList_update[#rows.index].other_price'/>"/>
								<ww:if test="time_kbn.equals('')">
									<input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].quantity" 
											value="<ww:property value='form.stockDetailModelList_update[#rows.index].quantity'/>" class="form-control text-right"
											readonly style="background-color:#fff" /> 
								</ww:if>
								<ww:else>	
                            	<!-- sxt 20221024 add end --> 
		                             <input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].quantity" 
											value="<ww:property value='form.stockDetailModelList_update[#rows.index].quantity'/>" class="form-control text-right"
											oninput="maxNumberLength(8)" onkeypress="return integerAndDecimal()" onchange="decimalLength(8,3)"/> 
								</ww:else> <!-- sxt 20221024 add -->
                            </td>
                            <!-- <td rowspan="2"> --><!-- sxt 20230508 del -->
                            <td>					 <!-- sxt 20230508 add -->
                              <input type="number" name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].amount" 
										value="<ww:property value='form.stockDetailModelList_update[#rows.index].amount'/>" class="form-control text-right"
										readonly style="background-color:#fff" />
                            </td>
                            <td class="text-center" rowspan="2">
								<ww:textarea name="'form.stockDetailModelList_update['+#rows.index+'].biko'" value="biko" cssClass="'form-control'" rows="3"></ww:textarea>
							</td>
<!--                             <td class="text-center" rowspan="2"> -->
<%--                               <ww:checkbox name="'form.stockDetailModelList_update['+#rows.index+'].isCheck'" fieldValue="'1'"></ww:checkbox> --%>
<!--                             </td> -->
                          </tr>
                          <tr>
                            <td style="border-top: none;">
								<input type=text disabled name="form.stockDetailModelList_update[<ww:property value='#rows.index'/>].company_name" 
									value="<ww:property value='form.stockDetailModelList_update[#rows.index].company_name'/>" style="background-color: #ffffff;" />	 
							</td>
							<!-- sxt 20230508 add start -->
                            <td class="text-center" >
								<ww:select size="1" name="'form.stockDetailModelList_update['+#rows.index+'].tax_div_input'" 
										   cssClass="'form-control'" 
										   list="tax_div_list" 
										   listKey="code_id" 
										   listValue="code_value" 
										   value="tax_div_input" 
										   headerKey="''"
										   headerValue="''"								   
								>
								</ww:select>
                            </td>
                            <!-- sxt 20230508 add end -->
                          </tr>
                          <% temp = temp +1 ;%>
                          </ww:iterator>
                        </tbody>
                        
                        <tfoot>
                          <tr>
                            <td class="text-center" colspan="4" rowspan="3"></td>
                            <!-- <td class="text-center" colspan="2">合 計</td> --><!-- sxt 20230508 del -->
                            <!-- sxt 20230508 add start -->
                            <td colspan="2">
	                      		<div class="checkbox" style="padding-left: 12rem;">
									<label>
										<ww:if test="form.estimate_amount_flg_update.equals(\"1\")">
											<ww:checkbox name="'form.estimate_amount_flg_chk'" fieldValue="form.estimate_amount_flg_update" value="1" onclick="'doCheckEstimate(this.name);'"></ww:checkbox>
										</ww:if>
										<ww:else>
											<ww:checkbox name="'form.estimate_amount_flg_chk'" fieldValue="form.estimate_amount_flg_update" value="0" onclick="'doCheckEstimate(this.name);'"></ww:checkbox>
										</ww:else>
										合 計
									</label>
								</div>
                            </td>
                            <!-- sxt 20230508 add end -->
                            <td class="text-right" colspan="2">
                            	<label id="estimate_amount_update"><ww:property value="form.estimate_amount_update"/></label>
                            </td>
                            <td rowspan="3"></td>
                          </tr>
                          <tr>
                            <!-- <td class="text-center" colspan="2">消 費 税</td> --><!-- sxt 20230508 del -->
                            <!-- sxt 20230508 add start -->
                            <td colspan="2">
                            	<div class="checkbox" style="padding-left: 12rem;">
									<label>
										<ww:if test="form.tax_amount_flg_update.equals(\"1\")">
											<ww:checkbox name="'form.tax_amount_flg_chk'" fieldValue="form.tax_amount_flg_update" value="1" onclick="'doCheckTax(this.name)'"></ww:checkbox>
										</ww:if>
										<ww:else>
											<ww:checkbox name="'form.tax_amount_flg_chk'" fieldValue="form.tax_amount_flg_update" value="0" onclick="'doCheckTax(this.name)'"></ww:checkbox>
										</ww:else>
										消 費 税
									</label>
								</div>
                            </td>
                            <!-- sxt 20230508 add end -->
                            <td class="text-right" nowrap colspan="2">
                            	<label id="tax_amount_update"><ww:property value="form.tax_amount_update"/></label>
                            </td>
                          </tr>
                          <tr>
                            <!-- <td class="text-center" colspan="2">税込合計</td> --><!-- sxt 20230508 del -->
                            <!-- sxt 20230508 add start -->
                            <td colspan="2">
                            	<div class="checkbox" style="padding-left: 12rem;">
									<label>
										<ww:if test="form.amount_flg_update.equals(\"1\")">
											<ww:checkbox name="'form.amount_flg_chk'" fieldValue="form.amount_flg_update" value="1" onclick="'doCheckAmount(this.name)'"></ww:checkbox>
										</ww:if>
										<ww:else>
											<ww:checkbox name="'form.amount_flg_chk'" fieldValue="form.amount_flg_update" value="0" onclick="'doCheckAmount(this.name)'"></ww:checkbox>
										</ww:else>
										税込合計
									</label>
								</div>
                            </td>
                            <!-- sxt 20230508 add end -->
                            <td class="text-right" nowrap colspan="2">
                            	<label id="amount_update"><ww:property value="form.amount_update"/></label>
                            </td>
                          </tr>
                        </tfoot>
                        
                      </table>
                      
<!--                       <div class="form-group" style="margin-bottom:1rem;"> -->
<!--                         <div> -->
<!--                           <button type="button" class="btn btn-primary" id="addRow">明細行追加</button> -->
<!-- 						  <button type="button" class="btn btn-primary" id="deleteRow">明細削除</button> -->
<!--                         </div> -->
<!--                       </div> -->
                      
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
<!--                       	<button type="button" class="btn btn-primary" onclick="submitAction(this.form,'hattyuOptionEditAddRow.action');">明細行追加</button> -->
<!--                   		<button type="button" class="btn btn-primary" onclick="optionDeleteRow(this.form);">明細削除</button> -->
                  		<button type="button" class="btn btn-primary" id="optionAddRow">明細行追加</button>
                  		<button type="button" class="btn btn-primary" id="optionDeleteRow">明細削除</button>
<!--                         <button type="button" class="btn btn-primary" onclick="calSeikyuyotei(this.form);">請求予定作成</button> -->
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
                  <textarea name="form.remark_update" class="form-control" rows="5" placeholder="備考"><ww:property value='form.remark_update'/></textarea>
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
                	<ww:if test="form.msgId=='top'">
                		<!-- sxt 20220712 del start -->
<!--                 		<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSaveTop.action');">戻る</button> -->
                		<!-- sxt 20220712 del end -->
                		<!-- sxt 20220712 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshSaveTop.action');">戻る</button>
						</ww:else>
						<!-- sxt 20220712 add end -->
						<!-- sxt 20220721 del start -->
<!--                   		<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyuTop2.action');">保存</button> -->
<%--                   		<ww:if test="form.stock_count==1"> --%>
<!-- 							<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuTOP(this.form);">削除</button> -->
<%-- 						</ww:if> --%>
						<!-- sxt 20220721 del end -->
						<!-- sxt 20220721 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyuTop2FromProject.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuTOPFromProject(this.form);">削除</button>
							</ww:if>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyuTop2.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuTOP(this.form);">削除</button>
							</ww:if>
						</ww:else>
						<!-- sxt 20220721 add end -->
                	</ww:if>
					<ww:else>
						<!-- sxt 20220712 del start -->
<!-- 						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'refreshHattyu.action');">戻る</button> -->
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
<!--                   		<button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyu2.action');">保存</button> -->
<%--                   		<ww:if test="form.stock_count==1"> --%>
<!-- 							<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyu(this.form);">削除</button> -->
<%-- 						</ww:if> --%>
						<!-- sxt 20220721 del end -->
						<!-- sxt 20220721 add start -->
						<ww:if test="form.modoruFlg.equals(\"1\")">
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyu2FromProject.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyuFromProject(this.form);">削除</button>
							</ww:if>
						</ww:if>
						<ww:else> 
						    <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'saveUpdateHattyu2.action');">保存</button>
	                  		<ww:if test="form.stock_count==1">
								<button type="button" class="btn btn-primary dora-sm-button" onclick="deleteUpdateHattyu(this.form);">削除</button>
							</ww:if>
						</ww:else>
						<ww:if test="form.approval_div_code_update.equals('03')">
							<button type="button" class="btn btn-primary dora-sm-button"
								onclick="openWindowResizable('hattyuPrint2.action?form.receive_no=<ww:property value='form.receive_no_update'/>&form.order_no_print=<ww:property value='form.order_no_update'/>','御発注書印刷',800,600);">印刷</button>
						</ww:if>
						<!-- sxt 20220721 add end -->
					</ww:else>
                </div>
              </div>
          </div>
        </div>
      </div>
      <ww:hidden name="'form.payment_method'" > </ww:hidden><!-- sxt 20220914 add -->
      <!-- sxt 20230508 add start -->
      <ww:hidden name="'form.estimate_amount_flg_update'" > </ww:hidden>
	  <ww:hidden name="'form.tax_amount_flg_update'"> </ww:hidden>
	  <ww:hidden name="'form.amount_flg_update'"> </ww:hidden>
	  <!-- sxt 20230508 add end -->
      <ww:include value="'/footer.jsp'" />
    </div>
	</form>

	</body>
	<ww:include value="'/footerJs.jsp'" />
	<script language="JavaScript">
	
		$(document).ready(function(){
			
			//sxt 20220914 add start#
			/* 精算方法*/
			var payment_method = $("input[name='form.payment_method']").val();		
			if (payment_method == '1'){
				$("#payment_method1").show();
				$("#payment_method2").show();
			} else {
				$("#payment_method1").hide();
				$("#payment_method2").hide();
			}
			//sxt 20220914 add end
			
			//合計金額計算
			calculateTotal();
			
			//明細部のイベント绑定
			bingDetailEvent();
			
			//明細行追加
			$("#addRow").click(function(){
				
				$.ajax({
			        type: "POST",  
			        url: "addUpdateHattyu2.action",
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
				
				if (deleteUpdateMeisaiHattyu()) {
					$.ajax({
				        type: "POST",  		        
	 			        dataType:"html",
				        url: "deleteUpdateMeisaiHattyu2.action",
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

								$("input[name^='form.stockDetailModelList_update'][name$='row_number']").each(function() {
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
	
			/* 月間作業基準時間開始blurイベント*/
			$("#work_time_from").blur(function(){
				$("#work_time_from1").val($("#work_time_from").val());
				$("#work_time_from2").val($("#work_time_from").val());
			});
			
			/* 月間作業基準時間終了blurイベント*/
			$("#work_time_to").blur(function(){
				$("#work_time_to1").val($("#work_time_to").val());
				$("#work_time_to2").val($("#work_time_to").val());
			});
			
			//請求予定明細行追加
			$("#optionAddRow").click(function(){
				
				$.ajax({
			        type: "POST",  
			        url: "hattyuOptionEditAddRow.action",
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
				        url: "hattyuOptionEditDeleteRow.action",
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
						
			//sxt 20220914 add start
			/* 精算方法changeイベント*/
			$("input[name='form.payment_method_chk']").change(function(){
				if ($("input[name='form.payment_method_chk']").is(':checked')){
					$("input[name='form.payment_method']").val("1");
					$("#payment_method1").show();
					$("#payment_method2").show();
				} else {
					$("input[name='form.payment_method']").val("0");
					$("#payment_method1").hide();
					$("#payment_method2").hide();
				}
			});
			//sxt 20220914 add end
		});
		
		//明細部のイベント绑定
		function bingDetailEvent(){
			
			/* 参照clickイベント*/
			$("input[name$='btn']").click (function(){
				var code = $("#out_order_code").val();
				var name = $("#out_order_name").val();
				if (!code){
					alert("外注先コードを入力してください。");
					return false;
				}
				
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				openWindowWithScrollbarGuide('initialSagyousyaGuide.action?form.company_code=' + code + '&form.company_name_in=' + name + '&form.fieldName_code=form.stockDetailModelList_update[' + index + '].task_code&form.fieldName_name=form.stockDetailModelList_update[' + index + '].task_content&form.company_name=form.stockDetailModelList_update[' + index + '].company_name&form.sagyousya_flg=2','技術者参照',850,760);
							
			});

			/* 内容blurイベント*/
			$("input[name$='task_content']").blur(function(){
				
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				if (!$(this).val()){
		
	 				//技術者コードをクリアする
	 				$("input[name='form.stockDetailModelList_update[" + index +"].task_code'").val("");
	 				
	 				//会社名をクリアする
	 				$("input[name='form.stockDetailModelList_update[" + index +"].company_name'").val("");
	 				
// 	 				//sxt 20220908 add start
// 				} else {
// 					var task_code_old = $("input[name='form.stockDetailModelList_update[" + index +"].task_code_old'").val();

// 					if ($(this).val()!=task_code_old){
// 						//発注をセット
// 						setPrice(index);
// 						$("input[name='form.stockDetailModelList_update[" + index +"].task_code_old'").val($(this).val());
// 					}
// 					//sxt 20220908 add end
				}
			});
			
			/* 明細部人月時間区分changeイベント*/
			$("select[name$='time_kbn']").change(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
// 				//sxt 20220908 add start
// 				//発注をセット
// 				setPrice(index);
// 				//sxt 20220908 add end

				//sxt 20221025 add start
				//空白を選択する時
				if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == ""){	
					
					//単価,超過単価,控除単価,工数を入力不可
					setItemState(true,index);
					
				} else {

					//単価,超過単価,控除単価,工数を入力可能
					setItemState(false,index);
					//sxt 20221025 add end
				
					//超過単価、控除単価をセットする
					setPriceAttr(index);
					
					//超過単価、控除単価を計算する
					calculatePriceAttr(index);
					
					//sxt 20220922 add start
					//工数に160セットする
					setDefaultQuantity(index);
					
					//金額を計算する
					calculateKingaku(index);
					//sxt 20220922 add end
				}	//sxt 20221025 add 
			});
			
			/* 明細部単価blurイベント*/
			$("input[name$='price_per']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				//超過単価、控除単価を計算する
				calculatePriceAttr(index);
				
				//sxt 20220928 add start
				//工数
				var quantity = $("input[name='form.stockDetailModelList_update[" + index +"].quantity'").val();
				
				if (!quantity){
					//工数に160セットする
					setDefaultQuantity(index);
				}
				//sxt 20220928 add end
				
				//sxt 20230528 add start
				setTaxDivInput(index);
				//sxt 20230508 add end
				
				//金額を計算する
				calculateKingaku(index);
			});
			
			//sxt 20230508 add start
			$("select[name$='tax_div_input']").change(function(){
				//合計金額計算
				calculateTotal();
			});
			//sxt 20230508 add end
		    
			/* 明細部その他blurイベント*/
			$("input[name$='other_price']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				//金額を計算する
				calculateKingaku(index);
			});
			
			/* 明細部工数blurイベント*/
			$("input[name$='quantity']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				//金額を計算する
				calculateKingaku(index);
			});
		}
		
// 		//sxt 20220908 add start
// 		//発注をセット
// 		function setPrice(index){
						
// 			var task_code = $("input[name='form.stockDetailModelList_update[" + index +"].task_code'").val();
			
			
// 			$.ajax({
// 		        type: "POST",  
// 		        url: "getSagyousyaList.action",
// 		        data: {id:task_code},
// 		        error: function (request) {  


// 		        },
// 		        success: function (data) {  
		        	
// 		        	//月額原価
// 		        	var month_price = JSON.parse(data).month_price;
// 		        	//月を選択する時
// 					if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "01"){	
						
// 						$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").val(month_price);
						
// 						//時を選択する時
// 					}　else if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "02"){
						
// 						//月標準時間
// 						var standard_time = $("input[name='form.standard_time'").val();
// 						if (!standard_time) {
// 							standard_time = 160;
// 						}
						
// 						var price = Math.round(parseFloat(month_price) / parseFloat(standard_time));
// 						$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").val(price);
// 					}
// 		        }
// 		    });
// 		}
// 		//sxt 20220908 add end

		//sxt 20221025 add start
		function setItemState(isReadOnly,index){
			if (isReadOnly){
				$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").attr("readonly","true");
				$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").attr("style","background-color:#fff");
				$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").val("");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").attr("readonly","true");
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").attr("style","background-color:#fff");
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").val("");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").attr("readonly","true");
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").attr("style","background-color:#fff");
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").val("");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").attr("readonly","true");
				$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").attr("style","background-color:#fff");
				$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").val("");
				
			} else {
				$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").removeAttr("readonly");
				$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").removeAttr("style");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").removeAttr("readonly");
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").removeAttr("style");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").removeAttr("readonly");
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").removeAttr("style");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").removeAttr("readonly");
				$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").removeAttr("style");
			}
		}
		//sxt 20221025 add end
		
		function addRow(){
			var size = parseInt($("#detailsize").val());
			
			if (size == 90) {
				return false;
			}
			
			//最大行番号を取得する
			var maxRowNumber = parseInt($("input[name='form.stockDetailModelList_update[" + (size-1) +"].row_number'").val());
								
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
			row_number.attr("name","form.stockDetailModelList_update[" + n + "].row_number");
			//设置input标签value
			//row_number.attr("value",rowNumber); 
			row_number.val(rowNumber);
			
			//获得当前行第2个TD值 
			var col1 = tr0.find("td:eq(1)"); 
			//获得当前TD的input标签 【作業内容】
			var task_code = col1.find("input[type='hidden']");
			task_code.attr("name","form.stockDetailModelList_update[" + n + "].task_code");
			task_code.attr("value",""); 
			task_code.val("");
	
			var task_content = col1.find("input[type='text']");
			task_content.attr("name","form.stockDetailModelList_update[" + n + "].task_content");
			task_content.attr("value",""); 
			task_content.val("");
			
			//获得当前TD的input标签 【参照】
// 			var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList_update[" + n + "].task_code&form.fieldName_name=form.stockDetailModelList_update[" + n+ "].task_content','作業内容参照',670,600)";
// 			var sanshoButton = col1.find("input[type='button']");
// 			sanshoButton.attr("onclick",clickContent);
// 			sanshoButton.attr("name","button[" + n + "]");
			var btn = col1.find("input[type='button']");
			btn.attr("name","form.stockDetailModelList_update[" + n + "].btn");
			
			//获得当前行第3个TD值 
			var col2 = tr0.find("td:eq(2)"); 
			//获得当前TD的input标签 【月時区分】
			var time_kbn = col2.find("select");
			time_kbn.attr("name","form.stockDetailModelList_update[" + n + "].time_kbn");
			time_kbn.attr("value",""); 
			time_kbn.val("01");
			
			//获得当前行第4个TD值 
			var col3 = tr0.find("td:eq(3)"); 
			//获得当前TD的input标签 【単価】
			var price_per = col3.find("input");
			price_per.attr("name","form.stockDetailModelList_update[" + n + "].price_per");
			price_per.attr("value",""); 
			price_per.val("");

			//获得当前行第5个TD值 
			var col4 = tr0.find("td:eq(4)"); 
			//获得当前TD的input标签 【超過単価】
			var more_price = col4.find("input");
			more_price.attr("name","form.stockDetailModelList_update[" + n + "].more_price");
			more_price.attr("value",""); 
			more_price.val("");
			
			//获得当前行第6个TD值 
			var col5 = tr0.find("td:eq(5)"); 
			//获得当前TD的input标签 【控除単価】
			var less_price = col5.find("input");
			less_price.attr("name","form.stockDetailModelList_update[" + n + "].less_price");
			less_price.attr("value",""); 
			less_price.val("");
			
			//获得当前行第7个TD值 
			var col6 = tr0.find("td:eq(6)"); 
			//获得当前TD的input标签 【そのた】
			var other_price = col6.find("input");
			other_price.attr("name","form.stockDetailModelList_update[" + n + "].other_price");
			other_price.attr("value",""); 
			other_price.val("");
			
			//获得当前行第8个TD值 
			var col7 = tr0.find("td:eq(7)"); 
			//获得当前TD的input标签 【数量】
			var quantity = col7.find("input");
			quantity.attr("name","form.stockDetailModelList_update[" + n + "].quantity");
			quantity.attr("value",""); 
			quantity.val("");
							
			//获得当前行第9个TD值 
			var col8 = tr0.find("td:eq(8)"); 
			//获得当前TD的input标签 【金額】
			var amount = col8.find("input");
			amount.attr("name","form.stockDetailModelList_update[" + n + "].amount");
			amount.attr("value",""); 
			amount.val("");
			
			//获得当前行第10个TD值 
			var col9 = tr0.find("td:eq(9)"); 
			//获得当前TD的input标签 【備考】
			var task_code = col9.find("textarea");
			task_code.attr("name","form.stockDetailModelList_update[" + n + "].biko");
			task_code.attr("value",""); 
			task_code.val("");
							
			//获得当前行第11个TD值 
			var col10 = tr0.find("td:eq(10)"); 
			//获得当前TD的input标签  【checkbox】
			var checkbox = col10.find("input");
			checkbox.attr("name","form.stockDetailModelList_update[" + n + "].isCheck");
			checkbox.attr("value","0"); 
			checkbox.prop('checked',false)
						
			//1行目を追加
			tr0.appendTo("#tbAddPart");
			 
			//2行目をコピー
			var tr1 = $("#tbAddPart tr").eq(1).clone();
			
			//获得当前行第1个TD值 
			var tr1col0 = tr1.find("td:eq(0)"); 
			//获得当前TD的input标签 【税区分】
			var org_price = tr1col0.find("input");
			org_price.attr("name","form.stockDetailModelList_update[" + n + "].company_name");
			org_price.attr("value",""); 
			org_price.val("");
			
			//sxt 20230508 add start
			//toto:由于行追加功能取消，这部分代码没有测试
			//获得当前行第2个TD值 
			var tr1col1 = tr1.find("td:eq(1)"); 
			//获得当前TD的input标签 【税区分】
			var tax_div_input = tr1col2.find("select");
			tax_div_input.attr("name","form.stockDetailModelList_update[" + n + "].tax_div_input");
			tax_div_input.attr("value",""); 
			tax_div_input.val("");
			//sxt 20230508 add end
			
			//2行目を追加
			tr1.appendTo("#tbAddPart");

		}

		function reSetRowIndex(curIndex){

			$("input[name^='form.stockDetailModelList_update'][name$='row_number']").each(function() {
				//获取当前元素的name
				rowNuber = parseInt($(this).val());
				
				var x = $(this).prop("name");
				//获取索引值
				var index = getCurIndex(x);
								
				if (index > curIndex){

					$("input[name='form.stockDetailModelList_update[" + index +"].row_number'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].row_number");
					$("input[name='form.stockDetailModelList_update[" + index +"].task_code'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].task_code");
					$("input[name='form.stockDetailModelList_update[" + index +"].task_content'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].task_content");
					
// 					var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.stockDetailModelList_update[" + (index-1) + "].task_code&form.fieldName_name=form.stockDetailModelList_update[" + (index-1) + "].task_content','作業内容参照',670,600)";		
// 					$("input[name='button[" + index +"]'").attr("onclick",clickContent);
// 					$("input[name='button[" + index +"]'").attr("name","button[" + (index-1) + "]");
					$("input[name='form.stockDetailModelList_update[" + index +"].btn'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].btn");
					
					$("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].time_kbn");
					$("input[name='form.stockDetailModelList_update[" + index +"].price_per'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].price_per");
					$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].more_price");
					$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].less_price");
					$("input[name='form.stockDetailModelList_update[" + index +"].other_price'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].other_price");
					
					$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].quantity");
					$("input[name='form.stockDetailModelList_update[" + index +"].amount'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].amount");
					$("textarea[name='form.stockDetailModelList_update[" + index +"].biko'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].biko");
					
					$("input[name='form.stockDetailModelList_update[" + index +"].isCheck'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].isCheck");
					$("input[name='form.stockDetailModelList_update[" + index +"].company_name'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].company_name");
					$("select[name='form.stockDetailModelList_update[" + index +"].tax_div_input'").attr("name","form.stockDetailModelList_update[" + (index-1) + "].tax_div_input");	//sxt 20230508 add
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
// 			//新しい10行を追加
// 			for (var i = 0; i < 10; i++) {

// 				appendOptionRow(i+size,i+maxRowNumber+1); 
// 			}
			
// 			$("#optionDetailsize").val(10+size);
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
			var tax_div = $("select[name='form.stockDetailModelList_update[" + index +"].tax_div_input'").val();
			
			//明細税区分未选择的场合，初期値は外税を設定
			if (!tax_div) $("select[name='form.stockDetailModelList_update[" + index +"].tax_div_input'").val("02");
	
		}
		//sxt 20230508 add end
		
		//超過単価、控除単価を計算する
		function calculatePriceAttr(index){
			
			//sxt 20220914 add start
			if (!$("input[name='form.payment_method_chk']").is(':checked')){
				return false;
			}
			//sxt 20220914 add end
					
			//月を選択する時
			if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "01"){	
				//超過単価、控除単価は支払条件で計算		
				var price_per = $("input[name='form.stockDetailModelList_update[" + index +"].price_per'").val();
				var work_time_from = $("#work_time_from").val();
				var work_time_to = $("#work_time_to").val();
				var morePrice;
				var lessPrice;
				
				//超過単価：月額単価 ÷ 月間作業基準時間（終了）
				if (price_per && work_time_to){
					//morePrice = (price_per / work_time_to).toFixed(0);	//sxt 20220922 del
					
					//sxt 20220922 add start
					//超過単価（円） 控除単価（円   希望计算后 去掉10位 比如 2345->2340  4456->4450
					morePrice = (price_per / work_time_to);
					morePrice = setPricePrecision(morePrice);
					//sxt 20220922 add end	
					
					$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").val(morePrice);
				}
				
				//控除単価：月額単価 ÷ 月間作業基準時間（開始）
				if (price_per && work_time_from){
					//lessPrice = (price_per / work_time_from).toFixed(0);		//sxt 20220922 del
					
					//sxt 20220922 add start
					//超過単価（円） 控除単価（円   希望计算后 去掉10位 比如 2345->2340  4456->4450
					lessPrice = (price_per / work_time_from);
					lessPrice = setPricePrecision(lessPrice);	
					//sxt 20220922 add end	
					
					$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").val(lessPrice);
				}
			//時を選択する時
			}　else if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "02"){
				
			}
		}
		
		//sxt 20220922 add start
		function setPricePrecision(price){
			//见机画面的 超過単価（円） 控除単価（円   希望计算后 去掉10位 比如 2345->2340  4456->4450
			var returnPrice = 0;
			if (price > 10){
				returnPrice = (Math.floor(price / 10)) * 10;
			} else {
				returnPrice = price.toFixed(0);
			}	
			
			return returnPrice;
		}
		//sxt 20220922 add end	
		
		//金額を計算する
		function calculateKingaku(index){
			var kingaku;
			var price_per = $("input[name='form.stockDetailModelList_update[" + index +"].price_per'").val();
			var other_price = $("input[name='form.stockDetailModelList_update[" + index +"].other_price'").val();	
			var quantity = $("input[name='form.stockDetailModelList_update[" + index +"].quantity'").val();
			if (price_per==null || price_per=="") {
				price_per = "0";
			}
			if (other_price==null || other_price=="") {
				other_price = "0";
			}
			if (quantity==null || quantity=="") {
				quantity = "0";
			}

			//sxt 20220922 del start
// 			var standard_time = $("input[name='form.standard_time'").val();
// 			if (standard_time==null || standard_time=="") {
// 				standard_time = "0";
// 			}
			//sxt 20220922 del end
			
			//月を選択する時
			if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "01"){	
				//(月次単価＋交通費など)X数量	
				kingaku = (parseFloat(price_per) + parseFloat(other_price)) * parseFloat(quantity);
			
			//時を選択する時
			}　else if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "02"){
				//sxt 20220922 del start
// 				//（時間単価X月稼働（H）＋交通費など）X数量
// 				var other_price = $("input[name='form.stockDetailModelList_update[" + index +"].other_price'").val();	
// 				if (other_price==null || other_price=="") {
// 					other_price = "0";
// 				}
// 				kingaku = (parseFloat(price_per) * parseFloat(standard_time) + parseFloat(other_price)) * parseFloat(quantity);	
				//sxt 20220922 del end
				
				//sxt 20220922 add start
				//単価X工数＋その他
				kingaku = parseFloat(price_per) * parseFloat(quantity) + parseFloat(other_price);
				//sxt 20220922 add end
			}
			
			//端数処理
			kingaku = doProcessing(kingaku);
			
			if (kingaku != 0) {
				$("input[name='form.stockDetailModelList_update[" + index +"].amount'").val(kingaku);
			}else {
				$("input[name='form.stockDetailModelList_update[" + index +"].amount'").val("");
			}
						
			//合計金額計算
			calculateTotal();
			
		}
		
		//sxt 20220922 add start
		function setDefaultQuantity(index){
			//時を選択する時
			if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "02"){
				$("input[name='form.stockDetailModelList_update[" + index +"].quantity'").val("160"); 
			}
		}
		//sxt 20220922 add end
				
		//端数処理
		function doProcessing( amount ) {
			//端数処理
			var processing = $("input[name='form.fraction_processing_update'").val();

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
			var out_order_code = $('input[name="form.out_order_code_update"]').val();
			//var order_div = $('select[name="form.order_div_input_update"]').val();	//sxt 20221003 del
			var order_div = $('input[name="form.order_div_input_update"]').val();		//sxt 20221003 add
			var work_start_date = $('input[name="form.work_start_date_input_update"]').val();
			var work_end_date = $('input[name="form.work_end_date_input_update"]').val();
			var delivery_date = $('input[name="form.delivery_date_input_update"]').val();	//sxt 20221008 add

			$.ajax({
		        type: "POST",  
		        url: "calculateEditOrderDate.action",
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
		
		//超過単価、控除単価をセットする
		function setPriceAttr(index){
			//月を選択する時
			if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "01"){			
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").removeAttr("readonly");
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").removeAttr("style");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").removeAttr("readonly");
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").removeAttr("style");

			//時を選択する時
			}　else if ($("select[name='form.stockDetailModelList_update[" + index +"].time_kbn'").val() == "02"){
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").attr("readonly","true");
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").attr("style","background-color:#fff");
				
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").attr("readonly","true");
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").attr("style","background-color:#fff");
				
				//超過、控除単価空白に
				$("input[name='form.stockDetailModelList_update[" + index +"].more_price'").val("");
				$("input[name='form.stockDetailModelList_update[" + index +"].less_price'").val("");
			}

		}
		
		//合計金額計算
		function calculateTotal(){
			
			//画面.消費税率
			var tax_rate = $("input[name='form.consume_tax_rate_update'").val();
			
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
				if ($("input[name='form.stockDetailModelList_update[" + i +"].amount'").val()) {
					amountDetail = parseInt($("input[name='form.stockDetailModelList_update[" + i +"].amount'").val());
				} 
				
				//明細税区分
				var tax_div = $("select[name='form.stockDetailModelList_update[" + i +"].tax_div_input'").val();
					
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
// 				$("#estimate_amount_update").text("￥" + amount.toLocaleString());
// 				$("#tax_amount_update").text("￥" + tax_amount.toLocaleString());
// 				$("#amount_update").text("￥" + (amount + tax_amount).toLocaleString());				
// 			}
			
			$("#estimate_amount_update").text("￥" + amount.toLocaleString());
			$("#tax_amount_update").text("￥" + tax_amount.toLocaleString());
			$("#amount_update").text("￥" + (amount + tax_amount).toLocaleString());		
		}
	</script>
</html>
