<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="ww" uri="webwork" %>
<html lang="ja">
<head>
<ww:include value="'/headContent.jsp'" />
<title>発注一覧画面</title>
  <style>
    /*覆写bootstrap的css*/
    .panel-body {
      padding: 10px 0;
    }

    .table>tbody>tr>td {
      padding: 0.5rem;
      vertical-align: middle;
    }

    .flex {
      display: flex;
    }

    .flex-left {
      flex-basis: 40rem;
    }

    .flex-right {
      flex-basis: auto;
    }
  </style>
<script language="JavaScript">
	function submitAction(pForm,action){
		pForm.action = action;
		pForm.submit();	
	}
	function setValue(pForm,pValue){
		pForm.form.person_in_charge_code_input.value = pValue;
	}
	
	function delSubmitAction(pForm, action) {
		var obj = document.getElementsByName("form.delcheckbox");
		var flag = 0;
		for (i = 0; i < obj.length; i++) {
			if (obj[i].disabled == false && 
				obj[i].checked == true) {
				flag = 1;
			}
		}
		if (flag == 0) {
			alert("削除データを選択してください。");
			return;
		}
		if (confirm("選択したデータを削除してよろしいですか？")) {
			pForm.action = action;
			pForm.submit();
		}
	}
	
	function selectAllCheckbox(selallobj) {
		var obj = document.getElementsByName("form.delcheckbox");
		
		for (i = 0; i < obj.length; i++) {
			if (obj[i].disabled == false) {
				obj[i].checked = selallobj.checked;
			}
		}
	}
	
</script>
</head>

<body onunload="closeSubWindow();" class="cm-no-transition cm-1-navbar">

<form name="HattyuForm" method="POST" class="form-horizontal">
<header id="cm-header">
<!--     <nav class="cm-navbar cm-navbar-primary"> -->
<!--       <div class="cm-flex"> -->
<!--         <h1>発注処理 -->
<!--           <i class="fa fa-fw fa-angle-double-right"></i> -->
<!--         </h1> -->
<!--       </div> -->
<%--       <ww:include value="'/header.jsp'"/>	 --%>
<!--     </nav> -->
  </header>
  <div id="global">
    <div class="container-fluid">
      <div class="text-center dora-form-title">
        発注一覧画面
        <ww:include value="'/loginName.jsp'"/>
      </div>
      <div class="panel panel-default">
        <div class="panel-body">
        
        	<ww:include value="'/message.jsp'" />
          
            <div class="form-group form-inline flex">
              <div class="flex-left">
                <label for="estimate_date" class="dora-label-left">受注番号</label>
                <input type="text" name="form.receive_no_input" value="<ww:property value='form.receive_no_input'/>" maxlength="14" class="form-control" placeholder="受注番号">
              </div>
              <div class="flex-right">
                <label for="estimate_date" class="dora-label-left">受注担当者</label>
                <ww:select name="'form.receive_in_code_input'" 
						   cssClass="'form-control dora-select'" 
						   cssStyle="'width:100%'" 
						   list="form.receive_in_namelist" 
						   listKey="person_in_charge_code" 
						   listValue="person_in_charge_name" 
						   value="form.receive_in_code_input" 
						   headerKey="''"
						   headerValue="'全て'"
				>
				</ww:select>
              </div>
<!--               <div class="flex-right"> -->
<!--                 <label for="estimate_date" class="dora-label-left">受注区分</label> -->
<%--                 <ww:select name="'form.receive_status_input'"  --%>
<%-- 						   cssClass="'form-control dora-select'"  --%>
<%-- 						   cssStyle="'width:100%'"  --%>
<%-- 						   list="form.receive_status"  --%>
<%-- 						   listKey="code_id"  --%>
<%-- 						   listValue="code_value"  --%>
<%-- 						   value="form.receive_status_input"  --%>
<%-- 						   headerKey="''" --%>
<%-- 						   headerValue="'全て'" --%>
<%-- 				> --%>
<%-- 				</ww:select> --%>
<!--               </div> -->
            </div>
  
            <div class="form-group form-inline flex">
              <div class="flex-left">
                <label for="estimate_date" class="dora-label-left">受注日付</label>
                <input type="date" name="form.receive_date" value="<ww:property value='form.receive_date'/>" class="form-control">
              </div>
            </div>
