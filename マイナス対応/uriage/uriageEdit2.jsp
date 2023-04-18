<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>売上（常駐）修正画面</title>
	<style>
		.flex{
			display: flex;
		}
		.flex-left{
			flex-basis: 36rem;
		}
		.flex-right{
			flex-basis: auto;
		}
      .table > thead > tr > td {
        padding: 0.25rem 0 0.25rem 0;
        vertical-align:top;
        font-weight: bold;
      }
      .table > tbody > tr > td {
        padding: 0.125rem;
        vertical-align:top;
      }
      .table > tfoot > tr > td {
        padding: 0.5rem;
      }
	</style>
	<script language="JavaScript">
	
		function deleteUriage() {
			if (confirm("削除してよろしいでしょうか？")==true){
				document.uriageform.action="deleteUriage.action";
				document.uriageform.submit();
			}
		}
		
		//sxt 20220721 add start
		function deleteUriageFromProject() {
			if (confirm("削除してよろしいでしょうか？")==true){
				document.uriageform.action="deleteUriageFromProject.action";
				document.uriageform.submit();
			}
		}
		//sxt 20220721 add end
		
		function deleteTopUriage() {
			if (confirm("削除してよろしいでしょうか？")==true){
				document.uriageform.action="deleteTopUriage.action";
				document.uriageform.submit();
			}
		}
				
		function doCheckEstimate(name) {
			var value = document.uriageform.elements[name].checked;
			if(value == true) {
				document.uriageform.elements['form.estimate_amount_flg'].value = "1";
			} else {
				document.uriageform.elements['form.estimate_amount_flg'].value = "0";
			}
		}
		function doCheckTax(name) {
			var value = document.uriageform.elements[name].checked;
			if(value == true) {
				document.uriageform.elements['form.tax_amount_flg'].value = "1";
			} else {
				document.uriageform.elements['form.tax_amount_flg'].value = "0";
			}
		}
		function doCheckAmount(name) {
			var value = document.uriageform.elements[name].checked;
			if(value == true) {
				document.uriageform.elements['form.amount_flg'].value = "1";
			} else {
				document.uriageform.elements['form.amount_flg'].value = "0";
			}
		}

		function deleteRow(pForm){
			var len = document.uriageform.elements.length;
			var count = 0;
			for (i=0; i<len; i++) {
				var strName=document.uriageform.elements[i].name;
				var lastStr = strName.charAt(strName.length -3) + strName.charAt(strName.length - 2) + strName.charAt(strName.length - 1);
				if (lastStr == "box"){
					if (document.uriageform.elements[i].checked==true){	
					    count = 1;
						document.uriageform.elements[i].value="1";
					}else{
						document.uriageform.elements[i].value="0";
					}
				}
			}
			if (count == 0){
				alert("削除したい明細を選択してください。" );
			}else{
				if (confirm("削除してよろしいでしょうか？")==true){
					//sxt 20220624 del start
					//document.uriageform.action="deleteRowEditSales.action";
					//document.uriageform.submit();
					//sxt 20220624 del end
					
					return true;	//sxt 20220624 add 
				}
			}
		}
		
		function checkQuantity(value){
			var quantity = value;
			var index;
			if(checkKingaku(quantity)){
				index = quantity.indexOf(".");
				if(index == -1){
					if(quantity.charAt(0)=="-"){
						if(quantity.length > 5){
							return false;
						}							
					}else{
						if(quantity.length > 4){
							return false;
						}
					}
					
				} else {
					str1 = quantity.substr(0,index);
					str2 = quantity.substr(index + 1,quantity.length);
				}
			} else {
				return false;
			}
			if(quantity == ""){
				return false;
			}
			return true;
		}
		function checkPrice(value){
			if(checkNumber(value) && value.length <9){
			} else {
				if(checkNumber(value) == false){
					return false;
				}else if (value.length > 8){
					return false;
				}	
			}
			if (value == "") {
				return false;
			}
			return true;
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
			var testStr = /^(\+|\-)?\d+(\.\d{1,2})?$/;
			return  testStr.test(varStr); 
		}
		
		function priceCalAmount(num){	
			var amount =0;
			var index;
			var price =  document.uriageform.elements['form.salesDetailList['+num +'].price_per'].value;
			var quantity = document.uriageform.elements['form.salesDetailList['+num +'].quantity'].value;
			var processing = "";
			if(document.uriageform.elements['form.processing']!=null){
				processing = document.uriageform.elements['form.processing'].value;
			}
			if(checkPrice(price) && checkQuantity(quantity) && processing != ""){
				amount = price * quantity;
				ret = amount.toString();
				index = ret.indexOf(".");
				if (index == -1){
					document.uriageform.elements['form.salesDetailList['+num +'].amount'].value = amount;		
				}else {
					if(processing == "02") {
						str1 = ret.substr(0,index);
						str2 = ret.substr(index + 1,1);
						if (parseInt(str2) > 4) {
							str1 = (parseInt(str1) + 1).toString();
						}
						document.uriageform.elements['form.salesDetailList['+num +'].amount'].value = str1;
					} else if (processing == "01"){
						str1 = ret.substr(0,index);
						document.uriageform.elements['form.salesDetailList['+num +'].amount'].value = str1;
					} else if (processing == "03"){
						str1 = ret.substr(0,index);
						str2 = ret.substr(index + 1,1);
						if (parseInt(str2) > 0) {
							str1 = (parseInt(str1) + 1).toString();
						}
						document.uriageform.elements['form.salesDetailList['+num +'].amount'].value = str1;
					}	
				}
			}
		}	
		function calculateAll(){
			var size = <ww:property value="form.salesDetailList.size()" />; 
			var i = 0;
			for(i;i < size;i++){
				var unit = document.uriageform.elements['form.salesDetailList['+i+'].quantity'].value;
				var price_per = document.uriageform.elements['form.salesDetailList['+i+'].price_per'].value;
				var processing = document.uriageform.elements['form.processing'].value;
				
				var result = 0;
				var index;
				if(checkPrice(price_per) && checkQuantity(unit) && processing != "") {
					result = price_per * unit;
					ret = result.toString();
					index = ret.indexOf(".");
					if (index == -1){
						document.uriageform.elements['form.salesDetailList['+i+'].amount'].value = result;
					} else {
						if(processing == "02") {
							str1 = ret.substr(0,index);
							str2 = ret.substr(index + 1,1);
							if (parseInt(str2) > 4) {
								str1 = (parseInt(str1) + 1).toString();
							}
							document.uriageform.elements['form.salesDetailList['+i+'].amount'].value = str1;
						} else if (processing == "01"){
							str1 = ret.substr(0,index);
							document.uriageform.elements['form.salesDetailList['+i+'].amount'].value = str1;
						} else if (processing == "03"){
							str1 = ret.substr(0,index);
							str2 = ret.substr(index + 1,1);
							if (parseInt(str2) > 0) {
								str1 = (parseInt(str1) + 1).toString();
							}
							document.uriageform.elements['form.salesDetailList['+i+'].amount'].value = str1;
						}
					}
				}
			}
		var customer_code = document.uriageform.elements['form.customer_code_input'].value;
		var customer_name = document.uriageform.elements['form.customer_name_input'].value;	
		var order_first_code = document.uriageform.elements['form.order_first_code_input'].value;
		var order_first_name = document.uriageform.elements['form.order_first_name_input'].value;	

		if (customer_code!=""&&order_first_code==""){
			document.uriageform.elements['form.order_first_code_input'].value = customer_code;		
			document.uriageform.elements['form.order_first_name_input'].value = customer_name;	
		}
		}
	</script>
