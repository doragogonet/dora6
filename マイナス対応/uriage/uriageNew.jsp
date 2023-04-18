<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>売上（請負）新規画面</title>
	<style>
      .table > thead > tr > td {
        padding: 0.25rem 0 0.25rem 0;
        vertical-align:top;
        font-weight: bold;
      }
      .table > tbody > tr > td {
        padding: 0.125rem;
/*         vertical-align:top; */
      }
      .table > tfoot > tr > td {
        padding: 0.5rem;
      }
	</style>
	<script language="JavaScript">

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
					//sxt 20220621 del start
					//document.uriageform.action="deleteRowSales.action";
					//document.uriageform.submit();
					//sxt 20220621 del end
					return true;	//sxt 20220621 add 
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
			//alert(num);
			var amount =0;
			var index;
			var price =  document.uriageform.elements['form.receivedDetailList['+num +'].price_per'].value;
			var quantity = document.uriageform.elements['form.receivedDetailList['+num +'].quantity'].value;
			//alert(price);
			var processing = "";
			if(document.uriageform.elements['form.processing']!=null){
				processing = document.uriageform.elements['form.processing'].value;
			}
			if(checkPrice(price) && checkQuantity(quantity) && processing != ""){
				amount = price * quantity;
				ret = amount.toString();
				index = ret.indexOf(".");
				if (index == -1){
					document.uriageform.elements['form.receivedDetailList['+num +'].amount'].value = amount;		
				}else {
					if(processing == "02") {
						str1 = ret.substr(0,index);
						str2 = ret.substr(index + 1,1);
						if (parseInt(str2) > 4) {
							str1 = (parseInt(str1) + 1).toString();
						}
						document.uriageform.elements['form.receivedDetailList['+num +'].amount'].value = str1;
					} else if (processing == "01"){
						str1 = ret.substr(0,index);
						document.uriageform.elements['form.receivedDetailList['+num +'].amount'].value = str1;
					} else if (processing == "03"){
						str1 = ret.substr(0,index);
						str2 = ret.substr(index + 1,1);
						if (parseInt(str2) > 0) {
							str1 = (parseInt(str1) + 1).toString();
						}
						document.uriageform.elements['form.receivedDetailList['+num +'].amount'].value = str1;
					}	
				}
			}
		}			
		
		function calculateAll(){
			var size = <ww:property value="form.receivedDetailList.size()" />; 
			var i = 0;
			for(i;i < size;i++){
				var unit = document.uriageform.elements['form.receivedDetailList['+i+'].quantity'].value;
				var price_per = document.uriageform.elements['form.receivedDetailList['+i+'].price_per'].value;
				var processing = document.uriageform.elements['form.processing'].value;
								
				var result = 0;
				var index;
				if(checkPrice(price_per) && checkQuantity(unit) && processing != "") {
					result = price_per * unit;
					ret = result.toString();
					index = ret.indexOf(".");
					if (index == -1){
						document.uriageform.elements['form.receivedDetailList['+i+'].amount'].value = result;
					} else {
						if(processing == "02") {
							str1 = ret.substr(0,index);
							str2 = ret.substr(index + 1,1);
							if (parseInt(str2) > 4) {
								str1 = (parseInt(str1) + 1).toString();
							}
							document.uriageform.elements['form.receivedDetailList['+i+'].amount'].value = str1;
						} else if (processing == "01"){
							str1 = ret.substr(0,index);
							document.uriageform.elements['form.receivedDetailList['+i+'].amount'].value = str1;
						} else if (processing == "03"){
							str1 = ret.substr(0,index);
							str2 = ret.substr(index + 1,1);
							if (parseInt(str2) > 0) {
								str1 = (parseInt(str1) + 1).toString();
							}
							document.uriageform.elements['form.receivedDetailList['+i+'].amount'].value = str1;
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
            売上（請負）新規画面
            <ww:include value="'/loginName.jsp'"/>           
          </div>
          <div class="panel panel-default">
            <div class="panel-body">
            	<ww:include value="'/message.jsp'" />
              
                <!--button-->              
                <div class="form-group">
                  <div>                   
                   	<ww:if test="form.prepage.equals(\"6\")">
                   		<button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('showUriageYoteiItiran.action')">戻る</button>
					</ww:if>
					<!-- sxt 20220711 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
					</ww:elseif>
					<!-- sxt 20220711 add end -->
					<ww:else>
						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitFunction(this.form,'refreshNewUriage.action')">戻る</button>
					</ww:else> 
					<!-- sxt 20220721 del start -->
<!-- 					<button type="button" class="btn btn-primary dora-sm-button" onclick="formSubmitDblClkChk(this.form,'saveUriage.action');">保存</button>	 -->
					<!-- sxt 20220721 del end -->
					<!-- sxt 20220721 add start -->
					<ww:if test="form.prepage.equals(\"7\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="formSubmitDblClkChk(this.form,'saveUriageFromProject.action');">保存</button>	
					</ww:if>	
					<ww:else>
						<button type="button" class="btn btn-primary dora-sm-button" onclick="formSubmitDblClkChk(this.form,'saveUriage.action');">保存</button>
					</ww:else>
					<!-- sxt 20220721 add end -->		
                  </div>
                </div>

                <!--状態区域-->
                <div class="panel-body" style="padding:1.75rem 1rem">
                  <div class="dora-state-zone">承認(未)</div>
                  <div class="dora-state-zone">契約形態 <ww:property value="form.contract_form_name" /></div>
                  <div class="dora-state-zone">請求区分 <ww:property value="form.order_div_name" /></div>
                  <div class="dora-state-zone">請求書発行(未)</div>
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
                            <button type="button" class="btn btn-link" onclick="hrefHaveParamAction('mitumoriInfo.action?form.estimate_no=<ww:property value="form.estimate_no" />&form.pageFlg=5')">
                          		<ww:property value="form.estimate_no" />
                          	</button>
                          </span>
                          <span>
                            受注番号
                            <button type="button" class="btn btn-link" onclick="hrefHaveParamAction('jyutyuInfo.action?form.pageFlg=2&form.receive_no=<ww:property value="form.received_no_input" />');">
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
                          <label for="estimate_date" class="dora-label-left-require">売上番号</label>
                          <input type="text" name="form.sales_no" value="<ww:property value='form.sales_no'/>" maxlength="25" class="form-control" placeholder="売上番号">
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
                              <td class="text-center" rowspan="2" style="width:4.5rem;">行</td>
                              <td class="text-center" rowspan="2" colspan="2" style="width:20rem;">作業内容</td>
                              <td class="text-center" rowspan="2" style="width:18rem;">単価</td>
                              <td class="text-center" rowspan="2" style="width:14rem;">数量</td>
                              <td class="text-center" style="width:17rem;">単位</td>
                              <td class="text-center" style="width:18rem;">金額</td>
                              <td class="text-center" rowspan="2" style="width:2rem;"></td>
                            </tr>
                            <tr>
                              <td class="text-center" nowrap>税区分</td>
                              <td class="text-center" nowrap>原価</td>
                              <ww:hidden name="'detailsize'" id="detailsize" value="form.receivedDetailList.size()"></ww:hidden>
                            </tr>
                          </thead>
                          <tbody id="tbAddPart">
                            <%int s = 0; %>
                            <ww:iterator value="form.receivedDetailList" status="rows" id="model">	
                            <tr>
                              <td class="text-center" rowspan="2" style="vertical-align:top;">
                                <input type="number" name="form.receivedDetailList[<ww:property value='#rows.index'/>].row_number" 
									value='<ww:property value="form.receivedDetailList[#rows.index].row_number"/>' class="form-control text-right"
									oninput="maxNumberLength(2)" onKeypress="return integerOnly()"/>
                              </td>
                              <td class="text-center" rowspan="2">
                                <ww:hidden name="'form.receivedDetailList['+#rows.index+'].task_code'" />
				  			    <ww:textarea name="'form.receivedDetailList['+#rows.index+'].task_content'" value="task_content" cssClass="'control'" rows="3"></ww:textarea>
                              </td>
                              <td class="text-center" rowspan="2" style="width:6rem;">
                                <input type="button" value="参照" class="btn btn-primary dora-tabel-button" onclick="openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.receivedDetailList[<%=s%>].task_code&form.fieldName_name=form.receivedDetailList[<%=s%>].task_content','作業内容参照',670,600)">
                              </td>
                              <td class="text-center"  >
                                <input type="number" name="form.receivedDetailList[<ww:property value='#rows.index'/>].price_per" 
									value="<ww:property value='form.receivedDetailList[#rows.index].price_per'/>" class="form-control text-right"
									oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/> 
                              </td>
                              <td class="text-center" >
                                <input type="number" name="form.receivedDetailList[<ww:property value='#rows.index'/>].quantity" 
									value="<ww:property value='form.receivedDetailList[#rows.index].quantity'/>" class="form-control text-right"
									oninput="maxNumberLength(8)" --onkeypress="return integerAndDecimal()" onchange="decimalLength(8,3)"/>  
                              </td>
                              <td class="text-center" >
                                <ww:select name="'form.receivedDetailList['+#rows.index+'].unit_div'"
									       cssClass="'form-control'" 
									       list="form.unitNameList"
									       listKey="code_id"
									       listValue="code_value"
									       value="unit_div"
									       headerKey="''"
									       headerValue="'選択してください'">
							    </ww:select>
                              </td>
                              <td class="text-center"  >
                                <input type="number" name="form.receivedDetailList[<ww:property value='#rows.index'/>].amount" 
									value="<ww:property value='form.receivedDetailList[#rows.index].amount'/>" class="form-control text-right"
									oninput="maxNumberLength(13)" onKeypress="return integerOnly()"/>
                              </td>
                              <td class="text-center"  rowspan="2">
                                <ww:checkbox name="'form.receivedDetailList['+#rows.index+'].checkbox'" fieldValue="checkbox" ></ww:checkbox>
                              </td>
                            </tr>
                            <tr>
                              <td class="text-center" ></td>
                              <td class="text-center" ></td>
                              <td class="text-center" >
                                <ww:select name="'form.receivedDetailList['+#rows.index+'].tax_div'"
								       	   cssClass="'form-control'" 
								           list="form.taxDivList"
								       	   listKey="code_id"
								    	   listValue="code_value"
									       value="tax_div"
									       headerKey="''"
									       headerValue="''">
						        </ww:select>
                              </td>
                              <td class="text-center" >
                                <input type="number" name="form.receivedDetailList[<ww:property value='#rows.index'/>].org_price" 
									value="<ww:property value='form.receivedDetailList[#rows.index].org_price'/>" class="form-control text-right"
									oninput="maxNumberLength(8)" onKeypress="return integerOnly()"/> 
                              </td>
                            </tr>
                            
                            <%  s++; %>
							</ww:iterator>
                          </tbody>
                          
                          <tfoot>
							<tr>
								<td colspan="3" nowrap rowspan="3"></td>
								<td class="text-center" nowrap colspan="2">合 計</td>
								<td class="text-right" nowrap colspan="2">
									<label id="receive_amount"><ww:property value="form.receive_amount"/></label>
								</td>
								<td class="text-right" rowspan="3"></td>
							</tr>
							<tr>
								<td class="text-center" nowrap colspan="2">消 費 税</td>
								<td class="text-right" nowrap colspan="2">
									<label id="tax_amount"><ww:property value="form.tax_amount"/></label>
								</td>
							</tr>
							<tr>
								<td class="text-center" nowrap colspan="2">税込合計</td>
								<td class="text-right" nowrap colspan="2">
									<label id="tax_in_amount"><ww:property value="form.tax_in_amount"/></label>
								</td>
							</tr>
                        </tfoot>
                        </table>

                        <div class="form-group" style="margin-bottom:1rem;">
                          <div>
<!--                             <button type="button" class="btn btn-primary" onclick="submitFunction(this.form,'addRowSales.action')">明細行追加</button> -->
<!--                             <button type="button" class="btn btn-primary" onclick="deleteRow(this.form);">明細削除</button> -->
                            <button type="button" class="btn btn-primary" id="addRow">明細行追加</button>
						    <button type="button" class="btn btn-primary" id="deleteRow">明細削除</button>
                          </div>
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

                <div class="form-group"  style="margin-top:1.25rem">
                  <div>                   
                   	<ww:if test="form.prepage.equals(\"6\")">
                   		<button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('showUriageYoteiItiran.action')">戻る</button>
					</ww:if>
					<!-- sxt 20220711 add start -->
					<ww:elseif test="form.prepage.equals(\"7\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="hrefAction('returnProjectDetail.action')">戻る</button>
					</ww:elseif>
					<!-- sxt 20220711 add end -->
					<ww:else>
						<button type="button" class="btn btn-primary dora-sm-button" onclick="submitFunction(this.form,'refreshNewUriage.action')">戻る</button>
					</ww:else> 
					<!-- sxt 20220721 del start -->
<!-- 					<button type="button" class="btn btn-primary dora-sm-button" onclick="formSubmitDblClkChk(this.form,'saveUriage.action');">保存</button>	 -->
					<!-- sxt 20220721 del end -->
					<!-- sxt 20220721 add start -->
					<ww:if test="form.prepage.equals(\"7\")">
						<button type="button" class="btn btn-primary dora-sm-button" onclick="formSubmitDblClkChk(this.form,'saveUriageFromProject.action');">保存</button>	
					</ww:if>	
					<ww:else>
						<button type="button" class="btn btn-primary dora-sm-button" onclick="formSubmitDblClkChk(this.form,'saveUriage.action');">保存</button>
					</ww:else>
					<!-- sxt 20220721 add end -->			
                  </div>
                </div>
            </div>
          </div>
  		<ww:hidden name="'form.estimate_amount_flg'" > </ww:hidden>
		<ww:hidden name="'form.tax_amount_flg'"> </ww:hidden>
		<ww:hidden name="'form.amount_flg'"> </ww:hidden>
		<ww:hidden name="'form.shurui'"> </ww:hidden>
        </div>
        <ww:include value="'/footer.jsp'" />
      </div>
</form> 
</body>
<ww:include value="'/footerJs.jsp'" />
	<!-- sxt 20220621 add start  -->
	<script language="JavaScript">
		$(document).ready(function(){
			
			//合計金額計算
			calculateTotal();
			
			//算出
			$("#calculateInputPreDate").click(function(){
				$.ajax({
			        type: "POST",  
			        url: "calculateInputPreDate.action",
			        error: function (error) {  
			        	alert(error);
			        },
			        success: function (data) {  
			        	$("#input_pre_date").val(data);
			        }
			    });
			});
			
			//明細行追加
			$("#addRow").click(function(){
				
				$.ajax({
			        type: "POST",  
			        url: "addRowSales.action",
			        error: function (error) {  

			        },
			        success: function (data) {  	        	      
			        	addRow();
			        }
			    });
		
				function addRow(){
					var size = parseInt($("#detailsize").val());
						
					if (size == 90) {
						return false;
					}
					
					//最大行番号を取得する
					var maxRowNumber = parseInt($("input[name='form.receivedDetailList[" + (size-1) +"].row_number'").val());
					
					//新しい５行を追加
					for (var i = 0; i < 5; i++) {
						appendRow(i+size,i+maxRowNumber+1); 
					}
					
					$("#detailsize").val(5+size);
				}
							
			});
			
			function appendRow(n,rowNumber){
				//1行目をコピー
				var tr0 = $("#tbAddPart tr").eq(0).clone();
				
				//获得当前行第1个TD值
				var col0 = tr0.find("td:eq(0)"); 
				//获得当前TD的input标签 【行】
				var row_number = col0.find("input");
				//设置input标签name
				row_number.attr("name","form.receivedDetailList[" + n + "].row_number");
				//设置input标签value
				row_number.attr("value",rowNumber); 
				
				//获得当前行第2个TD值 
				var col1 = tr0.find("td:eq(1)"); 
				//获得当前TD的input标签 【作業内容】
				var task_code = col1.find("input");
				task_code.attr("name","form.receivedDetailList[" + n + "].task_code");
				task_code.attr("value",""); 
				task_code.val("");
				
				var task_content = col1.find("textarea");
				task_content.attr("name","form.receivedDetailList[" + n + "].task_content");
				task_content.attr("value",""); 
				task_content.val("");
				
				//获得当前行第3个TD值 
				var col2 = tr0.find("td:eq(2)"); 
				//获得当前TD的input标签 【参照】
				var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.receivedDetailList[" + n + "].task_code&form.fieldName_name=form.receivedDetailList[" + n+ "].task_content','作業内容参照',670,600)";
				var sanshoButton = col2.find("input");
				sanshoButton.attr("onclick",clickContent);
				sanshoButton.attr("name","button[" + n + "]");
				
				//获得当前行第4个TD值 
				var col3 = tr0.find("td:eq(3)"); 
				//获得当前TD的input标签 【単価】
				var price_per = col3.find("input");
				price_per.attr("name","form.receivedDetailList[" + n + "].price_per");
				price_per.attr("value",""); 
				price_per.val("");

				//获得当前行第5个TD值 
				var col4 = tr0.find("td:eq(4)"); 
				//获得当前TD的input标签 【数量】
				var quantity = col4.find("input");
				quantity.attr("name","form.receivedDetailList[" + n + "].quantity");
				quantity.attr("value",""); 
				quantity.val("");
				
				//获得当前行第6个TD值 
				var col5 = tr0.find("td:eq(5)"); 
				//获得当前TD的input标签 【単位】
				var unit_div = col5.find("select");
				unit_div.attr("name","form.receivedDetailList[" + n + "].unit_div");
				unit_div.attr("value",""); 
				unit_div.val("");
				
				//获得当前行第7个TD值 
				var col6 = tr0.find("td:eq(6)"); 
				//获得当前TD的input标签 【単位】
				var amount = col6.find("input");
				amount.attr("name","form.receivedDetailList[" + n + "].amount");
				amount.attr("value",""); 
				amount.val("");
				
				//获得当前行第8个TD值 
				var col7 = tr0.find("td:eq(7)"); 
				//获得当前TD的input标签  【checkbox】
				var checkbox = col7.find("input");
				checkbox.attr("name","form.receivedDetailList[" + n + "].checkbox");
				checkbox.attr("value","0"); 
				checkbox.prop('checked',false)
				
				//1行目を追加
				tr0.appendTo("#tbAddPart");
				 
				//2行目をコピー
				var tr1 = $("#tbAddPart tr").eq(1).clone();
				
				//获得当前行第3个TD值 
				var tr1col2 = tr1.find("td:eq(2)"); 
				//获得当前TD的input标签 【税区分】
				var tax_div = tr1col2.find("select");
				tax_div.attr("name","form.receivedDetailList[" + n + "].tax_div");
				tax_div.attr("value",""); 
				tax_div.val("");
				
				//获得当前行第4个TD值 
				var tr1col3 = tr1.find("td:eq(3)"); 
				//获得当前TD的input标签 【税区分】
				var org_price = tr1col3.find("input");
				org_price.attr("name","form.receivedDetailList[" + n + "].org_price");
				org_price.attr("value",""); 
				org_price.val("");
				
				//2行目を追加
				tr1.appendTo("#tbAddPart");

			}
			
			//明細削除
			$("#deleteRow").click(function(){
				
				if (deleteRow()) {
					$.ajax({
				        type: "POST",  
				        url: "deleteRowSales.action",
				        error: function (error) {  

				        },
				        success: function (data) {  	
					        	
				        	$("input[name$='checkbox']:checked").each(function() { 	
				        		
				        		var obj;
								
								// 获取checkbox所在行的顺序
								var n = $(this).parents("tr").index(); 
								
								obj = $(this).prop("name");
								
								//当前index
								var curIndex = getCurIndex(obj);
	
								// 画面的一行实际上是有2行<tr>组成的，所有要删除2行tr
								removeRow(n);
								removeRow(n);
								
								var maxRowNuber;	//最大行番号
								var maxIndex;		//最大index

								$("input[name^='form.receivedDetailList'][name$='row_number']").each(function() {
									//获取当前元素的name
									maxRowNuber = parseInt($(this).val());
									
									obj = $(this).prop("name");
									//获取索引值
									maxIndex = getCurIndex(obj);
								});
															
								appendRow(maxIndex+1,maxRowNuber+1); 

								reSetRowIndex(curIndex);

				        	});
				        	
				        	//sxt 20220815 add start
				        	//合計金額計算
							calculateTotal();
							//sxt 20220815 add end
				        }
				    });
				}
				
			});
						
			function reSetRowIndex(curIndex){

				var index;
				$("input[name^='form.receivedDetailList'][name$='row_number']").each(function() {
					//获取当前元素的name			
					var x = $(this).prop("name");
					//获取索引值
					index = getCurIndex(x);
							
					if (index > curIndex){

						$("input[name='form.receivedDetailList[" + index +"].row_number'").attr("name","form.receivedDetailList[" + (index-1) + "].row_number");
						$("input[name='form.receivedDetailList[" + index +"].task_code'").attr("name","form.receivedDetailList[" + (index-1) + "].task_code");
						$("textarea[name='form.receivedDetailList[" + index +"].task_content'").attr("name","form.receivedDetailList[" + (index-1) + "].task_content");
						
						var clickContent = "openWindowWithScrollbarGuide('initSagyounaiyouGuide.action?form.fieldName_code=form.receivedDetailList[" + (index-1) + "].task_code&form.fieldName_name=form.receivedDetailList[" + (index-1) + "].task_content','作業内容参照',670,600)";		
						$("input[name='button[" + index +"]'").attr("onclick",clickContent);
						$("input[name='button[" + index +"]'").attr("name","button[" + (index-1) + "]");
							
						$("input[name='form.receivedDetailList[" + index +"].price_per'").attr("name","form.receivedDetailList[" + (index-1) + "].price_per");
						$("input[name='form.receivedDetailList[" + index +"].quantity'").attr("name","form.receivedDetailList[" + (index-1) + "].quantity");
						$("select[name='form.receivedDetailList[" + index +"].unit_div'").attr("name","form.receivedDetailList[" + (index-1) + "].unit_div");
						$("input[name='form.receivedDetailList[" + index +"].amount'").attr("name","form.receivedDetailList[" + (index-1) + "].amount");
						$("input[name='form.receivedDetailList[" + index +"].checkbox'").attr("name","form.receivedDetailList[" + (index-1) + "].checkbox");
						$("select[name='form.receivedDetailList[" + index +"].tax_div'").attr("name","form.receivedDetailList[" + (index-1) + "].tax_div");
						$("input[name='form.receivedDetailList[" + index +"].org_price'").attr("name","form.receivedDetailList[" + (index-1) + "].org_price");
					}
					
				});	
			}
			
			function removeRow(n){			
				$("#tbAddPart tr").eq(n).remove();
			}
			
			/* 明細部単価blurイベント*/
			$("input[name$='price_per']").blur(function(){
		
				//获取当前元素的name
				var x = $(this).prop("name");
				//获取当前索引
				var index = getCurIndex(x);
				
				//金額計算
				calculateAmount(index);
			});
			
			/* 明細部数量blurイベント*/
			$("input[name$='quantity']").blur(function(){
				//获取当前元素的name
				var x = $(this).prop("name");
				//获取当前索引
				var index = getCurIndex(x);
				
				//金額計算
				calculateAmount(index);
			});
			
			$("select[name$='tax_div']").change(function(){
				//合計金額計算
				calculateTotal();
			});

		});
		
		//获取当前索引
		function getCurIndex(x){
			//获取索引值
			var start = x.indexOf("[");
			var end = x.indexOf("]");
			return  parseInt(x.substr(start+1,end-start-1));
		}
		
		function calculateAmount( index ) {
			//金額
			var amount;
			
			//単価
			var price = 0;
			if ($("input[name='form.receivedDetailList[" + index +"].price_per'").val()){
				price = parseFloat($("input[name='form.receivedDetailList[" + index +"].price_per'").val());
			}
			
			//数量
			var quantity = 0;
			if ($("input[name='form.receivedDetailList[" + index +"].quantity'").val()){
				quantity = parseFloat($("input[name='form.receivedDetailList[" + index +"].quantity'").val());
			}
			
			//金額
			amount = price * quantity;
			
			//端数処理
			amount = doProcessing(amount);
											
			if (amount != 0) {
				$("input[name='form.receivedDetailList[" + index +"].amount'").val(amount);	
			} else {
				$("input[name='form.receivedDetailList[" + index +"].amount'").val("");	
			}
			
			//合計金額計算
			calculateTotal();
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
			
			var detailsize =  parseInt($("#detailsize").val());
						
			for (var i = 0; i < detailsize; i++) {
				
				//明細金額
				var amountDetail = 0; ;	
				if ($("input[name='form.receivedDetailList[" + i +"].amount'").val()) {
					amountDetail = parseInt($("input[name='form.receivedDetailList[" + i +"].amount'").val());
				} 
				//明細税区分
				var tax_div = $("select[name='form.receivedDetailList[" + i +"].tax_div'").val();
				
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
// 				$("#receive_amount").text("￥" + amount.toLocaleString());
// 				$("#tax_amount").text("￥" + tax_amount.toLocaleString());
// 				$("#tax_in_amount").text("￥" + (amount + tax_amount).toLocaleString());				
// 			}
			
			$("#receive_amount").text("￥" + amount.toLocaleString());
			$("#tax_amount").text("￥" + tax_amount.toLocaleString());
			$("#tax_in_amount").text("￥" + (amount + tax_amount).toLocaleString());		
		}
	</script>
	<!-- sxt 20220621 add end  -->
</html>