<!--             <div class="form-group form-inline"> -->
<!--               <label for="estimate_date" class="dora-label-left">注文受付番号</label> -->
<%--               <input type="text" name="form.order_code_from_cst" value="<ww:property value='form.order_code_from_cst'/>" maxlength="20" class="form-control" placeholder="注文受付番号"> --%>
<!--             </div> -->
            <div class="form-group form-inline">
              <label for="estimate_date" class="dora-label-left">得意先コード</label>
              <input type="hidden" id="customer_code_old">
              <input type="text" name="form.customer_code" id="customer_code" value="<ww:property value='form.customer_code'/>" maxlength="8"  class="form-control" placeholder="得意先コード">
              <input type="text" name="form.customer_name" id="customer_name" value="<ww:property value='form.customer_name'/>" maxlength="60" class="form-control" style="width:40rem;" readonly>
              <ww:hidden name="'form.processing'" value="form.processing"></ww:hidden>
			  <input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initTokuisakiGuide.action?form.fieldName_code=form.customer_code&form.fieldName_name=form.customer_name&form.processing=form.processing','得意先参照',670,770)">
            </div>
  
            <div class="form-group form-inline flex">
              <div class="flex-left">
                <label for="estimate_date" class="dora-label-left">発注番号</label>
                <input type="text" name="form.order_no" value="<ww:property value='form.order_no'/>" maxlength="14" class="form-control" placeholder="発注番号">
              </div>
              <div class="flex-right">
                <label for="estimate_date" class="dora-label-left">発注担当者</label>
                <ww:select name="'form.order_in_code_input'" 
						   cssClass="'form-control dora-select'" 
						   cssStyle="'width:100%'" 
						   list="form.order_in_namelist" 
						   listKey="person_in_charge_code" 
						   listValue="person_in_charge_name" 
						   value="form.order_in_code_input" 
						   headerKey="''"
						   headerValue="'全て'"
				>
				</ww:select>
              </div>
            </div>
            <div class="form-group form-inline">
              <label for="estimate_date" class="dora-label-left">発注日付</label>
              <input type="date" name="form.order_date" value="<ww:property value='form.order_date'/>" class="form-control">
            </div>
            <div class="form-group form-inline">
              <label for="estimate_date" class="dora-label-left">外注先</label>
              <input type="hidden" id="out_order_code_old">
              <input type="text" name="form.out_order_code" id="out_order_code" value="<ww:property value='form.out_order_code'/>" maxlength="8" class="form-control" placeholder="外注先コード">
              <input type="text" name="form.out_order_name" id="out_order_name" value="<ww:property value='form.out_order_name'/>" class="form-control" style="width:40rem;" disabled>
              <input type="button" class="btn btn-primary" value="参照" onclick="openWindowWithScrollbarGuide('initGaityuusakiGuide.action?form.fieldName_code=form.out_order_code&form.fieldName_name=form.out_order_name&form.processing=form.processing','外注先参照',670,770)" />
			  <ww:hidden name="'form.processing'"> </ww:hidden>
            </div>
  
            <div class="form-group" style="margin-top:1rem;">
              <div>
                <button type="button" class="btn btn-primary dora-sm-button" onclick="submitAction(this.form,'showHattyuSearchResultAction.action');">検索</button>
                <button type="button" class="btn btn-primary dora-sm-button" style="float: right;" onclick="delSubmitAction(this.form,'deleteHattyuBulk.action');">削除</button>
              </div>
            </div>
  
            <div class="form-group" style="margin-top:1.75rem">
            <!-- リストコンテント -->
			<ww:if test="form.customerList.size>0">
				<table style="margin-top:20px">
					<tr>
						<td width="90%">　</td>
						<td nowrap><ww:property value="form.countLines"/>件中 <ww:property value="form.startLines"/> －<ww:property value="form.endLines"/>件目  </td>
						<td width="5%">　</td>
						<td nowrap>
							<ww:if test="form.previous==true">
								<a href="#" onclick="linkAction('refreshHattyu.action?form.page=',-1)">前へ </a>
							</ww:if>
							<ww:else>
								<font color="gray">前へ </font>
							</ww:else>
						</td>
						<td>　</td>
						<td nowrap>
							<ww:if test="form.next==true">
								<a href="#" onclick="linkAction('refreshHattyu.action?form.page=',1)">次へ </a>
							</ww:if>
							<ww:else>
								<font color="gray">次へ </font>
							</ww:else>
						</td>
					</tr>
				</table>
			</ww:if>
              <table class="table table-bordered table-hover">
                <thead>
                  <tr>
                    <td width="15%" class="text-center">得意先</td>
                    <td class="text-center" style="width: 10rem;">受注番号</td>
                    <td class="text-center" style="width: 10rem;">受注日付</td>
                    <td class="text-center" nowrap>件名(納期)</td>
                    <td class="text-center" style="width: 15rem;">(請求締日)<br>(請求区分)</td>
                    <td class="text-center" style="width: 15rem;">発注日付</td>
                    <td class="text-center" style="width: 10rem;">発注番号</td>
                    <td class="text-center" style="width: 20rem;">外注先</td>
                    <td class="text-center" style="width: 7rem;">納品状況</td>
                    <td class="text-center" style="width: 10rem;">承認者</td>
                    <td class="text-center" style="width: 7rem;">承認</td>
                    <ww:if test="form.rw_flag==1">
	                    <td class="text-center" style="width: 6rem;">削除<br>
	                      <ww:checkbox name="'selall'" fieldValue="1" onclick="'selectAllCheckbox(this)'" ></ww:checkbox>
	                    </td>
                    </ww:if>
                  </tr>
                </thead>
                <tbody>
                <ww:iterator value="form.customerList" status="crows" id="cmodel">
               		<% String trClass = ""; %>
					<ww:if test="#crows.odd == true">
						<% trClass = "success"; %>
					</ww:if>
                
	                  <tr class="<%=trClass%>">
	                    <td class="text-center" rowspan="<ww:property value="customerListLength"/>" style="vertical-align:middle;"><ww:property value="customer_name"/></td>