</head>

<body onunload="closeSubWindow();" class="cm-no-transition cm-1-navbar">
<form name="uriageform" method="post" class="form-horizontal">
  		<header id="cm-header">
<!--         <nav class="cm-navbar cm-navbar-primary"> -->
<!--           <div class="cm-flex"> -->
<!--             <h1>売上処理 -->
<!--               <i class="fa fa-fw fa-angle-double-right"></i>  -->
<!--             </h1> -->
<!--           </div> -->
<%--           <ww:include value="'/header.jsp'"/>	 --%>
<!--         </nav> -->
      </header>
      <!--content-->
      <div id="global">
        <div class="container-fluid">
          <div class="text-center dora-form-title">
            売上（常駐）修正画面
            <ww:include value="'/loginName.jsp'"/>        
          </div>
          <div class="panel panel-default">
            <div class="panel-body">
            	<ww:include value="'/message.jsp'" />
              
                <!--button-->              
                <div class="form-group">
                  <div>                   
					<ww:if test="form.prepage.equals(\"6\")">
					    <input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('showUriageYoteiItiran.action')">
					</ww:if>
					<ww:elseif test="form.prepage.equals(\"0\")">
						<!-- sxt 20220725 del start -->
<!-- 						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'returnTopAction.action')"> -->
						<!-- sxt 20220725 del end -->
						<!-- sxt 20220725 add start -->
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('returnTopAction.action')">
						<!-- sxt 20220725 add end -->
					</ww:elseif>
					<!-- sxt 20220711 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
					</ww:elseif>
					<!-- sxt 20220711 add end -->
					<ww:else>
					<!-- sxt 20220725 del start -->