<%-- 	                    <ww:iterator value="#attr.cmodel.hattyuModelList" status="rows" id="model"> --%>	<!-- sxt 20221020 del -->
	                    <ww:iterator value="hattyuModelList" status="rows" id="model">							<!-- sxt 20221020 add -->
	                    	<td class="text-center" rowspan="<ww:property value="stockListLength"/>" style="vertical-align:middle;">
	                    		<ww:property value="receive_no"/>
	                    	</td>
	                    	<td class="text-center" rowspan="<ww:property value="stockListLength"/>" style="vertical-align:middle;"><ww:property value="receive_date"/></td>
	                    	
	                    	<ww:if test="delivery_date.equals(\"\")">
								<td style="word-break:break-all" rowspan="<ww:property value="stockListLength"/>"><ww:property value="receive_name1"/></td>
							</ww:if>
							<ww:else>
								<td style="word-break:break-all" rowspan="<ww:property value="stockListLength"/>"><ww:property value="receive_name1"/> <br> (<ww:property value="delivery_date"/>)</td>
							</ww:else>
							<td style="word-break:break-all" rowspan="<ww:property value="stockListLength"/>"><ww:property value="balance_date"/><ww:property value="order_div_name"/></td>
							<input type="hidden" name="StockList" value="<ww:property value="stockList"/>" />
							
<%-- 							<ww:iterator value="#attr.model.stockList" status="internalRows"> --%>	<!-- sxt 20221020 del -->
							<ww:iterator value="stockList" status="internalRows">						<!-- sxt 20221020 add -->
								<td nowrap>
									<ww:if test="form.rw_flag==1">
										<ww:if test="stock_date=='発注新規'">