<!-- 					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'refreshNewUriage.action')">  -->
					<!-- sxt 20220725 add end -->
					<!-- sxt 20220725 add start -->
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('refreshNewUriage.action')">
					<!-- sxt 20220725 add end -->
					</ww:else>
					<ww:if test="form.prepage.equals(\"0\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'saveTopEditUriage2.action')">	
					</ww:if>
					<!-- sxt 20220721 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'saveEditUriage2FromProject.action')">
					</ww:elseif>
					<!-- sxt 20220721 add end -->
					<ww:else>
						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'saveEditUriage2.action')">	
					</ww:else>	
					<ww:if test="form.prepage.equals(\"0\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="削除" onclick="deleteTopUriage()">	
					</ww:if>
					<!-- sxt 20220721 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="削除" onclick="deleteUriageFromProject()">
					</ww:elseif>
					<!-- sxt 20220721 add end -->
					<ww:else>			
						<input type="button" class="btn btn-primary dora-sm-button" value="削除" onclick="deleteUriage()">	
					</ww:else>	
					<!-- sxt 20220811 add start -->
					<ww:if test="form.approval_div == '03'">
						<ww:if test="form.month_close_flg.equals(\"1\") ">
							<input type="button" class="btn btn-primary dora-sm-button" value="印刷" onclick="openWindowResizable('uriagePrint.action?form.sales_no=<ww:property value='form.sales_no'/>&form.shurui=<ww:property value='form.shurui'/>','印刷',800,600);"">	
						</ww:if>
					</ww:if>
					<!-- sxt 20220811 add end -->
                  </div>
                </div>

                <!--状態区域-->
                <div class="panel-body" style="padding:1.75rem 1rem">
                  <div class="dora-state-zone">承認(<ww:property value="form.approval_div_name"/>)</div>
                  <div class="dora-state-zone">契約形態 <ww:property value="form.contract_form_name" /></div>
                  <div class="dora-state-zone">請求区分 <ww:property value="form.order_div_name" /></div>
                  <div class="dora-state-zone">請求書発行(<ww:property value="form.request_flg"/>)</div>
                  <div class="dora-state-zone">入金(未)</div>
                  <div class="dora-state-zone">月次締(未)</div>
                  
                  <div class="dora-state-zone form-inline">
                  	<label class="dora-label-right">売上担当者</label>
					<ww:select name="'form.sales_in_code_input'"
			              size="'1'" 
					      cssClass="'form-control'" 
					      list="form.receivedInNameForSelList" 
					      listKey="person_in_charge_code" 
					      listValue="person_in_charge_name" 
					      value="form.sales_in_code_input"  >
			   		</ww:select>
                  </div>
                  
                </div>

                <!--参照区域-->
                <div>
                  <ul id="myTab" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">受注参照</a></li>
                  </ul>

                  <div class="panel panel-default">
                    <div id="myTabContent" class="tab-content">
                      <div role="tabpanel" class="tab-pane fade active in panel-body" id="home" aria-labelledby="home-tab">
                        <div class="form-group form-inline">
                          <span>
                            見積番号
                            <button type="button" class="btn btn-link" onclick="hrefHaveParamAction('mitumoriInfo2.action?form.estimate_no=<ww:property value="form.estimate_no" />&form.pageFlg=6')">
                          		<ww:property value="form.estimate_no" />
                          	</button>
                          </span>
                          <span>
                            受注番号
                            <button type="button" class="btn btn-link" onclick="hrefHaveParamAction('jyutyuInfo2.action?form.pageFlg=3&form.receive_no=<ww:property value="form.received_no_input" />');">
                          		<ww:property value="form.received_no_input" />
                          	</button>
                          </span>
                          <span>
                            プロジェクトNo　<ww:property value="form.project_no" />　　
                          </span>

                          <span>
                            得意先　<ww:property value="form.customer_code_input" /> <ww:property value="form.customer_name_input" />
             				<ww:hidden name="'form.customer_code_input'" value="form.customer_code_input"></ww:hidden>
             				<ww:hidden name="'form.processing'" value="form.processing"></ww:hidden>
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>               
                </div>

                <!--ヘッダー-->
                <div>
                  <ul id="myTab" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#header" id="header-tab" role="tab" data-toggle="tab" aria-controls="header" aria-expanded="true">売上ヘッダー</a></li>                     
                  </ul>
                  <div class="panel panel-default">
                    <div id="myTabContent" class="tab-content">
                      <div role="tabpanel" class="tab-pane fade active in panel-body" id="header" aria-labelledby="header-tab">
                        <div class="form-group form-inline">
                          <label for="estimate_date" class="dora-label-left-require">件名</label>
                          <input type="text" name="form.receive_name1" value="<ww:property value='form.receive_name1'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名１">
                          <input type="text" name="form.receive_name2" value="<ww:property value='form.receive_name2'/>" maxlength="60" class="form-control" style="width:40rem;" placeholder="件名２">
                        </div>

                        <div class="form-group form-inline">
                          <label for="estimate_date" class="dora-label-left">売上番号</label>
                          <ww:property value="form.sales_no"/>

                          <label class="dora-label-right-require" for="estimate_date">売上日付</label>
                          <input type="date" name="form.sales_date_input"  value="<ww:property value='form.sales_date_input'/>" class="form-control">
                        </div>

                        <div class="form-group form-inline">
                          <label for="estimate_date" class="dora-label-left">請求日付</label>
                          <input type="date" name="form.request_date" value="<ww:property value='form.request_date'/>" class="form-control">
                          <label class="dora-label-right" for="estimate_date">入金予定日</label>
                          <input type="date" id="input_pre_date" name="form.input_pre_date" value="<ww:property value='form.input_pre_date'/>" class="form-control">