<%-- 											<a href="initialHattyuSinki2.action?form.receive_no=<ww:property value="#attr.model.receive_no"/>" >	 --%>	<!-- sxt 20221020 del -->
											<a href="initialHattyuSinki2.action?form.receive_no=<ww:property value="[1].receive_no"/>" >						<!-- sxt 20221020 add -->
												新規（常駐）
											</a>
											<br>
<%-- 											<a href="initialHattyuSinki.action?form.receive_no=<ww:property value="#attr.model.receive_no"/>" > --%>		<!-- sxt 20221020 del -->
											<a href="initialHattyuSinki.action?form.receive_no=<ww:property value="[1].receive_no"/>" >							<!-- sxt 20221020 add -->
												新規（請負）
											</a>
										</ww:if>			
										<ww:else>
											<ww:property value="stock_date"/>
										</ww:else>	
									</ww:if>
									<ww:else>
										<ww:if test="stock_date=='発注新規'">		
																													
										</ww:if>			
										<ww:else>
											<ww:property value="stock_date"/>
										</ww:else>
									</ww:else>				
								</td>
								<td class="text-center">
									<ww:if test="form.rw_flag==1">	
										<!-- sxt 20230201 del start -->	
										<%-- <ww:if test="month_close_flg.equals(\"2\")">
											<ww:if test="shurui.equals(\"2\")">
												<a href="#" onclick="linkAction('showHattyuItiran.action?form.order_no_itiran=<ww:property  value="stock_no" />&form.page_flg=10','');">
												<ww:property value="stock_no"/></a>
											</ww:if>
											<ww:else>
												<a href="#" onclick="linkAction('showHattyuItiran2.action?form.order_no_itiran=<ww:property  value="stock_no" />&form.page_flg=10','');">
												<ww:property value="stock_no"/></a>
											</ww:else>	
										</ww:if>
										<ww:else>	
											<ww:if test="shurui.equals(\"2\")">
												<a href="#" onclick="hrefHaveParamAction('initialUpdateHattyu.action?form.order_no_update=<ww:property value="stock_no"/>&form.receive_no_update=<ww:property value="receive_no"/>&form.msgId=update')"><ww:property value="stock_no"/></a>
											</ww:if>
											<ww:else>
												<a href="#" onclick="hrefHaveParamAction('initialUpdateHattyu2.action?form.order_no_update=<ww:property value="stock_no"/>&form.receive_no_update=<ww:property value="receive_no"/>&form.msgId=update')"><ww:property value="stock_no"/></a>
											</ww:else>	
										</ww:else> --%>
										<!-- sxt 20230201 del end -->
										<!-- sxt 20230201 add start -->
										<ww:if test="shurui.equals(\"2\")">
											<a href="#" onclick="hrefHaveParamAction('initialUpdateHattyu.action?form.order_no_update=<ww:property value="stock_no"/>&form.receive_no_update=<ww:property value="receive_no"/>&form.msgId=update')"><ww:property value="stock_no"/></a>
										</ww:if>
										<ww:else>
											<a href="#" onclick="hrefHaveParamAction('initialUpdateHattyu2.action?form.order_no_update=<ww:property value="stock_no"/>&form.receive_no_update=<ww:property value="receive_no"/>&form.msgId=update')"><ww:property value="stock_no"/></a>
										</ww:else>
										<!-- sxt 20230201 add end -->	
									</ww:if>
									<ww:else>
										<ww:if test="shurui.equals(\"2\")">
											<a href="#" onclick="linkAction('showHattyuItiran.action?form.order_no_itiran=<ww:property  value="stock_no" />&form.page_flg=10','');">
											<ww:property value="stock_no"/></a>
										</ww:if>
										<ww:else>
											<a href="#" onclick="linkAction('showHattyuItiran2.action?form.order_no_itiran=<ww:property  value="stock_no" />&form.page_flg=10','');">
											<ww:property value="stock_no"/></a>
										</ww:else>	
									</ww:else>	
								</td>
								<td style="word-break:break-all" ><ww:property value="out_order_name"/></td>
								<td class="text-center"><ww:property value="delivery_status_name"/></td>
								<td class="text-center"><ww:property value="syouninsya_name"/><br /><ww:property value="syounin_nichiji" /></td>
								<td class="text-center">
									<ww:if test="approval_div_name.equals('OK')">
										<ww:if test="shurui.equals(\"2\")">
											<input type="button" class="btn btn-primary" value="印刷" onclick="openWindowResizable('hattyuPrint.action?form.receive_no=<ww:property value='receive_no'/>&form.order_no_print=<ww:property value='stock_no'/>','御発注書印刷',800,600);"/>
										</ww:if>
										<ww:else>
											<input type="button" class="btn btn-primary" value="印刷" onclick="openWindowResizable('hattyuPrint2.action?form.receive_no=<ww:property value='receive_no'/>&form.order_no_print=<ww:property value='stock_no'/>','御発注書印刷',800,600);"/>
										</ww:else>	
									</ww:if>
									<ww:else>
										<ww:property value="approval_div_name"/>
									</ww:else>
								</td>
<!-- 								<td class="text-center"> -->
<%-- 									<ww:if test="approval_div_name.equals('OK')"> --%>
<%-- 										<ww:if test="server_ip.equals('') == false"> --%>
<%-- 										<input type="button" class="button" style="width:50px" value="送信" onclick="window.open('sendhatyu.action?form.receive_no=<ww:property value='receive_no'/>&form.order_no_print=<ww:property value='stock_no'/>');"/> --%>
<%-- 										</ww:if> --%>
<%-- 									</ww:if> --%>
<%-- 									<ww:else> --%>
<%-- 										<ww:property value="approval_div_name"/> --%>
<%-- 									</ww:else> --%>
<!-- 								</td> -->
								<ww:if test="form.rw_flag==1">
									<td class="text-center">
										<ww:if test="delflg.equals(\"1\")">
										<input type="checkbox" name="form.delcheckbox" value="<ww:property value='stock_no'/>" />
										</ww:if>
										<ww:else>
										<input type="checkbox" name="form.delcheckbox" value="<ww:property value='stock_no'/>" disabled />
										</ww:else>
									</td>
								</ww:if>
							</tr>
							<ww:if test="#internalRows.last == false">
								<tr class="<%=trClass%>">
							</ww:if>
						</ww:iterator>
						<ww:if test="#rows.last == false">
							<tr class="<%=trClass%>">
						</ww:if>
                    </ww:iterator>	        
                  </ww:iterator>         
                </tbody>
              </table>
            </div>
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
			/* 得意先コードblurイベント*/
			 $("#customer_code").blur(function(){
				var code = $("#customer_code").val();
				var codeOld = $("#customer_code_old").val();				
				if (code != codeOld) {
					$.ajax({
				        type: "POST",  
				        url: "getTokuisakiList.action",
				        data: {id:code},
//	 			        async: false,
//	 			        dataType:"json",
				        error: function (request) {  
				        	//得意先名をクリアする
				            $("#customer_name").val("");
				        },
				        success: function (data) {  
			        		//得意先の退避値をセット
				        	$("#customer_code_old").val(code);
				        	if (data == ""){
				        		//得意先名をクリアする
					            $("#customer_name").val("");
				        	} else {
					        	//得意先当名をセットする
					            $("#customer_name").val(JSON.parse(data).customer_name);	        		
				        	}
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
				        url: "getGaityusakiName.action",
				        data: {id:code},
				        error: function (request) {  
				        	//外注先担当名をクリアする
				            $("#out_order_name").val("");
				        },
				        success: function (data) {  
				        	//外注先の退避値をセット
				        	$("#out_order_code_old").val(code);
				        	//外注先担当名をセットする
				            $("#out_order_name").val(data);
				        }
				    });
		    	}

		  	});
		});
		function doSomething(){

		}
	</script>
</html>