<!--                           <button type="button" class="btn btn-primary dora-sm-button" onclick="submitFunction(this.form,'calculateInputPreDate.action')">算出</button> -->
                          <button type="button" class="btn btn-primary" id="calculateInputPreDate">算出</button>
                        </div>

                        <div class="form-group form-inline">
                          <label class="dora-label-left" for="estimate_date">作業期間</label>
                          <input type="date" name="form.work_start_date" value="<ww:property value='form.work_start_date'/>" class="form-control">
                          <label>～</label>
                          <input type="date" name="form.work_end_date" value="<ww:property value='form.work_end_date'/>" class="form-control">          
                        </div>

                        <div class="form-group form-inline">
                          <label class="dora-label-left" for="form.code_div_id">納品状況</label>
                          <ww:select name="'form.delivery_status'"
                                cssStyle="'width:16rem'" 
                                cssClass="'form-control'"
					       		list="form.deliveryStatusList" 
					       		listKey="code_id" 
					       		listValue="code_value" 
					       		value="form.delivery_status" >
			   			 </ww:select>
        
                          <label class="dora-label-right-require" for="form.code_div_id">消費税率(%)</label>
                          <input type="number" name="form.tax_rates" value="<ww:property value='form.tax_rates'/>" class="form-control" style="width: 8rem;" placeholder="税率(%)"  
                          		oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
                        	
                        </div>
                        
                        <!-- sxt 20220923 add start -->
		                <div class="form-group flex" style="padding-top:1rem;">
							<div class="flex-left" style="padding-left:0.625rem;">
								<label for="estimate_date">精算方法</label>
								<ww:if test="form.payment_method.equals(\"1\")">
									<ww:checkbox name="'form.payment_method_chk'" fieldValue="form.payment_method" value="1"></ww:checkbox>
								</ww:if>
								<ww:else>
									<ww:checkbox name="'form.payment_method_chk'" fieldValue="form.payment_method" value="0"></ww:checkbox>
								</ww:else>
								<table class="table table-bordered" id="payment_method1">
									<tr>
										<td colspan="3" class="text-center">月間作業基準時間（H）</td>
									</tr>
									<tr>
										<td class=" text-right" style="border-right-width:0px;">
											<input type="text" class="form-control" value="<ww:property value='form.work_time_from'/>"
													style="width:6rem;display:inline;background-color:#fff" readonly>
													
										</td>
										<td class="text-center"
											style="vertical-align:middle;border-left-width: 0px;border-right-width:0px;">
											～</td>
										<td style="border-left-width:0px;">
											<input type="text" class="form-control text-right" value="<ww:property value='form.work_time_to'/>"
												style="width:6rem;display:inline;background-color:#fff" readonly>
										</td>
									</tr>
		
								</table>
							</div>
							<div class="flex-right" style="padding-left:2rem;">
								<label for="estimate_date">　</label>
								<table class="table table-bordered" id="payment_method2">
									<tbody>
										<tr>
											<td class="text-center"
												style="width: 15rem;vertical-align:middle;">精算単位
											</td>
											<td>
											
											<input type="text" class="form-control" value="<ww:property value='form.time_unit'/>"
												style="background-color:#fff" readonly>
											</td>
										</tr>
										<tr>
											<td class="text-center" style="border-bottom:0;">
												<div class="checkbox">
													<label>
														超過時間精算：
													</label>
												</div>
											</td>
											<td style="border-bottom:0;padding: 0.5rem 0.5rem 0 0.5rem;">
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
												<input type="text" id="work_time_to2" class="form-control text-righ"  value="<ww:property value='form.work_time_to'/>" 
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
												<input type="text" id="work_time_from2" class="form-control text-righ" value="<ww:property value='form.work_time_from'/>"
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
		                <!-- sxt 20220923 add end -->
        
                      </div>
                    </div>
                  </div>
                </div>

                <!--明細-->
                <div>
                  <ul id="myTab" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#detail" id="detail-tab" role="tab" data-toggle="tab" aria-controls="detail" aria-expanded="true">売上明細</a></li>
                  </ul>

                  <div class="panel panel-default">
                    <div id="myTabContent" class="tab-content">
                      <div role="tabpanel" class="tab-pane fade active in panel-body" id="detail" aria-labelledby="detail-tab">
                        <table class="table table-bordered">
                          <thead>
	                          <tr>
								<td class="text-center" style="width:4.5rem;" rowspan="2">行</td>
								<td class="text-center" style="width:40rem;" rowspan="2">内容</td>
								<td class="text-center" style="width:8rem;" rowspan="2"></td>
								<td class="text-center" style="width:15rem;" rowspan="2">単価（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">稼働時間（H）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">超過単価（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">控除単価（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">精算額（円）</td>
<!-- 								<td class="text-center" style="width:10rem;" rowspan="2">そのた（円）</td> -->	<!-- sxt 20221024 del -->
								<td class="text-center" style="width:15rem;" rowspan="2">金額（円）</td>
								<td class="text-center" style="width:15rem;" rowspan="2">旅費（円）</td>
								<td class="text-center" style="width:45rem;" rowspan="2">備考</td>
								<ww:hidden name="'detailsize'" id="detailsize" value="form.salesDetailList.size()"></ww:hidden>
	                          </tr>
	                        </thead>
	                        <tbody id="tbAddPart">
		                        <%int s = 0; %>
		                        <ww:iterator value="form.salesDetailList" status="rows">
		                          <tr>
		                            <td class="text-center" rowspan="2" style="width:4.25rem;" nowrap>
		                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].row_number" 
											value='<ww:property value="form.salesDetailList[#rows.index].row_number"/>' class="form-control text-right"
											oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
		                            </td>
		                            <td class="text-center" style="border-bottom: none;">
			                            <div class="flex">
			                            	<ww:hidden name="'form.salesDetailList['+#rows.index+'].task_code'" value="form.salesDetailList[#rows.index].task_code" />
		                              		<input type="text" name="form.salesDetailList[<ww:property value='#rows.index'/>].task_content" 
												value='<ww:property value="form.salesDetailList[#rows.index].task_content"/>' class="form-control" />
											<input type="button" value="参照" class="btn btn-primary dora-tabel-button" 
												onclick="openWindowWithScrollbarGuide('initialSagyousyaGuide.action?form.fieldName_code=form.salesDetailList[<%=s%>].task_code&form.fieldName_name=form.salesDetailList[<%=s%>].task_content&form.company_name=form.salesDetailList[<%=s%>].company_name&form.sagyousya_flg=2','技術者参照',670,716)">		
			                            </div>
		                            </td>
		                            <td rowspan="2" class="text-center" style="width:6.75rem;" nowrap>
										<ww:select name="'form.salesDetailList['+#rows.index+'].time_kbn'"
											       cssClass="'form-control'" 
											       list="form.timeKbnList" 
											       listKey="code_id" 
											       listValue="code_value" 
											       value="time_kbn"
											       headerKey="''"
								       	   	   	   headerValue="''">
									    </ww:select>
		                            </td>
		                            
		                            <!-- sxt 20221024 add start -->
									<ww:if test="time_kbn.equals('')">
										<td rowspan="2">
			                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].price_per" 
												value="<ww:property value='form.salesDetailList[#rows.index].price_per'/>" class="form-control text-right"
												readonly style="background-color:#fff"  />
			                            </td>
										<td class="text-center" rowspan="2">
											<input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].quantity" 
												value="<ww:property value='form.salesDetailList[#rows.index].quantity'/>" class="form-control text-right"
												readonly style="background-color:#fff"  />
										</td>
									</ww:if>
									<ww:else>
									<!-- sxt 20221024 add end -->
										<td rowspan="2">
			                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].price_per" 
												value="<ww:property value='form.salesDetailList[#rows.index].price_per'/>" class="form-control text-right"
												oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
			                            </td>
										<td class="text-center" rowspan="2">
											<input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].quantity" 
												value="<ww:property value='form.salesDetailList[#rows.index].quantity'/>" class="form-control text-right"
												oninput="maxNumberLength(8)" --onkeypress="return integerAndDecimal()" onchange="decimalLength(8,3)"/>
										</td>
									</ww:else>	<!-- sxt 20221024 add -->

									<ww:if test="time_kbn.equals('01')">
										<td rowspan="2">
			                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].more_price" 
												value="<ww:property value='form.salesDetailList[#rows.index].more_price'/>" class="form-control text-right"
												oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
			                            </td>
		                            </ww:if>
									<ww:else>
										<td rowspan="2">
			                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].more_price" 
												value="<ww:property value='form.salesDetailList[#rows.index].more_price'/>" class="form-control text-right"
												readonly style="background-color:#fff"  />
			                            </td>
		                            </ww:else>
		                            
		                            <ww:if test="time_kbn.equals('01')">
		                            	<td rowspan="2">
			                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].less_price" 
												value="<ww:property value='form.salesDetailList[#rows.index].less_price'/>" class="form-control text-right"
												oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
			                            </td>
									</ww:if>
									<ww:else>
										<td rowspan="2">
			                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].less_price" 
												value="<ww:property value='form.salesDetailList[#rows.index].less_price'/>" class="form-control text-right"
												readonly style="background-color:#fff" />
			                            </td>
									</ww:else>
		
									<ww:if test="time_kbn.equals('01')">
										<td class="text-center" rowspan="2">
											<input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].calculate_amount" 
												value="<ww:property value='form.salesDetailList[#rows.index].calculate_amount'/>" class="form-control text-right"
												oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/>
										</td>
									</ww:if>
									<ww:else>
										<td class="text-center" rowspan="2">
											<input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].calculate_amount" 
												value="<ww:property value='form.salesDetailList[#rows.index].calculate_amount'/>" class="form-control text-right"
												readonly style="background-color:#fff" />
										</td>
									</ww:else>
									
									<!-- sxt 20221024 del start -->							
<!-- 		                            <td rowspan="2"> -->
<%-- 		                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].other_price"  --%>
<%-- 											value="<ww:property value='form.salesDetailList[#rows.index].other_price'/>" class="form-control text-right" --%>
<!-- 											oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/> -->
<!-- 		                            </td> -->
		                            <!-- sxt 20221024 del end -->
		            
		                            <td rowspan="2">
		                            	<!-- sxt 20221024 add start -->
		                            	<input type="hidden" name="form.salesDetailList[<ww:property value='#rows.index'/>].other_price" 
											value="<ww:property value='form.salesDetailList[#rows.index].other_price'/>" />
		                            	<!-- sxt 20221024 add end -->
		                              <input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].amount" 
												value="<ww:property value='form.salesDetailList[#rows.index].amount'/>" class="form-control text-right"
												readonly style="background-color:#fff" />
		                            </td>
		                            <td rowspan="2">
		                            	<!-- sxt 20221024 add start -->
										<ww:if test="time_kbn.equals('')">
											<input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].carfare" 
												value="<ww:property value='form.salesDetailList[#rows.index].carfare'/>" class="form-control text-right"
												readonly style="background-color:#fff"/>
										</ww:if>
										<ww:else>
										<!-- sxt 20221024 add end -->
											<input type="number" name="form.salesDetailList[<ww:property value='#rows.index'/>].carfare" 
												value="<ww:property value='form.salesDetailList[#rows.index].carfare'/>" class="form-control text-right"
												oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/> 
										</ww:else>	<!-- sxt 20221024 add -->
		                            </td>
		                            <td class="text-center" rowspan="2">
										<ww:textarea name="'form.salesDetailList['+#rows.index+'].biko'" value="biko" cssClass="'form-control'" cssStyle="'height:4.5em'"></ww:textarea>
									</td>
		                          </tr>
		                          <tr>
		                            <td style="border-top: none;">
										<input type=text disabled name="form.salesDetailList[<ww:property value='#rows.index'/>].company_name" 
											value="<ww:property value='form.salesDetailList[#rows.index].company_name'/>" style="background-color: #ffffff;" />	 
									</td>
		                          </tr>
		                          <%  s++; %>
		                          </ww:iterator>
		                      </tbody>
	                        
					          <tfoot>
								<tr>
									<td colspan="8" nowrap rowspan="4"></td>
									<td class="text-center" nowrap colspan="2">課税対象額計</td>
									<td class="text-right" nowrap>
										<label id="receive_amount"><ww:property value='form.receive_amount'/></label>
									</td>
								</tr>
								<tr>
									<td class="text-center" nowrap colspan="2">消費税</td>
									<td class="text-right" nowrap>
										<label id="tax_amount"><ww:property value='form.tax_amount'/></label>
									</td>
								</tr>
								<tr>
									<td class="text-center" nowrap colspan="2">交通費など</td>
									<td class="text-right" nowrap>
										<label id="carfare"><ww:property value='form.carfare'/></label>
									</td>
								</tr>
								<tr>
									<td class="text-center" nowrap colspan="2">合計額</td>
									<td class="text-right" nowrap>
										<label id="tax_in_amount"><ww:property value='form.tax_in_amount'/></label>
									</td>
								</tr>
						 	  </tfoot>
                          </table>

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

                <div class="form-group"  style="margin-top:1.25rem">
                  <div>                   
					<ww:if test="form.prepage.equals(\"6\")">
					    <input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="hrefAction('showUriageYoteiItiran.action')">
					</ww:if>
					<ww:elseif test="form.prepage.equals(\"0\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'returnTopAction.action')">
					</ww:elseif>
					<!-- sxt 20220711 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
					</ww:elseif>
					<!-- sxt 20220711 add end -->
					<ww:else>
					<input type="button" class="btn btn-primary dora-sm-button" value="戻る" onclick="submitFunction(this.form,'refreshNewUriage.action')"> 
					</ww:else>
					
					<ww:if test="form.prepage.equals(\"0\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'saveTopEditUriage2.action')">	
					</ww:if>
					<!-- sxt 20220721 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'saveEditUriage2FromProject.action')">
					</ww:elseif>
					<!-- sxt 20220721 add end -->
					<ww:else>
						<input type="button" class="btn btn-primary dora-sm-button" value="保存" onclick="formSubmitDblClkChk(this.form,'saveEditUriage2.action')">	
					</ww:else>	
					<ww:if test="form.prepage.equals(\"0\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="削除" onclick="deleteTopUriage()">	
					</ww:if>
					<!-- sxt 20220721 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<input type="button" class="btn btn-primary dora-sm-button" value="削除" onclick="deleteUriageFromProject()">
					</ww:elseif>
					<!-- sxt 20220721 add end -->
					<ww:else>			
						<input type="button" class="btn btn-primary dora-sm-button" value="削除" onclick="deleteUriage()">	
					</ww:else>	
					<!-- sxt 20220811 add start -->
					<ww:if test="form.approval_div == '03'">
						<ww:if test="form.month_close_flg.equals(\"1\") ">
							<input type="button" class="btn btn-primary dora-sm-button" value="印刷" onclick="openWindowResizable('uriagePrint.action?form.sales_no=<ww:property value='form.sales_no'/>&form.shurui=<ww:property value='form.shurui'/>','印刷',800,600);"">	
						</ww:if>
					</ww:if>
					<!-- sxt 20220811 add end -->			
                  </div>
                </div>
            </div>
          </div>

		<ww:hidden name="'form.work_time_from'" value="form.work_time_from"></ww:hidden>
		<ww:hidden name="'form.work_time_to'" value="form.work_time_to"></ww:hidden>
		<ww:hidden name="'form.shurui'"> </ww:hidden>
		<ww:hidden name="'form.received_in_code_input'" value="form.received_in_code_input"></ww:hidden>
		<ww:hidden name="'form.request_no'" value="form.request_no"></ww:hidden>
<%-- 		<ww:hidden name="'form.request_date'" value="form.request_date"></ww:hidden> --%>
		<ww:hidden name="'form.reg_id'" value="form.reg_id"></ww:hidden>
		<ww:hidden name="'form.reg_date'" value="form.reg_date"></ww:hidden>
		<ww:hidden name="'form.reg_name'" value="form.reg_name"></ww:hidden>
		<ww:hidden name="'form.estimate_amount_flg'" > </ww:hidden>
		<ww:hidden name="'form.tax_amount_flg'"> </ww:hidden>
		<ww:hidden name="'form.amount_flg'"> </ww:hidden>
		<ww:hidden name="'form.month_close_flg'" value="form.month_close_flg"></ww:hidden>  
		<ww:hidden name="'form.payment_method'" > </ww:hidden><!-- sxt 20220923 add -->
        </div>
        <ww:include value="'/footer.jsp'" />
      </div>		
</form>
</body>
<ww:include value="'/footerJs.jsp'" />
	<!-- sxt 20220621 add start  -->
	<script language="JavaScript">
		$(document).ready(function(){
			
			//sxt 20220923 add start#
			/* 精算方法*/
			var payment_method = $("input[name='form.payment_method']").val();		
			if (payment_method == '1'){
				$("#payment_method1").show();
				$("#payment_method2").show();
			} else {
				$("#payment_method1").hide();
				$("#payment_method2").hide();
			}
			//sxt 20220923 add end
			
			//合計金額計算
			calculateTotal();
			
			//算出
			$("#calculateInputPreDate").click(function(){
				$.ajax({
			        type: "POST",  
			        url: "calculateEditPreDate.action",
			        error: function (error) {  
			        	alert(error);
			        },
			        success: function (data) { 
			        	$("#input_pre_date").val(data);
			        }
			    });
			});
			
			/* 内容blurイベント*/
			$("input[name$='task_content']").blur(function(){
				
				//获取当前元素的name
				var x = $(this).prop("name");
				
				if (!$(this).val()){
					//获取索引值
					var index = getCurIndex(x);
					
	 				//技術者コードをクリアする
	 				$("input[name='form.salesDetailList[" + index +"].task_code'").val("");
	 				
	 				//会社名をクリアする
	 				$("input[name='form.salesDetailList[" + index +"].company_name'").val("");
				}
			});
			
			/* 明細部人月時間区分changeイベント*/
			$("select[name$='time_kbn']").change(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				//sxt 20221025 add start
				//空白を選択する時
				if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == ""){	
					
					//単価,超過単価,控除単価,工数を入力不可
					setItemState(true,index);
					
				} else {

					//単価,超過単価,控除単価,工数を入力可能
					setItemState(false,index);
					//sxt 20221025 add end
				
					//精算額をセットする
					setPriceAttr(index);
					
					//精算額を計算
					setCalculateAmount(index);
					
					//金額計算
					setAmount(index);
				
				}	//sxt 20221025 add 

			});
			
			//sxt 20220928 add start
			/* 契約単価blurイベント*/
			$("input[name$='price_per']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				//金額計算
				setAmount(index);
					
			});
			//sxt 20220928 add end
						
			/* 明細部稼働時間blurイベント*/
			$("input[name$='quantity']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");

				//获取索引值
				var index = getCurIndex(x);
				
				//精算額を計算
				setCalculateAmount(index);
				
				//金額計算
				setAmount(index);
				
			});
			
			/* 明細部超過単価blurイベント*/
			$("input[name$='more_price']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");

				//获取索引值
				var index = getCurIndex(x);
				
				//精算額を計算
				setCalculateAmount(index);
				
				//金額計算
				setAmount(index);
					
			});
			
			/* 明細部控除単価blurイベント*/
			$("input[name$='less_price']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");

				//获取索引值
				var index = getCurIndex(x);
				
				//精算額を計算
				setCalculateAmount(index);
				
				//金額計算
				setAmount(index);
					
			});
			
			/* 明細部精算額blurイベント*/
			$("input[name$='calculate_amount']").blur(function(){
			
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);

				//金額計算
				setAmount(index);
			});
			
			/* 明細部その他blurイベント*/
			$("input[name$='other_price']").blur(function(){
			
				//获取当前元素的name
				var x = $(this).prop("name");
				
				//获取索引值
				var index = getCurIndex(x);
				
				//金額計算
				setAmount(index);
				
			});
			
			/* 明細部交通費blurイベント*/
			$("input[name$='carfare']").blur(function(){
			
				//合計金額計算
				calculateTotal();
			});
			
			//sxt 20220923 add start
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
			//sxt 20220923 add end

		});
		
		//sxt 20221025 add start
		function setItemState(isReadOnly,index){
			if (isReadOnly){
				$("input[name='form.salesDetailList[" + index +"].price_per'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].price_per'").attr("style","background-color:#fff");
				$("input[name='form.salesDetailList[" + index +"].price_per'").val("");
				
				$("input[name='form.salesDetailList[" + index +"].quantity'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].quantity'").attr("style","background-color:#fff");
				$("input[name='form.salesDetailList[" + index +"].quantity'").val("");
				
				$("input[name='form.salesDetailList[" + index +"].more_price'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].more_price'").attr("style","background-color:#fff");
				$("input[name='form.salesDetailList[" + index +"].more_price'").val("");
				
				$("input[name='form.salesDetailList[" + index +"].less_price'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].less_price'").attr("style","background-color:#fff");
				$("input[name='form.salesDetailList[" + index +"].less_price'").val("");
				
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").attr("style","background-color:#fff");
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").val("");
				
				$("input[name='form.salesDetailList[" + index +"].carfare'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].carfare'").attr("style","background-color:#fff");
				$("input[name='form.salesDetailList[" + index +"].carfare'").val("");
				
			} else {
				$("input[name='form.salesDetailList[" + index +"].price_per'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].price_per'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].quantity'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].quantity'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].more_price'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].more_price'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].less_price'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].less_price'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].carfare'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].carfare'").removeAttr("style");
			}
		}
		//sxt 20221025 add end
		
		//精算額を計算
		function setCalculateAmount(index){
			
			//月を選択する時
			if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == "01"){		
				
				//月間作業基準時間from
				var work_time_from = parseFloat($("input[name='form.work_time_from'").val());
				//月間作業基準時間to
				var work_time_to = parseFloat($("input[name='form.work_time_to'").val());
									
				//稼働時間
				var quantity = 0;
				if ($("input[name='form.salesDetailList[" + index +"].quantity'").val()){
					quantity = parseFloat($("input[name='form.salesDetailList[" + index +"].quantity'").val());
				}
												
				//契約単価
				var price = 0;
				if ($("input[name='form.salesDetailList[" + index +"].price_per'").val()){
					price = parseFloat($("input[name='form.salesDetailList[" + index +"].price_per'").val());
				}
								
				//精算額
				var calculateAmount = 0;
				//超過料金を計算
				if (quantity > work_time_to) {
					//超過単価
					//var morePrice = price / work_time_to;
					var morePrice = parseFloat($("input[name='form.salesDetailList[" + index +"].more_price'").val());
						
					//超過料金
					calculateAmount = (quantity - work_time_to) * morePrice;
				}
				
				//控除金額を計算
				if (quantity < work_time_from) {
					//控除単価
					//var lessPrice = price / work_time_from;
					var lessPrice = parseFloat($("input[name='form.salesDetailList[" + index +"].less_price'").val());
						
					//控除金額
					calculateAmount = (quantity - work_time_from) * lessPrice;
				}
																			
				//端数処理
				calculateAmount = doProcessing(calculateAmount);
		
				if (calculateAmount != 0) {
					$("input[name='form.salesDetailList[" + index +"].calculate_amount'").val(calculateAmount);	
				} else {
					$("input[name='form.salesDetailList[" + index +"].calculate_amount'").val("");	
				}


			} else if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == "02"){		
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").val("");
			}
		}
		
		//金額を計算
		function setAmount(index){
			
			//金額
			var amount;
			//契約単価
			var price = 0;
			if ($("input[name='form.salesDetailList[" + index +"].price_per'").val()){
				price = parseFloat($("input[name='form.salesDetailList[" + index +"].price_per'").val());
			}
			
			//精算額
			var calculateAmount = 0;
			if ($("input[name='form.salesDetailList[" + index +"].calculate_amount'").val()){
				calculateAmount = parseFloat($("input[name='form.salesDetailList[" + index +"].calculate_amount'").val());
			}

			//稼働時間
			var quantity = 0;
			if ($("input[name='form.salesDetailList[" + index +"].quantity'").val()){
				quantity = parseFloat($("input[name='form.salesDetailList[" + index +"].quantity'").val());
			}
				
			//そのた
			var otherPrice = 0;
			if ($("input[name='form.salesDetailList[" + index +"].other_price'").val()){
				otherPrice = parseFloat($("input[name='form.salesDetailList[" + index +"].other_price'").val());
			}
							
			//月を選択する時
			if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == "01"){		
				//月：金額＝　契約単価　＋　精算額　＋　そのた
				amount = price + calculateAmount + otherPrice;
									
			//時を選択する時
			}　else if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == "02"){
				//時：金額＝　契約単価X稼働時間　＋　そのた
				amount = price * quantity + otherPrice;
				
				//端数処理
				amount = doProcessing(amount);
			}
			
			if (amount != 0) {
				$("input[name='form.salesDetailList[" + index +"].amount'").val(amount);	
			} else {
				$("input[name='form.salesDetailList[" + index +"].amount'").val("");	
			}
			
			//合計金額計算
			calculateTotal();
		}
		
		//精算額をセットする
		function setPriceAttr(index){
			//月を選択する時
			if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == "01"){	
				
				$("input[name='form.salesDetailList[" + index +"].more_price'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].more_price'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].less_price'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].less_price'").removeAttr("style");
				
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").removeAttr("readonly");
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").removeAttr("style");

			//時を選択する時
			}　else if ($("select[name='form.salesDetailList[" + index +"].time_kbn'").val() == "02"){
				
				$("input[name='form.salesDetailList[" + index +"].more_price'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].more_price'").attr("style","background-color:#fff");
				
				$("input[name='form.salesDetailList[" + index +"].less_price'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].less_price'").attr("style","background-color:#fff");
				
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").attr("readonly","true");
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").attr("style","background-color:#fff");
				
				//精算額空白に
				$("input[name='form.salesDetailList[" + index +"].more_price'").val("");
				$("input[name='form.salesDetailList[" + index +"].less_price'").val("");
				$("input[name='form.salesDetailList[" + index +"].calculate_amount'").val("");
			}
		}
		
		//获取当前索引
		function getCurIndex(x){
			//获取索引值
			var start = x.indexOf("[");
			var end = x.indexOf("]");
			return  parseInt(x.substr(start+1,end-start-1));
		}
				
		//端数処理
		function doProcessing( amount ) {
			//端数処理
			var processing = $("input[name='form.processing'").val();
			
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
		
		//合計金額計算
		function calculateTotal(){
			
			//画面.消費税率
			var tax_rate = $("input[name='form.tax_rates'").val();

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
			//交通費合計
			var carfareTotal = 0;
			
			var detailsize =  parseInt($("#detailsize").val());
						
			for (var i = 0; i < detailsize; i++) {
				
				//明細金額
				var amountDetail = 0; ;	
				if ($("input[name='form.salesDetailList[" + i +"].amount'").val()) {
					amountDetail = parseInt($("input[name='form.salesDetailList[" + i +"].amount'").val());
				} 
				
				//明細交通費
				var carfareDetail = 0; ;	
				if ($("input[name='form.salesDetailList[" + i +"].carfare'").val()) {
					carfareDetail = parseInt($("input[name='form.salesDetailList[" + i +"].carfare'").val());
				} 
				
				//明細税区分
				var tax_div = $("select[name='form.salesDetailList[" + i +"].tax_div'").val();
				
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
				
				//交通費合計
				carfareTotal += carfareDetail;
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
// 				$("#receive_amount").text("￥" + amount.toLocaleString());
// 				$("#tax_amount").text("￥" + tax_amount.toLocaleString());
// 				$("#carfare").text("￥" + carfareTotal.toLocaleString());
// 				$("#tax_in_amount").text("￥" + (amount + tax_amount).toLocaleString());				
// 			}	
			
			$("#receive_amount").text("￥" + amount.toLocaleString());
			$("#tax_amount").text("￥" + tax_amount.toLocaleString());
			$("#carfare").text("￥" + carfareTotal.toLocaleString());
			$("#tax_in_amount").text("￥" + (amount + tax_amount).toLocaleString());	
		}
	</script>
	<!-- sxt 20220621 add end  -->
</html>